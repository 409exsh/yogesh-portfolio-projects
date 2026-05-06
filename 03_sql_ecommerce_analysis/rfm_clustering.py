"""
rfm_clustering.py
=================
RFM (Recency, Frequency, Monetary) segmentation using K-Means clustering.

Pipeline
--------
1. Connect to MySQL and pull order data
2. Compute RFM metrics per customer
3. Scale features
4. Run K-Means (k=4)
5. Label segments & print/export results

Requirements: pip install pandas numpy scikit-learn sqlalchemy pymysql matplotlib seaborn
"""

import os
import warnings
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import date
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

warnings.filterwarnings("ignore")

# ──────────────────────────────────────────────────────────────
# 1. DATABASE CONFIG  (override via env vars in production)
# ──────────────────────────────────────────────────────────────
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", 3306))
DB_USER = os.getenv("DB_USER", "root")
DB_PASS = os.getenv("DB_PASS", "")
DB_NAME = os.getenv("DB_NAME", "ecommerce_db")

SNAPSHOT_DATE = date.today()   # reference date for recency

# ──────────────────────────────────────────────────────────────
# 2. LOAD DATA
# ──────────────────────────────────────────────────────────────
def load_orders() -> pd.DataFrame:
    """Pull delivered/shipped orders from MySQL."""
    try:
        from sqlalchemy import create_engine
        url = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
        engine = create_engine(url)
        query = """
            SELECT
                o.customer_id,
                CONCAT(c.first_name,' ',c.last_name) AS customer_name,
                o.order_date,
                o.total_amount
            FROM orders o
            JOIN customers c ON c.customer_id = o.customer_id
            WHERE o.status NOT IN ('cancelled','returned')
        """
        df = pd.read_sql(query, engine)
        df["order_date"] = pd.to_datetime(df["order_date"])
        print(f"[DB] Loaded {len(df):,} orders for {df['customer_id'].nunique()} customers.")
        return df
    except Exception as exc:
        print(f"[DB] Could not connect ({exc}). Generating synthetic data instead.")
        return _synthetic_orders()


def _synthetic_orders() -> pd.DataFrame:
    """Reproducible synthetic dataset when no DB is available."""
    rng = np.random.default_rng(42)
    n_customers = 30
    rows = []
    base_date = pd.Timestamp("2022-01-01")

    for cid in range(1, n_customers + 1):
        n_orders = rng.integers(1, 12)
        for _ in range(n_orders):
            offset_days = rng.integers(0, 730)
            amount = round(float(rng.uniform(20, 650)), 2)
            rows.append(
                {"customer_id": cid,
                 "customer_name": f"Customer_{cid}",
                 "order_date": base_date + pd.Timedelta(days=int(offset_days)),
                 "total_amount": amount}
            )
    df = pd.DataFrame(rows)
    print(f"[Synthetic] {len(df):,} orders, {df['customer_id'].nunique()} customers.")
    return df


# ──────────────────────────────────────────────────────────────
# 3. COMPUTE RFM METRICS
# ──────────────────────────────────────────────────────────────
def compute_rfm(df: pd.DataFrame) -> pd.DataFrame:
    snapshot = pd.Timestamp(SNAPSHOT_DATE)
    rfm = (
        df.groupby("customer_id")
        .agg(
            customer_name=("customer_name", "first"),
            recency=("order_date",   lambda x: (snapshot - x.max()).days),
            frequency=("order_id" if "order_id" in df.columns else "order_date", "count"),
            monetary=("total_amount", "sum"),
        )
        .reset_index()
    )
    rfm.rename(columns={"order_date": "frequency"}, errors="ignore", inplace=True)
    print(rfm[["recency", "frequency", "monetary"]].describe().round(2))
    return rfm


# ──────────────────────────────────────────────────────────────
# 4. K-MEANS CLUSTERING
# ──────────────────────────────────────────────────────────────
def find_optimal_k(X_scaled: np.ndarray, k_range=range(2, 8)) -> int:
    """Elbow + silhouette to pick the best k."""
    inertias, sil_scores = [], []
    for k in k_range:
        km = KMeans(n_clusters=k, random_state=42, n_init=10)
        km.fit(X_scaled)
        inertias.append(km.inertia_)
        sil_scores.append(silhouette_score(X_scaled, km.labels_))

    best_k = k_range.start + int(np.argmax(sil_scores))
    print(f"[KMeans] Best k by silhouette: {best_k}  (score={max(sil_scores):.3f})")

    # Elbow plot
    fig, axes = plt.subplots(1, 2, figsize=(12, 4))
    axes[0].plot(list(k_range), inertias, "o-", color="#4C72B0")
    axes[0].set(title="Elbow Curve", xlabel="k", ylabel="Inertia")
    axes[1].plot(list(k_range), sil_scores, "o-", color="#DD8452")
    axes[1].set(title="Silhouette Scores", xlabel="k", ylabel="Score")
    plt.tight_layout()
    plt.savefig("elbow_silhouette.png", dpi=120)
    plt.close()
    return best_k


def run_kmeans(rfm: pd.DataFrame, k: int = 4) -> pd.DataFrame:
    features = ["recency", "frequency", "monetary"]
    scaler   = StandardScaler()
    X_scaled = scaler.fit_transform(rfm[features])

    km = KMeans(n_clusters=k, random_state=42, n_init=10)
    rfm["cluster"] = km.fit_predict(X_scaled)

    # Label clusters based on centroid means
    centers = pd.DataFrame(
        scaler.inverse_transform(km.cluster_centers_),
        columns=features
    )
    centers["cluster"] = range(k)
    centers["label"] = centers.apply(_label_cluster, axis=1)

    rfm = rfm.merge(centers[["cluster", "label"]], on="cluster")
    return rfm, centers


def _label_cluster(row: pd.Series) -> str:
    """Heuristic segment label from centroid values."""
    if row["frequency"] >= 4 and row["recency"] <= 90:
        return "Champions"
    elif row["frequency"] >= 3 and row["recency"] <= 180:
        return "Loyal Customers"
    elif row["recency"] > 300:
        return "At Risk / Lost"
    else:
        return "Promising / New"


# ──────────────────────────────────────────────────────────────
# 5. VISUALISE
# ──────────────────────────────────────────────────────────────
PALETTE = {
    "Champions":       "#2ecc71",
    "Loyal Customers": "#3498db",
    "Promising / New": "#f39c12",
    "At Risk / Lost":  "#e74c3c",
}


def plot_rfm_scatter(rfm: pd.DataFrame) -> None:
    fig, axes = plt.subplots(1, 2, figsize=(14, 5))
    fig.suptitle("RFM Customer Segments", fontsize=14, fontweight="bold")

    for ax, (x_col, y_col, title) in zip(axes, [
        ("recency",   "monetary",  "Recency vs Monetary"),
        ("frequency", "monetary",  "Frequency vs Monetary"),
    ]):
        for label, grp in rfm.groupby("label"):
            ax.scatter(grp[x_col], grp[y_col],
                       label=label, alpha=0.75,
                       color=PALETTE.get(label, "grey"), s=70)
        ax.set(title=title, xlabel=x_col.capitalize(), ylabel="Monetary ($)")
        ax.legend(fontsize=8)

    plt.tight_layout()
    plt.savefig("rfm_scatter.png", dpi=120)
    plt.close()
    print("[Plot] rfm_scatter.png saved.")


def plot_segment_summary(rfm: pd.DataFrame) -> None:
    summary = (
        rfm.groupby("label")[["recency", "frequency", "monetary"]]
        .mean()
        .round(1)
        .reset_index()
    )

    fig, axes = plt.subplots(1, 3, figsize=(15, 5))
    fig.suptitle("Segment Averages", fontsize=13, fontweight="bold")
    metrics = [("recency", "Avg Recency (days)"),
               ("frequency", "Avg Frequency (orders)"),
               ("monetary", "Avg Monetary ($)")]

    for ax, (metric, ylabel) in zip(axes, metrics):
        colors = [PALETTE.get(lbl, "grey") for lbl in summary["label"]]
        ax.bar(summary["label"], summary[metric], color=colors, edgecolor="white")
        ax.set(title=ylabel, ylabel=ylabel)
        ax.tick_params(axis="x", rotation=20)

    plt.tight_layout()
    plt.savefig("rfm_segments_bar.png", dpi=120)
    plt.close()
    print("[Plot] rfm_segments_bar.png saved.")


# ──────────────────────────────────────────────────────────────
# 6. EXPORT
# ──────────────────────────────────────────────────────────────
def export_results(rfm: pd.DataFrame) -> None:
    out_file = "rfm_results.csv"
    rfm.to_csv(out_file, index=False)
    print(f"\n[Export] Results saved to {out_file}")

    print("\n── Segment Distribution ──")
    dist = rfm["label"].value_counts().reset_index()
    dist.columns = ["Segment", "Customers"]
    dist["% of Total"] = (dist["Customers"] / len(rfm) * 100).round(1)
    print(dist.to_string(index=False))

    print("\n── Segment Averages ──")
    avg = rfm.groupby("label")[["recency", "frequency", "monetary"]].mean().round(2)
    print(avg.to_string())


# ──────────────────────────────────────────────────────────────
# 7. MAIN
# ──────────────────────────────────────────────────────────────
if __name__ == "__main__":
    print("=" * 55)
    print(" RFM CLUSTERING – E-Commerce Analysis")
    print("=" * 55)

    df  = load_orders()
    rfm = compute_rfm(df)

    features  = ["recency", "frequency", "monetary"]
    scaler    = StandardScaler()
    X_scaled  = scaler.fit_transform(rfm[features])

    best_k    = find_optimal_k(X_scaled)
    rfm, centers = run_kmeans(rfm, k=best_k)

    plot_rfm_scatter(rfm)
    plot_segment_summary(rfm)
    export_results(rfm)

    print("\n[Done] Check rfm_results.csv and *.png for outputs.")
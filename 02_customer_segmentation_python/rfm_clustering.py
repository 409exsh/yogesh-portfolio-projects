import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
import matplotlib.pyplot as plt
import seaborn as sns
import os

# -------------------------------
# Setup
# -------------------------------
os.makedirs("outputs", exist_ok=True)

# -------------------------------
# Load & Clean Data
# -------------------------------
df = pd.read_excel('data/ecommerce_data.xlsx')

df = df[df['Quantity'] > 0].dropna(subset=['CustomerID'])
df['Revenue'] = df['Quantity'] * df['UnitPrice']

# -------------------------------
# RFM Calculation
# -------------------------------
snapshot_date = df['InvoiceDate'].max() + pd.Timedelta(days=1)

rfm = df.groupby('CustomerID').agg(
    Recency=('InvoiceDate', lambda x: (snapshot_date - x.max()).days),
    Frequency=('InvoiceNo', 'nunique'),
    Monetary=('Revenue', 'sum')
).reset_index()

# -------------------------------
# Scaling
# -------------------------------
scaler = StandardScaler()
rfm_scaled = scaler.fit_transform(rfm[['Recency', 'Frequency', 'Monetary']])

# -------------------------------
# Elbow Method
# -------------------------------
inertias = []
K_range = range(2, 9)

for k in K_range:
    km = KMeans(n_clusters=k, random_state=42, n_init=10)
    km.fit(rfm_scaled)
    inertias.append(km.inertia_)

plt.plot(K_range, inertias, marker='o')
plt.title("Elbow Method for Optimal K")
plt.xlabel("Number of Clusters")
plt.ylabel("Inertia")
plt.savefig("outputs/elbow_method.png")
plt.clf()

# -------------------------------
# Final Model (K=4)
# -------------------------------
kmeans = KMeans(n_clusters=4, random_state=42, n_init=10)
rfm['Cluster'] = kmeans.fit_predict(rfm_scaled)

# Silhouette Score
score = silhouette_score(rfm_scaled, rfm['Cluster'])
print(f"\nSilhouette Score: {score:.3f}")

# -------------------------------
# Cluster Summary
# -------------------------------
cluster_summary = rfm.groupby('Cluster')[['Recency', 'Frequency', 'Monetary']].mean()
print("\nCluster Summary:\n", cluster_summary)

# -------------------------------
# Segment Labeling (Smart Logic)
# -------------------------------
segment_map = {}

for cluster in cluster_summary.index:
    r = cluster_summary.loc[cluster, 'Recency']
    f = cluster_summary.loc[cluster, 'Frequency']
    m = cluster_summary.loc[cluster, 'Monetary']

    if r < 50 and f > 5 and m > 1000:
        segment_map[cluster] = 'High-Value'
    elif r > 120:
        segment_map[cluster] = 'Dormant'
    elif r > 80:
        segment_map[cluster] = 'At-Risk'
    else:
        segment_map[cluster] = 'New'

rfm['Segment'] = rfm['Cluster'].map(segment_map)

print("\nSegment Summary:\n")
print(rfm.groupby('Segment')[['Recency','Frequency','Monetary']].mean().round(1))

# -------------------------------
# Segment Distribution (%)
# -------------------------------
segment_pct = (rfm['Segment'].value_counts(normalize=True) * 100).round(2)
print("\nSegment Distribution (%):\n", segment_pct)

segment_pct.plot(kind='bar')
plt.ylabel("Percentage (%)")
plt.title("Customer Segment Distribution (%)")
plt.xticks(rotation=30)
plt.savefig("outputs/segment_percentage.png")
plt.clf()

# -------------------------------
# Revenue Contribution
# -------------------------------
segment_revenue = df.merge(rfm[['CustomerID','Segment']], on='CustomerID')

revenue_summary = segment_revenue.groupby('Segment')['Revenue'].sum().sort_values(ascending=False)
print("\nRevenue by Segment:\n", revenue_summary)

revenue_summary.plot(kind='bar')
plt.title("Revenue Contribution by Segment")
plt.ylabel("Revenue")
plt.xticks(rotation=30)
plt.savefig("outputs/revenue_by_segment.png")
plt.clf()

# -------------------------------
# Heatmap
# -------------------------------
sns.heatmap(rfm[['Recency','Frequency','Monetary']].corr(), annot=True)
plt.title("RFM Correlation Heatmap")
plt.savefig("outputs/rfm_heatmap.png")
plt.clf()

# -------------------------------
# Segment Distribution Count
# -------------------------------
sns.countplot(x='Segment', data=rfm, order=rfm['Segment'].value_counts().index)
plt.xticks(rotation=30)
plt.title("Customer Segments Distribution")
plt.savefig("outputs/cluster_distribution.png")
plt.clf()

# -------------------------------
# Cluster Profiles (Normalized)
# -------------------------------
cluster_profile = rfm.groupby('Segment')[['Recency','Frequency','Monetary']].mean()

scaler = MinMaxScaler()
cluster_scaled = pd.DataFrame(
    scaler.fit_transform(cluster_profile),
    columns=cluster_profile.columns,
    index=cluster_profile.index
)

cluster_scaled.plot(kind='bar', width=0.8)

plt.title("Customer Segmentation using RFM Analysis", fontsize=14, weight='bold')
plt.ylabel("Normalized Score (0-1)")
plt.xlabel("Customer Segment")
plt.xticks(rotation=0)
plt.legend(title="Metrics")
plt.grid(axis='y', linestyle='--', alpha=0.6)

plt.tight_layout()
plt.savefig("outputs/cluster_profiles.png", dpi=300)
plt.clf()

# -------------------------------
# Save Final Output
# -------------------------------
rfm.to_csv("outputs/rfm_segments.csv", index=False)

print("\n✅ All outputs saved in 'outputs/' folder")
# 🧠 Customer Segmentation using K-Means Clustering

## 📌 Problem Statement

An e-commerce company lacked clarity on which customers to prioritize for retention and marketing campaigns.
As a result, marketing efforts were inefficient and budget allocation was suboptimal.

---

## ❓ Key Business Questions

* Who are the most valuable customers?
* Which customers are at risk of churning?
* How is revenue distributed across customer segments?
* Where should marketing efforts be focused?

---

## ⚙️ Approach

* Loaded and cleaned **50,000+ transactional records** (UCI Online Retail dataset)
* Performed **RFM analysis** (Recency, Frequency, Monetary)
* Normalized features using **StandardScaler**
* Applied **K-Means clustering**
* Determined optimal clusters using **Elbow Method + Silhouette Score**
* Profiled clusters and assigned business-friendly labels

---

## 📊 Key Insights

* High-Value customers (~12%) contribute **43% of total revenue**
* At-Risk customers (~28%) show declining purchase activity → strong re-targeting opportunity
* Dormant customers have minimal engagement and low lifetime value
* Strong correlation between **Frequency and Monetary (≈0.55)** indicates repeat buyers drive revenue

---

## 📈 Model Performance

* Silhouette Score: **0.67** → indicates strong cluster separation

---

## 🎯 Business Impact

* Enables **targeted marketing campaigns**
* Reduces wasted spend on low-value segments
* Improves **customer retention strategy**
* Supports **data-driven decision making**

---

## 📊 Outputs

* `rfm_segments.csv` → Final segmented dataset
* `cluster_distribution.png` → Segment distribution
* `cluster_profiles.png` → RFM comparison
* `rfm_heatmap.png` → Feature correlation
* `elbow_method.png` → Optimal cluster selection

---

## 🛠 Tools Used

* Python 3.11
* Pandas
* NumPy
* Scikit-Learn
* Matplotlib
* Seaborn
* Jupyter Notebook

---

## 📂 Dataset

* UCI Online Retail Dataset
  https://archive.ics.uci.edu/ml/datasets/Online+Retail

---

## ▶️ How to Run

```bash
pip install -r requirements.txt
jupyter notebook customer_segmentation.ipynb
```

---

## ⚠️ Note

This project uses real-world transactional data for analysis.
All insights are derived for portfolio demonstration purposes.

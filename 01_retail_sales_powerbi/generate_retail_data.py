# 📊 Retail Sales Data Generator for Power BI Project

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os

# -------------------------------
# Reproducibility
# -------------------------------
random.seed(42)
np.random.seed(42)

# -------------------------------
# Configuration
# -------------------------------
START_DATE = datetime(2022, 1, 1)
END_DATE   = datetime(2024, 12, 31)
NUM_ROWS   = 8000

REGIONS = ['North', 'South', 'East', 'West', 'Central']

CATEGORIES = [
    'Electronics', 'Clothing', 'Groceries',
    'Furniture', 'Sports', 'Beauty'
]

STORES = {
    'North':   ['Store_N1', 'Store_N2', 'Store_N3'],
    'South':   ['Store_S1', 'Store_S2'],
    'East':    ['Store_E1', 'Store_E2', 'Store_E3'],
    'West':    ['Store_W1', 'Store_W2'],
    'Central': ['Store_C1', 'Store_C2', 'Store_C3'],
}

PRODUCTS = {
    'Electronics': [
        ('Laptop', 45000), ('Smartphone', 25000),
        ('Tablet', 18000), ('Headphones', 3500),
        ('Smart Watch', 12000)
    ],
    'Clothing': [
        ('Jeans', 1800), ('T-Shirt', 799),
        ('Jacket', 3500), ('Saree', 2200),
        ('Shoes', 2800)
    ],
    'Groceries': [
        ('Rice 5kg', 350), ('Dal 1kg', 120),
        ('Oil 1L', 180), ('Milk 1L', 60),
        ('Biscuits', 50)
    ],
    'Furniture': [
        ('Office Chair', 8500), ('Sofa Set', 32000),
        ('Dining Table', 18000), ('Bookshelf', 6500),
        ('Bed Frame', 22000)
    ],
    'Sports': [
        ('Cricket Bat', 2200), ('Yoga Mat', 850),
        ('Dumbbells', 1500), ('Badminton Set', 1200),
        ('Running Shoes', 3500)
    ],
    'Beauty': [
        ('Face Cream', 450), ('Shampoo', 320),
        ('Perfume', 1800), ('Lipstick', 550),
        ('Sunscreen', 380)
    ]
}

# Customers
CUSTOMERS = [f'CUST_{str(i).zfill(4)}' for i in range(1, 501)]

CUSTOMER_NAMES = [
    'Amit Sharma','Priya Patel','Rahul Verma','Sneha Reddy','Vikram Singh',
    'Anjali Nair','Suresh Kumar','Deepa Iyer','Ravi Mehta','Kavya Rao',
    'Arjun Das','Pooja Gupta','Manoj Joshi','Sunita Yadav','Kiran Bhat',
    'Neha Jain','Rohit Agarwal','Divya Pillai','Ashok Tiwari','Meera Nambiar'
] * 25

# -------------------------------
# Generate Sales Data
# -------------------------------
rows = []
order_id = 10001

for _ in range(NUM_ROWS):

    # Random Date
    date = START_DATE + timedelta(
        days=random.randint(0, (END_DATE - START_DATE).days)
    )

    region = random.choices(REGIONS, weights=[20, 18, 22, 25, 15])[0]
    store  = random.choice(STORES[region])

    category = random.choices(
        CATEGORIES,
        weights=[25, 20, 15, 10, 15, 15]
    )[0]

    product, base_price = random.choice(PRODUCTS[category])

    # Seasonal Effect
    if date.month in [10, 11, 12]:
        seasonal_factor = 1.3
    elif date.month in [7, 8, 9]:
        seasonal_factor = 1.1
    else:
        seasonal_factor = 1.0

    quantity = random.choices(
        [1, 2, 3, 4, 5],
        weights=[40, 30, 15, 10, 5]
    )[0]

    unit_price = round(
        base_price * seasonal_factor * random.uniform(0.9, 1.1), 2
    )

    discount = random.choices(
        [0, 5, 10, 15, 20],
        weights=[50, 20, 15, 10, 5]
    )[0]

    revenue = round(unit_price * quantity * (1 - discount / 100), 2)

    profit = round(
        revenue * random.uniform(0.12, 0.35), 2
    )

    cust_idx = random.randint(0, 499)

    rows.append({
        'Order_ID': order_id,
        'Order_Date': date.strftime('%Y-%m-%d'),
        'Month': date.strftime('%Y-%m'),
        'Quarter': f"Q{((date.month-1)//3)+1} {date.year}",
        'Year': date.year,
        'Region': region,
        'Store_ID': store,
        'Category': category,
        'Product_Name': product,
        'Customer_ID': CUSTOMERS[cust_idx],
        'Customer_Name': CUSTOMER_NAMES[cust_idx],
        'Quantity': quantity,
        'Unit_Price': unit_price,
        'Discount_Pct': discount,
        'Revenue': revenue,
        'Profit': profit,
        'Profit_Margin': round((profit / revenue) * 100, 1) if revenue > 0 else 0
    })

    order_id += 1

# Create DataFrame
df = pd.DataFrame(rows)
df = df.sort_values('Order_Date').reset_index(drop=True)

# -------------------------------
# Generate Target Data
# -------------------------------
target_rows = []

for region in REGIONS:
    for year in [2022, 2023, 2024]:
        for month in range(1, 13):
            target_rows.append({
                'Region': region,
                'Year': year,
                'Month_Num': month,
                'Month': f"{year}-{str(month).zfill(2)}",
                'Revenue_Target': random.randint(180000, 320000)
            })

targets_df = pd.DataFrame(target_rows)

# -------------------------------
# Save Data
# -------------------------------
output_path = 'data/retail_sales_data.xlsx'
os.makedirs('data', exist_ok=True)

with pd.ExcelWriter(output_path, engine='openpyxl') as writer:
    df.to_excel(writer, sheet_name='Sales_Data', index=False)
    targets_df.to_excel(writer, sheet_name='Targets', index=False)

# -------------------------------
# Summary Output
# -------------------------------
print("=" * 60)
print("✅ RETAIL SALES DATA GENERATED SUCCESSFULLY")
print("=" * 60)

print(f"📁 File Path:        {output_path}")
print(f"📦 Total Orders:     {len(df):,}")
print(f"💰 Total Revenue:    ₹{df['Revenue'].sum():,.0f}")
print(f"📈 Total Profit:     ₹{df['Profit'].sum():,.0f}")

print(f"\n📅 Date Range:       {df['Order_Date'].min()} → {df['Order_Date'].max()}")
print(f"🌍 Regions:          {df['Region'].nunique()}")
print(f"🛒 Categories:       {df['Category'].nunique()}")
print(f"🏬 Stores:           {df['Store_ID'].nunique()}")
print(f"👥 Customers:        {df['Customer_ID'].nunique()}")

print("\n📊 Revenue by Region:")
print(df.groupby('Region')['Revenue'].sum().apply(lambda x: f"₹{x:,.0f}"))

print("\n📊 Revenue by Category:")
print(df.groupby('Category')['Revenue'].sum().sort_values(ascending=False)
      .apply(lambda x: f"₹{x:,.0f}"))

print("\n🏆 Top 5 Products:")
print(df.groupby('Product_Name')['Revenue'].sum()
      .sort_values(ascending=False).head(5)
      .apply(lambda x: f"₹{x:,.0f}"))

print("\n👉 Next Step: Open Power BI and load the dataset")
print("=" * 60)
import json, pandas as pd

# Compare datasets
df_v1 = pd.read_csv("data/iris.csv")
df_v2 = pd.read_csv("data/iris_v2.csv")

print("=== Dataset Comparison ===")
print(f"V1 shape: {df_v1.shape} | Columns: {list(df_v1.columns)}")
print(f"V2 shape: {df_v2.shape} | Columns: {list(df_v2.columns)}")
print(f"New columns in V2: {list(set(df_v2.columns) - set(df_v1.columns))}")

# Compare metrics
with open("metrics/metrics_v1.json") as f:
    m1 = json.load(f)
with open("metrics/metrics_v2.json") as f:
    m2 = json.load(f)

print("\n=== Model Comparison ===")
print(f"{'Metric':<20} {'Model V1':>10} {'Model V2':>10}")
print("-" * 42)
for key in ["n_estimators", "max_depth", "accuracy"]:
    print(f"{key:<20} {str(m1[key]):>10} {str(m2[key]):>10}")

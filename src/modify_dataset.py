import pandas as pd
from sklearn.datasets import load_iris
import os

os.makedirs("data", exist_ok=True)

# Load original and add engineered feature
df = pd.read_csv("data/iris.csv")
df["petal_ratio"] = df["petal length (cm)"] / (df["petal width (cm)"] + 1e-6)
df.to_csv("data/iris_v2.csv", index=False)

print(f"Dataset v2 saved: {df.shape[0]} rows, {df.shape[1]} columns")
print(f"New feature added: petal_ratio")

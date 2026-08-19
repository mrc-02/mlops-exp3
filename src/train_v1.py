import pandas as pd
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import joblib, json, os

os.makedirs("data", exist_ok=True)
os.makedirs("models", exist_ok=True)
os.makedirs("metrics", exist_ok=True)

# Save dataset v1
iris = load_iris()
df = pd.DataFrame(iris.data, columns=iris.feature_names)
df["target"] = iris.target
df.to_csv("data/iris.csv", index=False)
print("Dataset saved: data/iris.csv")

# Train model v1
X, y = df.drop("target", axis=1), df["target"]
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = RandomForestClassifier(n_estimators=10, max_depth=3, random_state=42)
model.fit(X_train, y_train)
acc = accuracy_score(y_test, model.predict(X_test))

joblib.dump(model, "models/model_v1.pkl")
with open("metrics/metrics_v1.json", "w") as f:
    json.dump({"n_estimators": 10, "max_depth": 3, "accuracy": round(acc, 4)}, f, indent=2)

print(f"Model v1 saved | Accuracy: {acc:.4f}")

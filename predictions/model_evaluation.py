import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import LabelEncoder
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from imblearn.over_sampling import SMOTE

output_dir = os.path.join(os.path.dirname(__file__), 'reports')
os.makedirs(output_dir, exist_ok=True)

current_dir = os.path.dirname(__file__)
data_path = os.path.join(current_dir, '..', 'data', 'forest_health_data_modified.csv')
data = pd.read_csv(data_path)

# setting up target and features
print(f"Loaded data shape: {data.shape}")


label_encoder = LabelEncoder()
data['Health_Status'] = label_encoder.fit_transform(data['Health_Status'])

X = data[['DBH', 'Tree_Height', 'Crown_Width_North_South', 'Crown_Width_East_West',
          'Temperature', 'Humidity', 'Soil_TN', 'Soil_TP', 'Soil_AN',
          'Disturbance_Level', 'Fire_Risk_Index']]
y = data['Health_Status']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# model selection
models = {
    "Logistic Regression": LogisticRegression(max_iter=2000, random_state=42),
    "Decision Tree": DecisionTreeClassifier(random_state=42),
    "Random Forest": RandomForestClassifier(n_estimators=100, random_state=42)
}

results = {}
for model_name, model in models.items():
    print(f"Training {model_name} ...")
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    results[model_name] = {
        "Model": model,
        "Accuracy": accuracy,
        "Classification Report": classification_report(y_test, y_pred, target_names=label_encoder.classes_, output_dict=True),
        "Confusion Matrix": confusion_matrix(y_test, y_pred)
    }

rf_cm = results["Random Forest"]["Confusion Matrix"]
plt.figure(figsize=(8,6))
sns.heatmap(rf_cm, annot=True, fmt='d', cmap='Blues', xticklabels=label_encoder.classes_, yticklabels=label_encoder.classes_)
plt.title("Confusion Matrix - Random Forest")
plt.xlabel("Predicted")
plt.ylabel("True")
plt.show()

comparison = pd.DataFrame({
    model: {
        "Accuracy": metrics["Accuracy"],
        "Precision (macro avg)": metrics["Classification Report"]["macro avg"]["precision"],
        "Recall (macro avg)": metrics["Classification Report"]["macro avg"]["recall"],
        "F1-Score (macro avg)": metrics["Classification Report"]["macro avg"]["f1-score"]
    }
    for model, metrics in results.items()
}).T

comparison.to_csv(os.path.join(output_dir,'model_comparison.csv'), index=True)

# hyperparameter training
param_grid = {
    'n_estimators': [50, 100, 200],
    'max_depth': [None, 10, 20],
    'min_samples_split': [2, 5, 10]
}

grid_search = GridSearchCV(RandomForestClassifier(random_state=42), param_grid, cv=5)
grid_search.fit(X_train, y_train)
print("Best Parameters:", grid_search.best_params_)

feature_importances = results["Random Forest"]["Model"].feature_importances_
feature_df = pd.DataFrame({
    'Feature': X_train.columns,
    'Importance': feature_importances
}).sort_values(by='Importance', ascending=False)

feature_df.to_csv(os.path.join(output_dir, 'feature_importances.csv'), index=False)

plt.figure(figsize=(10,6))
sns.barplot(x='Importance', y='Feature', data=feature_df)
plt.title('Feature Importances - Random Forest')
plt.xlabel('Importance')
plt.ylabel('Feature')
plt.tight_layout()
plt.show()

best_params = grid_search.best_params_
print("Best Parameters Found:", best_params)

final_rf = RandomForestClassifier(**best_params, random_state=42)
final_rf.fit(X_train, y_train)
final_y_pred = final_rf.predict(X_test)

print("\nEvaluation of Final Optimized Random Forest:")
print(f"Accuracy: {accuracy_score(y_test, final_y_pred):.2f}")
print(classification_report(y_test, final_y_pred, target_names=label_encoder.classes_))

final_cm = confusion_matrix(y_test, final_y_pred)
plt.figure(figsize=(8,6))
sns.heatmap(final_cm, annot=True, fmt='d', cmap='Blues', xticklabels=label_encoder.classes_, yticklabels=label_encoder.classes_)
plt.title("Confusion Matrix - Final Optimized Random Forest")
plt.xlabel("Predicted")
plt.ylabel("True")
plt.tight_layout()
plt.show()

smote = SMOTE(random_state=42)
X_train_balanced, y_train_balanced = smote.fit_resample(X_train, y_train)

weighted_rf = RandomForestClassifier(
    max_depth=10,
    min_samples_split=5,
    n_estimators=200,
    random_state=42,
    class_weight='balanced'
)

weighted_rf.fit(X_train_balanced, y_train_balanced)
y_pred_weighted_rf = weighted_rf.predict(X_test)

cm_weighted_rf = confusion_matrix(y_test, y_pred_weighted_rf)
plt.figure(figsize=(8,6))
sns.heatmap(cm_weighted_rf, annot=True, fmt='d', cmap='Blues', xticklabels=label_encoder.classes_, yticklabels=label_encoder.classes_)
plt.title("Confusion Matrix - Weighted Random Forest with SMOTE")
plt.show()



print(classification_report(y_test, y_pred_weighted_rf, target_names=label_encoder.classes_))
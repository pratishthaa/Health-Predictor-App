#!/usr/bin/env python
# coding: utf-8

# In[34]:


import numpy as np
import pandas as pd
import os


# In[35]:


df = pd.read_csv("D:/Git_Repo/Stroke-Predictor-App/API-DIABETES/diabetes.csv")
df.head()


# In[36]:


df.describe()


# In[37]:


from sklearn.model_selection import train_test_split
# import xgboost as xgb

y = df.Outcome
x = df.drop("Outcome", axis=1)
x_train, x_test, y_train, y_test = train_test_split(x, y, train_size=0.8)

# In[38]:


from sklearn.linear_model import LogisticRegression
lr=LogisticRegression()


# In[39]:


lr.fit(x_train,y_train)


# In[40]:


predictions=lr.predict(x_test)


# In[43]:


from sklearn.metrics import accuracy_score, plot_confusion_matrix, f1_score, precision_score, recall_score
print('Logistic Regression model accuracy score: {0:0.4f}'. format(accuracy_score(y_test, predictions)))
print('Logistic Regression model F1 score: {0:0.4f}'. format(f1_score(y_test, predictions)))
print('Logistic Regression model precision score: {0:0.4f}'. format(precision_score(y_test, predictions)))
print('Logistic Regression model recall score: {0:0.4f}'. format(recall_score(y_test, predictions)))



# In[45]:


#from sklearn.externals import joblib
import joblib
joblib.dump(lr, 'model.pkl')
print("Model dumped!")

# Load the model that you just saved
lr = joblib.load('model.pkl')

# Saving the data columns from training
model_columns = list(x_train.columns)
joblib.dump(model_columns, 'model_columns.pkl')
print("Models columns dumped!")






#!/usr/bin/env python
# coding: utf-8

# In[12]:


#First, it is important to import all essential libraries used
#get_ipython().system('pip install imblearn')
import numpy as np
import pandas as pd
#import seaborn as sns
#import matplotlib.pyplot as plt
from sklearn.pipeline import Pipeline
#import matplotlib.ticker as mtick
#import matplotlib.gridspec as grid_spec
#import seaborn as sns
from sklearn.linear_model import LinearRegression,LogisticRegression
from sklearn.tree import DecisionTreeRegressor,DecisionTreeClassifier
#from sklearn.ensemble import RandomForestClassifier
#from sklearn.svm import SVC
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.metrics import accuracy_score, recall_score, roc_auc_score, precision_score, f1_score
from sklearn.preprocessing import StandardScaler,LabelEncoder
from sklearn.model_selection import train_test_split,cross_val_score
import warnings
#import sys
#!{sys.executable} -m pip install xgboost
warnings.simplefilter(action='ignore', category=FutureWarning)
#%matplotlib inline


# In[6]:


df=pd.read_csv(r'D:/Stroke_predictor/API/healthcare-dataset-stroke-data.csv')
#df.head()


# In[7]:


DT_bmi_pipe = Pipeline( steps=[  ('scale',StandardScaler()),('lr',DecisionTreeRegressor(random_state=42))])
X = df[['age','gender','bmi']].copy()
X.gender = X.gender.replace({'Male':0,'Female':1,'Other':-1}).astype(np.uint8)

Missing = X[X.bmi.isna()]
X = X[~X.bmi.isna()]
Y = X.pop('bmi')
DT_bmi_pipe.fit(X,Y)
predicted_bmi = pd.Series(DT_bmi_pipe.predict(Missing[['age','gender']]),index=Missing.index)
df.loc[Missing.index,'bmi'] = predicted_bmi


# In[9]:


str_only = df[df['stroke'] == 1]
no_str_only = df[df['stroke'] == 0]


# In[10]:


no_str_only = no_str_only[(no_str_only['gender'] != 'Other')]


# In[11]:


df['gender'] = df['gender'].replace({'Male':0,'Female':1,'Other':-1}).astype(np.uint8)
df['Residence_type'] = df['Residence_type'].replace({'Rural':0,'Urban':1}).astype(np.uint8)
df['work_type'] = df['work_type'].replace({'Private':0,'Self-employed':1,'Govt_job':2,'children':-1,'Never_worked':-2}).astype(np.uint8)


# In[13]:


X  = df[['gender','age','hypertension','heart_disease','work_type','avg_glucose_level','bmi']]
y = df['stroke']

from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=0.3, random_state=42)


# In[14]:


# Our data is biased, we can fix this with SMOTE

from imblearn.over_sampling import SMOTE

oversample = SMOTE()
X_train_resh, y_train_resh = oversample.fit_resample(X_train, y_train.ravel())


# In[15]:


logreg_pipeline = Pipeline(steps = [('scale',StandardScaler()),('LR',LogisticRegression(random_state=42))])


# In[16]:


logreg_cv = cross_val_score(logreg_pipeline,X_train_resh,y_train_resh,cv=10,scoring='f1')


# In[17]:


logreg_pipeline.fit(X_train_resh,y_train_resh)


# In[19]:


#get_ipython().system('pip install joblib')


# In[24]:


#from sklearn.externals import joblib
import joblib
joblib.dump(logreg_pipeline, 'model.pkl')
print("Model dumped!")

# Load the model that you just saved
logreg_pipeline = joblib.load('model.pkl')

# Saving the data columns from training
model_columns = list(X_train_resh.columns)
joblib.dump(model_columns, 'model_columns.pkl')
print("Models columns dumped!")


# In[ ]:





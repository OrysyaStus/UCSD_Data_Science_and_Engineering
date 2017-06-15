# coding: utf-8

# Name: Orysya Stus
# Email: ostus@eng.ucsd.edu
# PID: A10743411

from pyspark import SparkContext
sc = SparkContext()


# In[3]:

from pyspark.mllib.linalg import Vectors
from pyspark.mllib.regression import LabeledPoint

from string import split,strip

from pyspark.mllib.tree import GradientBoostedTrees, GradientBoostedTreesModel
from pyspark.mllib.tree import RandomForest, RandomForestModel

from pyspark.mllib.util import MLUtils


# ### As done in previous notebook, create RDDs from raw data and build Gradient boosting and Random forests models. Consider doing 1% sampling since the dataset is too big for your local machine

# In[6]:

path='/HIGGS/HIGGS.csv'
inputRDD=sc.textFile(path).sample(False, 0.1, seed=255).cache()


# In[7]:

Data = inputRDD.map(lambda line: [float(strip(x)) for x in line.split(',')])        .map(lambda x: LabeledPoint(x[0], x[1:])).cache()

# In[8]:

# Data1=Data.sample(False,0.1).cache()
(trainingData,testData)=Data.randomSplit([0.7,0.3], seed=255)

# ### Gradient Boosting
errors={}
for depth in [10]:
    model=GradientBoostedTrees.trainClassifier(trainingData, categoricalFeaturesInfo={}, numIterations=10, maxDepth=depth, learningRate=0.25)
    #print model.toDebugString()
    errors[depth]={}
    dataSets={'train':trainingData,'test':testData}
    for name in dataSets.keys():  # Calculate errors on train and test sets
        data=dataSets[name]
        Predicted=model.predict(data.map(lambda x: x.features))
        LabelsAndPredictions=data.map(lambda p: p.label).zip(Predicted)
        Err = LabelsAndPredictions.filter(lambda (v,p):v != p).count()/float(data.count())
        errors[depth][name]=Err
    print depth,errors[depth]

# ### Random Forest
# errors={}
# for depth in [15]:
#     model = RandomForest.trainClassifier(trainingData, numClasses=2, categoricalFeaturesInfo={}, numTrees=10, featureSubsetStrategy='auto', impurity='gini', maxDepth=depth)
#     #print model.toDebugString()
#     errors[depth]={}
#     dataSets={'train':trainingData,'test':testData}
#     for name in dataSets.keys():  # Calculate errors on train and test sets
#         data=dataSets[name]
#         Predicted=model.predict(data.map(lambda x: x.features))
#         LabelsAndPredictions = data.map(lambda p: p.label).zip(Predicted)
#         Err = LabelsAndPredictions.filter(lambda (v,p): v != p).count()/float(data.count())
#         errors[depth][name]=Err
#     print depth,errors[depth]
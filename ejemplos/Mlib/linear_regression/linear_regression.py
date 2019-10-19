from __future__ import print_function
from pyspark.ml.regression import LinearRegression
from pyspark.sql import SparkSession

spark = SparkSession\
    .builder\
    .appName("LinearRegressionWithElasticNet")\
    .getOrCreate()

# $example on$
# Load training data
training = spark.read.format("libsvm")\
    .load("./sample_linear_regression_data.txt")

lr = LinearRegression(maxIter=10, regParam=0.3, elasticNetParam=0.8)

# Fit the model
lrModel = lr.fit(training)

# Print the coefficients and intercept for linear regression
print("Coefficients: %s" % str(lrModel.coefficients))
print("Intercept: %s" % str(lrModel.intercept))

# Summarize the model over the training set and print out some metrics
trainingSummary = lrModel.summary
print("numIterations: %d" % trainingSummary.totalIterations)
print("objectiveHistory: %s" % str(trainingSummary.objectiveHistory))
trainingSummary.residuals.show()
print("RMSE: %f" % trainingSummary.rootMeanSquaredError)
print("r2: %f" % trainingSummary.r2)
# $example off$

spark.stop()
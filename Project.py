import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.svm import SVC
from sklearn.svm import LinearSVC
from sklearn import metrics
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
from sklearn.model_selection import KFold, GridSearchCV

from keras.datasets import cifar10

# import data
(X_train, Y_train), (X_test, Y_test) = cifar10.load_data()
X_train = X_train[0:50000, ]
Y_train = Y_train[0:50000]
X_test = X_test[0:10000, ]
Y_test = Y_test[0:10000]

# visualize data
# labels = ['airplane', 'automobile', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse', 'ship', 'truck']


# process data
# change the data format
# X value
X_train_new = X_train.reshape(-1, 3072)
X_test_new = X_test.reshape(-1, 3072)

# column name of the new format data
col_names = ['pixel_%s'%i for i in range(0, 32*32*3)]
X_train_new = pd.DataFrame(X_train_new, columns = col_names)
X_test_new = pd.DataFrame(X_test_new, columns = col_names)

# # scale data
# X_train_new = X_train_new/255
# X_test_new = X_test_new/255

# Y value
Y_train_new = Y_train.reshape(-1, 1)
Y_test_new = Y_test.reshape(-1, 1)

Y_train_new = pd.DataFrame(Y_train_new, columns=["label"])
Y_test_new = pd.DataFrame(Y_test_new, columns=["label"])


# fit model
# SVM with linear model
linear_model = SVC(kernel='linear')
linear_model.fit(X_train_new, Y_train_new["label"])
Y_predict = linear_model.predict(X_test_new)

print(metrics.accuracy_score(y_true=Y_test_new["label"], y_pred=Y_predict))

cm = confusion_matrix(Y_test_new, Y_predict, labels=linear_model.classes_)
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=linear_model.classes_)
disp.plot()
plt.show()

#
# # SVM with non-linear model
# # Without turning parameters
# # 0.4383 for 10,000; 0.5286 for 50,000
# nonlinear_model = SVC(kernel='poly')
#
# nonlinear_model.fit(X_train_new, Y_train_new)
# Y_predict = nonlinear_model.predict(X_test_new)
#
# print(metrics.accuracy_score(y_true=Y_test_new, y_pred=Y_predict))
#
# # Turning parameters
# folds = KFold(n_splits=6, shuffle=True, random_state=542)
# gamma = [0.1, 0.01, 0.001]
# C = [1, 2, 5, 10]
# params = [{'gamma': gamma, 'C': C}]
#
# # set up GridSearchCV()
# model_cv = GridSearchCV(estimator=linear_model,
#                         param_grid=params,
#                         scoring='accuracy',
#                         cv=folds,
#                         verbose=1,
#                         return_train_score=True)
#
# model_cv.fit(X_train_new, Y_train_new["label"])
# cv_results = pd.DataFrame(model_cv.cv_results_)
# best_params = model_cv.best_params_
# print(best_params)

# # the final model
# finalModel = SVC(C=5, gamma='scale', kernel='rbf', degree=2)
#
#     # LinearSVC(C=1.0, class_weight=None, dual=True, fit_intercept=True,
#     #  intercept_scaling=1, loss='squared_hinge', max_iter=1000,
#     #  multi_class='ovr', penalty='l2', random_state=None, tol=0.0001,
#     #  verbose=0)
#
# finalModel.fit(X_train_new, Y_train_new["label"])
# Y_predict = finalModel.predict(X_test_new)
#
# print(metrics.accuracy_score(y_true=Y_test_new["label"], y_pred=Y_predict))
#
# cm = confusion_matrix(Y_test_new, Y_predict, labels=finalModel.classes_)
# disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=finalModel.classes_)
# disp.plot()
# plt.show()

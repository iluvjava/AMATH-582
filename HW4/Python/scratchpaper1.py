from keras.datasets import mnist
import matplotlib.pyplot as plt
import numpy as np
from sklearn import datasets, svm, metrics
from sklearn.model_selection import train_test_split


def Prepare_Data():
    """
    Read the data and then standardize the data, and then return it.
    Format:
        Rows are all features of one sample, and columns count are the number of samples.
    :return:
    """
    mean = np.mean
    var = np.var
    (train_X, train_y), (test_X, test_y) = mnist.load_data()
    def Standardize(Arr):
        Arr = Arr.reshape((Arr.shape[0], Arr.shape[1]*Arr.shape[2])).astype(np.float)
        Arr -= mean(Arr, axis=1, keepdims=True)
        Arr /= var(Arr, axis=1, keepdims=True)
        return Arr
    TrainData = Standardize(train_X)
    TestData = Standardize(test_X)
    return TrainData, train_y, TestData, test_y


def Perform_SVM(data, labels):
    """
    * Perform training on an SVM
    * Cross validate
    * Report results

    :param data:
        np.array, rows are data and columns are samples
    :param labels:
        1d array with labels.
    :return:
        The model that got trained with the givern data set.
    """
    Xtrain, Xtest, Ytrain, Ytest = train_test_split(data, labels, test_size=0.95, shuffle=True)
    Model = svm.SVC(verbose=True, kernel='poly', degree=2)
    Model.fit(Xtrain, Ytrain)
    print(f"Training SVM completed")
    LabelsPredicted = Model.predict(Xtest)
    print(f"Predicting Labels")
    Loss = sum(LabelsPredicted != Ytest)/len(Ytest)
    print(f"Cross Validation Loss: {Loss}")
    return Model


def Report_Metrics(model, testData, testLabels):

    pass


def main():
    StdTrainData, TrainLabels ,_ ,_ = Prepare_Data()
    print("Prepared data: ")
    print(StdTrainData.shape)
    plt.matshow(StdTrainData[0, ...].reshape(28, 28))
    plt.show()
    Model = Perform_SVM(StdTrainData, TrainLabels)






if __name__ == "__main__":
    import os
    print(f"script running under dir: \n{os.getcwd()}")
    main()
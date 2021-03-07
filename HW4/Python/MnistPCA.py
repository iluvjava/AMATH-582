import numpy as np
from keras.datasets import mnist

class PCAMnist:
    """
        This class manage the training set and the data set and it stores the PCA principal
        modes for dimensionality reduction etc.
    """
    def __inti__(this):
        TrainData, TrainLabels, TestData, TestLabels = Prepare_Data()
        this.TrainX = TrainData
        this.TestX = TestData
        this.TrainY = TrainLabels
        this.TestY = TestLabels


    def Get_Projector(self, energyerLevel):
        
        pass


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
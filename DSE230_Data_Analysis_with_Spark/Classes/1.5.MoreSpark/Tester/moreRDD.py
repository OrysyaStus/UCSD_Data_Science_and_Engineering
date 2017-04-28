import numpy as np
import urllib

from Tester import *

###   Import Dataset  ###
def getData(sc):
    f = urllib.urlretrieve ("http://kdd.ics.uci.edu/databases/kddcup99/kddcup.data_10_percent.gz", "kddcup.data_10_percent.gz")
    data_file = "./kddcup.data_10_percent.gz"
    return sc.textFile(data_file)

###   Exercise 1   ###
def exercise1(pickleFile, func_student, data, sc):
    corAns= getPickledData(pickleFile)['ex1']['outputs']   
    noError = TestRDDK( data=data, func_student=func_student, corAns=corAns[0][0], corType=corAns[0][1], takeK=3)
    if noError == False: raise AssertionError('Your Answer is Incorrect') 

###   Exercise 2   ###
def exercise2(pickleFile, func_student, data, sc):
    corAns= getPickledData(pickleFile)['ex2']['outputs']   
    noError = TestRDDK( data=data, func_student=func_student, corAns=corAns[0][0], corType=corAns[0][1], takeK=5)
    if noError == False: raise AssertionError('Your Answer is Incorrect') 

        
###   Exercise 3   ###
def exercise3(pickleFile, func_student, data, sc): 
    corAns=  getPickledData(pickleFile)['ex3']['outputs'][0][0]  
    corType= getPickledData(pickleFile)["ex3"]["inputs"]
    takeK=9
    
    initDebugStr = data.toDebugString() 
    studentRDD = func_student(data)
    print "Input: "+ str(type(data)) 
    print "Correct Output: " + str(corAns)
    
    newDebugStr  = studentRDD.toDebugString()
    initDebugStr = '|'.join(initDebugStr.split('|')[-1:])[3:50]

    try: assert( initDebugStr.replace(' ','') in newDebugStr.replace(' ','') )
    except AssertionError as e:
        print "\nError: Did you use only Spark commands? Original RDD is not found in execution path."
        return False

    try:
        studentAns = studentRDD.take(takeK)
        for i in range(9):
            assert studentAns[i][0] == corAns[i][0]
            assert  abs(studentAns[i][1]-corAns[i][1]) < 0.0005
    except AssertionError as e:
        print "\nError: Function returned incorrect output"
        print "Your Output: ",studentRDD.take(takeK)
        return False
    
    print "Great Job!"
    return True

    #corAns= getPickledData(pickleFile)['ex3']['outputs'] 
    #noError = TestRDDK(data=data, func_student=func_student, corAns=corAns[0][0], corType=corAns[0][1], takeK=9)
    #if noError == False: raise AssertionError('Your Answer is Incorrect') 
    


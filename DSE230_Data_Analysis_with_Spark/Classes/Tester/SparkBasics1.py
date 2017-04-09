
import pickle

from Tester import *


def exercise1_1(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDD,'ex1_1',sc)
def exercise1_2(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDDStr,'ex1_2',sc)
def exercise1_3(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestNumber,'ex1_3',sc)
def exercise1_4(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestListStr,'ex1_4',sc)
#def exercise1_5(pickleFile, func_student, sc):  
#    checkExerciseFromPickle(pickleFile, lambda x: x.reduce(func_student),TestList,'ex1_5',sc)
def exercise5(pickleFile, func, sc):  
    f = open( pickleFile )
    data = pickle.load(f)
    f.close()
        
    inputs = [ sc.parallelize([[15,20],[21,14],[18,4,20]]),
               sc.parallelize([[3,4,5,-3,19],[19.1],[7,-11]]),
               sc.parallelize([[-3.2,-3.233,-3.9],[-4],[-3,-5]]) ]
    
    def func5(A):
        return A.reduce(func)
    for input,case in zip( inputs, data['ex5'] ):
        TestList( data=input, func_student=func5, corAns=case[0], corType=case[1], isNum=True  ) 
        print ""


        
        
        
        
        
        
        
        
        
        
        
        




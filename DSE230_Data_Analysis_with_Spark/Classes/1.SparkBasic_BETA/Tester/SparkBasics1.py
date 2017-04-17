from Tester import *

def exercise1_1(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDD,'ex1_1',sc)
def exercise1_2(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDDStr,'ex1_2',sc)
def exercise1_3(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestNumber,'ex1_3',sc)
def exercise1_4(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestListStr,'ex1_4',sc)
def exercise1_5(pickleFile, func_student, sc):  
    checkExerciseFromPickle(pickleFile, lambda x: x.reduce(func_student),TestList,'ex1_5',sc)
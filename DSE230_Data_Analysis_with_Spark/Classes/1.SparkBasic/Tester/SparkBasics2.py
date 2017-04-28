from Tester import *

def exercise1(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestNumber,'ex1',sc)
def exercise2(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDD,'ex2',sc)
def exercise3(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDDStr,'ex3',sc)
def exercise4(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDD,'ex4',sc)
def exercise5(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDDStr2,'ex5',sc, twoInputs=True)
def exercise6(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDDStr2,'ex6',sc, twoInputs=True)
def exercise7(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDDStr2,'ex7',sc, twoInputs=True)
def exercise8(pickleFile, func_student, sc):
    checkExerciseFromPickle(pickleFile, func_student,TestRDDStr2,'ex8',sc, twoInputs=True)
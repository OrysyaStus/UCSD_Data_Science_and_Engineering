import pickle

from basic_tester import *

def exercise_1(sql_context, pickleFile, func_student):
    checkExerciseFromPickle(sql_context, pickleFile, func_student,TestList,'ex_1', multiInputs=True)
    
def exercise_2(sql_context, pickleFile, func_student):
    checkExerciseFromPickle(sql_context, pickleFile, func_student,TestList,'ex_2', multiInputs=True)
    
def exercise_3(sql_context, pickleFile, func_student):
    checkExerciseFromPickle(sql_context, pickleFile, func_student,TestNumber,'ex_3', multiInputs=False)
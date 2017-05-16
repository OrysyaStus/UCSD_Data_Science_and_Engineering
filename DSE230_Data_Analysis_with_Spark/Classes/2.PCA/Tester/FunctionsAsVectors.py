import numpy as np
from pylab import *
import math
import pickle
import matplotlib.pyplot as plt
from ipywidgets import interact, interactive, fixed, interact_manual,widgets
import ipywidgets as widgets
import sys
from lib.recon_plot import recon_plot
from lib.Eigen_decomp import Eigen_decomp
from lib.YearPlotter import YearPlotter



    


###   Exercise 1   ###

def exercise1(fstudent):
    step=2*pi/365
    x=arange(0,2*pi,step)
    f1=abs(x-4)
    
    f = open("Tester/hw3.pkl",'r')
    data = pickle.load(f)["fv"]
    f.close()
    vals = [0,2,4,8,16,32,64]
    
    for i in range(len(vals)):
        v= data[i]
        print "Checking getWaves("+str(vals[i])+")"
        studentAns = fstudent(vals[i])
        
        try: assert( len(v)==len(studentAns) )
        except AssertionError as e:
            print "v has incorrect length of "+str(len(studentAns))+", correct length: "+str(len(v))
            raise AssertionError('Your Answer is Incorrect') 
        
        try: assert( len(studentAns[0])== 365 )
        except AssertionError as e:
            print "functions in v have incorrect length of "+str(len(v[0]))+", correct length: 365"
            raise AssertionError('Your Answer is Incorrect') 
        
        try: assert( sum(np.abs( np.array(v)-np.array(studentAns) )) <.01)
        except AssertionError as e:
            print "Some values in v are incorrect"
            raise AssertionError('Your Answer is incorrect') 
    print 
    print "Great Job!"

    
    






    
    
###   Exercise 2   ###

def exercise2(fstudent):
    step=2*pi/365
    x=arange(0,2*pi,step)
    f1=abs(x-4)
    
    f = open("Tester/hw3.pkl",'r')
    data = pickle.load(f)["fv"]
    f.close()
    answers=[20.78835938775,5.127644451785,3.4878090389905,2.590377200299,1.8362464057336,1.2912034552171,0.8783802241723]
    
    nums = [0,2,4,8,16,32,64]
    for i in range(len(nums)):
        v= data[i]
        print
        print "When there are "+str(len(v))+" functions in v:"
        corAns = answers[i]
        studentAns = fstudent(f1,v,x)
        print "Correct output: "+str(corAns)

        try: assert( abs(corAns-studentAns)<.01 )
        except AssertionError as e:
            print "Your Output: \t"+str(studentAns)
            raise AssertionError('Your Answer is Incorrect') 
    print 
    print "Great Job!"

























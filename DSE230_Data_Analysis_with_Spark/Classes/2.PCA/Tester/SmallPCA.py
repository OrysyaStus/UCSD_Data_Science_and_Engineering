import pickle
import numpy as np
import math
from numpy import linalg as LA



def exercise(fstudent, sc):
    f = open("Tester/hw3.pkl",'r')
    thePickle = pickle.load(f)
    datasets = thePickle["pca"]
    answers  = thePickle["pca_correct"]
    f.close()

    for i in range(len(datasets)):
        data   = datasets[i]
        corAns = answers[i] 
        print "Checking data_list of length "+str(len(data))+" with length 10 vectors each having "\
                +str(np.sum(np.isnan(data[0])))+" np.NaN values"
        RDD=sc.parallelize(data)
        studentAns = fstudent(RDD)
        
        #print studentAns; print;print;print;print;print;
        
        # Checking output structure is correct
        try: assert( len(studentAns)==len(corAns) )
        except AssertionError as e:
            print "\ncomputeCov has the wrong output structure, return the same output as the template"
            raise AssertionError('Your Answer is Incorrect') 
            
        try: assert(np.all( np.sort([i1 for i1 in studentAns])==np.sort([i2 for i2 in corAns]) ))
        except AssertionError as e:
            print "\ncomputeCov has the wrong output structure, return the same output as the template"
            raise AssertionError('Your Answer is Incorrect') 
            
        # we check each dictionary output one at a time
        for j in corAns: 
            try: assert( type(corAns[j])==type(studentAns[j]) )
            except AssertionError as e:
                print "\nError in "+j+":"
                print "output["+j+"] has wrong return type return a np.array"
                raise AssertionError('Your Answer is Incorrect') 
                
            try: assert( corAns[j].shape == studentAns[j].shape )
            except AssertionError as e:
                print "\nError in "+j+":"
                print "output["+j+"] has the wrong shape. Correct shape: "+str(corAns[i].shape)
                raise AssertionError('Your Answer is Incorrect') 
            
            try: assert(np.all(  np.abs(corAns[j]-studentAns[j])/np.abs(corAns[j]) <.01  ))
            except AssertionError as e:
                print "\nError in "+j+":"
                print "output["+j+"] has incorrect values"
                raise AssertionError('Your Answer is Incorrect') 
        print
    print "Great Job!"
        




















import pickle

#      ***   WE MUST CHANGE VERY_CLOSE FUNCTION   ***
def GenPickle(sc, func_teacher, inputs, filename, ex, isRDD=True,twoInputs=False ):
    try:
        f = open(filename,'r')
        toPickle = pickle.load(f)
        f.close()
    except:
        toPickle = {}
    
    exData = []
    for input in inputs:
        if twoInputs:
            tmpAns = func_teacher(sc.parallelize(input[0]),sc.parallelize(input[1]))
        else:
            i = sc.parallelize(input)
            tmpAns = func_teacher(i)
        if isRDD:
            exData.append([ tmpAns.collect()  , 
                      type(tmpAns) ]) 
        else:
            exData.append([ tmpAns, 
                      type(tmpAns) ]) 
    toPickle[ex] = {'inputs': inputs, 'outputs':exData}
    
    f = open(filename,'w')
    pickle.dump(toPickle,f)
    f.close()

    
def very_close(A,B,tol=0.000001):
    ''' Check that the two firs parameters are lists of equal length 
    and then check'''
    if (not type(A)==list and type(B) ==list) or len(A)!=len(B):
        return False
    for i in range(len(A)):
        a=A[i]; b=B[i]
        if abs(a-b)>tol:
            return False
    return True 

def TestList(data, func_student, corAns, corType, isNum=True, toPrint=True):
    studentAns = func_student(data)
    
    if toPrint: print "Input: " + str( data.collect() )
    print "Correct Output: " + str(corAns)
    
    try: assert( type(studentAns) == corType )
    except AssertionError as e:
        print "\nError: Incorrect return type. The return type of your function should be: " + str(corType)
        return False
    
    try:
        if isNum:  assert( very_close(studentAns,corAns))
        else:      assert(studentAns == corAns)
    except AssertionError as e:
        print "\nError: Function returned incorrect output"
        print "Your Output: ", studentAns
        return False
    print "Great Job!"
    return True

def TestListStr(data, func_student, corAns, corType):
    return TestList(data, func_student, corAns, corType, isNum=False)


def TestNumber(data, func_student, corAns, corType, toPrint=True):
    studentAns = func_student(data)
    if toPrint: print "Input: " + str( data.collect() )
    print "Correct Output: " + str(corAns)
    
    try: assert( type(studentAns) == corType )
    except AssertionError as e:
        print "\nError: Incorrect return type. The return type of your function should be: "+str(corType)
        return False
    
    try: assert( very_close([studentAns],[corAns]) )
    except AssertionError as e:
        print "\nError: Function returned incorrect output"
        print "Your Output: ", studentAns
        return False
    print "Great Job!"
    return True

def TestRDDStr2(data, func_student, corAns, corType):
    return TestRDD( data, func_student, corAns, corType, isNum=False,twoInputs=True)

def TestRDDStr(data, func_student, corAns, corType,twoInputs=False):
    return TestRDD( data, func_student, corAns, corType, isNum=False)
    
def TestRDDK(data, func_student, corAns, corType,takeK,toPrint=True):
    return TestRDD( data, func_student, corAns, corType, isNum=False, takeK=takeK, toPrint=toPrint)
    
def TestRDD( data, func_student, corAns, corType, isNum=True,twoInputs=False, takeK=0, toPrint=True):
    if twoInputs:
        initDebugStr = data[0].toDebugString()
        studentRDD = func_student(data[0], data[1])
        print "Input: " + str(data[0].collect())
        if toPrint: print data[1].collect()
    else:
        initDebugStr = data.toDebugString()
        studentRDD = func_student(data)
        if toPrint: print "Input: " + str(data.collect())
    
    print "Correct Output: " + str(corAns)
    
    try: assert( type(studentRDD) == corType )
    except AssertionError as e:
        print "\nError: Incorrect return type. The return type of your function should be: " + str(corType)
        return False
    
    newDebugStr  = studentRDD.toDebugString()
    initDebugStr = ' '.join(initDebugStr.split(' ')[1:])

    try: assert( initDebugStr.replace(' ','') in newDebugStr.replace(' ','') )
    except AssertionError as e:
        print "\nError: Did you use only Spark commands? Original RDD is not found in execution path."
        return False

    try:
        if takeK == 0:
            if isNum:  assert( very_close(studentRDD.collect(),corAns))
            else:      assert(studentRDD.collect() == corAns)
        else:
            if isNum:  assert( very_close(studentRDD.take(takeK),corAns))
            else:      assert(studentRDD.take(takeK) == corAns)
    except AssertionError as e:
        print "\nError: Function returned incorrect output"
        if takeK == 0:
            print "Your Output: ",studentRDD.collect()
        else:
            print "Your Output: ",studentRDD.take(takeK)
        return False
    
    print "Great Job!"
    return True

def RddReduce(func):
    return lambda RDD: RDD.reduce(func)

def getPickledData(pickleFileName):
    f = open( pickleFileName )
    data = pickle.load(f)
    f.close()
    return data

def checkExercise(inputs, outputs, func_student, TestFunction, exerciseNumber, sc, twoInputs=False):
    for input,case in zip( inputs, outputs ):
        if twoInputs:
            input = [sc.parallelize(input[0]), sc.parallelize(input[1])]
        else:
            input = sc.parallelize(input)
        noError= TestFunction( data=input, func_student=func_student, corAns=case[0], corType=case[1]  )
        if noError == False: raise AssertionError('Your Answer is Incorrect') 
        print 

def checkExerciseFromPickle(pickleFile, func_student, TestFunction, exerciseNumber, sc, twoInputs=False):
    data = getPickledData(pickleFile)
    inputs = data[exerciseNumber]['inputs']
    outputs = data[exerciseNumber]['outputs']
    checkExercise(inputs, outputs, func_student, TestFunction, exerciseNumber, sc,twoInputs=twoInputs)
    
        
def checkExerciseCorrectAns(inputs, func_teacher, func_student, TestFunction, exerciseNumber, sc,
                            twoInputs=False,isRDD=True):
    outputs = []
    for input in inputs:
        if twoInputs:
            tmpAns = func_teacher(sc.parallelize(input[0]), sc.parallelize(input[1]))
        else:
            tmpAns = func_teacher(sc.parallelize(input))
        if isRDD:
            ty = type(tmpAns)
            tmpAns = tmpAns.collect()
            outputs.append([tmpAns,ty])
        else:
            outputs.append([tmpAns, type(tmpAns)])
    checkExercise(inputs, outputs, func_student, TestFunction, exerciseNumber, sc,twoInputs=twoInputs)
    

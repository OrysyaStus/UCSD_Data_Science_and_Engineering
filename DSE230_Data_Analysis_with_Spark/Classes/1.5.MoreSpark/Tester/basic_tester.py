import pickle

def function_string(inputs, func_name):
    result = func_name + "("
    for i in xrange(0,len(inputs)):
        input_string = ""
        if i != 0:
            input_string += ","
        input_string += "input[" + str(i) + "]" 
        result += input_string
    result += ")"
    return result

def GenPickle(sqlContext, func_teacher, inputs, filename, ex , multiInputs=False):
    try:
        f = open(filename,'r')
        toPickle = pickle.load(f)
        f.close()
    except:
        toPickle = {}
    
    exData = []
    for input in inputs:
        if multiInputs == True:
            tmpAns = func_teacher(input[0],input[1], sqlContext)
        else:
            tmpAns = func_teacher(input[0], sqlContext)

        exData.append([ tmpAns, 
                      type(tmpAns) ]) 
    toPickle[ex] = {'inputs': inputs, 'outputs':exData}
    print "topickle",toPickle
    f = open(filename,'w')
    pickle.dump(toPickle,f)
    f.close()

def TestList(sqlContext, input, func_student, corAns, corType, multiInputs=False):
    
    if multiInputs == True:
        studentAns = func_student(input[0], input[1], sqlContext)
    else:
        studentAns = func_student(input)
    
    #print "Input: " + str(data)
    print "Correct Output: " + str(corAns)
    
    try: assert( type(studentAns) == corType )
    except AssertionError as e:
        print "\nError: Incorrect return type. The return type of your function should be: " + str(corType)
        return False
    
    try:
        assert(sorted(studentAns) == sorted(corAns))
    except AssertionError as e:
        print "\nError: Function returned incorrect output"
        print "Your Output: ", studentAns
        return False
    print "Great Job!"
    return True

def TestNumber(sqlContext, input, func_student, corAns, corType, multiInputs=False):
    
    if multiInputs == True:
        studentAns = func_student(input[0], input[1], sqlContext)
    else:
        studentAns = func_student(input[0], sqlContext)
    
    #print "Input: " + str(data)
    print "Correct Output: " + str(corAns)
    
    try: assert( type(studentAns) == corType )
    except AssertionError as e:
        print "\nError: Incorrect return type. The return type of your function should be: " + str(corType)
        return False
    
    try:
        assert(studentAns == corAns)
    except AssertionError as e:
        print "\nError: Function returned incorrect output"
        print "Your Output: ", studentAns
        return False
    print "Great Job!"
    return True

def getPickledData(pickleFileName):
    f = open( pickleFileName )
    data = pickle.load(f)
    f.close()
    return data

def checkExerciseFromPickle(sql_context, pickleFile, func_student, TestFunction, exerciseNumber, multiInputs=False):
    data = getPickledData(pickleFile)
    inputs = data[exerciseNumber]['inputs']
    outputs = data[exerciseNumber]['outputs']
    checkExercise(sql_context, inputs, outputs, func_student, TestFunction, exerciseNumber, multiInputs=multiInputs)

def checkExercise(sql_context, inputs, outputs, func_student, TestFunction, exerciseNumber, multiInputs=False):
    for input,case in zip( inputs, outputs ):
        noError= TestFunction(sql_context, input=input, func_student=func_student,
                     corAns=case[0], corType=case[1],multiInputs=multiInputs) 
        if noError == False: raise AssertionError("Incorrect Answer")
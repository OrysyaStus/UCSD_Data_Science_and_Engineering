# %load ../../lib/measureRandomAccess.py
import numpy as np
from numpy.random import rand
import time

def measureRandomAccess(size,filename='',k=100000):
    """Measure the distribution of random accesses in computer memory.

    :param size: size of memory block.
    :param filename: a file that is used as an external buffer. If filename=='' then everything is done in memory.
    :param k: number of times that the experiment is repeated.
    :returns: (mean,std,T):
              mean = the mean of T
              std = the std of T
              T = a list the contains the times of all k experiments
    :rtype: tuple

    """
    # Prepare buffer.
    if filename == '':
        inmem=True
        A=bytearray(size)
    else:
        inmem=False
        file=open(filename,'r+')
        
    # Read and write k times from/to buffer.
    sum=0; sum2=0
    T=np.zeros(k)
    for i in range(k):
        if (i%10000==0): print '\r',i,
        t=time.time()
        loc=int(rand()*size)
        if inmem:
            x=A[loc:loc+4]
            A[loc]=(i % 256)
        else:
            file.seek(loc)
            poke=file.read(1)
            file.write("test")
        d=time.time()-t
        T[i]=d
        sum += d
        sum2 += d*d
    mean=sum/k; var=(sum2/k)-mean**2; std=np.sqrt(var)
    if not inmem:
        file.close()
    return (mean,std,T)
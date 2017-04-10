from numpy import arange
from matplotlib.pylab import loglog,grid
from scipy.special import erf,erfinv

def PlotTime(Tsorted,Mean,Std,Color='b',LS='-',Legend='',m_i=1):
    """ plot distribution of times on a log-log scale

    :param Tsorted: a sorted sample of latencies 
    :param Mean: The main of the sample
    :param Std: The STD of the sample
    :param Color: The desired color
    :param LS: LineStyle
    :param Legend: The name for this set of lines in the plot legend
    :param m_i: The number of blocks in the array
    """
    
    P=arange(1,0,-1.0/len(Tsorted))    # probability 
    loglog(Tsorted,P,color=Color,label=Legend,linestyle=LS)       # plot log-log of 1-CDF 
    
    loglog([Mean,Mean],[1,0.0001],color=Color,linestyle=LS)       # vert line at mean
    Y=0.1**((m_i+1.)/2.)
    loglog([Mean,min(Mean+Std,1)],[Y,Y],color=Color,linestyle=LS) # horiz line from mean to mean + std
        
    x=arange(Mean,Mean+Std*erfinv(1.0-1.0/len(Tsorted)),Std/100)  # normal distribution 
    loglog(x,1-erf((x-Mean)/Std),color=Color,linestyle=LS)

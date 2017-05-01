import numpy as np
import matplotlib.pyplot as plt
from ipywidgets import interact, interactive, fixed, interact_manual
import ipywidgets as widgets
 
class Eigen_decomp:
    """A class for approximating a function with an orthonormal set of
    function    """
    
    def __init__(self,x,f,mean,v):
        """ Initialize the widget

        :param x: defines the x locations
        :param f: the function to be approximated
        :param mean: The initial approximation (the mean)
        :param v: a list of numpy.arrays that are the eigenvectors
        :returns: None
        """
        # Todo: test parameters for type and orthonormality.
        #if type(v) != list:
        #    err+='recon_plot: type of parameter v is'+)

        self.v=[np.array(vec,dtype=np.float64) for vec in v]
        self.x=x
        self.mean=mean
        self.U=np.vstack(v)
        self.f=f
        self.startup_flag=True
        self.C=np.dot(self.U,np.nan_to_num(f)-mean)  # computer the eigen-vectors coefficients.
        self.n,self.m=np.shape(self.U)
        self.coeff={'c'+str(i):self.C[i] for i in range(len(self.C))} # Put the coefficient in the dictionary format that is used by "interactive".
        return None

    def compute_var_explained(self):
        """Compute a summary of the decomposition

        :returns: ('total_energy',total_energy),
                ('residual var after mean, eig1,eig2,...',residual_var[0]/total_energy,residual_var[1:]/residual_var[0]),
                ('reduction in var for mean,eig1,eig2,...',percent_explained[0]/total_energy,percent_explained[1:]/residual[0]),
                ('eigen-vector coefficients',self.C)

        :rtype: tuple of pairs. The first element in each pair is a
        description, the second is a number or a list of numbers or an
        array.

        """
        def compute_var(vector):
            v=np.array(np.nan_to_num(vector),dtype=np.float64)
            return np.dot(v,v) # /float(total_variance)
        
        residual_var=np.zeros(self.n+1)
        residual=self.f
        total_energy=compute_var(residual)
        residual=residual-self.mean
        residual_var[0]=compute_var(residual)
        for i in range(self.n):
            g=self.v[i]*self.coeff['c'+str(i)]
            residual=residual-g
            residual_var[i+1]=compute_var(residual)
        percent_explained=np.zeros(self.n+1)
        percent_explained[0]=total_energy-residual_var[0]  # percent explained by mean
        for i in range(self.n):
            percent_explained[i+1]=residual_var[i]-residual_var[i+1]
        _residuals=residual_var[1:]/residual_var[0]
        _residuals=np.insert(_residuals,0,residual_var[0]/total_energy)
        _percent_explained=percent_explained[1:]/residual[0]
        _percent_explained=np.insert(_percent_explained,0,percent_explained[0]/total_energy)
        return (('total_energy',total_energy),
                ('residual var after mean, eig1,eig2,...',_residuals),
                ('reduction in var for mean,eig1,eig2,...',_percent_explained),
                ('eigen-vector coefficients',self.C)
        )
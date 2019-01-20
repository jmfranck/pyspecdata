#!/usr/bin/env python
# coding: utf-8

# 


#!/usr/bin/env python


# 


try:
    get_ipython().magic(u'load_ext pyspecdata.ipy')
    in_notebook = True
except:
    from pyspecdata import *
    in_notebook = False
from pyspecdata import nnls_regularized
from numpy import random
import time
fl=figlist_var()
init_logging(level='debug')


# got the following from here:

# 


#https://medium.com/pythonhive/python-decorator-to-measure-the-execution-time-of-methods-fa04cb6bb36d
l_line = ''
def timeit(method,n_times=1):
    def timed(*args, **kw):
        timing = zeros(n_times+1)
        timing[0] = time.time()
        for j in range(n_times):
            result = method(*args, **kw)
            timing[j+1] = time.time()
        time_diff = (timing[-1]-timing[0])/float(n_times)
        if 'log_time' in kw:
            name = kw.get('log_name', method.__name__.upper())
            kw['log_time'][name] = int(time_diff * 1000)
        else:
            print '%r  %2.2f ms (average of %d runs)' %                   (method.__name__, time_diff * 1000, n_times) + l_line
        return result
    return timed


# 


R = c_[1.:100:500j] # distribution of T2 relaxation rates
peaks = [(80,4,1),(20,0.5,0.5),(30,0.5,0.25)]
calcd = False
for mu,sigma,A in peaks:
    if not calcd:
        P = A*exp(-(R-mu)**2/(2*sigma**2))
        calcd = True
    else:
        P += A*exp(-(R-mu)**2/(2*sigma**2))


# Vary R as we move along the rows

# 


P = P.T
R = R.T
fl.next('distribution function')
plot(R.flatten(),P.flatten())


# 


endp = 0.2
t = c_[1e-3:endp:2048j] # column vectors give functions of time
test_signal = exp(-R*t).dot(P.T)

test_signal += random.normal(scale = 0.01,size=(2048,1))
print test_signal.shape
print t.squeeze().shape
fl.next('test data function')
test_data = nddata(test_signal.flatten(),'t').labels('t',t)
plot(test_data)
xlim(-endp/10,endp)


# 


test_data.nnls('t',{'R':R.ravel()},lambda x,y: exp(-y*x), l=0.)


# 





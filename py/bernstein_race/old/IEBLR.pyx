import numpy as np
from mpire import WorkerPool

pool = WorkerPool(n_jobs=5)

cdef float epsilon, delta, LB, UB, mu, sig
cdef short n_max
cdef int n, t
cdef list X_t

epsilon = 0.01
delta = 0.05
n_max = 208
t0 = 6-1

def cB_n(n, sig, delta = 0.05, epsilon = 0.01):
    return sig * np.sqrt(2*np.log(3*n_max/delta)/(n+t0)**2) + 3*np.log(3*n_max/delta)/(n+t0)**2

def IEBLR(symulation, p1, p2, delta = 0.05, epsilon = 0.01, n_max = 208, n_jobs = 4):
    LB = 0
    UB = 1
    t = 1
    X_t = []
    with  WorkerPool(n_jobs=n_jobs) as pool:
        for n in range(1, n_max):
            # X_t.extend(np.random.random(size=2*n - 1))
            X_t.extend(pool.map(symulation, [[p1, p2]]*(2*n - 1)))
            mu = np.mean(X_t)  
            sig = np.std(X_t)
            cn = cB_n(n, sig)
            LB = max(LB, mu - cn)
            UB = min(UB, mu + cn)
            if UB - LB < 2*epsilon:
                break
    return mu



def IEBLR2(symulation, p1, p2, delta = 0.05, epsilon = 0.01, n_max = 208, n_jobs = 4):
    LB = 0
    UB = 1
    t = 1
    X_t = []
    with  WorkerPool(n_jobs=n_jobs) as pool:
        for n in range(1, n_max):
            # X_t.extend(np.random.random(size=2*n - 1))
            X_t.extend(pool.map(symulation, [[p1, p2]]*(2*n - 1)))
            mu = np.mean(X_t)  
            sig = np.std(X_t)
            cn = cB_n(n, sig)
            LB = max(LB, mu - cn)
            UB = min(UB, mu + cn)
            if UB - LB < 2*epsilon:
                break
            elif UB < 0.5:
                break
            elif LB > 0.5:
                break
    if LB > 0.5:
        return 1
    elif UB < 0.5:
        return 2
    elif mu > 0.5:
        return 1
    else:
        return 2
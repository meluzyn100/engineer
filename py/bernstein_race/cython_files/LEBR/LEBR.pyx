import numpy as np

cdef float epsilon, delta, LB, UB, mu, sig
cdef short n_max
cdef int n, t
cdef list X_t

epsilon = 0.01
delta = 0.05
pi= np.pi

def eB_n(n, sig, delta = 0.05, epsilon = 0.01):
    d_n = delta/n**2 * 6/pi**2
    return sig * np.sqrt(2*np.log(3/d_n)/n) + 3*np.log(3/d_n)/n



def LEBR(symulation, p1, p2, delta = 0.05, epsilon = 0.01):
    LB = 0
    UB = 1
    t = 0
    X_t = []
    n = 1
    sumx=0
    sumx2=0
    while UB - LB > 2*epsilon:
        # Xt = np.random.choice([1, 0],p=[0.01,0.99])
        Xt= symulation(p1, p2)
        t+=1
        sumx += Xt
        sumx2 += Xt**2
        mu = sumx/(t)
        sig = np.sqrt(sumx2/t - mu**2)
        e_n = eB_n(n, sig)
        LB = max(LB, mu - e_n)
        UB = min(UB, mu + e_n)
        d = UB - LB
        n+=1
    return mu


def LEBR_test(p, delta = 0.05, epsilon = 0.01):
    np.random.seed()
    LB = 0
    UB = 1
    t = 0
    n = 1
    sumx = 0
    sumx2 = 0
    while UB - LB > 2*epsilon:
        Xt = np.random.choice([1, 0],p=[p, 1-p])
        t+=1
        sumx += Xt
        sumx2 += Xt**2
        mu = sumx/(t)
        sig = np.sqrt(sumx2/t - mu**2)
        e_n = eB_n(n, sig)
        LB = max(LB, mu - e_n)
        UB = min(UB, mu + e_n)
        n+=1
    return mu, t
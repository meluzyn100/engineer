import numpy as np

cdef float epsilon, delta, LB, UB, mu, sig
cdef int n_max
cdef int n, t
cdef list X_t

epsilon = 0.01
delta = 0.05
n_max = 205
t0=8-1

def eB_n(n, sig, delta = 0.05, epsilon = 0.01):
    return sig * np.sqrt(2*np.log(3*n_max/delta)/(n+t0)**2) + 3*np.log(3*n_max/delta)/(n+t0)**2

def ILEBR_star2_test(p, delta = 0.05, epsilon = 0.01, n_max = n_max):
    np.random.seed()
    LB = 0
    UB = 1
    t = t0**2
    # XT0 = [symulation(p1, p2) for i in range(t0)]
    XT0 = np.random.choice([1, 0],p=[p, 1-p], size=t)
    sumx= sum(XT0)
    sumx2= sum(XT0**2)
    for n in range(1, n_max+1):
        for i in range(2*(n+t0) - 1):
            Xt = np.random.choice([1, 0],p=[p, 1-p])
            # Xt= symulation(p1, p2)
            t+=1
            sumx += Xt
            sumx2 += Xt**2
            mu = sumx/(t)
            sig = np.sqrt(sumx2/t - mu**2)
        e_n = eB_n(n, sig)
        LB = max(LB, mu - e_n)
        UB = min(UB, mu + e_n)
        if UB - LB < 2*epsilon:
            break
        elif UB < 0.5:
            break
        elif LB > 0.5:
            break
    if LB > 0.5:
        return 1, t
    elif UB < 0.5:
        return 0, t
    elif mu > 0.5:
        return 1, t
    else:
        return 0, t

def ILEBR_star2(symulation, p1, p2, pool, delta = 0.05, epsilon = 0.01, n_max = n_max):
    np.random.seed()
    LB = 0
    UB = 1
    t = t0**2
    XT0 = np.array([symulation(p1, p2) for i in range(t)])
    sumx= np.sum(XT0)
    sumx2= np.sum(XT0**2)
    for n in range(1, n_max+1):
        games_to_play = 2*(n+t0) - 1
        X_t = np.array(pool.map(symulation, [[p1, p2]] * games_to_play))
        sumx += np.sum(X_t)
        sumx2 += np.sum(X_t**2)
        t += games_to_play
        
        mu = sumx/(t)
        
        sig = np.sqrt(sumx2/(t) - mu**2)
        
        e_n = eB_n(n, sig)
        LB = max(LB, mu - e_n)
        UB = min(UB, mu + e_n)
        if UB - LB < 2*epsilon:
            break
        elif UB < 0.5:
            break
        elif LB > 0.5:
            break
    if LB > 0.5:
        return 1
    elif UB < 0.5:
        return 0
    elif mu > 0.5:
        return 1
    else:
        return 0
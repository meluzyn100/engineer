import numpy as np

cdef float epsilon, delta, LB, UB, mu, sig
cdef int n_max
cdef int n, t
cdef list X_t

epsilon = 0.01
delta = 0.05
n_max = 213

def eB_n(n, sig, delta = 0.05, epsilon = 0.01):
    return sig * np.sqrt(2*np.log(3*n_max/delta)/n**2) + 3*np.log(3*n_max/delta)/n**2

def ILEBR_star_test(p, delta = 0.05, epsilon = 0.01, n_max = n_max):
    np.random.seed()
    LB = 0
    UB = 1
    t = 0
    sumx=0
    sumx2=0
    for n in range(1, n_max+1):
        for i in range(2*n - 1):
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
def ILEBR_star(symulation, p1, p2, pool, delta = 0.05, epsilon = 0.01, n_max = n_max):
    np.random.seed()
    LB = 0
    UB = 1
    t = 0
    sumx = 0
    sumx2 = 0
    for n in range(1, n_max+1):
        games_to_play = 2*(n) - 1
        Xt = np.array(pool.map(symulation, [[p1, p2]] * games_to_play))
        sumx += sum(Xt)
        sumx2 += sum(Xt**2)
        t += games_to_play
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
        return 1
    elif UB < 0.5:
        return 0
    elif mu > 0.5:
        return 1
    else:
        return 0
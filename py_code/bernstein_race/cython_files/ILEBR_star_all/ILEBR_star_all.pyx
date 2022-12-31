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


def ILEBR_star_all(symulation, p1, ps, pool, delta = 0.05, epsilon = 0.01, n_max = n_max):
    np.random.seed()
    LB = 0
    UB = 1
    t = 0
    sumx=0
    sumx2=0
    ps_range = range(len(ps))
    ps = np.array(ps)
    for n in range(1, n_max+1):
        games_to_play = 2*(n) - 1
        p2 = np.random.choice(ps_range, games_to_play ,replace=True)
        games_par = [[p1, list(p)] for p in ps[p2]]
        X_t = np.array(pool.map(symulation, games_par ))
        sumx += np.sum(X_t)
        sumx2 += np.sum(X_t**2)
        t += games_to_play
        mu = sumx/(t)
        sig = np.sqrt(sumx/(t) - mu**2)
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


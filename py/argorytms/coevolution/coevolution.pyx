import numpy as np
import random 
from datetime import datetime
from mpire import WorkerPool

import sys
sys.path.append(str(__file__).rsplit("/", 3)[0])
# from bernstein_race.cython_files.ILEBR_star2.ILEBR_star2 import ILEBR_star2
from bernstein_race.cython_files.ILEBR_star.ILEBR_star import ILEBR_star


cdef float epsilon, delta, sig
cdef int n_jobs, i_max




epsilon = 0.01
delta = 0.05

# def confert_to_p(x):
#     p = np.exp(x)
#     return p/np.sum(p)

def coevolution(x0, symulation, n_jobs = 4, delta = 0.01, epsilon = 0.05, i_max = np.inf):
    cdef int n, i, iterations 
    sig = 1
    x0 = np.array(x0)
    P = [x0]
    n = len(x0)
    i = 0
    iterations = 0
    with WorkerPool(n_jobs = n_jobs) as pool:
        with open("x_coevolution", "w+") as file:
            while 1:
                child = P[-1] + sig * np.random.normal(size = n) 
                for ancestor in P:
                    # p1 = confert_to_p(child)
                    # p2 = confert_to_p(ancestor)
                    # print("child:", child, "ancestor: ", ancestor)
                    race = ILEBR_star(symulation, child, ancestor, 
                                    delta = delta, epsilon = epsilon, pool = pool)
                    # print("race: ", race)
                    if race == 0:
                        break
                if race == 1:
                    P.append(child)
                    sig = 1.25*sig #ograniczamy wariancje
                    today = datetime.now()
                    i+=1
                    print(f"{i}, P: {P}, sig: {sig}, data: {today}")
                    file.write(f"{i}, {P}, {today} \n")
                else:
                    sig = 0.84*sig
                    print("sig: ", sig)

                iterations+=1
                if iterations > i_max:
                    return P[-1]
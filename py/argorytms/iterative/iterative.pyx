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

def confert_to_p(x):
    p = np.exp(x)
    return p/np.sum(p)

def iterative(x0, symulation, n_jobs = 4, delta = 0.01, epsilon = 0.05, i_max = np.inf):
    cdef int n, i, iterations 
    sig = 1
    x0 = np.array(x0)
    x = x0
    n = len(x0)
    i = 0
    iterations = 0
    with WorkerPool(n_jobs = n_jobs) as pool:
        with open("x_iterativ", "w+") as file:
            while 1:
                child = [x_i + sig * np.random.normal() for x_i in x] #python limitation
                # p1 = confert_to_p(child)
                # p2 = confert_to_p(x)
                race = ILEBR_star(symulation, child, x, 
                                delta = delta, epsilon = epsilon, pool = pool)
                if race == 1:
                    x = child
                    sig = 1.25*sig
                    today = datetime.now()
                    i+=1
                    print(f"{i}, x: {x}, sig: {sig}, data: {today}")
                    file.write(f"{i}, {x}, {today} \n")
                else:
                    sig = 0.84*sig
                    print("sig: ", sig)

                iterations+=1
                if iterations > i_max:
                    return x
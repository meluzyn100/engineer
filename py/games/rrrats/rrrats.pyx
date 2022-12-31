import random
import numpy as np
cimport numpy as np
np.import_array()

import collections
from mpire import WorkerPool
cdef short max_points
max_points = 31


cdef class Player():
    cdef short hand, points
    cdef np.ndarray strategy
    def __init__(self, strategy) -> None:
        self.hand = 0
        self.points = 0
        self.strategy = np.exp(strategy, dtype = np.float128)

    def set_hand(self, n):
        self.hand = n
    
    def add_to_hand(self, n):
        self.hand += n
        
    def get_points(self):
        return self.points
    
    def get_hand(self):
        return self.hand
    
    def add_points(self, n):
        self.points += n
        
    def sub_points(self, n):
        self.points -=n
    
    def calc_weights(self, x, n, pile, gamma, delta):
        # return np.exp(x[0] + x[1]*delta + x[2]*delta**2/n + x[3]*delta**3/n**2 + x[4]*gamma + x[5]*gamma**2/n + x[6]*gamma**3/n**2 , dtype = np.float128)
        # return np.exp(x[0] + x[1]*delta/pile + x[2]*delta**2/pile**2 + x[3]*gamma/pile + x[4]*gamma**2/pile**2  , dtype = np.float128)
        return np.exp(x[0], dtype = np.float128)


    def get_p(self, strategy, oponent_points, pile):
        n =  max_points - self.points
        gamma = min(n-oponent_points, 0)
        delta = max(n-oponent_points, 0)
        weights = np.apply_along_axis(self.calc_weights, 1, strategy, n, pile, gamma, delta)
        return weights
    
cdef class rrrats4_player(Player):
    def make_decision_about_throw(self, oponent_points, pile):
        if self.hand == 0:
            return 1
        elif self.hand == 1:
            choice = random.choices([1, 0], weights = self.strategy[:2])[0]
        elif self.hand == 2:
            choice = random.choices([1, 0], weights = self.strategy[2:4])[0]
        else:
            choice = random.choices([1, 0], weights = self.strategy[4:])[0]
        return choice

def tour(player_1, player_2, pile):
    for i in range(4):
        tour_results = player_1.make_decision_about_throw(player_2.get_points(), pile)
        if tour_results == 1:
            draw = [random.choices([0, 1, 2], weights = [3, 2, 1])[0], random.choices([0, 1, 2], weights = [3, 2, 1])[0]]            
            if draw == [0,0]:
                pile += player_1.get_hand()
                player_1.set_hand(0)
                break
            
            if draw[0] == 1:
                player_1.add_to_hand(1)
                pile -= 1
            elif draw[0] == 2:
                if player_2.get_points() > 0: #still from oponent
                    player_2.sub_points(1)
                    player_1.add_to_hand(1)
                else:
                    player_1.add_to_hand(1)
                    pile -= 1
            else:
                pass
            if pile < 1:
                break
            if draw[1] == 1:
                player_1.add_to_hand(1)
                pile -= 1
            elif draw[1] == 2:
                if player_2.get_points() > 0: #still from oponent
                    player_2.sub_points(1)
                    player_1.add_to_hand(1)
                else:
                    player_1.add_to_hand(1)
                    pile -= 1
            else:
                pass

            if pile < 1:
                break
        else:
            break
        
    if player_1.get_hand() > 4:
        pile +=  player_1.get_hand() - 4
        player_1.set_hand(4)
    player_1.add_points(player_1.get_hand())
    player_1.set_hand(0)
    return pile

def symulation(parameters1, parameters2):
    cdef short pile
    np.random.seed()
    
    pile = max_points
    player_1 = rrrats4_player(parameters1)
    player_2 = rrrats4_player(parameters2)
    
    while True:
        # try:
            pile = tour(player_1, player_2, pile)
            if pile < 1:
                break
            pile = tour(player_2, player_1, pile)
            if pile < 1:
                break

        # except ValueError: 
            # print("hahahahah")
            # break
    if player_1.get_points() > player_2.get_points():
        return 1
    else:
        return 0
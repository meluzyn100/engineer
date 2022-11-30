import random
import numpy as np
import collections
import multiprocessing
from collections import deque
from mpire import WorkerPool

cdef list deck
cdef short deck_len
cdef double parameters_0[3]
cdef int games_to_play

deck = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]*4  # deck of 52 cards
deck_len = len(deck)
parameters_0 = [1, 1, 1]

cdef class Player():
    """
    A class that represents a player's basic moves
    """
    # cdef double parameters[3]
    cdef list hand, cards
    cdef char card
    cdef double parameters[3], strategy[3]

    def __init__(self, parameters, cards):
        if cards is None:
            self.hand = [0]*52
        else:
            self.hand = cards
    
        self.strategy = [np.exp(i) for i in parameters]
        
    def get_card(self) :
        return self.hand.pop(0)

    def add_card(self, card):
        self.hand.append(card)

    def add_cards(self, cards):
        for card in cards:
            self.add_card(card)

    def get_hend_len(self):
        return len(self.get_hand())
    
    def get_hand(self) -> list:
        return self.hand
        
cdef class war3_player(Player):
    cdef char choice
    def make_decision(self, cards):
        choice = random.choices([1, 2, 3], self.strategy)[0]
        if choice == 1: 
            cards = sorted(cards)
        elif choice == 2:
            cards = sorted(cards, reverse=True)
        else:
            random.shuffle(cards)
            
        self.add_cards(cards)
        
def battle(player_1, player_2):
    cdef char player_1_card, player_2_card, winner, player_1_card_1, player_2_card_1, player_1_card_2, player_2_card_2
    cdef list cards
    
    player_1_card = player_1.get_card()
    player_2_card = player_2.get_card()
    cards = [player_1_card, player_2_card]
    if player_1_card > player_2_card:
        winner = 1
        return winner, cards
    elif player_2_card > player_1_card:
        winner = 2
        return winner, cards
    else:
        while 1:
            player_1_card_1 = player_1.get_card()
            player_2_card_1 = player_2.get_card()
            player_1_card_2 = player_1.get_card()
            player_2_card_2 = player_2.get_card()
            cards.extend([player_1_card_1, player_2_card_1,
                        player_1_card_2,player_2_card_2])
            if player_1_card_2 > player_2_card_2:
                winner = 1
                return winner, cards
            elif player_2_card_2 > player_1_card_2:
                winner = 2
                return winner, cards
            
def symulation(player_1, player_2):
    cdef char battle_winner
    cdef list cards
    while 1:
        try:
            battle_winner, cards = battle(player_1, player_2)
            if battle_winner == 1:
                player_1.make_decision(cards)
            else:
                player_2.make_decision(cards)
        except:
            if player_1.get_hend_len() == 0:
                return 1
            else:
                return 2

            
random.shuffle(deck)
player_1 = war3_player(parameters_0, deck[0:int(deck_len/2)])
player_2 = war3_player(parameters_0, deck[int(deck_len/2):deck_len])

games_to_play = 100000
# cdef double x[100][2][3]
x = [[player_1, player_2]]*games_to_play

def test(symulation, x):
    # with WorkerPool(n_jobs=5) as pool:
    pool = WorkerPool(n_jobs=5)
    return pool.map(symulation, x)
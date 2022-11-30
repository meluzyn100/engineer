import random
import numpy as np
import collections
from mpire import WorkerPool

cdef list decks
cdef short deck_len, half_deck_len
cdef double parameters_0[3]
cdef int games_to_play

deck = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]*4  # deck of 52 cards
deck_len = len(deck)
half_deck_len = int(deck_len/2)
parameters_0 = [1, 1, 1]

cdef class Player():
    """
    A class that represents a player's basic moves
    """
    cdef list hand, cards
    cdef char card
    cdef double parameters[3], strategy[3]

    def __init__(self, parameters, cards = None):
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
    
    def set_hend(self,cards):
        self.hand = cards
        
cdef class war3_player(Player):
    cdef char choice
    def make_decision(self, cards):
        choice = random.choices([1, 2, 3], weights = self.strategy)[0]
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
            
def symulation(parameters1, parameters2, deck = deck):
    cdef char battle_winner
    cdef list cards
    cdef list shuffle_decl
    
    shuffle_decl = random.sample(deck, deck_len)
    player_1 = war3_player(parameters1)
    player_2 = war3_player(parameters2)
    player_1.set_hend(shuffle_decl[0:half_deck_len])
    player_2.set_hend(shuffle_decl[half_deck_len:deck_len])

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
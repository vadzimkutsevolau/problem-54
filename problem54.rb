# combinations
# royal_flush = 10
# straight_flush = 9
# four_of_a_kind = 8
# full_house = 7
# flush = 6
# straight = 5
# three_of_a_kind = 4
# two_pairs = 3
# pair = 2
# _____________________
# A = 14
# K = 13
# Q = 12
# J = 11
# T= 10
# _____________________


file = File.read("problem54/p054_poker.txt")
arr = file.split("\n")
arr_new = arr.map {|x| x.delete(' ')}

def create_two_players_hands(lists_string)
	two_hands = lists_string.insert(10, " ").split(" ").map {|x| x.chars}
	players1_card = [two_hands[0][0], two_hands[0][2], two_hands[0][4], two_hands[0][6], two_hands[0][8]]
	players1_color = [two_hands[0][1], two_hands[0][3], two_hands[0][5], two_hands[0][7], two_hands[0][9]]
	players2_card = [two_hands[1][0], two_hands[1][2], two_hands[1][4], two_hands[1][6], two_hands[1][8]]
	players2_color = [two_hands[1][1], two_hands[1][3], two_hands[1][5], two_hands[1][7], two_hands[1][9]]
	hands = [players1_card, players1_color, players2_card, players2_color]
end
# _______________________________________________________________
# this block of code used for testing all combinations one by one
# string from 0 to 999 in given list
# given_string = 1
# hands for each player splitted by cards and colors
# hands[0] - player1 cards, hands[1] - player1 colors, hands[2] - player2 cards, hands[3] - player2 colors
# hands = ["2", "2", "3", "2", "2"]
# colors = ["D", "D", "D", "D", "D"]
# _______________________________________________________________


all_hands = arr_new.map {|x| create_two_players_hands(x)}


def kicker(players_cards)
	kicker = 0
	players_cards.map do |x|
		if x == "A"
			kicker = 14
		elsif x == "K" && 13 >= kicker
			kicker = 13
		elsif x == "Q" && 12 >= kicker 
			kicker = 12
		elsif x == "J" && 11 >= kicker
			kicker = 11
		elsif x == "T" && 10 >= kicker
			kicker = 10
		elsif x == "9" && 9 >= kicker
			kicker = 9
		elsif x == "8" && 8 >= kicker
			kicker = 8
		elsif x == "7" && 7 >= kicker
			kicker = 7
		elsif x == "6" && 6 >= kicker
			kicker = 6
		elsif x == "5" && 5 >= kicker
			kicker = 5
		elsif x == "4" && 4 >= kicker
			kicker = 4
		elsif x == "3" && 3 >= kicker
			kicker = 3
		elsif x == "2" && 2 >= kicker
			kicker = 2
		end
	end
	kicker
end

def pairs(players_cards)
	pairs = players_cards.each_with_object(Hash.new(0)) { |pairs,counts| counts[pairs] += 1 }
	pairs_count = 0
	pairs_points = 0
	pairs.map do |k, v| 
		if v == 2
			pairs_count += 1
		end
	end
	if pairs_count == 1
		pairs_points = 2
	elsif pairs_count == 2
		pairs_points = 3
	end
	pairs_points
end

def three_of_a_kind(players_cards)
	threes = players_cards.each_with_object(Hash.new(0)) { |threes,counts| counts[threes] += 1 }
	threes_points = 0
	threes.map do |k, v|
		if v == 3
			threes_points = 4
		end
	end
	threes_points
end

def straight(players_cards)
	straight = {14 => "A", 13 => "K", 12 => "Q", 11 => "J", 10 => "T", 9 => "9", 8 => "8", 7 => "7", 6 => "6", 5 => "5", 4 => "4", 3 => "3", 2 => "2"}
	kicker_points = kicker(players_cards)
	straight_points = 0

	if players_cards.include?(straight[kicker_points-1]) && players_cards.include?(straight[kicker_points-2]) && players_cards.include?(straight[kicker_points-3]) && players_cards.include?(straight[kicker_points-4])
		straight_points = 5
	else
		straight_points = 0
	end
	straight_points
end

def flush(players_color)
	flush = players_color.each_with_object(Hash.new(0)) { |color,counts| counts[color] += 1 }
	flush_points = 0
	flush.map do |k, v|
		if v == 5
			flush_points = 6
		end
	end
	flush_points
end

def full_house(players_cards)
	full_house_points = 0
    if three_of_a_kind(players_cards) == 4 && pairs(players_cards) == 2
    	full_house_points = 7
    end
    full_house_points
end


def four_of_a_kind(players_cards)
	fours = players_cards.each_with_object(Hash.new(0)) { |fours,counts| counts[fours] += 1 }
	fours_points = 0
	fours.map do |k, v|
		if v == 4
			fours_points = 8
		end
	end
	fours_points
end


def straight_flush(players_cards, players_color)
	straight_flush_points = 0
	if straight(players_cards) == 5 && flush(players_color) == 6
		straight_flush_points = 9
	end

	straight_flush_points
    
end

def royal_flush(players_cards, players_color)
	royal_flush_cards = ["T", "J", "Q", "K", "A"]
	royal_flush_points = 0
    if royal_flush_cards.sort == players_cards.sort && flush(players_color) == 6
    	royal_flush_points = 10
    end
    royal_flush_points
end

def highest_card_if_pair_is_in_hand(players_cards)
	pairs = players_cards.each_with_object(Hash.new(0)) { |pairs,counts| counts[pairs] += 1 }
	keys = []
	pairs.map do |k, v|
		if v == 2 || v == 3 || v == 4
			keys << k
		end
	end
	rating = {14 => "A", 13 => "K", 12 => "Q", 11 => "J", 10 => "T", 9 => "9", 8 => "8", 7 => "7", 6 => "6", 5 => "5", 4 => "4", 3 => "3", 2 => "2"}
	rating_keys = []
	keys.map do |x| 
		rating_keys << rating.key(x)
	end
	rating_keys.max
end


# game
player1_wins = 0

game = all_hands.map do |game|
	players1_cards = game[0]
	players1_colors = game[1]
	players2_cards = game[2]
	players2_colors = game[3]
	players1_score = 0
	players2_score = 0

	if_pairs_exists = 0

# player 1 
	if pairs(players1_cards) != 0
        players1_score = pairs(players1_cards)
        if_pairs_exists = 1
    end

    if three_of_a_kind(players1_cards) != 0
        players1_score = three_of_a_kind(players1_cards)
        if_pairs_exists = 1
    end

    if straight(players1_cards) != 0
        players1_score = straight(players1_cards)
    end

    if flush(players1_colors) != 0
        players1_score = flush(players1_colors)
    end

    if full_house(players1_cards) != 0
        players1_score = full_house(players1_cards)
        if_pairs_exists = 1
    end

    if four_of_a_kind(players1_cards) != 0
        players1_score = four_of_a_kind(players1_cards)
        if_pairs_exists = 1
    end

    if straight_flush(players1_cards, players1_colors) != 0
       	players1_score = straight_flush(players1_cards, players1_colors)
    end

    if royal_flush(players1_cards, players1_colors) != 0
        players1_score = royal_flush(players1_cards, players1_colors)
    end

# player 2 
	if pairs(players2_cards) != 0
        players2_score = pairs(players2_cards)
        if_pairs_exists = 1
    end

    if three_of_a_kind(players2_cards) != 0
        players2_score = three_of_a_kind(players2_cards)
        if_pairs_exists = 1
    end

    if straight(players2_cards) != 0
        players2_score = straight(players2_cards)
    end

    if flush(players2_colors) != 0
        players2_score = flush(players2_colors)
    end

    if full_house(players2_cards) != 0
        players2_score = full_house(players2_cards)
        if_pairs_exists = 1
    end

    if four_of_a_kind(players2_cards) != 0
        players2_score = four_of_a_kind(players2_cards)
        if_pairs_exists = 1
    end

    if straight_flush(players2_cards, players2_colors) != 0
       	players2_score = straight_flush(players2_cards, players2_colors)
    end

    if royal_flush(players2_cards, players2_colors) != 0
        players2_score = royal_flush(players2_cards, players2_colors)
    end

# result

    if players1_score > players2_score
    	player1_wins += 1
    end

    if players1_score == players2_score && if_pairs_exists == 1 && highest_card_if_pair_is_in_hand(players1_cards) > highest_card_if_pair_is_in_hand(players2_cards)
    	player1_wins += 1
    end

    if players1_score == players2_score && if_pairs_exists == 1 && highest_card_if_pair_is_in_hand(players1_cards) == highest_card_if_pair_is_in_hand(players2_cards) && kicker(players1_cards) > kicker(players2_cards)
		player1_wins += 1
   	end

   	if players1_score == 0 && players2_score == 0
   		if kicker(players1_cards) > kicker(players2_cards)
   			player1_wins += 1
   		end
    end
end

p player1_wins


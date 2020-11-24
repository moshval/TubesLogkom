/* Fact and Rules */

store :- \+init(_), write('Game has not started yet'),!.
store :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.
store :- init(_), posX(X), posY(Y), isStore(X,Y),
         write('| ----------------------------------------------------|\n'),
         write('|              WELCOME TO THE STORE                   |\n'),
         write('| What do you want to buy ?                           |\n'),
         write('| 1. Gacha (200 gold)                                 |\n'),
         write('| 2. Health Potion (100 gold)                         |\n'),
         write('| 3. I want to sell my items                          |\n'),
         write('| 4. Exit the store                                   |\n'),
         write('| ----------------------------------------------------|\n'), 
         write('Insert your command (gacha./potion./sell./exitstore.) : \n'),!.

gacha :- \+init(_), write('Game has not started yet'),!.
gacha :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.

gacha :- player(SJob, _, _, _, _, _, _, _, SGold),
         NewGold is SGold - 200,
         NewGold >= 0,
	 random(1,5,Randomize),
         random(1,3,RandomJob),
         jobID(SJob,RandomJob),
         addItem(Randomize,SJob,1),
	 item(Randomize, Name, SJob, _,_,_,_),
         nl,
         write('****************************************************\n'), 
         write('Congratulation! You got '), write(Name), write('!\n'),
         write('****************************************************\n'),
	 retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, _)),
         asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, NewGold)),
         store,!.

gacha :- player(_,_,_,_,_,_,_,_,SGold),
         NewGold is SGold - 200,
         NewGold < 0,
         write('****************************************************\n'), 
         write('!! Insufficient amount of gold !! \n'),
         write('****************************************************\n'), 
         store,!.

potion :- \+init(_), write('Game has not started yet'),!.
potion :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.
potion :- write('How many potion do you want to buy ? \n'),
          read(BanyakPotion),
          player(_,_,_,_,_,_,_,_, SGold),
          item(_,_,SJob,_,_,_,_),
          NewGold is SGold - BanyakPotion*100,
          NewGold >= 0,
          addItem(99,SJob,BanyakPotion),
	  retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, _)),
          asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, NewGold)),
          nl,write('****************************************************\n'), 
          write('Potion has been added to your inventory\n'),
          write('****************************************************\n'), 
          store,!.
potion :- write('****************************************************\n'), 
          write('!! Insufficient amount of gold !! \n'),
          write('****************************************************\n'), 
          nl,store,!.

exitstore :- write('****************************************************\n'), 
             write('You have exited the store, comeback anytime ^_^ ! \n'),
             write('****************************************************\n\n'),
             s,!.

sell :- \+init(_), write('Game has not started yet'),!.
sell :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.
sell :- inventory, nl,
		player(Job, _, _, _, _, _, _, _, Duit),
		write('What do yo want to sell, Traveler?'), nl,
		write('Item name (lowercase) : '), read(ItemName), nl,
		( 
		(\+cekItemAda(ItemName, _) -> nl, write('Please check again!\n'));
		(cekItemAda(ItemName, _) -> (
            inventory(_,ItemName,ItemJob,_,_,_,_,_),
			NewGold is Duit+300,
			retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, _)),
        		asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, NewGold)),
			delItem(ItemName, ItemJob),
			write('****************************************************\n'),
			write('Your item has been sold for 300 gold!\n'),
			write('****************************************************\n')
			)
		)
		),store,!.
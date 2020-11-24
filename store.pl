/* Fact and Rules */


store :- \+init(_), write('Game has not started yet'),!.
store :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.
store :- init(_), posX(X), posY(Y), isStore(X,Y), write('Welcome to The Store \n What do you want, Traveler? \n 1. Gacha (100 gold) (gacha.)\n 2. Health Potion (100 gold) (potion.)\n 3. I want to sell my items (sell.)'), !.

gacha :- \+init(_), write('Game has not started yet'),!.
gacha :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.

gacha :- player(SJob, _, _, _, _, _, _, _, SGold),
         NewGold is SGold - 100,
         NewGold >= 0,
         /*random(1,3,RandomJob),*/
         random(1,5,Randomize),
         /*jobID(SJob,RandomJob),*/
         addItem(Randomize,SJob,1),
	 item(Randomize, Name, SJob, _,_,_,_),
	 write('Congratulation! You got '), write(Name), write('!\n'),
	 retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, _)),
         asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, NewGold)),!.

gacha :- player(_,_,_,_,_,_,_,_,SGold),
         NewGold is SGold - 100,
         NewGold < 0,
         write('Insufficient amount of gold'),!.

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
          asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, NewGold)),!.
potion :- write('Insufficient amount of gold'),!.


sell :- \+init(_), write('Game has not started yet'),!.
sell :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.
sell :- inventory, nl,
	player(Job, _, _, _, _, _, _, _, Duit),
	write('What do yo want to sell, Traveler?'), nl,
	write('Item ID: '), read(ItemID), nl,
	( 
		(\+delItem(ItemID, Job) -> nl, write('Please check again!'));
		(delItem(ItemID, Job) -> (
			NewGold is Duit+500,
			retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, _)),
        		asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, NewGold)),
			addItem(ItemID, Job, 1), /* biar nambah 1 soalnya kekurang 2x pas proses */
			write('Your item has been sold for 500 gold!')
			)
		)
	), !.
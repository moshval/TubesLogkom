/* Fact and Rules */


store :- \+init(_), write('Game has not started yet'),!.
store :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.
store :- init(_), posX(X), posY(Y), isStore(X,Y), write('Welcome to The Store \n What do you want to buy \n 1. Gacha (1000 gold)\n 2. Health Potion (100 gold)\n 3. I want to sell my items'), !.

gacha :- \+init(_), write('Game has not started yet'),!.
gacha :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.

gacha :- player(_, _, _, _, _, _, _, _, SGold),
         item(_,_,SJob,_,_,_,_),
         NewGold is SGold - 100,
         NewGold >= 0,
         random(1,3,Randomize),
         addItem(Randomize,SJob,1),
	 retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, _)),
         asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, NewGold)),!.

gacha :- player(_,_,_,_,_,_,_,_,SGold),
         NewGold is SGold - 1000,
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







         
         


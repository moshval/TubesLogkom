/* Fact and Rules */


store :- \+init(_), write('Game has not started yet'),!.
store :- init(_), posX(X), posY(Y), \+isStore(X,Y), write('You are not in the store position!'),!.
store :- init(_), posX(X), posY(Y), isStore(X,Y), write('Welcome to The Store \n What do you want to buy \n 1. Gacha (1000 gold)\n 2. Health Potion (100 gold)\n 3. I want to sell my items'), !.

gacha :- player(Job, MaxHealth, Level, Health, Attack, Defense, Exp, Gold),
         NewGold is Gold - 1000,
         NewGold > 0,
         random(1,3,Randomize),
         addItem(Randomize,Job,1),
         asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Exp, NewGold)),
         write("Congratulation, you've got ", item(Randomize, Name, Job, Type, Health, Attack, Defense)).

gacha :- player(Job, MaxHealth, Level, Health, Attack, Defense, Exp, Gold),
         NewGold is Gold - 1000,
         NewGold < 0,
         write('Insufficient amount of gold').

potion :- write('How many potion do you want to buy ?'),
          read(BanyakPotion),
          player(Job, MaxHealth, Level, Health, Attack, Defense, Exp, Gold),
          NewGold is Gold - BanyakPotion*100,
          NewGold > 0,
          addItem(99,Job,BanyakPotion),
          asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Exp, NewGold)).

potion :- write('How many potion do you want to buy ?'),
          read(BanyakPotion),
          player(Job, MaxHealth, Level, Health, Attack, Defense, Exp, Gold),
          NewGold is Gold - BanyakPotion*100,
          NewGold < 0,
          write('Insufficient amount of gold').




         
         


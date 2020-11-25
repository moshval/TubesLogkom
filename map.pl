:- dynamic(posX/1).
:- dynamic(posY/1).
:- dynamic(lebar/1).
:- dynamic(panjang/1).

tembok(3,3,4,3,5,3,6,3,3,4,3,5,3,6,12,13,11,13,10,13,13,10,13,11,13,12,13,13).

isLimitAtas(_,Y) :- Y=:=0.
isLimitBawah(_,Y) :- lebar(L), Limit is L+1, Y =:= Limit.
isLimitKiri(X,_) :- X=:=0.
isLimitKanan(X,_) :- panjang(L), Limit is L+1, X =:= Limit.
isPlayer(X,Y) :- posX(X1), posY(Y1), X=:=X1, Y=:=Y1.
isStore(X,Y) :- X=:=7, Y=:=8.
isBoss(X,Y) :- X=:=5, Y=:=4.
isBoss(X,Y) :- X=:=15, Y=:=3.
isDungeon(X,Y) :- X=:=11, Y=:=12.
isQuest(X,Y) :- X=:=9, Y=:=9.
isTP(X,Y) :- X=:=7, Y=:=2,!.
isTP(X,Y) :- X=:=3, Y=:=13,!.
isTP(X,Y) :- X=:=14, Y=:=12,!.
isMedusa(X,Y) :- isQuest1(_),X=:=3, Y=:=15.
isHydra(X,Y) :- isQuest1(_),X=:=1, Y=:=4.
isCerberus(X,Y) :- isQuest1(_),X=:=8, Y=:=1.
isTembok(X,Y) :-
	tembok(X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,X7,Y7,X8,Y8,X9,Y9,X10,Y10,X11,Y11,X12,Y12,X13,Y13,X14,Y14),
	((X=:=X1,Y=:=Y1);(X=:=X2,Y=:=Y2);(X=:=X3,Y=:=Y3);(X=:=X4,Y=:=Y4);(X=:=X5,Y=:=Y5);(X=:=X6,Y=:=Y6);(X=:=X7,Y=:=Y7);
	(X=:=X8,Y=:=Y8);(X=:=X9,Y=:=Y9);(X=:=X10,Y=:=Y10);(X=:=X11,Y=:=Y11);(X=:=X12,Y=:=Y12);(X=:=X13,Y=:=Y13);(X=:=X14,Y=:=Y14)).

/* teleport tapi ini buat godmode */
jumpTo(_, _) :- \+godMode(_), write('You can not use teleport because you have not reached God Mode yet, Traveler!'),!.
jumpTo(X,Y) :- godMode(_), isTembok(X,Y), write('You can not teleport into wall!'),!.
jumpTo(X,Y) :- godMode(_), (X<1;X>15;Y<1;Y>15), write('You can not teleport into outside of this world!'),!.
jumpTo(X,Y) :- godMode(_), \+isTembok(X,Y), retract(posX(_)), retract(posY(_)), asserta(posX(X)), asserta(posY(Y)), map, 
		( (isStore(X,Y) -> write('\n\nWrite `store.` to see store menu.\n')) ; 
		  (isQuest(X,Y) -> write('\n\nWrite `quest.` to do a quest.\n')) ;
		  (isBoss(X,Y) -> foundBoss) ; 
		  (isDungeon(X,Y) -> foundDungeon) ;
		  (\+isTembok(X,Y))
		), !.

/* teleport dari teleport point */
teleport :- posX(X), posY(Y), \+isTP(X,Y), write('You are not in the Teleport Point, Traveler!'),!.
teleport :- posX(X), posY(Y), isTP(X,Y), player(_,_,_,_,_,_,_,_,Duit), NDuit is Duit-250, NDuit<0, write('==============================\nYou do not have enough Gold (250), Traveler!\n=============================='), !.
teleport :- posX(X), posY(Y), isTP(X,Y), player(_,_,_,_,_,_,_,_,Duit), NDuit is Duit-250, NDuit>=0,
	nl, nl,
	write('Welcome to Teleport Point, Traveler!'), nl,
	write('This is gonna cost 250 Gold.'), nl,
	write('Where do you want to teleport?'), nl, nl,
	write('===================================='), nl,
	write(' Useful Coordinates (X,Y):'), nl,
	write(' S = Store (7,8)'), nl,
	write(' Q = Quest (9,9)'), nl,
	write(' B = Boss (5,4)|(15,3)'), nl,
	write(' D = Dungeon (11,12)'), nl,
	( (X=:=7,Y=:=2) -> (write(' T = Teleport Point 2 (3,13)'), nl, write(' T = Teleport Point 3 (14,12)'), nl) ;
	  (X=:=3,Y=:=13) -> (write(' T = Teleport Point 1 (7,2)'), nl, write(' T = Teleport Point 3 (14,12)'), nl) ;
	  (X=:=14,Y=:=12) -> (write(' T = Teleport Point 1 (7,2)'), nl, write(' T = Teleport Point 2 (3,13)'), nl)
	),
	write('===================================='), nl,
	write('(input X and Y = 0. if you want to cancel the teleport)'), nl, nl,
	write('Enter X: '), read(TX), nl,
	write('Enter Y: '), read(TY), nl,
	teleportTo(TX,TY),!.

teleportTo(_, _) :- posX(X), posY(Y), \+isTP(X,Y), write('You can not cast teleport outside Teleport Point, Traveler!'),!.
teleportTo(_,_) :- posX(Xx), posY(Yy), isTP(Xx,Yy), player(_,_,_,_,_,_,_,_,Duit), NDuit is Duit-250, NDuit<0, write('==============================\nYou do not have enough Gold (250), Traveler!\n=============================='), !.
teleportTo(X,Y) :- posX(Xx), posY(Yy), isTP(Xx,Yy), X=:=0, Y=:=0, write('==============================\nYou cancelled the teleport, Traveler!\n=============================='),!.
teleportTo(X,Y) :- posX(Xx), posY(Yy), isTP(Xx,Yy), isTP(X,Y), Xx =:= X, Yy =:= Y, write('==============================\nYou can not teleport into current Teleport Point, Traveler!\n=============================='), teleport,!.
teleportTo(X,Y) :- posX(Xx), posY(Yy), isTP(Xx,Yy), isTembok(X,Y), write('==============================\nYou can not teleport into wall!\n=============================='), teleport,!.
teleportTo(X,Y) :- posX(Xx), posY(Yy), isTP(Xx,Yy), (X<1;X>15;Y<1;Y>15), write('You can not teleport into outside of this world!'), teleport,!.
teleportTo(X,Y) :- posX(Xx), posY(Yy), isTP(Xx,Yy), X>0, Y>0, \+isTembok(X,Y), retract(posX(_)), retract(posY(_)), asserta(posX(X)), asserta(posY(Y)), map,
		player(_,_,_,_,_,_,_,_,Duit), NDuit is Duit-250, NDuit>=0, 
		retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, _)),
         	asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, NDuit)),
		write('You are successfully teleported into ('), write(X), write(','), write(Y), write(')!'), nl, nl,
		( (isStore(X,Y) -> write('\n\nWrite `store.` to see store menu.\n')) ; 
		  (isQuest(X,Y) -> write('\n\nWrite `quest.` to do a quest.\n')) ;
		  (isBoss(X,Y) -> foundBoss) ; 
		  (isDungeon(X,Y) -> foundDungeon) ;
		  (\+isTembok(X,Y))
		), !.

printMap(X,Y) :- isLimitBawah(X,Y), isLimitKanan(X,Y), write('#').
printMap(X,Y) :- isLimitBawah(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isLimitKiri(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isLimitKanan(X,Y), write('#\n'), X2 is 0, Y2 is Y+1, printMap(X2,Y2).
printMap(X,Y) :- isLimitAtas(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isTembok(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isBoss(X,Y), write('B'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isDungeon(X,Y), write('D'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isPlayer(X,Y), write('P'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- isQuest(X,Y), write('Q'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- isStore(X,Y), write('S'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- isTP(X,Y), write('T'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- isQuest1(_),isMedusa(X,Y), write('M'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isQuest1(_),isHydra(X,Y), write('H'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- isQuest1(_),isCerberus(X,Y), write('C'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- \+isLimitBawah(X,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), write('-'), X2 is X+1, printMap(X2,Y).

w :- \+init(_), write('Game has not started yet!') ,!.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_),(isTembok(X,Y2); isLimitBawah(X,Y2); isLimitAtas(X,Y2); isLimitKiri(X,Y2); isLimitKanan(X,Y2)), map, write('\n\nThere is wall, unable to move.\n\n'), !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isStore(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nWrite `store.` to see store menu.\n'), !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isQuest(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nWrite `quest.` to do a quest.\n'), !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isTP(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nWrite `teleport.` to do a teleport.\n'), !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isQuest1(_), isMedusa(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nYou just found Medusa, write `defeat.` to fight.\n'), !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isQuest1(_), isHydra(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nYou just found Hydra, write `defeat.` to fight.\n'), !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isQuest1(_), isCerberus(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nYou just found Cerberus, write `defeat.` to fight.\n'), !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isBoss(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, foundBoss, !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isDungeon(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, foundDungeon, !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_),\+isStore(X,Y2), \+isLimitBawah(X,Y2), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posY(_)), asserta(posY(Y2)),map,enemySpawner, !.
w :- isEnemyAlive(_),write('Oh no u cant, there is still an enemy to fight with. But lets try fleeing'),nl,flee,!.

s :- \+init(_), write('Game has not started yet!') ,!.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), (isTembok(X,Y2); isLimitBawah(X,Y2); isLimitAtas(X,Y2); isLimitKiri(X,Y2); isLimitKanan(X,Y2)), map, write('\n\nThere is wall, unable to move.\n\n'), !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), isStore(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nWrite `store.` to see store menu.\n'), !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), isQuest(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nWrite `quest.` to do a quest.\n'), !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), isTP(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nWrite `teleport.` to do a teleport.\n'), !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), isQuest1(_), isMedusa(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nYou just found Medusa, write `defeat.` to fight.\n'), !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), isQuest1(_), isHydra(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nYou just found Hydra, write `defeat.` to fight.\n'), !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), isQuest1(_), isCerberus(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nYou just found Cerberus, write `defeat.` to fight.\n'), !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), isBoss(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, foundBoss, !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), isDungeon(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, foundDungeon, !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), \+isStore(X,Y2), \+isLimitBawah(X,Y2), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posY(_)), asserta(posY(Y2)),map,enemySpawner, !.
s :- isEnemyAlive(_),write('Oh no u cant, there is still an enemy to fight with.  But lets try fleeing'),nl,flee,!.

a :- \+init(_), write('Game has not started yet!') ,!.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), (isTembok(X2,Y); isLimitBawah(X2,Y); isLimitAtas(X2,Y); isLimitKiri(X2,Y); isLimitKanan(X2,Y)), map, write('\n\nThere is wall, unable to move.\n\n'), !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), isStore(X2,Y), retract(posX(_)), asserta(posX(X2)), map, write('\n\nWrite `store.` to see store menu.\n'), !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), isQuest(X2,Y), retract(posX(_)), asserta(posX(X2)), map, write('\n\nWrite `quest.` to do a quest.\n'), !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), isTP(X2,Y), retract(posX(_)), asserta(posX(X2)), map, write('\n\nWrite `teleport.` to do a teleport.\n'), !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), isQuest1(_), isMedusa(X2,Y), retract(posX(_)), asserta(posX(X2)), map, write('\n\nYou just found Medusa, write `defeat.` to fight.\n'), !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), isQuest1(_), isHydra(X2,Y), retract(posX(_)), asserta(posX(X2)), map, write('\n\nYou just found Hydra, write `defeat.` to fight.\n'), !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), isQuest1(_), isCerberus(X2,Y), retract(posX(_)), asserta(posX(X2)), map, write('\n\nYou just found Cerberus, write `defeat.` to fight.\n'), !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), isBoss(X2,Y), retract(posX(_)), asserta(posX(X2)), map, foundBoss, !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), isDungeon(X2,Y), retract(posX(_)), asserta(posX(X2)), map, foundDungeon, !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), \+isStore(X2,Y), \+isLimitBawah(X2,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posX(_)), asserta(posX(X2)),map,enemySpawner, !.
a :- isEnemyAlive(_),write('Oh no u cant, there is still an enemy to fight with.  But lets try fleeing'),nl,flee,!.

d :- \+init(_), write('Game has not started yet!') ,!.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), (isTembok(X2,Y); isLimitBawah(X2,Y); isLimitAtas(X2,Y); isLimitKiri(X2,Y); isLimitKanan(X2,Y)), map, write('\n\nThere is wall, unable to move.\n\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isStore(X2,Y), retract(posX(_)), asserta(posX(X2)), map, write('\n\nWrite `store.` to see store menu.\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isQuest(X2,Y), retract(posX(_)), asserta(posX(X2)), map, write('\n\nWrite `quest.` to do a quest.\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isTP(X2,Y), retract(posX(_)), asserta(posX(X2)), map, write('\n\nWrite `teleport.` to do a teleport.\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isQuest1(_), isMedusa(X2,Y), retract(posY(_)), asserta(posX(X2)), map, write('\n\nYou just found Medusa, write `defeat.` to fight.\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isQuest1(_), isHydra(X2,Y), retract(posY(_)), asserta(posX(X2)), map, write('\n\nYou just found Hydra, write `defeat.` to fight.\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isQuest1(_), isCerberus(X2,Y), retract(posY(_)), asserta(posX(X2)), map, write('\n\nYou just found Cerberus, write `defeat.` to fight.\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isBoss(X2,Y), retract(posX(_)), asserta(posX(X2)), map, foundBoss, !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isDungeon(X2,Y), retract(posX(_)), asserta(posX(X2)), map, foundDungeon, !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), \+isStore(X2,Y), \+isLimitBawah(X2,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posX(_)), asserta(posX(X2)),map,enemySpawner, !.
d :- isEnemyAlive(_),write('Oh no u cant, there is still an enemy to fight with.  But lets try fleeing'),nl,flee,!.

legend :- \+ isQuest1(_),
		write('~~~~~~~~~~~~~~~'),nl,
		write('Map Legends:'), nl,
		write('P = Player'), nl,
		write('S = Store'), nl,
		write('Q = Quest'), nl,
		write('T = Teleport Point'), nl,
		write('B = Boss'), nl,
		write('D = Dungeon'), nl,
		write('# = Wall'), nl,
		write('~~~~~~~~~~~~~~~'),nl.

legend :-isQuest1(_),
		write('~~~~~~~~~~~~~~~'),nl,
		write('Map Legends:'), nl,
		write('M = Medusa'), nl,
		write('H = Hydra'), nl,
		write('C = Cerberus'), nl,
		write('P = Player'), nl,
		write('S = Store'), nl,
		write('Q = Quest'), nl,
		write('T = Teleport Point'), nl,
		write('B = Boss'), nl,
		write('D = Dungeon'), nl,
		write('# = Wall'), nl,
		write('~~~~~~~~~~~~~~~'),nl.

map :- \+init(_), write('Game has not started yet!') ,!.
map :- init(_), printMap(0,0), nl, legend, !.

initMap :- asserta(lebar(15)), asserta(panjang(15)),!.
initP :- asserta(posX(1)), asserta(posY(1)),!.

enemySpawner:-
    random(1,6,X),
    ( X =:= 5 -> foundEnemy
        ; !).
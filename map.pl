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
isMedusa(X,Y) :- isQuest1(_),X=:=5, Y=:=1.
isHydra(X,Y) :- isQuest1(_),X=:=1, Y=:=4.
isCerberus(X,Y) :- isQuest1(_),X=:=8, Y=:=1.
isTembok(X,Y) :-
	tembok(X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,X7,Y7,X8,Y8,X9,Y9,X10,Y10,X11,Y11,X12,Y12,X13,Y13,X14,Y14),
	((X=:=X1,Y=:=Y1);(X=:=X2,Y=:=Y2);(X=:=X3,Y=:=Y3);(X=:=X4,Y=:=Y4);(X=:=X5,Y=:=Y5);(X=:=X6,Y=:=Y6);(X=:=X7,Y=:=Y7);
	(X=:=X8,Y=:=Y8);(X=:=X9,Y=:=Y9);(X=:=X10,Y=:=Y10);(X=:=X11,Y=:=Y11);(X=:=X12,Y=:=Y12);(X=:=X13,Y=:=Y13);(X=:=X14,Y=:=Y14)).

jumpTo(_, _) :- \+godMode(_), write('You can not use teleport because you have not reached God Mode yet, Traveler!'),!.
jumpTo(X,Y) :- godMode(_), isTembok(X,Y), write('You can not teleport into wall!'),!.
jumpTo(X,Y) :- godMode(_), \+isTembok(X,Y), retract(posX(_)), retract(posY(_)), asserta(posX(X)), asserta(posY(Y)), map, 
		( (isStore(X,Y) -> write('\n\nWrite `store.` to see store menu.\n')) ; 
		  (isQuest(X,Y) -> write('\n\nWrite `quest.` to do a quest.\n')) ;
		  (isBoss(X,Y) -> foundBoss) ; 
		  (isDungeon(X,Y) -> foundDungeon)
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
printMap(X,Y) :- isQuest1(_),isMedusa(X,Y), write('M'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isQuest1(_),isHydra(X,Y), write('H'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- isQuest1(_),isCerberus(X,Y), write('C'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- \+isLimitBawah(X,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), write('-'), X2 is X+1, printMap(X2,Y).

w :- \+init(_), write('Game has not started yet!') ,!.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_),(isTembok(X,Y2); isLimitBawah(X,Y2); isLimitAtas(X,Y2); isLimitKiri(X,Y2); isLimitKanan(X,Y2)), map, write('\n\nThere is wall, unable to move.\n\n'), !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isStore(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nWrite `store.` to see store menu.\n'), !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_), isQuest(X,Y2), retract(posY(_)), asserta(posY(Y2)), map, write('\n\nWrite `quest.` to do a quest.\n'), !.
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
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isQuest1(_), isMedusa(X2,Y), retract(posY(_)), asserta(posX(X2)), map, write('\n\nYou just found Medusa, write `defeat.` to fight.\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isQuest1(_), isHydra(X2,Y), retract(posY(_)), asserta(posX(X2)), map, write('\n\nYou just found Hydra, write `defeat.` to fight.\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isQuest1(_), isCerberus(X2,Y), retract(posY(_)), asserta(posX(X2)), map, write('\n\nYou just found Cerberus, write `defeat.` to fight.\n'), !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isBoss(X2,Y), retract(posX(_)), asserta(posX(X2)), map, foundBoss, !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isDungeon(X2,Y), retract(posX(_)), asserta(posX(X2)), map, foundDungeon, !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), \+isStore(X2,Y), \+isLimitBawah(X2,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posX(_)), asserta(posX(X2)),map,enemySpawner, !.
d :- isEnemyAlive(_),write('Oh no u cant, there is still an enemy to fight with.  But lets try fleeing'),nl,flee,!.

legend :-
	write('Map Legends:'), nl,
	write('P = Player'), nl,
	write('S = Store'), nl,
	write('Q = Quest'), nl,
	write('B = Boss'), nl,
	write('D = Dungeon'), nl,
	write('# = Wall'), nl.

map :- \+init(_), write('Game has not started yet!') ,!.
map :- init(_), printMap(0,0), nl, legend, !.

initMap :- asserta(lebar(15)), asserta(panjang(15)),!.
initP :- asserta(posX(1)), asserta(posY(1)),!.

enemySpawner:-
    random(1,6,X),
    ( X =:= 5 -> foundEnemy
        ; !).


/* Yang kurang : indikator map quest, boss, dungeon, trus movement kalo lagi di tempat2 kaya store dungeon gitu2 */
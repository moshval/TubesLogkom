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
isBoss(X,Y) :- X=:=11, Y=:=12.
isBoss(X,Y) :- X=:=15, Y=:=3.
isQuest(X,Y) :- X=:=9, Y=:=9.
isTembok(X,Y) :-
	tembok(X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,X7,Y7,X8,Y8,X9,Y9,X10,Y10,X11,Y11,X12,Y12,X13,Y13,X14,Y14),
	((X=:=X1,Y=:=Y1);(X=:=X2,Y=:=Y2);(X=:=X3,Y=:=Y3);(X=:=X4,Y=:=Y4);(X=:=X5,Y=:=Y5);(X=:=X6,Y=:=Y6);(X=:=X7,Y=:=Y7);
	(X=:=X8,Y=:=Y8);(X=:=X9,Y=:=Y9);(X=:=X10,Y=:=Y10);(X=:=X11,Y=:=Y11);(X=:=X12,Y=:=Y12);(X=:=X13,Y=:=Y13);(X=:=X14,Y=:=Y14)).

printMap(X,Y) :- isLimitBawah(X,Y), isLimitKanan(X,Y), write('#').
printMap(X,Y) :- isLimitBawah(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isLimitKiri(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isLimitKanan(X,Y), write('#\n'), X2 is 0, Y2 is Y+1, printMap(X2,Y2).
printMap(X,Y) :- isLimitAtas(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isTembok(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isBoss(X,Y), write('D'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isPlayer(X,Y), write('P'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- isQuest(X,Y), write('Q'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- isStore(X,Y), write('S'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- \+isLimitBawah(X,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), write('-'), X2 is X+1, printMap(X2,Y).

w :- \+init(_), write('Game has not started yet!') ,!.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_),(isTembok(X,Y2); isLimitBawah(X,Y2); isLimitAtas(X,Y2); isLimitKiri(X,Y2); isLimitKanan(X,Y2)), write('There is wall, unable to move.\n\n'), map, !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_),isStore(X,Y2), write('Write `store.` to see store menu.\n\n'), retract(posY(_)), asserta(posY(Y2)), map, !.
w :- posX(X), posY(Y), Y2 is Y-1,\+ isEnemyAlive(_),\+isStore(X,Y2), \+isLimitBawah(X,Y2), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posY(_)), asserta(posY(Y2)),map,enemySpawner, !.
w :- isEnemyAlive(_),write('Oh no u cant, there is still an enemy to fight with'),nl,fightmenu,!.

s :- \+init(_), write('Game has not started yet!') ,!.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), (isTembok(X,Y2); isLimitBawah(X,Y2); isLimitAtas(X,Y2); isLimitKiri(X,Y2); isLimitKanan(X,Y2)), write('There is wall, unable to move.\n\n'), map, !.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), isStore(X,Y2), write('Write `store.` to see store menu.\n\n'), retract(posY(_)), asserta(posY(Y2)), map,!.
s :- posX(X), posY(Y), Y2 is Y+1,\+ isEnemyAlive(_), \+isStore(X,Y2), \+isLimitBawah(X,Y2), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posY(_)), asserta(posY(Y2)),map,enemySpawner, !.
s :- isEnemyAlive(_),write('Oh no u cant, there is still an enemy to fight with'),nl,fightmenu,!.

a :- \+init(_), write('Game has not started yet!') ,!.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), (isTembok(X2,Y); isLimitBawah(X2,Y); isLimitAtas(X2,Y); isLimitKiri(X2,Y); isLimitKanan(X2,Y)), write('There is wall, unable to move.\n\n'), map, !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), isStore(X2,Y), write('Write `store.` to see store menu.\n\n'), retract(posX(_)), asserta(posX(X2)), map, !.
a :- posX(X), posY(Y), X2 is X-1,\+ isEnemyAlive(_), \+isStore(X2,Y), \+isLimitBawah(X2,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posX(_)), asserta(posX(X2)),map,enemySpawner, !.
a :- isEnemyAlive(_),write('Oh no u cant, there is still an enemy to fight with'),nl,fightmenu,!.

d :- \+init(_), write('Game has not started yet!') ,!.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), (isTembok(X2,Y); isLimitBawah(X2,Y); isLimitAtas(X2,Y); isLimitKiri(X2,Y); isLimitKanan(X2,Y)), write('There is wall, unable to move.\n\n'), map, !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), isStore(X2,Y), write('Write `store.` to see store menu.\n\n'), retract(posX(_)), asserta(posX(X2)), map, !.
d :- posX(X), posY(Y), X2 is X+1,\+ isEnemyAlive(_), \+isStore(X2,Y), \+isLimitBawah(X2,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posX(_)), asserta(posX(X2)),map,enemySpawner, !.
d :- isEnemyAlive(_),write('Oh no u cant, there is still an enemy to fight with'),nl,fightmenu,!.

legend :-
	write('Map Legends:'), nl,
	write('P = Player'), nl,
	write('S = Store'), nl,
	write('Q = Quest'), nl,
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
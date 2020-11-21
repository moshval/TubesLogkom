:- dynamic(posX/1).
:- dynamic(posY/1).

lebar(10).
panjang(10).

isLimitAtas(_,Y) :- Y=:=0.
isLimitBawah(_,Y) :- lebar(L), Limit is L+1, Y =:= Limit.
isLimitKiri(X,_) :- X=:=0.
isLimitKanan(X,_) :- panjang(L), Limit is L+1, X =:= Limit.
isPlayer(X,Y) :- posX(X1), posY(Y1), X=:=X1, Y=:=Y1.
isStore(X,Y) :- X=:=3, Y=:=3.

printMap(X,Y) :- isLimitBawah(X,Y), isLimitKanan(X,Y), write('#').
printMap(X,Y) :- isLimitBawah(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isLimitKiri(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isLimitKanan(X,Y), write('#\n'), X2 is 0, Y2 is Y+1, printMap(X2,Y2).
printMap(X,Y) :- isLimitAtas(X,Y), write('#'), X2 is X+1, printMap(X2,Y).
printMap(X,Y) :- isPlayer(X,Y), write('P'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- isStore(X,Y), write('S'), X1 is X+1, printMap(X1, Y).
printMap(X,Y) :- \+isLimitBawah(X,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), write('-'), X2 is X+1, printMap(X2,Y).

w :- posX(X), posY(Y), Y2 is Y-1, (isLimitBawah(X,Y2); isLimitAtas(X,Y2); isLimitKiri(X,Y2); isLimitKanan(X,Y2)), write('ada tembok'), !.
w :- posX(X), posY(Y), Y2 is Y-1, isStore(X,Y2), write('Gunakan store. untuk membuka store.'), retract(posY(_)), asserta(posY(Y2)), !.
w :- posX(X), posY(Y), Y2 is Y-1, \+isStore(X,Y2), \+isLimitBawah(X,Y2), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posY(_)), asserta(posY(Y2)), !.

s :- posX(X), posY(Y), Y2 is Y+1, (isLimitBawah(X,Y2); isLimitAtas(X,Y2); isLimitKiri(X,Y2); isLimitKanan(X,Y2)), write('ada tembok'), !.
s :- posX(X), posY(Y), Y2 is Y+1, isStore(X,Y2), write('Gunakan store. untuk membuka store.'), retract(posY(_)), asserta(posY(Y2)), !.
s :- posX(X), posY(Y), Y2 is Y+1, \+isStore(X,Y2), \+isLimitBawah(X,Y2), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posY(_)), asserta(posY(Y2)), !.

a :- posX(X), posY(Y), X2 is X-1, (isLimitBawah(X2,Y); isLimitAtas(X2,Y); isLimitKiri(X2,Y); isLimitKanan(X2,Y)), write('ada tembok'), !.
a :- posX(X), posY(Y), X2 is X-1, isStore(X2,Y), write('Gunakan store. untuk membuka store.'), retract(posX(_)), asserta(posX(X2)), !.
a :- posX(X), posY(Y), X2 is X-1, \+isStore(X2,Y), \+isLimitBawah(X2,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posX(_)), asserta(posX(X2)), !.

d :- posX(X), posY(Y), X2 is X+1, (isLimitBawah(X2,Y); isLimitAtas(X2,Y); isLimitKiri(X2,Y); isLimitKanan(X2,Y)), write('ada tembok'), !.
d :- posX(X), posY(Y), X2 is X+1, isStore(X2,Y), write('Gunakan store. untuk membuka store.'), retract(posX(_)), asserta(posX(X2)), !.
d :- posX(X), posY(Y), X2 is X+1, \+isStore(X2,Y), \+isLimitBawah(X2,Y), \+isLimitAtas(X,Y), \+isLimitKiri(X,Y), \+isLimitKanan(X,Y), retract(posX(_)), asserta(posX(X2)), !.

map :- printMap(0,0),!.

initP :- asserta(posX(1)), asserta(posY(1)),!.
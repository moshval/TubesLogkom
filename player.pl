:- dynamic(player/9).
:- dynamic(inventory/8). 

/*** player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, Exp, Gold) ***/

maxInventory(100).
initGold(1000).
initExp(0).

initPlayer(Job) :-
    role(Job, MaxHealth, Level, Attack, Defense, Special),
    initGold(Gold),
    initExp(Exp),
    Health is MaxHealth,
    asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Special, Exp, Gold)),
    addItem(99,Job,5),
    addItem(1,Job,1),
    !.
playerStatus :-
    init(_),
    player(Job, _, Level, Health, Attack, Defense, _, Exp, Gold),
    write('Job      : '), write(Job), nl,
    write('Health   : '), write(Health), nl,
    write('Level    : '), write(Level), nl,
    write('Attack   : '), write(Attack), nl,
    write('Defense  : '), write(Defense), nl,
    write('Exp      : '), write(Exp), nl,
    write('Gold     : '), write(Gold), nl,!.


/** Inventory **/
/*** inventory(ID, Name, Job, Type, Amount, Health, Attack, Defense) ***/ 
list_sum([Item], Item).
list_sum([H | T], S) :-
    list_sum(T,X), S is H + X.

banyakItem(Amount) :-
    findall(Amount, inventory(_,_,_,_,Amount,_,_,_), ListAmount),
    list_sum(ListAmount, Amount).
    
isFull :-
    banyakItem(Amount),
    maxInventory(MAX),
    Amount == MAX.

addItem(_,_,Qty) :-
    banyakItem(Amount),
    NewAmount is Amount + Qty,
    maxInventory(Max),
    NewAmount >= Max,
    write('The inventory is full!'),
    !,fail.

addItem(ID,Job,Qty) :-
    item(ID, Name, Job, Type, Health, Attack, Defense),
    inventory(ID, Name, Job, Type, Amount, Health, Attack, Defense),
    NewAmount is Amount + Qty,
    retract(inventory(ID, _, Job, _, _, _, _, _)),
    asserta(inventory(ID, Name, Job, Type, NewAmount, Health, Attack, Defense)),
    !.

addItem(ID,Job,Qty) :-
    item(ID, Name, Job, Type, Health, Attack, Defense),
    asserta(inventory(ID, Name, Job, Type, Qty, Health, Attack, Defense)),
    !.

delItem(ID,Job) :-
    \+inventory(ID,_,Job,_,_,_,_,_),
    write('There is no such item in your inventory!'),
    !,fail.

delItem(ID,Job) :-
    inventory(ID, Name, Job, Type, Amount, Health, Attack, Defense),
    NewAmount is Amount - 1,
    retract(inventory(ID,_,_,_,_,_,_,_)),
    asserta(inventory(ID, Name, Job, Type, NewAmount, Health, Attack, Defense)),
    !.

delItem(ID,Job) :-
    retract(inventory(ID,_,Job,_,_,_,_,_)),
    !.

listInventory(ListItem,ListJob,ListAmount) :-
    findall(Name, inventory(_,Name,_,_,_,_,_,_), ListItem),
    findall(Job, inventory(_,_,Job,_,_,_,_,_), ListJob),
    findall(Amount, inventory(_,_,_,_,Amount,_,_,_), ListAmount).

showInven([],[],[]).
showInven([Name|X],[Job|Y],[Amount|Z]) :-
    write(Amount), write(' '),
    write(Name), write(' '),
    write('('),write(Job),write(')'), nl,
    showInven(X,Y,Z).

showInventory :-
    init(_),
    write('Your inventory: '),nl,nl,
    listInventory(ListItem,ListJob,ListAmount),
    showInven(ListItem,ListJob,ListAmount).


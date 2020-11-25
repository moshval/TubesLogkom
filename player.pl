:- dynamic(player/9).
:- dynamic(inventory/8).
:- dynamic(equipped/8). 

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
    player(Job, _, Level, Health, Attack, Defense, Special, Exp, Gold),
    write('Job      : '), write(Job), nl,
    write('Health   : '), write(Health), nl,
    write('Level    : '), write(Level), nl,
    write('Attack   : '), write(Attack), nl,
    write('Defense  : '), write(Defense), nl,
    write('Special   : '), write(Special), nl,
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
    write('****************************************************\n'), 
    write('!! Your inventory is full !! \n'),
    write('****************************************************\n'),
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

cekItemAda(Name,Job) :-
    \+ inventory(_,Name,Job,_,_,_,_,_),
    !,fail.

cekItemAda(Name,Job) :-
    inventory(_,Name,Job,_,_,_,_,_).

delItem(Name,Job) :-
    \+inventory(_,Name,Job,_,_,_,_,_),
    write('****************************************************\n'), 
    write('!! There is no such item in your inventory !! \n'),
    write('****************************************************\n'),
    !,fail.

delItem(Name,Job) :-
    inventory(ID, Name, Job, Type, Amount, Health, Attack, Defense),
    NewAmount is Amount - 1,
    NewAmount > 0,
    retract(inventory(_,Name,Job,_,_,_,_,_)),
    asserta(inventory(ID, Name, Job, Type, NewAmount, Health, Attack, Defense)),
    !.

delItem(Name,Job) :-
    retract(inventory(_,Name,Job,_,_,_,_,_)),
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
    write('Your inventory: '),nl,
    listInventory(ListItem,ListJob,ListAmount),
    showInven(ListItem,ListJob,ListAmount).

usePotion :-
    \+ inventory(99, _, _, _, _, _, _, _),
    write('****************************************************\n'), 
    write('!! You have no AMER left, buy some more at Store !! \n'),
    write('****************************************************\n'), 
    !, fail.

usePotion :-
    player(_, MaxHealth, _, HP, _, _, _, _, _),
    HP == MaxHealth,
    write('****************************************************\n'), 
    write('!! You already sehat wal afiat !! \n'),
    write('****************************************************\n'),  
    !.

usePotion :-
    \+ isFighting(_),
    player(_, MaxHealth, _, HP, _, _, _, _, _),
    inventory(99, Name, Job, _, _, Health, _, _),
    ( 
        ((HP + Health) >= MaxHealth -> NewHP is MaxHealth); 
        ((HP + Health) < MaxHealth -> NewHP is HP + Health) 
    ),
    delItem(Name,Job),
    retract(player(Job, MaxHealth, Level, HP, Attack, Defense, Sepcial, Exp, Gold)),
    asserta(player(Job, MaxHealth, Level, NewHP, Attack, Defense, Sepcial, Exp, Gold)),
    write('****************************************************\n'), 
    write('!! By the power of AMER, you gained 80 extra HP... !! \n'),
    write('****************************************************\n'), !.


usePotion :-
    isFighting(_),
    player(_, MaxHealth, _, HP, _, _, _, _, _),
    inventory(99, Name, Job, _, _, Health, _, _),
    ( 
        ((HP + Health) >= MaxHealth -> NewHP is MaxHealth); 
        ((HP + Health) < MaxHealth -> NewHP is HP + Health) 
    ),
    delItem(Name,Job),
    retract(player(Job, MaxHealth, Level, HP, Attack, Defense, Sepcial, Exp, Gold)),
    asserta(player(Job, MaxHealth, Level, NewHP, Attack, Defense, Sepcial, Exp, Gold)),
    write('****************************************************\n'), 
    write('!! By the power of AMER, you gained 80 extra HP... !! \n'),
    write('****************************************************\n'),
    enemyStats,!.


/* BELOM WORK */
equip(Name) :-
    inventory(_, Name, _, _, _, _, _, _),
    \+ cekItemAda(Name,_),
    write('Equipment not found!\n'),
    !, fail.

equip(Name) :-
    player(PJob, _, _, _, _, _, _, _, _),
    inventory(_, Name, Job, _, _, _, _, _),
    PJob \== Job,
    write('You are unable to equip this item!\n'),
    !, fail.

equip(Name) :-
    player(_, MaxHealth, _, HP, Att, Def, _, _, _),
    inventory(_, Name, Job, _, _, Health, Attack, Defense),
    NewHP is HP + Health,
    NewAtt is Att + Attack,
    NewDef is Def + Defense,
    delItem(Name,Job),
    retract(player(Job, MaxHealth, Level, HP, Attack, Defense, Sepcial, Exp, Gold)),
    asserta(player(Job, MaxHealth, Level, NewHP, NewAtt, NewDef, Sepcial, Exp, Gold)),
    write('Item successfully equipped.\n').
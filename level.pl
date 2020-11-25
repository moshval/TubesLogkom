levelUp :-
    player(_, _, _, _, _, _, _, Exp, _),
    maxExp(MaxExp),
    Exp =< MaxExp,
    !.
levelUp :-
    maxExp(MaxExp),
    Exp >= MaxExp,
    player(Job, MaxHealth, Level, Health, Attack, Defense, Special, Exp, Gold),
    NewLevel is (Level + 1),
    NewMaxHealth is (MaxHealth + 80),
    NewHealth is NewMaxHealth,
    NewAttack is (Attack + 20),
    NewDefense is (Defense + 20),
    NewSpecial is (Special + 20),
    NewExp is (Exp - MaxExp),
    NewGold is (Gold + 150),
    write('You have leveled up'),nl,
    retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Special, Exp, Gold)),
    asserta(player(Job, NewMaxHealth, NewLevel, NewHealth, NewAttack, NewDefense, NewSpecial, NewExp, NewGold)),!.
 

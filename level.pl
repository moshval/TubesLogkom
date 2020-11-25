levelUp :-
    player(_, _, _, _, _, _, _, Exp, _),
    maxExp(MaxExp),
    Exp < MaxExp,
    !.
levelUp :-
    player(Job, MaxHealth, Level, Health, Attack, Defense, Special, Exp, Gold),
    maxExp(MaxExp),
    Exp >= MaxExp,
    NewLevel is (Level + 1),
    NewMaxHealth is (MaxHealth + 80),
    NewHealth is NewMaxHealth,
    NewAttack is (Attack + 20),
    NewDefense is (Defense + 20),
    NewSpecial is (Special + 20),
    NewExp is (Exp - MaxExp),
    NewGold is (Gold + 150),
    write('****************************************************\n'), 
    write('!! Congratulations, you have leveled up !! \n'),
    write('****************************************************\n'), 
    retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Special, Exp, Gold)),
    asserta(player(Job, NewMaxHealth, NewLevel, NewHealth, NewAttack, NewDefense, NewSpecial, NewExp, NewGold)),
    levelUp,
    !.

addExp(N):-
    player(Job, MaxHealth, Level, Health, Attack, Defense, Special, Exp, Gold),
    NewExp is Exp + N,
    retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Special, Exp, Gold)),
    asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Special, NewExp, Gold)),
    levelUp.
 

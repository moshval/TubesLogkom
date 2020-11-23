:- dynamic(enemy/11).  /* enemy(ID,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold) */ /*Boss or nah */
/*** player(Job, MaxHealth, Level, Health, Attack, Defense, Exp, Gold) ***/
:- dynamic(canFlee/1). 
:- dynamic(isEnemyAlive/1).
:- dynamic(isFighting/1).
:- dynamic(playerCanUseSkill/1).
:- dynamic(playerSkillCD/1).

/* Help gan combat banyak betul */
/* TBA : flee , potion , dll yg sekiranya kurang */

/* ---------- FIGHT CMDS ----------- */

foundEnemy:- /* Encountered an enemy (blm ditambah leveler) */
    /*player(_,_,PLevel,_, _, _, _, _, _), */
    random(1,10,ID),
    mobdata(ID,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    Health is MaxHealth,
    asserta(enemy(ID,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold)),
    write('You found a '),write(Name),nl,
    write('What will u do? (fight / flee) '),nl,
    asserta(isEnemyAlive(1)).

fightmenu:- /* menu waktu fight */
    write('What will u do?'),nl,
    write('- attack.'),nl,
    write('- specialAttack.'),nl,
    write('- usePotion.'),nl,
    write('- flee.'),nl,
    !.    

fight:- /* Baru ketemu enemy, fight */
    asserta(isFighting(1)),
    isEnemyAlive(_),
    asserta(playerCanUseSkill(1)),
    fightmenu,!.

fight:- /* Blm ketemu enemy */
    \+ isEnemyAlive(_),
    write('No enemy here, go somewhere else.'),nl,!.

flee:- /*Kaburr,flee successful , blm diapply move di map*/
    isEnemyAlive(_),
    player(_, PMaxHealth, _, PHealth, _, _, _, _, _),
    F is (PMaxHealth * 0.1),
    PHealth > F,
    write('You unleashed ur secret special technique : Nigerundayo '),nl,
    write('Flee successful'),nl,
    retract(isEnemyAlive(_)),!.

flee:- /*Kabur, but failed*/
    isEnemyAlive(_),
    player(_, PMaxHealth, _, PHealth, _, _, _, _, _),
    F is (PMaxHealth * 0.1),
    PHealth =< F,
    write('You unleashed ur secret special technique : Nigerundayo'),nl,
    write('....but unssuccessful'),nl,
    fight,!.

flee:- /*Kabur while blm ketemu enemy */
    \+ isEnemyAlive(_),
    \+ isFighting(_),
    write('Running from this sekai? No u dont, even if u r a dead man'),!.


attack:- /*Blm ada yg bisa di attack */
    \+ isEnemyAlive(_),
    write('Nothing to be attacked. U cannot attack urself (especially if u r dead)'),nl,!.

attack:- /* Scheme Attack, Incomplete, Skill on CD */
    isEnemyAlive(_),
    playerSkillCD(X),
    player(_, _, _, _, PAttack, _, _, _, _),
    enemy(_,EName,_,_,_,EHealth,_,EDefense,_,_,_),
    TmpDamage is (PAttack - EDefense),
    (TmpDamage >= 0 -> PDamage is TmpDamage
        ;PDamage is 0),
    CurrEHealth is (EHealth - PDamage),
    retract(enemy(EID,EName,EType,EMaxHealth,ELevel,EHealth,EAttack,EDefense,ESpecial,EExp,EGold)),
    asserta(enemy(EID,EName,EType,EMaxHealth,ELevel,CurrEHealth,EAttack,EDefense,ESpecial,EExp,EGold)),
    write('Player dealt '),write(PDamage),write(' damage '),write('to '),write(EName),nl,
    (X < 3 -> P is X+1,retract(playerSkillCD(X)),asserta(playerSkillCD(P)) 
      ;retract(playerSkillCD(X)),asserta(playerCanUseSkill(1))),
    enemyStats,!.

attack:- /* Scheme Attack, Incomplete, Skill not on CD */
    isEnemyAlive(_),
    \+playerSkillCD(_),
    player(_, _, _, _, PAttack, _, _, _, _),
    enemy(_,EName,_,_,_,EHealth,_,EDefense,_,_,_),
    TmpDamage is (PAttack - EDefense),
    (TmpDamage >= 0 -> PDamage is TmpDamage
        ;PDamage is 0),
    CurrEHealth is (EHealth - PDamage),
    retract(enemy(EID,EName,EType,EMaxHealth,ELevel,EHealth,EAttack,EDefense,ESpecial,EExp,EGold)),
    asserta(enemy(EID,EName,EType,EMaxHealth,ELevel,CurrEHealth,EAttack,EDefense,ESpecial,EExp,EGold)),
    write('Player dealt '),write(PDamage),write(' damage '),write('to '),write(EName),nl,
    enemyStats,!.

enemyStats :- /* Stats enemy abis player attack, continuing to enemy turn if enemy still alive */
    enemy(_,EName,_,_,_,EHealth,_,_,_,_,_),
    EHealth > 0,
    write(EName),write(' health is '),write(EHealth),nl,
    write('Now tis enemy turn'),nl,
    enemyTurn,!.

enemyStats :- /* if enemy s ded */
    enemy(_,EName,_,_,_,EHealth,_,_,_,EExp,EGold),
    EHealth =< 0,
    write(EName),write(' is now dead.'),nl,
    player(_, _, _, _, _, _, _, PExp, PGold),
    NewPExp is (PExp + EExp) , NewPGold is (PGold + EGold),
    retract(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    asserta(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, NewPExp, NewPGold)),
    (playerCanUseSkill(_)-> retract(playerCanUseSkill(_))
        ; EHealth is EHealth),
    retract(isEnemyAlive(_)),retract(isFighting(_)),!.

enemyTurn :- /* Turn enemy , enemy bisa ngeskill bebas berapa kalipun , dengan proc rate 16% */
    random(1,6,Skillgakya),
    (Skillgakya < 6
        -> enemyAttack
        ;  enemySpecial
    ),!.

enemyAttack :- /* Enemy normal attack */
    isEnemyAlive(_),
    player(_, _, _, PHealth, PAttack, PDefense, _, _, _),
    enemy(_,EName,_,_,_,_,EAttack,_,_,_,_),
    TmpDamage is (EAttack - PDefense),
    (TmpDamage >= 0 -> EDamage is TmpDamage
        ; EDamage is 0),
    CurrPHealth is (PHealth - EDamage),
    retract(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    asserta(player(PJob, PMaxHealth, PLevel, CurrPHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    write(EName),write(' dealt '),write(EDamage),write(' damage '),write('to player'),nl,
    playerStats,!.

playerStats :- /* Stats player abis turn enemy */
    player(_, _, _, PHealth,_, _, _, _, _),
    PHealth > 0,
    write('Your health is '),write(PHealth),nl,nl,
    write('Now tis ur turn'),nl,
    fightmenu,!.

playerStats :- /* Player ded */
    player(_, _, _, PHealth,_, _, _, _, _),
    PHealth =< 0,
    write('You just died (again). Maybe this sekai aint for u.'),nl,
    retract(isEnemyAlive(_)),retract(isFighting(_)),
    quit,!.

enemySpecial :- /* enemy special atk */
    isEnemyAlive(_),
    player(_, _, _, PHealth, PAttack, PDefense, _, _, _),
    enemy(_,EName,_,_,_,_,_,_,ESpecial,_,_),
    TmpDamage is (ESpecial - PDefense),
    (TmpDamage >= 0 -> EDamage is TmpDamage
        ; EDamage is 0),
    CurrPHealth is (PHealth - EDamage),
    retract(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    asserta(player(PJob, PMaxHealth, PLevel, CurrPHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    specialdata(EName,Spec),
    write(EName),write(' uses '),write(Spec),nl,
    write(EName),write(' dealt '),write(EDamage),write(' damage '),write('to player'),nl,
    playerStats,!.

specialAttack:- /*player special atk, can only be used every 3 turns, CD resets after leaving combat */
    isEnemyAlive(_),
    playerCanUseSkill(_),
    asserta(playerSkillCD(1)),
    player(PJob, _, _, _, _, _, PSpecial, _, _),
    enemy(_,EName,_,_,_,EHealth,_,EDefense,_,_,_),
    TmpDamage is (PSpecial - EDefense),
    (TmpDamage >= 0 -> PDamage is TmpDamage
        ;PDamage is 0),
    CurrEHealth is (EHealth - PDamage),
    retract(enemy(EID,EName,EType,EMaxHealth,ELevel,EHealth,EAttack,EDefense,ESpecial,EExp,EGold)),
    asserta(enemy(EID,EName,EType,EMaxHealth,ELevel,CurrEHealth,EAttack,EDefense,ESpecial,EExp,EGold)),
    write('Player uses '),write(PJob),write(' special attack'),nl,
    write('Player dealt '),write(PDamage),write(' damage '),write('to '),write(EName),nl,
    retract(playerCanUseSkill(_)),
    enemyStats,!.

specialAttack:- /* player special atk is in CD */
    isEnemyAlive(_),
    \+ playerCanUseSkill(_),
    write('Special attack is in cooldown'),nl,
    fightmenu,!.

specialAttack:- /*outside combat */
    \+ isEnemyAlive(_),
    write('Nothing to be attacked. U cannot attack urself (especially if u r dead)'),nl,!.



    





    










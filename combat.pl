:- dynamic(enemy/11).  /* enemy(ID,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold) */ /*Boss or nah */
:- dynamic(me/9). /* basically player but dynamic */
:- dynamic(canFlee/1). 
:- dynamic(isEnemyAlive/1).
:- dynamic(isFighting/1).
:- dynamic(enemyCanUseSkill/1).
:- dynamic(playerCanUseSkill/1).

/* Help gan combat banyak betul */
/* TBA : flee , potion , dll yg sekiranya kurang */

/* ---------- FIGHT CMDS ----------- */
/* Encountered an enemy (blm ditambah leveler) */
foundEnemy:-
    random(1,3,ID),
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
    asserta(enemyCanUseSkill(1)),
    fightmenu,!.

fight:- /* Blm ketemu enemy */
    \+ isEnemyAlive(_),
    write('No enemy here, go somewhere else.'),nl,!.

attack:- /*Blm ada yg bisa di attack */
    \+ isEnemyAlive(_),
    write('Nothing to be attacked. U cannot attack urself'),nl,!.

attack:- /* Scheme Attack, Incomplete, */
    isEnemyAlive(_),
    player(_, _, _, _, PAttack, _, _, _, _),
    enemy(_,EName,_,_,_,EHealth,_,EDefense,_,_,_),
    PDamage is (PAttack - EDefense),
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

/* enemyStats :- /* if enemy s ded */

enemyTurn :- /* Turn enemy */
    random(1,6,Skillgakya),
    (Skillgakya < 6
        -> enemyAttack
        ;  enemySpecial
    ),!.

enemyAttack :- /* Enemy normal attack */
    isEnemyAlive(_),
    player(_, _, _, PHealth, PAttack, PDefense, _, _, _),
    enemy(_,EName,_,_,_,_,EAttack,EDefense,_,_,_),
    EDamage is (EAttack - PDefense),
    CurrPHealth is (PHealth - EDamage),
    retract(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    asserta(player(PJob, PMaxHealth, PLevel, CurrPHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    write(EName),write(' dealt '),write(EDamage),write(' damage '),write('to player'),nl,
    playerStats,!.

playerStats :- /* Stats player abis turn enemy */
    player(_, _, _, PHealth,_, _, _, _, _),
    PHealth > 0,
    write('Your health is '),write(PHealth),nl,
    write('Now tis ur turn'),nl,
    fightmenu,!.
    





    










:- dynamic(enemy/11).  /* enemy(ID,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold) */ /*Boss or nah */
/*** player(Job, MaxHealth, Level, Health, Attack, Defense,Special, Exp, Gold) ***/
:- dynamic(canFlee/1). 
:- dynamic(isEnemyAlive/1).
:- dynamic(isFighting/1).
:- dynamic(isFightingBoss/1).
:- dynamic(winEliteOne/1).
:- dynamic(winEliteTwo/1).
:- dynamic(winEliteThree/1).
:- dynamic(winPaimon/1).
:- dynamic(playerCanUseSkill/1).
:- dynamic(playerSkillCD/1).

/* Help gan combat banyak betul */
/* TBA :potion , dll yg sekiranya kurang */

/* ---------- FIGHT CMDS ----------- */

showEnemyStatus:- /* Show enemy status , enemy still found(alive) */
    isEnemyAlive(_),
    enemy(_,Name,Type,_,Level,Health,Attack,Defense,Special,Exp,Gold),
    write('Name            : '), write(Name), nl,
    write('Type            : '), write(Type), nl,
    write('Health          : '), write(Health), nl,
    write('Level           : '), write(Level), nl,
    write('Attack          : '), write(Attack), nl,
    write('Defense         : '), write(Defense), nl,
    write('Special Attack  : '), write(Special), nl,
    write('Exp given       : '), write(Exp), nl,
    write('Gold given      : '), write(Gold), nl,!.

showEnemyStatus:- /* No enemy to be found */
    \+ isEnemyAlive(_),
    write('Whose stats to be shown? To show your own stats, use status. '),nl,!.

foundEnemy:- /* Encountered an enemy ,enemy stats can scale (without even leveling up)*/
    player(_,_,PLevel,_, _, _, _, _, _),
    random(1,10,ID),
    mobdata(ID,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    NMaxHealth is (MaxHealth + 80*(PLevel-1)),
    NLevel is (Level + (PLevel//5)),
    Health is NMaxHealth,
    NAttack is (Attack + 20*(PLevel-1)),
    NDefense is (Defense + 20*(PLevel-1)),
    NSpecial is (Special + 20*(PLevel-1)),
    NExp is (Exp + 20*(PLevel-1)),
    NGold is (Gold + 20*(PLevel-1)),
    asserta(enemy(ID,Name,Type,NMaxHealth,NLevel,Health,NAttack,NDefense,NSpecial,NExp,NGold)),nl,
    write('A/An '),write(Name),write(' is approaching you'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    write('- flee.'),nl,
    asserta(isEnemyAlive(1)),!.

foundEliteOne:- /* Encountered elite enemy,wave 1 (in dungeon) */
    random(50,51,ID),
    mobdata(ID,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    Health is MaxHealth,
    asserta(enemy(ID,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold)),nl,
    write('An Elite '),write(Name),write(' is approaching you'),nl,
    write('After you win (if you win, ofc), type cont1 to continue'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    asserta(isFightingBoss(1)),
    asserta(isEnemyAlive(1)),!.

cont1:-
    \+ isEnemyAlive(_),
    retract(isFightingBoss(_)),
    write('You win against the first one. But can you pass this? '),nl,
    asserta(winEliteOne(1)),
    foundEliteTwo,!.


foundEliteTwo:- /* Encountered elite enemy, wave 2 (in dungeon) */
    random(52,53,ID),
    mobdata(ID,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    Health is MaxHealth,
    asserta(enemy(ID,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold)),nl,
    write('An Elite '),write(Name),write(' is approaching you'),nl,
    write('After you win (if you win, ofc), type cont2 to continue'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    asserta(isFightingBoss(1)),
    asserta(isEnemyAlive(1)),!.

cont2 :-
    \+ isEnemyAlive(_),
    winEliteOne(_),
    retract(isFightingBoss(_)),
    write('What a surprise, you can go this far. Now face me! '),nl,
    asserta(winEliteTwo(1)),
    foundBoss,!.

foundBoss :- /* Encountered the 'final' boss , Demon Lord Paimon */
    posX(X), posY(Y), (isBoss(X,Y); isDungeon(X,Y)),
    mobdata(66,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    Health is MaxHealth,
    asserta(enemy(66,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold)),nl,
    write('This is it. '),write(Name),write(' is approaching you'),nl,
    write('After you win (if you win, ofc), type cont3 to continue(wait what, this aint the end?)'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    asserta(isFightingBoss(1)),
    asserta(isEnemyAlive(1)),!.

cont3:-
    \+ isEnemyAlive(_),
    winEliteOne(_),
    winEliteTwo(_),
    retract(isFightingBoss(_)),
    write('What....u can win against me...'),nl,
    write('...............'),nl,
    write('Echoing voice is being heard in the air. Suddenly someone claps'),nl,
    write('<< Grreatt Jobbu >>'),nl,
    write('That someone is....... yourself'),nl,
    write('Now face yourself to win THIS GAME !'),nl,
    asserta(winEliteThree(1)),
    foundYourself,!.

foundYourself :- /*Encountered final boss, yourself */
    player(_, PMaxHealth, PLevel,_, PAttack, PDefense,PSpecial, PExp, PGold),
    EMaxHealth is (PMaxHealth - PDefense - PAttack),
    EHealth is EMaxHealth,
    EAttack is PAttack,
    ESpecial is (PSpecial * 5),
    EDefense is 0,
    asserta(enemy(99,you,boss,EMaxHealth,PLevel,EHealth,EAttack,EDefense,ESpecial,PExp,PGold)),
    write('This is yourself. '),nl,
    write('After you win (if you win, ofc), type cont4 to continue(trust me, this is the last time)'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    asserta(isFightingBoss(1)),
    asserta(isEnemyAlive(1)),!.

cont4 :-
    \+ isEnemyAlive(_),
    winEliteOne(_),
    winEliteOne(_),
    winEliteThree(_),
    retract(isFightingBoss(_)),
    write('YOU WIN. YOUVE COME THIS FAR TO THIS EXTENT TO THIS WORLD TO FACE YOURSELF IN THE END.'),nl,
    write('NOW YOU ARE WORTHY'),nl,
    write('Zlrprpspspsps....(Teleporting back to original world)'),nl,
    quit,!.

foundDungeon:- /* Encountered a dungeon */
    posX(X), posY(Y), isDungeon(X,Y),
    write('You sure want to enter this dungeon?'),nl,
    write('You will face 2 waves of enemies and lastly...'),nl,
    write('The Final Boss'),nl,
    write('What will u do? '),nl,
    write('- enterD.'),nl,
    write('- notenterD.'),nl,!.

notenterD:- /* not entering */
    a,!.

enterD:- /* enter dungeon, masi blm fi fix krn ini baru sequencenya */
    write('Entering dungeon.......'),nl,
    foundEliteOne,!.



fightmenu:- /* menu waktu fight */
    write('What will u do?'),nl,
    write('- attack.'),nl,
    write('- specialAttack.'),nl,
    write('- usePotion.'),nl,
    write('- flee.'),nl,
    write('- showEnemyStatus.'),nl,
    !.    

fight:- /* Baru ketemu enemy, fight */
    \+ isFighting(_),
    asserta(isFighting(1)),
    isEnemyAlive(_),
    asserta(playerCanUseSkill(1)),
    fightmenu,!.

fight:- /*still in fight, redirected after fightmenu */
    isFighting(_),
    isEnemyAlive(_),
    fightmenu,!.

fight:- /* Blm ketemu enemy */
    \+ isEnemyAlive(_),
    write('No enemy here, go somewhere else.'),nl,!.

flee:- /*Kaburr,flee successful , blm diapply move di map*/
    isEnemyAlive(_),
    \+ isFightingBoss(_),
    player(_, PMaxHealth, _, PHealth, _, _, _, _, _),
    F is (PMaxHealth * 0.1),
    PHealth > F,
    write('You unleashed ur secret special technique : Nigerundayo '),nl,
    write('Flee successful'),nl,
    retract(enemy(_,_,_,_,_,_,_,_,_,_,_)),
    retract(isEnemyAlive(_)),!.

flee:- /*Kabur, but failed*/
    isEnemyAlive(_),
    \+ isFightingBoss(_),
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

flee:- /* flee while fighting boss */
    isFightingBoss(_),
    write('CANT RUN. MUST FACE.'),
    fight,!.

attack :- /* if someone accidentally uses attack instead of fight */
    isEnemyAlive(_),
    \+ isFighting(_),
    write('Press fight first'),!.

attack:- /*Blm ada yg bisa di attack */
    \+ isEnemyAlive(_),
    write('Nothing to be attacked. U cannot attack urself (especially if u r dead)'),nl,!.

attack:- /* Scheme Attack, Incomplete, Skill on CD */
    isEnemyAlive(_),
    isFighting(_),
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
    isFighting(_),
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
    retract(enemy(_,_,_,_,_,_,_,_,_,_,_)),
    (playerCanUseSkill(_)-> retract(playerCanUseSkill(_))
        ; EHealth is EHealth),
    retract(isEnemyAlive(_)),retract(isFighting(_)),levelUp,!.

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
    fight,!.

playerStats :- /* Player ded */
    player(_, _, _, PHealth,_, _, _, _, _),
    PHealth =< 0,
    write('You just died (again). Maybe this sekai aint for u.'),nl,
    retract(isEnemyAlive(_)),retract(isFighting(_)),
    retract(enemy(_,_,_,_,_,_,_,_,_,_,_)),retract(player(_, _, _, _, _, _, _, _, _)),
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
    isFighting(_),
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
    isFighting(_),
    \+ playerCanUseSkill(_),
    write('Special attack is in cooldown'),nl,
    fight,!.

specialAttack:- /*outside combat */
    \+ isEnemyAlive(_),
    write('Nothing to be attacked. U cannot attack urself (especially if u r dead)'),nl,!.






    





    










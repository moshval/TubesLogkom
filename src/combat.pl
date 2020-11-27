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
:- dynamic(isFightingCerberus/1).
:- dynamic(isFightingMedusa/1).
:- dynamic(isFightingHydra/1).

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
    NMaxHealth is (MaxHealth + 40*(PLevel-1)),
    NLevel is (Level + (PLevel//5)),
    Health is NMaxHealth,
    NAttack is (Attack + 10*(PLevel-1)),
    NDefense is (Defense + 10*(PLevel-1)),
    NSpecial is (Special + 10*(PLevel-1)),
    NExp is (Exp + 20*(PLevel-1)),
    NGold is (Gold + 20*(PLevel-1)),
    asserta(enemy(ID,Name,Type,NMaxHealth,NLevel,Health,NAttack,NDefense,NSpecial,NExp,NGold)),nl,
    write('A/An '),write(Name),write(' is approaching you'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    write('- flee.'),nl,
    asserta(isEnemyAlive(1)),!.


foundMedusa:- /* Self explanatory, in quest */
    isMedusaAlive(_),
    player(_,_,PLevel,_, _, _, _, _, _),
    mobdata(101,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    NMaxHealth is (MaxHealth + 40*(PLevel-1)),
    NLevel is (Level + (PLevel//5)),
    Health is NMaxHealth,
    NAttack is (Attack + 10*(PLevel-1)),
    NDefense is (Defense + 10*(PLevel-1)),
    NSpecial is (Special + 10*(PLevel-1)),
    NExp is (Exp + 20*(PLevel-1)),
    NGold is (Gold + 20*(PLevel-1)),
    asserta(enemy(101,Name,Type,NMaxHealth,NLevel,Health,NAttack,NDefense,NSpecial,NExp,NGold)),nl,
    write('The Legendary '),write(Name),write(' is approaching you'),nl,
    write('Defeat this thing to complete a part of your quest'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    write('- flee.'),
    asserta(isEnemyAlive(1)),asserta(isFightingMedusa(1)),nl,!.

foundMedusa:- /* dah ded */
    \+ isMedusaAlive(_),
    write('Now all you see is the corpse of the legendary Medusa. Already defeated this thing'),nl,!.


foundCerberus:- /* Self explanatory, in quest */
    isCerberusAlive(_),
    player(_,_,PLevel,_, _, _, _, _, _),
    mobdata(103,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    NMaxHealth is (MaxHealth + 40*(PLevel-1)),
    NLevel is (Level + (PLevel//5)),
    Health is NMaxHealth,
    NAttack is (Attack + 10*(PLevel-1)),
    NDefense is (Defense + 10*(PLevel-1)),
    NSpecial is (Special + 10*(PLevel-1)),
    NExp is (Exp + 20*(PLevel-1)),
    NGold is (Gold + 20*(PLevel-1)),
    asserta(enemy(103,Name,Type,NMaxHealth,NLevel,Health,NAttack,NDefense,NSpecial,NExp,NGold)),nl,
    write('The Legendary '),write(Name),write(' is approaching you'),nl,
    write('Defeat this thing to complete a part of your quest'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    write('- flee.'),
    asserta(isEnemyAlive(1)),asserta(isFightingCerberus(1)),nl,!.

foundCerberus:- /* dah ded */
    \+ isCerberusAlive(_),
    write('Now all you see is the corpse of the legendary Cerberus. Already defeated this thing'),nl,!.

foundHydra:- /* Self explanatory, in quest */
    isHydraAlive(_),
    player(_,_,PLevel,_, _, _, _, _, _),
    mobdata(102,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    NMaxHealth is (MaxHealth + 40*(PLevel-1)),
    NLevel is (Level + (PLevel//5)),
    Health is NMaxHealth,
    NAttack is (Attack + 10*(PLevel-1)),
    NDefense is (Defense + 10*(PLevel-1)),
    NSpecial is (Special + 10*(PLevel-1)),
    NExp is (Exp + 20*(PLevel-1)),
    NGold is (Gold + 20*(PLevel-1)),
    asserta(enemy(102,Name,Type,NMaxHealth,NLevel,Health,NAttack,NDefense,NSpecial,NExp,NGold)),nl,
    write('The Legendary '),write(Name),write(' is approaching you'),nl,
    write('Defeat this thing to complete a part of your quest'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    write('- flee.'),
    asserta(isEnemyAlive(1)),asserta(isFightingHydra(1)),nl,!.

foundHydra:- /* dah ded */
    \+ isHydraAlive(_),
    write('Now all you see is the corpse of the legendary Hydra. Already defeated this thing'),nl,!.

foundEliteOne:- /* Encountered elite enemy,wave 1 (in dungeon) */
    posX(X), posY(Y), isDungeon(X,Y),
    random(50,51,ID),
    mobdata(ID,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    Health is MaxHealth,
    asserta(enemy(ID,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold)),nl,
    write('An Elite '),write(Name),write(' is approaching you'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    asserta(isFightingBoss(1)),
    asserta(isEnemyAlive(1)),!.

cont1:- /* after defeating elite one in dungeon, cont1 to fight elite two */
    posX(X), posY(Y), isDungeon(X,Y),
    \+ isEnemyAlive(_),
    retract(isFightingBoss(_)),
    write('You win against the first one. But can you pass this? '),nl,
    asserta(winEliteOne(1)),
    foundEliteTwo,!.


foundEliteTwo:- /* Encountered elite enemy, wave 2 (in dungeon) */
    posX(X), posY(Y), isDungeon(X,Y),
    random(52,53,ID),
    mobdata(ID,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    Health is MaxHealth,
    asserta(enemy(ID,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold)),nl,
    write('An Elite '),write(Name),write(' is approaching you'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    asserta(isFightingBoss(1)),
    asserta(isEnemyAlive(1)),!.

cont2 :- /* after defeating elite two, cont2 to fight paimon */
    posX(X), posY(Y), isDungeon(X,Y),
    \+ isEnemyAlive(_),
    winEliteOne(_),
    retract(isFightingBoss(_)),
    write('What a surprise, you can go this far'),nl,write('NOW FACE ME!!!!!!!!!!! '),nl,
    asserta(winEliteTwo(1)),
    foundBoss,!.

foundBoss :- /* Encountered the 'not so final' boss , Demon Lord Paimon */
    posX(X), posY(Y), isDungeon(X,Y),
    mobdata(66,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    Health is MaxHealth,
    asserta(enemy(66,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold)),nl,
    write('This is it. '),write('Demon Lord Paimon'),write(' is approaching you'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    asserta(isFightingBoss(1)),
    asserta(isEnemyAlive(1)),!.

foundMiniBoss :- /* Encountered Mini Boss, doragon,kerberos,archmage, or abyssknight */
    posX(X), posY(Y), isBoss(X,Y),
    random(50,53,ID),
    mobdata(ID,Name,Type,MaxHealth,Level,Attack,Defense,Special,Exp,Gold),
    Health is MaxHealth,
    asserta(enemy(ID,Name,Type,MaxHealth,Level,Health,Attack,Defense,Special,Exp,Gold)),nl,
    write('An Elite '),write(Name),write(' is approaching you'),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    asserta(isFightingBoss(1)),
    asserta(isEnemyAlive(1)),!.


cont3:- /* after defeating paimon, cont3 to ehem ehem */
    posX(X), posY(Y), isDungeon(X,Y),
    \+ isEnemyAlive(_),
    winEliteOne(_),
    winEliteTwo(_),
    retract(isFightingBoss(_)),
    write('*******************************************************************************\n'), 
    write('                      What....u can win against me...'),nl,
    write('                               ...............                   '),nl,
    write('        Echoing voice is being heard in the air. Suddenly someone claps       '),nl,
    write('                             << Grreatt Jobbu >>'),nl,
    write('                      That someone is....... yourself'),nl,
    write('                    Now face yourself to win THIS GAME !'),nl,
    write('*******************************************************************************\n'),
    asserta(winEliteThree(1)),
    foundYourself,!.

foundYourself :- /*Encountered final boss, yourself */
    posX(X), posY(Y), isDungeon(X,Y),
    player(_, PMaxHealth, PLevel,_, PAttack, PDefense,PSpecial, PExp, PGold),
    EMaxHealth is (PMaxHealth - PDefense - PAttack),
    EHealth is EMaxHealth,
    EAttack is (PAttack * 2),
    ESpecial is (PSpecial * 5),
    EDefense is 0,
    pemain(NamaPemain),
    asserta(enemy(99,NamaPemain,boss,EMaxHealth,PLevel,EHealth,EAttack,EDefense,ESpecial,PExp,PGold)),
    write('This is yourself, mirrored. '),nl,
    write('What will u do? '),nl,
    write('- fight.'),nl,
    asserta(isFightingBoss(1)),
    asserta(isEnemyAlive(1)),!.

cont4 :- /* End the game, after defeating final boss */
    \+ isEnemyAlive(_),
    winEliteOne(_),
    winEliteTwo(_),
    winEliteThree(_),
    retract(isFightingBoss(_)),nl,
    write('   #     # ####### #     #    #     # ### #     # '),nl,
    write('    #   #  #     # #     #    #  #  #  #  ##    #'),nl,
    write('     # #   #     # #     #    #  #  #  #  # #   #'),nl,
    write('      #    #     # #     #    #  #  #  #  #  #  # '),nl,
    write('      #    #     # #     #    #  #  #  #  #   # #'),nl,
    write('      #    #     # #     #    #  #  #  #  #    ##'),nl,
    write('      #    #######  #####      ## ##  ### #     #'),nl,nl,
    write('****************************************************\n'), 
    write('      CONGRATULATIONS. YOU HAVE WON THIS GAME      '),nl,
    write('****************************************************\n'),
    write('YOUVE COME THIS FAR TO THIS EXTENT TO THIS WORLD TO FACE YOURSELF IN THE END.'),nl,
    write('                NOW YOU ARE WORTHY'),nl,
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
    posX(X), posY(Y), isDungeon(X,Y),
    a,!.

notenterD:- /* not entering */
    posX(X), posY(Y), \+ isDungeon(X,Y),
    write('You have to reach dungeon first to use this command'),nl,!.

enterD:- /* entering but not in dungeon coordinates */
    posX(X), posY(Y), \+ isDungeon(X,Y),
    write('You have to reach dungeon first to use this command'),nl,!.

enterD:- /* enter dungeon, masi blm fi fix krn ini baru sequencenya */
    posX(X), posY(Y), isDungeon(X,Y),
    write('Entering dungeon.......'),nl,
    write('.......................\n'),
    write('.......................'),nl,
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
    \+ isFighting(_),
    \+ isFightingBoss(_),
    player(_, PMaxHealth, _, PHealth, _, _, _, _, _),
    F is (PMaxHealth * 0.1),
    PHealth > F,
    write('You unleashed ur secret special technique : [Nigerundayo] '),nl,
    write('Flee successful'),nl,
    retract(enemy(_,_,_,_,_,_,_,_,_,_,_)),
    retract(isEnemyAlive(_)),!.

flee:- /*Kaburr,flee successful , in battle*/
    isEnemyAlive(_),
    isFighting(_),
    \+ isFightingBoss(_),
    player(_, PMaxHealth, _, PHealth, _, _, _, _, _),
    F is (PMaxHealth * 0.1),
    PHealth > F,
    write('You unleashed ur secret special technique : [Nigerundayo] '),nl,
    write('Flee successful'),nl,
    retract(enemy(_,_,_,_,_,_,_,_,_,_,_)),
    retract(isEnemyAlive(_)),retract(isFighting(_)),!.

flee:- /*Kabur, but failed*/
    isEnemyAlive(_),
    \+ isFightingBoss(_),
    player(_, PMaxHealth, _, PHealth, _, _, _, _, _),
    F is (PMaxHealth * 0.1),
    PHealth =< F,
    write('You unleashed ur secret special technique : [Nigerundayo]'),nl,
    write('....but unsuccessful'),nl,
    fight,!.

flee:- /*Kabur while blm ketemu enemy */
    \+ isEnemyAlive(_),
    \+ isFighting(_),
    write('Running from this sekai? No u dont, even if u r a dead man'),nl,!.

flee:- /* flee while fighting boss */
    isFightingBoss(_),
    write('CANT RUN. MUST FACE.'),nl,
    fight,!.

attack :- /* if someone accidentally uses attack instead of fight */
    isEnemyAlive(_),
    \+ isFighting(_),
    write('Press fight first'),nl,!.

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

enemyStats :- /* Defeating Medusa*/
    isQuest1(_),
    isMedusaAlive(_),
    isEnemyAlive(_),
    isFightingMedusa(_),\+ isFightingCerberus(_),\+ isFightingHydra(_),
    posX(X), posY(Y), \+ isDungeon(X,Y),
    enemy(_,EName,_,_,_,EHealth,_,_,_,EExp,EGold),
    EHealth =< 0,
    write(EName),write(' is now dead.'),nl,
    write('A part of your quest is completed. Now you can continue exploring.'),nl,
    player(_, _, _, _, _, _, _, PExp, PGold),
    NewPExp is (PExp + EExp) , NewPGold is (PGold + EGold),
    retract(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    asserta(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, NewPExp, NewPGold)),
    retract(enemy(_,_,_,_,_,_,_,_,_,_,_)),
    (playerCanUseSkill(_)-> retract(playerCanUseSkill(_))
        ; EHealth is EHealth),
    retract(isEnemyAlive(_)),retract(isFighting(_)),retract(isMedusaAlive(_)),retract(isFightingMedusa(_)),levelUp,!.

enemyStats :- /* Defeating Hydra*/
    isQuest1(_),
    isHydraAlive(_),
    isEnemyAlive(_),
    \+ isFightingMedusa(_),\+ isFightingCerberus(_), isFightingHydra(_),
    posX(X), posY(Y), \+ isDungeon(X,Y),
    enemy(_,EName,_,_,_,EHealth,_,_,_,EExp,EGold),
    EHealth =< 0,
    write(EName),write(' is now dead.'),nl,
    write('A part of your quest is completed. Now you can continue exploring.'),nl,
    player(_, _, _, _, _, _, _, PExp, PGold),
    NewPExp is (PExp + EExp) , NewPGold is (PGold + EGold),
    retract(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    asserta(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, NewPExp, NewPGold)),
    retract(enemy(_,_,_,_,_,_,_,_,_,_,_)),
    (playerCanUseSkill(_)-> retract(playerCanUseSkill(_))
        ; EHealth is EHealth),
    retract(isEnemyAlive(_)),retract(isFighting(_)),retract(isHydraAlive(_)),retract(isFightingHydra(_)),levelUp,!.

enemyStats :- /* Defeating Cerberus*/
    isQuest1(_),
    isCerberusAlive(_),
    isEnemyAlive(_),
    \+ isFightingMedusa(_), isFightingCerberus(_), \+ isFightingHydra(_),
    posX(X), posY(Y), \+ isDungeon(X,Y),
    enemy(_,EName,_,_,_,EHealth,_,_,_,EExp,EGold),
    EHealth =< 0,
    write(EName),write(' is now dead.'),nl,
    write('A part of your quest is completed. Now you can continue exploring.'),nl,
    player(_, _, _, _, _, _, _, PExp, PGold),
    NewPExp is (PExp + EExp) , NewPGold is (PGold + EGold),
    retract(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    asserta(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, NewPExp, NewPGold)),
    retract(enemy(_,_,_,_,_,_,_,_,_,_,_)),
    (playerCanUseSkill(_)-> retract(playerCanUseSkill(_))
        ; EHealth is EHealth),
    retract(isEnemyAlive(_)),retract(isFighting(_)),retract(isCerberusAlive(_)),retract(isFightingCerberus(_)),levelUp,!.

enemyStats :- /* if enemy s ded , not in dungeon*/
    posX(X), posY(Y), \+ isDungeon(X,Y),
    \+ isFightingMedusa(_),\+ isFightingCerberus(_),\+ isFightingHydra(_),
    enemy(_,EName,_,_,_,EHealth,_,_,_,EExp,EGold),
    EHealth =< 0,
    write(EName),write(' is now dead.'),nl,
    write('Now you can continue exploring.'),nl,
    player(_, _, _, _, _, _, _, PExp, PGold),
    NewPExp is (PExp + EExp) , NewPGold is (PGold + EGold),
    retract(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, PExp, PGold)),
    asserta(player(PJob, PMaxHealth, PLevel, PHealth, PAttack, PDefense, PSpecial, NewPExp, NewPGold)),
    retract(enemy(_,_,_,_,_,_,_,_,_,_,_)),
    (playerCanUseSkill(_)-> retract(playerCanUseSkill(_))
        ; EHealth is EHealth),
    retract(isEnemyAlive(_)),retract(isFighting(_)),levelUp,!.

enemyStats :- /* if enemy s ded , in dungeon (after defeating eliteone) */
    posX(X), posY(Y), isDungeon(X,Y),
    \+ winEliteOne(_),
    \+ winEliteTwo(_),
    \+ winEliteThree(_),
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
    retract(isEnemyAlive(_)),retract(isFighting(_)),cont1,!.

enemyStats :- /* if enemy s ded in dungeon (after defeating elitetwo) */
    posX(X), posY(Y), isDungeon(X,Y),
    winEliteOne(_),
    \+ winEliteTwo(_),
    \+ winEliteThree(_),
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
    retract(isEnemyAlive(_)),retract(isFighting(_)),cont2,!.

enemyStats :- /* if enemy s ded,after defeating paimon */
    posX(X), posY(Y), isDungeon(X,Y),
    winEliteOne(_),
    winEliteTwo(_),
    \+ winEliteThree(_),
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
    retract(isEnemyAlive(_)),retract(isFighting(_)),cont3,!.

enemyStats :- /* if enemy s ded, after defeating ehem ehem */
    posX(X), posY(Y), isDungeon(X,Y),
    winEliteOne(_),
    winEliteTwo(_),
    winEliteThree(_),
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
    retract(isEnemyAlive(_)),retract(isFighting(_)),cont4,!.

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
    write('  :::       :::     :::      :::::::: ::::::::::: :::::::::: ::::::::: '),nl,
    write('  :+:       :+:   :+: :+:   :+:    :+:    :+:     :+:        :+:    :+:'),nl,
    write('  +:+       +:+  +:+   +:+  +:+           +:+     +:+        +:+    +:+'),nl,
    write('  +#+  +:+  +#+ +#++:++#++: +#++:++#++    +#+     +#++:++#   +#+    +:+'),nl,
    write('  +#+ +#+#+ +#+ +#+     +#+        +#+    +#+     +#+        +#+    +#+'),nl,
    write('   #+#+# #+#+#  #+#     #+# #+#    #+#    #+#     #+#        #+#    #+#'),nl,
    write('    ###   ###   ###     ###  ########     ###     ########## ######### '),nl,nl,
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

specialAttack:- /*outside combat */
    \+ isEnemyAlive(_),
    write('Nothing to be attacked. U cannot attack urself (especially if u r dead)'),nl,!.

specialAttack:- /* player special atk is in CD */
    isEnemyAlive(_),
    isFighting(_),
    \+ playerCanUseSkill(_),
    write('Special attack is in cooldown'),nl,
    fight,!.

specialAttack:- /*player special atk, can only be used every 3 turns, CD resets after leaving combat */
    isEnemyAlive(_),
    isFighting(_),
    playerCanUseSkill(_),
    asserta(playerSkillCD(1)),
    player(PJob, _, PLevel, _, _, _, PSpecial, _, _),
    enemy(_,EName,_,_,_,EHealth,_,EDefense,_,_,_),
    TmpDamage is (PSpecial - EDefense),
    (TmpDamage >= 0 -> PDamage is TmpDamage
        ;PDamage is 0),
    CurrEHealth is (EHealth - PDamage),
    retract(enemy(EID,EName,EType,EMaxHealth,ELevel,EHealth,EAttack,EDefense,ESpecial,EExp,EGold)),
    asserta(enemy(EID,EName,EType,EMaxHealth,ELevel,CurrEHealth,EAttack,EDefense,ESpecial,EExp,EGold)),
    ((PLevel//10) > 3 -> Spreq is 3
        ; Spreq is (PLevel//10)),
    playerspecial(PJob,Spreq,SpName),
    write('Player uses '),write('special attack : '),write(SpName),nl,
    write('Player dealt '),write(PDamage),write(' damage '),write('to '),write(EName),nl,
    retract(playerCanUseSkill(_)),
    enemyStats,!.








    





    










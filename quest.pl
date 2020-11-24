:- dynamic(isQuest1/1).
:- dynamic(isMedusaAlive/1).
:- dynamic(isHydraAlive/1).
:- dynamic(isCerberusAlive/1).

/*Random spawn enemy pas quest dinonaktif*/

quest :- \+init(_), write('Game has not started yet'),!.
quest :- init(_), posX(X), posY(Y), \+isQuest(X,Y), write('You are not in the quest position!'),!.
quest :- \+ isQuest1(_),
         write('| ----------------------------------------------------------|\n'),
         write('|                        QUEST                              |\n'),
         write('| You will receive a quest to defeat 3 ancient opponents    |\n'),
         write('| After finishing the quest, you will gain some gold & exp  |\n'),
         write('| 1. Accept the challenge                                   |\n'),
         write('| 2. Decline and exit                                       |\n'),
         write('| ----------------------------------------------------------|\n'),
         write('Insert your command (accept. / decline.) : '),!.

quest :- isQuest1(_),
         \+ isCerberusAlive(_),
         \+ isMedusaAlive(_),
         \+ isHydraAlive(_),
         player(_, _, _, _, _, _, _, Pexp, PGold),
         NewPGold is PGold + 2000,
         NewPExp is Pexp + 1500,
         retract(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, _, _)),
         asserta(player(Job, MaxHealth, Level, Health, Attack, Defense, Sepcial, NewPExp, NewPGold)),
         write('| ----------------------------------------------------------|\n'),
         write('|                      CONGRATULATIONS                      |\n'),
         write('| Youve completed the quest !!                              |\n'),
         write('| You gain 2000 Gold and 1500 Exp                           |\n'),
         write('| Comeback anytime ^_^                                      |\n'),
         write('| ----------------------------------------------------------|\n'),
         retract(isQuest1(_)),
         s,!.


quest :- isQuest1(_),
         write('| ----------------------------------------------------------|\n'),
         write('|                        QUEST                              |\n'),
         write('| Do you want to cancel the quest? You will gain no reward  |\n'),
         write('| 1. Yes                                                    |\n'),
         write('| 2. No                                                     |\n'),
         write('| ----------------------------------------------------------|\n'),
         write('Insert your command (cancel. / dontcancel.) : '),!.

accept :- \+init(_), write('Game has not started yet'),!.
accept :- init(_), posX(X), posY(Y), \+isQuest(X,Y), write('You are not in the quest position!'),!.
accept :- write('| ----------------------------------------------------------|\n'),
          write('|                        QUEST                              |\n'),
          write('| Find three ancient opponent on the map : Medusa, Hydra    |\n'),
          write('| and Cerberus and defeat them all. After you succeed come- |\n'),
          write('| back to receive the reward                                |\n'),
          write('| ----------------------------------------------------------|\n'),
          asserta(isQuest1(1)),
          asserta(isMedusaAlive(1)),
          asserta(isHydraAlive(1)),
          asserta(isCerberusAlive(1)),!.

decline :- \+init(_), write('Game has not started yet'),!.
decline :- init(_), posX(X), posY(Y), \+isQuest(X,Y), write('You are not in the quest position!'),!.
decline :- write('****************************************************\n'), 
           write('Comeback whenever youre ready ! \n'),
           write('****************************************************\n\n'),!.

cancel :- \+init(_), write('Game has not started yet'),!.
cancel :- init(_), posX(X), posY(Y), \+isQuest(X,Y), write('You are not in the quest position!'),!.
cancel :- retract(isQuest1(_)),
          write('****************************************************\n'), 
          write('Comeback whenever youre ready ! \n'),
          write('****************************************************\n\n'),!.

dontcancel :- \+init(_), write('Game has not started yet'),!.
dontcancel :- init(_), posX(X), posY(Y), \+isQuest(X,Y), write('You are not in the quest position!'),!.
dontcancel :-  write('****************************************************\n'), 
               write('Go slay em !! Continue your quest \n'),
               write('****************************************************\n\n'),!.

/*
defeat

*/



:- dynamic(isQuest1/1).
:- dynamic(isMedusaDead/1).
:- dynamic(isHydraDead/1).
:- dynamic(isCerberusDead/1).



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
         write('| ----------------------------------------------------------|\n'),
         write('|                        QUEST                              |\n'),
         write('| Do you want to cancel the quest? You will gain no reward  |\n'),
         write('| 1. Yes                                                    |\n'),
         write('| 2. No                                                     |\n'),
         write('| ----------------------------------------------------------|\n'),
         write('Insert your command (cancel. / cancelquest.) : '),!.

accept :- write('| ----------------------------------------------------------|\n'),
          write('|                        QUEST                              |\n'),
          write('| Find three ancient opponent on the map : Medusa, Hydra    |\n'),
          write('| and Cerberus and defeat them all. After you succeed come- |\n'),
          write('| back to receive the reward                                |\n'),
          write('| ----------------------------------------------------------|\n'),
          asserta(isQuest1(1)),!.

decline :- write('****************************************************\n'), 
           write('Comeback whenever youre ready ! \n'),
           write('****************************************************\n\n'),
           s,!.



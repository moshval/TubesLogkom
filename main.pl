:- dynamic(pemain/1).
:- dynamic(init/1).
:- dynamic(godMode/1).

:- include('map.pl').
:- include('mobdata.pl').
:- include('role.pl').
:- include('player.pl').
:- include('store.pl').
:- include('combat.pl').
:- include('level.pl').
:- include('quest.pl').

title :-
	write('-------------------------------------------------------------'),nl,
	write('                                                           '),nl,
	write('         ____                  _                           '),nl,
	write('        |  _ \\               (_)                          '),nl,
	write('        | |_) | ___ _ __    ___ _ _ __                     '),nl,
	write('        |  _ < / _ \\  _\\ / __| |  _\\                    '),nl,
	write('        | |_) |  __/ | | \\__ \\ | | | |                   '),nl,
	write('        |____/\\___|_| |_ |___/_|_| |_|                    '),nl,
	write('                _____                       _              '),nl,
	write('               |_   _|                     | |             '),nl,
	write('                 | |  _ __ ___   _ __   ___| | __          '),nl,
	write('                 | | |  _   _ \\|  _\\ / _\\ |/ /          '),nl,
	write('                _| |_| | | | |  | |_) |  __/   <           '),nl,
	write('               |_____|_| |_| |_ | .__/\\___|_|\\_\\        '),nl,
	write('                           | |                             '),nl,
	write('                           |_|                             '),nl,
	write('                                                           '),nl,
	write('-------------------------------------------------------------'),nl,
	write('Welcome to Bensin Impek!\n'),
	write('You got hit by truck and dead, now you are reincarnated to another world!').

help :-
	write('------------------------------\n'),
	write('| start. - start the game    |\n'),
	write('| help. - see the cmd        |\n'),
	write('| w. a. s. d. - move         |\n'),
	write('| status. - see your status  |\n'),
	write('| inventory. - open inventory|\n'),
	write('| map. - open map            |\n'),
	write('| quit. - quit game          |\n'),
	write('------------------------------\n').

/* loop ref: https://stackoverflow.com/questions/29857372/how-to-go-back-to-repeat-in-prolog */
initPemain :-
	write('\n\nWrite your name, traveler!\nName (lowercase): '),
	read(Nama),
	asserta(pemain(Nama)),
	write('\nHello, '), write(Nama), write('\n'),
	repeat, nl,
	write('Here is Job List for you to choose\n'),
	write('1. Swordsman\n'),
	write('2. Archer\n'),
	write('3. Sorcerer\n\nChoose one (lowercase): '),
	read(Job),
     	(    \+validJob(Job) -> write('\nWrong input!'), fail
     	;    validJob(Job) -> (
		initPlayer(Job),
		write('\nYou choose '), write(Job),
		write('!\nGood luck on your new life, Traveler!\nHere is your status\n\n'),
		playerStatus,
		write('\n\nHere is the list of commands that may be useful for your new life!\n'),
		help
	     ),  !
     	),
	!.

initGame :- 
	initMap,
	initP,!.
	
start :- init(_), write('Game has already started!'),!.
start :-
	\+init(_),
	title,
	asserta(init(1)),
	initGame,
	initPemain, 
	!.

status :- \+init(_), write('Game has not started yet!'),!.
status :- init(_), playerStatus,!.

inventory :- \+init(_), write('Game has not started yet!'),!.
inventory :- init(_), showInventory, !.

/* forbidden technique */
godMode :- \+init(_), write('Game has not started yet!'),!.
godMode :- init(_),
	 retract(player(Job, _, _, _, _, _, _, _, _)),
         asserta(player(Job, 9999999, 99, 9999999, 99999, 99999, 999999, 0, 99999999)),
	 asserta(godMode(1)),
	 write('You have reached God Mode!'), !.

quit :- \+init(_), write('Game has not started yet!'),!.
quit :- init(_),
	write('Thank you for you adventure, '), pemain(Nama), write(Nama), write('!'), nl,
	write('You will be missed.'),
	retract(posX(_)),
	retract(posY(_)),
	retract(lebar(_)),
	retract(panjang(_)),
	retract(pemain(_)),
	retract(init(_)),!.

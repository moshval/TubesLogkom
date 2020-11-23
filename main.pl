:- dynamic(pemain/1).
:- dynamic(init/1).

:- include('map.pl').
:- include('mobdata.pl').
:- include('role.pl').
:- include('player.pl').
:- include('store.pl').

title :-
	write('welcome\n'),
	write('start. - start the game\n'),
	write('help. - see the cmd\n'),
	write('w. a. s. d. - move\n'),
	write('map. - open map\n'),
	write('quit. - quit game').

initPemain :-
	write('\n\nWrite your name\n'),
	read(Nama),
	asserta(pemain(Nama)),
	write('\nHello, '), write(Nama), write('\n'),
	write('Job List:\n'),
	write('1. swordsman\n'),
	write('2. archer\n'),
	write('3. sorcerer\n\nChoose one: '),
	read(Job),
	initPlayer(Job),
	write('\nYou choose '), write(Job),
	write('!\nHere is your stat\n\n'),
	playerStatus,
	!.

initGame :- 
	initMap,
	initP,!.
	
start :- init(_), write('Permainan sudah dimulai'),!.
start :-
	\+init(_),
	title,
	asserta(init(1)),
	initGame,
	initPemain, !.

quit :- \+init(_), write('Permainan belom dimulai'),!.
quit :- init(_),
	write('bye'),
	retract(posX(_)),
	retract(posY(_)),
	retract(lebar(_)),
	retract(panjang(_)),
	retract(pemain(_)),
	retract(init(_)),!.
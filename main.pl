:- dynamic(pemain/1).
:- dynamic(init/1).

:- include('map.pl').
:- include('mobdata.pl').
:- include('player.pl').
:- include('role.pl').
:- include('store.pl').

title :-
	write('welcome\n'),
	write('start. - memulai permainan\n'),
	write('help. - liat-liat perintah\n'),
	write('w. a. s. d. - berpindah\n'),
	write('map. - liat map\n'),
	write('quit. - quit game').

initPemain :-
	write('\n\nMasukkan nama\n'),
	read(Nama),
	asserta(pemain(Nama)),
	write('\nHalo, '), write(Nama), write('\n'),
	write('Pilih kelas\n'),
	write('1,2,3'),!.

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
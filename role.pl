/*** Facts & Rules tiap Role ***/
/*** role(Job, MaxHealth, Level, Attack, Defense, Special) ***/

role(swordsman, 300, 1, 30, 20, 70).
role(archer, 300, 1, 30, 20, 70).
role(sorcerer, 300, 1, 30, 20, 70).

/*** item(ID, Name, Job, Type, Health, Attack, Defense) ***/
/* item swordsman */
item(1,sapujagad, swordsman, equipment, 0, 20, 0).
/* item archer */
item(1,panahomo, archer, equipment, 0, 20, 0).
/* item scorcerer */
item(1,sulingsakti, sorcerer, equipment, 0, 20, 0).

/* potion */
item(99,amer, swordsman, potion, 20, 0, 0).
item(99,amer, archer, potion, 20, 0, 0).
item(99,amer, sorcerer, potion, 20, 0, 0).

price(potion, 100).
/*** price equipment buat gacha juga ***/
price(equipment, 1000). 

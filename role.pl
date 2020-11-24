/*** Facts & Rules tiap Role ***/
/*** role(Job, MaxHealth, Level, Attack, Defense, Special) ***/

validJob(swordsman).
validJob(archer).
validJob(sorcerer).

role(swordsman, 500, 1, 80, 30, 90).
role(archer, 400, 1, 90, 20, 100).
role(sorcerer, 400, 1, 70, 35, 120).

jobID(swordsman,1).
jobID(archer,2).
jobID(sorcerer,3).

maxExp(100).

/*** item(ID, Name, Job, Type, Health, Attack, Defense) ***/
/* item swordsman */
item(1,sapujagad, swordsman, equipment, 0, 20, 0).
item(2,pedangberurat,swordsman,equipment,0,30,0).
item(3,pedangnaga, swordsman, equipment, 0, 50, 0).
item(4,pedangyisunshin, swordsman, equipment, 0, 80, 0).
item(5,armorgta,swordsman,equipment, 0,0,50).
/* item archer */
item(1,panahomo, archer, equipment, 0, 20, 0).
item(2,panaharjuna, archer, equipment, 0, 30, 0).
item(3,panahasmara, archer, equipment, 0, 50, 0).
item(4,panahyisunshin, archer, equipment, 0, 80, 0).
item(5,armorgta,archer,equipment, 0,0,50).
/* item scorcerer */
item(1,sulingsakti, sorcerer, equipment, 0, 20, 0).
item(2,tongkatnenek, sorcerer, equipment, 0, 30, 0).
item(3,selendangkadita, sorcerer, equipment, 0, 50, 0).
item(4,skateboardyisunshin, sorcerer, equipment, 0, 80, 0).
item(5,armorgta,sorcerer,equipment, 0,0,50).

/* potion */
item(99,amer, swordsman, potion, 20, 0, 0).
item(99,amer, archer, potion, 20, 0, 0).
item(99,amer, sorcerer, potion, 20, 0, 0).

/* price */
price(potion, 100).
/*** price equipment buat gacha juga ***/
price(equipment, 1000).

/* sell price */
sellprice(amer, 80).

sellprice(armorgta, 300).

sellprice(sapujagad, 300).
sellprice(pedangberurat, 400).
sellprice(pedangnaga, 600).
sellprice(pedangyisunshin, 900).

sellprice(panahomo, 300).
sellprice(panaharjuna, 400).
sellprice(panahasmara, 600).
sellprice(panahyisunshin, 900).

sellprice(sulingsakti, 300).
sellprice(tongkatnenek, 400).
sellprice(selendangkadita, 600).
sellprice(skateboardyisunshin, 900).
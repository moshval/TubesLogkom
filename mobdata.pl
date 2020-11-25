/* Testing Purposes */

/*mobdata(ID,Name,Type,MaxHealth,Level,Attack,Defense,SpecialAtk,Exp,Gold) */

/* EZ PZ (mob level 5 kebawah) / base level ; stat bakal dibuat scalable based on level, mungkin per 5 level(?) */
mobdata(1,slime,mob,100,1,50,5,75,100,100).
mobdata(2,hilichurl,mob,200,2,80,20,100,200,150).
mobdata(3,richgoblin,mob,500,1,50,10,0,200,3000).
mobdata(4,wolf,mob,250,3,90,30,120,200,200).
mobdata(5,bandit,mob,400,5,100,40,110,210,250).
mobdata(6,shaman,mob,300,5,120,30,150,250,200).
mobdata(7,cultist,mob,400,5,120,40,200,250,200).
mobdata(8,orc,mob,400,5,120,40,150,250,200).
mobdata(9,boar,mob,100,1,60,10,150,150,150).
mobdata(10,bonus_enemy,mob,5,1,0,0,0,0,0).


/* Quest Enemy */
mobdata(101,medusa,quest,700,5,200,60,250,400,750).
mobdata(102,hydra,quest,800,5,150,40,300,500,800).
mobdata(103,cerberus,quest,600,5,200,60,300,600,1000).

/* TBA */
/* BOSSU Lv 10 for example */
mobdata(50,doragon,boss,4000,20,800,300,950,1000,5000).
mobdata(51,kerberos,boss,2000,20,700,250,1200,1000,4000).
mobdata(52,archmage,boss,2000,20,600,150,1500,1000,5000).
mobdata(53,abyssknight,boss,3000,10,750,200,1300,1000,4500).

mobdata(66,demonlord_paimon,boss,6666,66,666,666,1666,6666,6666).

mobdata(-999,secret_boss,boss,99999,99,99999,99999,99999,99999,99999).

/* Special name (if needed)  specialdata(Name,SpecialName)*/
specialdata(slime,slime_bomb).
specialdata(hilichurl,random_spin).
specialdata(richgoblin,here_is_ur_gold).
specialdata(wolf,auuuuuuuu).
specialdata(bandit,stabstabstab).
specialdata(shaman,curse_u).
specialdata(cultist,awaken_my_master).
specialdata(orc,orc_rant).
specialdata(boar,sruduk).
specialdata(bonus_enemy,oof).

specialdata(doragon,fusrodah).
specialdata(kerberos,use_our_heads).
specialdata(archmage,adava_kedavra).
specialdata(abyssknight,phantom_slash).
specialdata(demonlord_paimon,how_about_we_explore_the_area_ahead_of_us_later).
specialdata(secret_boss,getrekt).
specialdata(you,fullcounter).
specialdata(medusa,stone_gaze).
specialdata(hydra,extra_heads).
specialdata(cerberus,use_our_heads).

/* playerspecial(Job,SpecialTreeLevelRequirement,SpecialName) */

playerspecial(swordsman,0,triple_slash).
playerspecial(archer,0,arrow_barrage).
playerspecial(sorcerer,0,exproshon).

playerspecial(swordsman,1,quintuple_slash).
playerspecial(archer,1,rain_of_arrows).
playerspecial(sorcerer,1,mega_exproshon).

playerspecial(swordsman,2,quattuordecuple_slash).
playerspecial(archer,2,meteor_of_arrows).
playerspecial(sorcerer,2,super_mega_exproshon).

playerspecial(swordsman,3,excalibur).
playerspecial(archer,3,requiem_of_arrows).
playerspecial(sorcerer,3,super_mega_exproshon_requiem).


/* Secret boss diakhir abis ngalahin paimon bakalan mirror dari player itu sendiri */
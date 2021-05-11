pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--petipave

niveau=5
joueurs=2

function _init()
	jeu={
		mode="debut",
		joueur=1,
		tirage,
		largeur,
		hauteur,
		main,
		case=13,
		niveau=niveau,
		joueurs=joueurs,
		ax,
		ay,
		dx,
		dy,
		fx,
		fy
	}
	
	--point
	px={6,2,10,6}
	py={2,6,6,10}
	
	--parametre	
	jeu.largeur=jeu.niveau
	jeu.hauteur=jeu.largeur
	jeu.main=jeu.largeur
	jeu.tirage=2*jeu.largeur*jeu.hauteur
	jeu.joueurs=joueurs
	
	--calcul
	lg=jeu.largeur*jeu.case+
		(jeu.largeur+1)
	hg=lg
	xg=flr((128-lg)/2)
	yg=xg
	
	hm=jeu.main*jeu.case+
		(jeu.main+1)
	lm=jeu.case+2
	xm=flr((xg-lm)/2)
	ym=flr((128-hm)/2)	
	
	--main
	mx={xm,xg+lg+xm}
	
	my={}
	for n=0,jeu.main-1 do	
		add(my,ym+n*(jeu.case+1))
	end
	
	--grille
	gx={}
	for n=0,jeu.largeur-1 do
		add(gx,xg+n*(jeu.case+1))
	end
	
	gy={}
	for n=0,jeu.hauteur-1 do
		add(gy,yg+n*(jeu.case+1))
	end

	joueur={}
	add(joueur,{
		x=1,
		y=1,
		carte=1,
		main={},
		score=0})
	add(joueur,{
		x=1,
		y=1,
		carte=1,
		main={},
		score=0})
	
	grille={}
	
	for x=1,jeu.largeur do
		for y=1,jeu.hauteur do
			add(grille,{x=x,y=y,carte=""})
		end
	end
	
	distribution()
end

function _update()
	if jeu.mode=="carte" then
		--mode 1 joueur
		if jeu.joueurs==1 and jeu.joueur==2 then
			joueur[2].carte=flr(rnd(jeu.main))+1
			carte=joueur[2].main[joueur[2].carte]
		 
		 repeat
		 	joueur[2].x=flr(rnd(jeu.niveau))+1
		 	joueur[2].y=flr(rnd(jeu.niveau))+1
			 			 
			 cible=grille[case(
			 	joueur[2].x,
			 	joueur[2].y)].carte
			until cible==""
			
		 grille[case(
		 	joueur[2].x,
		 	joueur[2].y)].carte=carte
		 	
			carte=joueur[2].main[joueur[2].carte]
			del(joueur[2].main,carte)	
		 
		 if #joueur[2].main==0 or
		 	grille_pleine() then
		 	jeu.mode="fin"
		 end
		 		
			jeu.ax=mx[jeu.joueur]
			jeu.ay=my[jeu.joueur]
			
			resolution()
		 jeu.joueur=joueur_suivant(jeu.joueur)
			 				
			sfx(0)
		else
			if btnp(❎) then
				jeu.mode=mode_suivant(jeu.mode)
				sfx(0)
			elseif btnp(⬆️) then
				if joueur[jeu.joueur].carte>1 then
					joueur[jeu.joueur].carte-=1
				end
			elseif btnp(⬇️) then
				if joueur[jeu.joueur].carte<jeu.main then
					joueur[jeu.joueur].carte+=1
				end
			end
		end
	elseif jeu.mode=="animation" then
		--jeu.ax=jeu.ax+(jeu.ax*jeu.fx/jeu.dx)
		--jeu.ay=jeu.ay+(jeu.ay*jeu.fx/jeu.dy)
	 
		--if jeu.ax>=jeu.fx 
		--	and jeu.ay>=jeu.fy then 
			jeu.mode=mode_suivant(jeu.mode)
		--end
	elseif jeu.mode=="case" then
		if btnp(❎) then
			if grille[case(
				joueur[jeu.joueur].x,			
				joueur[jeu.joueur].y)]
				.carte=="" then
				grille[case(
					joueur[jeu.joueur].x,			
					joueur[jeu.joueur].y)]
					.carte=
					joueur[jeu.joueur].main[
					joueur[jeu.joueur].carte]				
				
				del(joueur[jeu.joueur].main,
					joueur[jeu.joueur].main[
					joueur[jeu.joueur].carte])
				joueur[jeu.joueur].carte=1
								
			 --fin
			 if (#joueur[1].main==0 and
			 	#joueur[2].main==0) or
			 	grille_pleine() then
			 	jeu.mode="fin"
			 end
			 
			 if jeu.mode!="fin" then
					resolution()
					
					jeu.ax=mx[jeu.joueur]
					jeu.ay=my[jeu.joueur]
					
					jeu.mode=mode_suivant(jeu.mode)
					jeu.joueur=joueur_suivant(jeu.joueur)
			 end
			end
			
			sfx(0)			
		elseif btnp(4) then
			jeu.mode="carte"
		elseif btnp(⬅️) then
			if joueur[jeu.joueur].x>1 then
				joueur[jeu.joueur].x-=1
			end
		elseif btnp(➡️) then
			if joueur[jeu.joueur].x<jeu.largeur then
				joueur[jeu.joueur].x+=1
			end
		elseif btnp(⬆️) then
			if joueur[jeu.joueur].y>1 then
				joueur[jeu.joueur].y-=1
			end
		elseif btnp(⬇️) then
			if joueur[jeu.joueur].y<jeu.hauteur then
				joueur[jeu.joueur].y+=1
			end
		end
	elseif jeu.mode=="debut" then
		if btnp(❎) then
			niveau=jeu.niveau
			joueurs=jeu.joueurs
			_init()
			jeu.mode="carte"
			sfx(1)
		elseif btnp(⬆️) then
			if (jeu.niveau<6) jeu.niveau+=1
		elseif btnp(⬇️) then
			if (jeu.niveau>2) jeu.niveau-=1
		elseif btnp(⬅️) then
			if (jeu.joueurs>1) jeu.joueurs-=1
		elseif btnp(➡️) then
			if (jeu.joueurs<2) jeu.joueurs+=1
		end
	elseif jeu.mode=="fin" then
		if btnp(❎) then
		 _init()
			sfx(1)
		end
	end
end

function _draw()
	cls()
	
	if jeu.mode=="debut" then
		print("niveau:"..jeu.niveau,52,60)
		print("joueurs:"..jeu.joueurs,50,67)
	elseif jeu.mode=="fin" then
		print("fin",59,60)
	else	
		--mains
		for x=1,2 do
			for y=1,jeu.main do
				carte=joueur[x].main[y]
				couleur=7
				if x==jeu.joueur 
					and y==joueur[jeu.joueur].carte 
					then
			 	rectfill(
			 		mx[x],
			 		my[y],
			 		mx[x]+jeu.case+1,
			 		my[y]+jeu.case+1,
			 		5
			 		)
				end
				rect(
					mx[x],
					my[y],
					mx[x]+jeu.case+1,
					my[y]+jeu.case+1,
					7
					)
				if (carte!=nil) afficher_carte(x,y,carte,"main")
			end
		end
		
		--grille
		for x=1,jeu.largeur do
			for y=1,jeu.hauteur do
			 carte=grille[case(x,y)].carte
			 couleur=7
			 if jeu.mode=="case" and x==joueur[jeu.joueur].x 
			 	and y==joueur[jeu.joueur].y
			 	then 
			 	rectfill(
			 		gx[x],
			 		gy[y],
			 		gx[x]+jeu.case+1,
			 		gy[y]+jeu.case+1,
			 		5
			 		)
				end
			
				rect(
					gx[x],
					gy[y],
					gx[x]+jeu.case+1,
					gy[y]+jeu.case+1,
					7
					)
			 afficher_carte(x,y,carte,"grille")
			end
		end
		
		--scores
		print(joueur[1].score,xm+flr((jeu.case-3)/2),ym-6,7)
		print(joueur[2].score,xg+lg+xm+flr((jeu.case-3)/2),ym-6,7)
		
		--restes
		print(#joueur[1].main,xm+flr((jeu.case-3)/2),yg+hg+1,7)	
		print(#joueur[2].main,xg+lg+xm+flr((jeu.case-3)/2),yg+hg+1,7)
	end
	
	if jeu.mode=="animation" then
		rectfill(
			jeu.ax,
			jeu.ay,
			jeu.ax+jeu.case,
			jeu.ay+jeu.case,
			7)
	end	
end
-->8
--fonction

function distribution()
	local cartes={}
	
	for carte=1,9999 do
		add(cartes,sub("0000"..carte,-4))
	end
	
	for main=1,#joueur do
		for nombre=1,jeu.tirage do
			carte=flr(rnd(9999))
			add(joueur[main].main,
				cartes[carte])
			del(cartes,cartes[carte])
		end
	end
end

function joueur_suivant(numero)
	if numero==2 then
		return 1
	else
		return 2
	end
end

function mode_suivant(mode)	
	if mode=="case" then
		jeu.dx=grille[case(
			joueur[jeu.joueur].x,
			joueur[jeu.joueur].y)].x
		jeu.fx=mx[jeu.joueur]
		jeu.dy=grille[case(
			joueur[jeu.joueur].x,
			joueur[jeu.joueur].y)].y			
		jeu.fy=my[joueur[jeu.joueur].carte]
		return "animation"
	elseif mode=="carte" then
		return "case"
	elseif mode=="animation" then
		return "carte"
	end
end

function joueurs_suivant(joueurs)
	if joueurs==1 then
		return 2
	else
		return 1
	end
end

function case(x,y)
	for id=1,#grille do
		if grille[id].x==x and 
			grille[id].y==y then
			return id
		end
	end
end

function afficher_carte(x,y,carte,mode)
	for point=1,4 do
		if mode=="grille" then 
			spr(
				tonum(sub(carte,point,point)),
				gx[x]+px[point],
				gy[y]+py[point]
				)
		elseif mode=="main" then
			spr(
				tonum(sub(carte,point,point)),
				mx[x]+px[point],
				my[y]+py[point]
				) 
		end
	end	
end

function resolution()
	--base
	base=grille[case(
	joueur[jeu.joueur].x,
	joueur[jeu.joueur].y)].carte
	
	--dessus
	if joueur[jeu.joueur].y>1 then
		dessus=grille[case(
		joueur[jeu.joueur].x,
		joueur[jeu.joueur].y-1)].carte
	
		if dessus!="" then
			if tonum(sub(dessus,4,4)) 
				< tonum(sub(base,1,1)) then
				joueur[jeu.joueur].score+=1
				grille[case(
					joueur[jeu.joueur].x,
					joueur[jeu.joueur].y-1)]
					.carte=""
			elseif tonum(sub(dessus,4,4)) 
				> tonum(sub(base,1,1)) then
				grille[case(
					joueur[jeu.joueur].x,
					joueur[jeu.joueur].y)]
					.carte=""
			end
		end
	end
	
	--dessous
	if joueur[jeu.joueur].y<jeu.hauteur then
		dessous=grille[case(
		joueur[jeu.joueur].x,
		joueur[jeu.joueur].y+1)].carte
	
		if dessous!="" then
			if tonum(sub(dessous,1,1)) 
				< tonum(sub(base,4,4)) then
				joueur[jeu.joueur].score+=1
				grille[case(
					joueur[jeu.joueur].x,
					joueur[jeu.joueur].y+1)]
					.carte=""
			elseif tonum(sub(dessous,1,1)) 
				> tonum(sub(base,4,4)) then
				grille[case(
					joueur[jeu.joueur].x,
					joueur[jeu.joueur].y)]
					.carte=""				
			end
		end
	end
	
	--gauche	
	if joueur[jeu.joueur].x>1 then
		gauche=grille[case(
		joueur[jeu.joueur].x-1,
		joueur[jeu.joueur].y)].carte
	
		if gauche!="" then
			if tonum(sub(gauche,3,3)) 
				< tonum(sub(base,2,2)) then
				joueur[jeu.joueur].score+=1
				grille[case(
					joueur[jeu.joueur].x-1,
					joueur[jeu.joueur].y)]
					.carte=""
			elseif tonum(sub(gauche,3,3)) 
				> tonum(sub(base,2,2)) then
				grille[case(
					joueur[jeu.joueur].x,
					joueur[jeu.joueur].y)]
					.carte=""
			end
		end
	end
	
	--droite
	if joueur[jeu.joueur].x<jeu.largeur then
		droite=grille[case(
		joueur[jeu.joueur].x+1,
		joueur[jeu.joueur].y)].carte
	
		if droite!="" then
			if tonum(sub(droite,2,2)) 
				< tonum(sub(base,3,3)) then
				joueur[jeu.joueur].score+=1
				grille[case(
					joueur[jeu.joueur].x+1,
					joueur[jeu.joueur].y)]
					.carte=""
			elseif tonum(sub(droite,2,2)) 
				> tonum(sub(base,3,3)) then
				grille[case(
					joueur[jeu.joueur].x,
					joueur[jeu.joueur].y)]
					.carte=""
			end
		end
	end
end

function grille_pleine()
	for case=1,#grille do
		if (grille[case].carte=="") return false		
	end
	return true
end
__gfx__
000000000000000000000000303000004040000050500000600000008880000090900000aaa00000777007770000000000000000000000000000000000000000
000000000100000020200000000000000000000005000000606000000880000099900000aaa00000757777570000000000000000000000000000000000000000
000000000000000000000000030000004040000050500000666000000880000099900000aaa00000755555570000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000775575770000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000075775770000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000775555570000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000755775570000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000777777770000000000000000000000000000000000000000
__sfx__
00010000205501b55017550115500d550085500255000550084000640003400014000040003100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000b5500c5500e5501055010550125501745015550165501755019550195501955019550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00102101032502a500002500b40002250235000025029500022502550000250235000225032500012502b500032502650001250205000325022500012501e5000325019500022500000003250000000025000200
001000001605000000000000b050000000000003050000000e050000001105000000170501605017050000001a050000001b0501b050000000000020050200502005000000230500000022050000001e05000000
__music__
01 02034344


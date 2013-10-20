with Dessin; use Dessin;
with Ligne; use Ligne;
with STL ; use STL;
with Algebre ; use Algebre;

with Scene;
use Scene;

with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;
use Ada.Float_Text_IO;
with Ada.Text_IO;
use Ada.Text_IO;

package body Frame is

	procedure Calcul_Image is
		couleur : Byte := Valeur_Luminosite;
	begin
		-- a faire : calcul des projections, affichage des triangles
		for i in 1..Nombre_De_Facettes loop
			declare
				P1,P2,P3 : Vecteur(1..2);
			begin
				Projection_Facette(i,P1,P2,P3);
				--On verifie que tous les points sont dans l'ecran
				if Integer(P1(1)) in 1..SCRW and Integer(P1(2)) in 1..SCRH
			   and Integer(P2(1)) in 1..SCRW and Integer(P2(2)) in 1..SCRH	then
					Tracer_Segment(Integer(P1(1)),Integer(P1(2)),Integer(P2(1)),Integer(P2(2)),couleur);
				end if;
				if Integer(P2(1)) in 1..SCRW and Integer(P2(2)) in 1..SCRH
			   and Integer(P3(1)) in 1..SCRW and Integer(P3(2)) in 1..SCRH	then
					Tracer_Segment(Integer(P2(1)),Integer(P2(2)),Integer(P3(1)),Integer(P3(2)),couleur);
				end if;
				if Integer(P1(1)) in 1..SCRW and Integer(P1(2)) in 1..SCRH
			   and Integer(P3(1)) in 1..SCRW and Integer(P3(2)) in 1..SCRH	then
					Tracer_Segment(Integer(P3(1)),Integer(P3(2)),Integer(P1(1)),Integer(P1(2)),couleur);
				end if;
			end;
		end loop;
		null;
	end;

	--Permet d'effacer l'ecran pour afficher la prochaine image
	procedure Clean_Screen is
	begin
		for i in 1..SCRW loop
			for j in 1..SCRH loop
				Fixe_Pixel(i,j,0);
			end loop;
		end loop;
	end;

end Frame;

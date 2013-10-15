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
	begin
		-- a faire : calcul des projections, affichage des triangles
		for i in 1..Nombre_De_Facettes loop
			declare
				P1,P2,P3 : Vecteur(1..2);
			begin
				Projection_Facette(i,P1,P2,P3);
				--Put(Integer(P1(2)));
				Tracer_Segment(Integer(P1(1)),Integer(P1(2)),Integer(P2(1)),Integer(P2(2)));
				Tracer_Segment(Integer(P2(1)),Integer(P2(2)),Integer(P3(1)),Integer(P3(2)));
				Tracer_Segment(Integer(P3(1)),Integer(P3(2)),Integer(P1(1)),Integer(P1(2)));
			--	Put(P1(1));
			--	Put(P1(2));
			--	Put_Line("");
			--	Put(P2(1));
			--	Put(P2(2));
			--	Put_Line("");
			--	Put(P3(1));
			--	Put(P3(2));
			--	Put_Line("");
			end;
		end loop;
		null;
	end;

end Frame;

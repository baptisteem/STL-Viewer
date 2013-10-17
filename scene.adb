with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
use Ada.Float_Text_IO;

package body Scene is

	R : Float := 50.0; -- coordonnee Z initiale de la camera
	Rho : Float := 0.0; -- rotation autour de X
	Theta : Float := 0.0; -- rotation autour de Y
	Phi : Float := 0.0; -- rotation autour de Z

	E : Vecteur(1..3) := (-400.0, -300.0, 400.0); -- position du spectateur
	T : Matrice(1..3, 1..3); -- matrice de rotation

	M : Maillage;

	procedure Modification_Matrice_Rotation is
	begin
		T := Matrice_Rotations ((1 => -Rho, 2 => -Theta, 3 => -Phi));
	end Modification_Matrice_Rotation;

	function Position_Camera return Vecteur is
		Position : Vecteur(1..3) := (0.0,0.0,-R);
		Angles : Vecteur(1..3) := (Rho,Theta,Phi);
	begin
		-- a faire
		Position := Matrice_Rotations(Angles) * Position;
		return Position;
	end;

	procedure Projection_Facette(Index_Facette : Positive ; P1, P2, P3 : out Vecteur) is
		C : Vecteur(1..3);
		Angles : Vecteur(1..3) := (Rho,Theta,Phi);
	begin
		C := Position_Camera;
		T := Matrice_Rotations_Inverses(Angles);
		P1 := Projection(M(Index_Facette).P1,C,E,T);
		P2 := Projection(M(Index_Facette).P2,C,E,T);
		P3 := Projection(M(Index_Facette).P3,C,E,T);
		null;
	end;

	procedure Ajout_Maillage(Ma : Maillage) is
	begin
		-- a faire
		M := Ma;
		--Pour debugage -->
		--for i in 1..M'Length loop
		--   Put(M(i).P1(1));
		--   Put(M(i).P1(2));	
		--   Put(M(i).P1(3));
		--   Put_Line("");	   
		--   Put(M(i).P2(1));	
		--   Put(M(i).P2(2));	
		--   Put(M(i).P2(3));
		--   Put_Line("");	   
		--   Put(M(i).P3(1));	
		--   Put(M(i).P3(2));	
		--   Put(M(i).P3(3));
	    --   Put_Line("");	   
	    --end loop;
		null;
	end;

	function Nombre_De_Facettes return Natural is
		N : Natural;
	begin
		N := M'Length;
		-- a faire
		return N;
	end;

	procedure Modification_Coordonnee_Camera(Index : Positive ; Increment : Float) is
	begin
		-- a faire
		if Index = 1 then
			R := R + Increment;
		elsif Index = 2 then
		   	Rho := Rho + Increment;
		elsif Index = 3 then
			Theta := Theta + Increment;
		elsif Index = 4 then
			Phi := Phi + Increment;
		end if;
	end;

begin
	--initialisation de la matrice de rotation au lancement du programme
	Modification_Matrice_Rotation;
end;

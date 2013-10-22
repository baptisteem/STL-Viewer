
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with Ada.Float_Text_IO;
use Ada.Float_Text_IO;


package body Algebre is

	--voir http://en.wikipedia.org/wiki/3D_projection#Perspective_projection
	function "*" (X: Matrice ; Y : Matrice ) return Matrice is 
		M : Matrice (1..3, 1..3) := ((0.0,0.0,0.0),(0.0,0.0,0.0),(0.0,0.0,0.0));
 	begin 
		for i in 1..3 loop
			for j in 1..3 loop 
				for k in 1..3 loop
					M(i,j):=M(i,j)+ X(i,k)*Y(k,j);
				end loop ;
			end loop;
		end loop;
		return M ;
	end;

	function Matrice_Rotations(Angles : Vecteur) return Matrice is
		Rotation : Matrice(1..3, 1..3);
		Rx,Ry,Rz : Matrice(1..3,1..3);
	begin
		Rx :=   ((1.0,0.0,0.0),
				(0.0,cos(Angles(1)),-sin(Angles(1))),
				(0.0,sin(Angles(1)),cos(Angles(1))));
		Ry := ((cos(Angles(2)),0.0,-sin(Angles(2))),
				(0.0,1.0,0.0),
				(sin(Angles(2)),0.0,cos(Angles(2))));
		Rz := ((cos(Angles(3)),-sin(Angles(3)),0.0),
				(sin(Angles(3)),cos(Angles(3)),0.0),
				(0.0,0.0,1.0));
		Rotation := Rx;
		Rotation := Ry * Rotation;
		Rotation := Rz * Rotation;
		return Rotation;
	end;

	function Matrice_Rotations_Inverses(Angles : Vecteur) return Matrice is
		Rx,Ry,Rz : Matrice(1..3, 1..3);
		Rotation : Matrice(1..3, 1..3);
	begin 
		Rx:=((1.0,0.0,0.0),
			(0.0,cos(-Angles(1)),-sin(-Angles(1))),
			(0.0,sin(-Angles(1)),cos(-Angles(1))));
		Ry:=((cos(-Angles(2)),0.0,-sin(-Angles(2))),
			(0.0,1.0,0.0),
			(sin(-Angles(2)),0.0,cos(-Angles(2))));
		Rz:=((cos(-Angles(3)),-sin(-Angles(3)),0.0),
			(sin(-Angles(3)),cos(-Angles(3)),0.0),
			(0.0,0.0,1.0));
		Rotation := Rz;
		Rotation := Ry * Rotation;
		Rotation := Rx * Rotation;
		return Rotation;
	end;

	function "*" (X : Matrice ; Y : Vecteur) return Vecteur is
		Z : Vecteur(X'Range(1)) := (0.0,0.0,0.0);
	begin
		for i in 1..3 loop
			for j in 1..3 loop
				Z(i) := Z(i) + X(i,j)*Y(j);
			end loop ;
		end loop;
		return Z;
	end ;

	function Projection(A, C, E : Vecteur ; T : Matrice) return Vecteur is
		Resultat : Vecteur(1..2);
		D : Vecteur(1..3) := (A(1)-C(1),A(2)-C(2),A(3)-C(3));
		begin
		D := T * D;

		if D(3) > 0.1 then
			Resultat(1) := (E(3)/D(3))*D(1)-E(1);
			Resultat(2) := (E(3)/D(3))*D(2)-E(2);
		end if;

		return Resultat;
	end;
end;

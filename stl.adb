with Ada.Text_IO;
with GNAT.String_Split;
use Ada.Text_IO;

package body STL is

	function Nombre_Facettes(Nom_Fichier : String) return Natural is
		F : File_Type;
		Nb : Natural := 0;
   begin
		Open(File => F, Mode => In_File, Name => Nom_Fichier);
		-- a faire : compter les facettes (p.ex. chercher les "endloop")...
		while not End_Of_File(F) loop
			declare 
				Line : String := Get_Line(F);
			begin
				Nb := Nb + 1;
			end;
		end loop;
		Close(F);
		-- -2 car on supprime les deux lignes d'encadrements
		-- /7 car 7 lignes par bloc de facette
		return (Nb-2)/7;
   end;

	function Chargement_ASCII(Nom_Fichier : String) return Maillage is
		Nb_Facettes : Natural;
		M : Maillage;
		F : File_Type;
		i : Integer := 1;
	begin
		Nb_Facettes := Nombre_Facettes(Nom_Fichier);
		-- une fois qu'on a le nombre de facettes on connait la taille du maillage
		M := new Tableau_Facette(1..Nb_Facettes);
		-- on ouvre de nouveau le fichier pour parcourir les facettes
		-- et remplir le maillage
		Open(File => F, Mode => In_File, Name => Nom_Fichier);
		-- a faire...
	    --while not End_Of_File(F) loop
		--	declare
		--		ligne : String := Get_Line(F);
		--		subs_lignes : GNAT.String_Split.Slice_Set;
		--		separateur : String := " " & ASCII.HT;
		--	begin
				---- On decoupe la chaine grâce au espaces
				--GNAT.String_Split.Create(subs_lignes,ligne,separateur,Mode => GNAT.String_Split.Multiple);
				 --
				----if GNAT.String_Split.Slice(subs_lignes, 2) = "vertex" then
				----	Put_Line("Vertex");
				----end if;
				--for i 1..GNAT.String_Split.Slice_Count(subs_lignes) loop
				 --       declare
				 --       	sub_ligne : String := GNAT.String_Split.Slice(subs_lignes, i);
				 --       begin
				 --       	Put(sub_ligne);
				 --       	Put(" ");
				 --       end;
				--end loop;
				--put_Line("");
			--end;
		--end loop;
		Close (F);
		return M;
	end;

end;

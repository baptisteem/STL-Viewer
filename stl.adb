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
		pos : Etat := None;
		cpt : Integer := 1;
	begin
		Nb_Facettes := Nombre_Facettes(Nom_Fichier);
		-- une fois qu'on a le nombre de facettes on connait la taille du maillage
		M := new Tableau_Facette(1..Nb_Facettes);
		-- on ouvre de nouveau le fichier pour parcourir les facettes
		-- et remplir le maillage
		Open(File => F, Mode => In_File, Name => Nom_Fichier);
	    -- a faire...
	   while not End_Of_File(F) loop
			declare
				ligne : String := Get_Line(F);
				subs_lignes : GNAT.String_Split.Slice_Set;
				separateur : String := " " & ASCII.HT;
				une_facette : Facette;
			begin
				-- On decoupe la chaine grâce au espaces
				GNAT.String_Split.Create(subs_lignes,ligne,separateur,Mode => GNAT.String_Split.Multiple);						
				if GNAT.String_Split.Slice(subs_lignes, 2) = "vertex" then
					if pos = None then
						-- On ajoute les valeurs à chaque points de la facette
						une_facette.P1 := (Float'Value(GNAT.String_Split.Slice(subs_lignes,3)),
										   Float'Value(GNAT.String_Split.Slice(subs_lignes,4)),
										   Float'Value(GNAT.String_Split.Slice(subs_lignes,5)));
						pos := Prem;						
					elsif pos = Prem then
						une_facette.P2 := (Float'Value(GNAT.String_Split.Slice(subs_lignes,3)),
										   Float'Value(GNAT.String_Split.Slice(subs_lignes,4)),
										   Float'Value(GNAT.String_Split.Slice(subs_lignes,5)));
						pos := Deux;                             
					elsif pos = Deux then             						
						une_facette.P3 := (Float'Value(GNAT.String_Split.Slice(subs_lignes,3)),
										   Float'Value(GNAT.String_Split.Slice(subs_lignes,4)),
										   Float'Value(GNAT.String_Split.Slice(subs_lignes,5)));
						pos := None;
						-- On ajoute la facette au maillage 
						M.all(cpt) := une_facette;
						cpt := cpt + 1;
					end if;
				end if;			
			end;
		end loop;
		Close (F);
		return M;
	end;
end;

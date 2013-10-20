with Ada.Text_IO;
with GNAT.String_Split;
with Ada.Strings.Fixed;
with Ada.Sequential_IO;
with Ada.Integer_Text_IO;
with Ada.Float_Text_IO;
with Ada.Directories;
use Ada.Text_IO;
use Ada.Strings.Fixed;
use Ada.Integer_Text_IO;
use Ada.Directories;
use Ada.Float_Text_IO;

package body STL is

	-- Nous partons du principe que tout fichier avec l'extension .stl est
	-- syntaxiquement correct (Binaire ou ASCII)
	function Test_Fichier(Nom_Fichier : String) return Type_Fichier is
		F : File_Type;
	begin
		if Ada.Strings.Fixed.Count(Nom_Fichier, ".stl") /= 1 then
			return Invalide;
		else
			Open(File => F, Mode => In_File, Name => Nom_Fichier);
			declare
				Line : String := Get_Line(F);
			begin
				Close(F);
				-- On regarde si nous avons un fichier ascii
				if Ada.Strings.Fixed.Count(Line, "solid") > 0 then
					return Ascii_File;
				-- Sinon c'est un fichier binaire
				else
					return Binaire_File;
				end if;
			end;
		end if;
	end;	

	function Nombre_Facettes_Binaires(Nom_Fichier : String) return Natural is

		package Integer_IO is new Ada.Sequential_IO(Integer);
		
		F : Integer_IO.File_Type;
		Data : Integer;
		cpt : Natural := 1;
		Nb_Facettes : Natural := 0;
		begin
			Integer_IO.Open(File => F, Mode => Integer_IO.In_File, Name => Nom_Fichier);
			while not Integer_IO.End_Of_File(F) loop
				Integer_IO.Read(F, Data);
				if(cpt=21) then
					Nb_Facettes := Data;
				end if;
				cpt := cpt + 1;
			end loop;
			Integer_IO.Close(F);
		return Nb_Facettes;
	end;

	function Nombre_Facettes_ASCII(Nom_Fichier : String) return Natural is
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

	function Chargement_Binaire(Nom_Fichier : String) return Maillage is
		
		--On définit un type byte(8bits) et double_byte(16bits)
		--type Byte is mod 2 ** 8; for Byte'Size use 8;
		--type Double_Byte is mod 2 ** 16; for Double_Byte'Size use 16;
		
		--On définit un type triangle
		type Triangle is
			record
				Normal : Vecteur(1..3);
				P1 : Vecteur(1..3);
				P2 : Vecteur(1..3);
				P3 : Vecteur(1..3);
				Byte_count : Double_Byte;
			end record;

		--Permet de bloquer la taille de la structure à 50 octets
		for Triangle'Size use 50 * 8; Pragma Pack(Triangle);

		-- Variables utile pour la création du nouveau fichier temporaire
		package Byte_IO is new Ada.Sequential_IO(Byte);
		Byte_File : Byte_IO.File_Type;
		Byte_File_tmp : Byte_IO.File_Type;
		Byte_Data : Byte;
		cpt : Natural := 1;

		--Variables pour l'extraction des données
		package Triangle_IO is new Ada.Sequential_IO(Triangle);
		Triangle_File : Triangle_IO.File_Type;
		Triangle_Data : Triangle;
		i : Natural := 1;
		
		M : Maillage;
		Nb_Facettes : Natural;
	begin

		Nb_Facettes := Nombre_Facettes_Binaires(Nom_Fichier);
		
		M := new Tableau_Facette(1..Nb_Facettes);

		--Reecriture du fichier pour enlever le header dans un fichier temporaire
		Byte_IO.Open(Byte_File, Byte_IO.In_File, Nom_Fichier);
		Byte_IO.Create(Byte_File_tmp, Byte_IO.Out_File, Nom_Fichier & ".tmp");

		while not Byte_IO.End_Of_File(Byte_File) loop
			Byte_IO.read(Byte_File, Byte_Data);
			if cpt > 84 then
				Byte_IO.write(Byte_File_tmp, Byte_Data);
			end if;
			cpt := cpt + 1;
		end loop;
		Byte_IO.Close(Byte_File);
		Byte_IO.Close(Byte_File_tmp);
		
		--On récupère maintenant toutes les facettes dans le fichier temporaire
		Triangle_IO.Open(Triangle_File, Triangle_IO.In_File, Nom_Fichier & ".tmp");
		while not Triangle_IO.End_Of_File(Triangle_File) loop
			declare
				une_facette : Facette;
			begin
				Triangle_IO.read(Triangle_File, Triangle_Data);
				--Put(Triangle_Data.Byte_Count);
				une_facette.P1 := Triangle_Data.P1;
				une_facette.P2 := Triangle_Data.P2;
				une_facette.P3 := Triangle_Data.P3;
				M.all(i) := une_facette;
			end;
			i := i + 1;
		end loop;
		Triangle_IO.Close(Triangle_File);
		-- supprime le fichier temporaire
		Delete_File(Nom_Fichier & ".tmp");
		return M;
	end;

	function Chargement_ASCII(Nom_Fichier : String) return Maillage is
		Nb_Facettes : Natural;
		M : Maillage;
		F : File_Type;
		pos : Etat := None;
		cpt : Integer := 1;
	begin
		Nb_Facettes := Nombre_Facettes_ASCII(Nom_Fichier);
		-- une fois qu'on a le nombre de facettes on connait la taille du maillage
		M := new Tableau_Facette(1..Nb_Facettes);
		-- on ouvre de nouveau le fichier pour parcourir les facettes
		-- et remplir le maillage
		Open(File => F, Mode => In_File, Name => Nom_Fichier);

	   while not End_Of_File(F) loop
			declare
				ligne : String := Get_Line(F);
				subs_lignes : GNAT.String_Split.Slice_Set;
				separateur : String := " " & ASCII.HT & ASCII.LF & ASCII.CR;
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

with Algebre;
use Algebre;

package STL is

	-- nous avons besoin de stocker un ensemble de facettes
	-- il nous faut donc definir les quelques structures suivantes
	type Facette is record
		P1, P2, P3 : Vecteur(1..3);
	end record;

	type Etat is (None, Prem, Deux);	
	-- Donne le type du fichier 
	type Type_Fichier is (Invalide, Ascii_File, Binaire_File);

	type Tableau_Facette is array(positive range<>) of Facette;

	type Maillage is access Tableau_Facette;

	-- savoir si le fichier est valide puis si celui ci est au format ASCII ou binaire
	-- 0 : Fichier non conforme
	-- 1 : Fichier ASCII
	-- 2 : Fichier binaire
	function Test_Fichier(Nom_Fichier : String) return Type_Fichier;

	-- charge un fichier STL au format ASCII
	function Chargement_ASCII(Nom_Fichier : String) return Maillage;
	
	-- charge un fichier STL au format binaire
	function Chargement_Binaire(Nom_Fichier : String) return Maillage;
end;

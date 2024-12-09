drop table if exists InventarioPrese;
drop table if exists Route;
drop table if exists Peso;
drop table if exists OccupazionePalestra;
drop table if exists Effettuazione;
drop table if exists Prenotazione;
drop table if exists Receptionist;
drop table if exists Gestione;
drop table if exists RouteSetter;
drop table if exists RouteDiGara;
drop table if exists Competizione cascade;
drop table if exists Agonista;
drop table if exists Ingressi;
drop table if exists Abbonamento;
drop table if exists DettagliPacchetto;
drop table if exists Iscritto;
drop table if exists Corso;
drop table if exists Trainer;
drop table if exists Area;
drop table if exists Utente;

CREATE TABLE Utente (
	CF varchar(16) NOT NULL,
	Nome varchar(30) NOT NULL,
	Cognome varchar(30) NOT NULL,
	Telefono int,
	DataDiNascita date NOT NULL,
	LuogoDiNascita varchar(30) NOT NULL,
	Paese varchar(30) NOT NULL,
	Provincia varchar(2) NOT NULL,
	Città varchar(30) NOT NULL,
	CAP varchar(5) NOT NULL,
	Indirizzo varchar(50) NOT NULL,
	primary key (CF));
	
CREATE TABLE Area(
	Nome varchar(30) NOT NULL,
	Capienza int NOT NULL,
	primary key (Nome)
);

CREATE TABLE Trainer (
	Utente varchar(16) NOT NULL,
	Stipendio float NOT NULL,
	primary key (Utente),
	foreign key(Utente) references Utente(CF)
);

CREATE TABLE Corso(
	CodCorso varchar(10) NOT NULL,
	Giorno varchar(30) NOT NULL,
	Orario varchar(30) NOT NULL,
	Area varchar(30) NOT NULL,
	Trainer varchar(16) NOT NULL,
	Difficoltà varchar(30) NOT NULL,
	Età varchar(30) NOT NULL,
	primary key (CodCorso),
	foreign key (Area) references Area(Nome),
	foreign key (Trainer) references Trainer(Utente)

);

CREATE TABLE Iscritto (
	CodTessera varchar(10) NOT NULL,
	CF varchar (16) NOT NULL,
	CodCorso varchar (10),
	NumNoleggioScarpette int NOT NULL,
	ScadenzaCertMedico date,
	primary key (CodTessera),
	foreign key (CF) references Utente(CF),
	foreign key (CodCorso) references Corso(CodCorso)
);

CREATE TABLE DettagliPacchetto (
	Nome varchar(30) NOT NULL,
	Costo int NOT NULL,
	Durata varchar (100) NOT NULL,
	primary key (Nome)
);

CREATE TABLE Abbonamento (
	CodTessera varchar (10) NOT NULL,
	Nome varchar (30) NOT NULL,
	Tipo varchar (30),
	Data date,
	primary key (CodTessera),
	foreign key (CodTessera) references Iscritto(CodTessera),
	foreign key (Nome) references DettagliPacchetto(Nome)
);

CREATE TABLE Ingressi (
	CodTessera varchar (10) NOT NULL,
	Nome varchar (30) NOT NULL,
	NumIngressi int NOT NULL,
	primary key (CodTessera),
	foreign key (CodTessera) references Iscritto (CodTessera),
	foreign key (Nome) references DettagliPacchetto (Nome)
);

CREATE TABLE Agonista (
	CodTessera varchar(10) NOT NULL,
	Categoria varchar (30) NOT NULL,
	Scheda varchar (50),
	ApeIndex float NOT NULL,
	Altezza int NOT NULL,
	primary key (CodTessera),
	foreign key (CodTessera) references Iscritto (CodTessera)
);

CREATE TABLE Competizione (
	Luogo varchar (30) NOT NULL,
	Data date NOT NULL,
	Agonista varchar(20) NOT NULL,
	NomeCampionato varchar (30),
	Classifica int NOT NULL,
	NumZone int NOT NULL,
	NumTop int NOT NULL,
	primary key (Luogo, Data, Agonista),
	foreign key (Agonista) references Iscritto(CodTessera)
);

CREATE TABLE RouteDiGara (
	NumeroRoute int NOT NULL,
	Luogo varchar (30) NOT NULL,
	Data date NOT NULL,
	Agonista varchar(10) NOT NULL,
	InclinazioneMuro int NOT NULL,
	TipoPresa varchar(30) NOT NULL,
	Dinamicità varchar(30) NOT NULL,
	Completamento float NOT NULL,
	primary key (Luogo, Data, Agonista,NumeroRoute),
	foreign key (Luogo,Data,Agonista) references Competizione(Luogo,Data,Agonista)
);

CREATE TABLE RouteSetter (
	Soprannome varchar(30) NOT NULL,
	CF varchar(16) NOT NULL,
	Stipendio float NOT NULL,
	primary key (Soprannome),
	foreign key (CF) references Utente(CF)
);

CREATE TABLE Gestione (
	Routesetter varchar(30) NOT NULL,
	Area varchar(30) NOT NULL,
	primary key (Routesetter, Area),
	foreign key (Routesetter) references Routesetter(Soprannome),
	foreign key (Area) references Area(Nome)
);

CREATE TABLE Receptionist(
	Utente varchar(16) NOT NULL,
	Stipendio float NOT NULL,
	Turni varchar(50) NOT NULL,
	primary key (Utente),
	foreign key(Utente) references Utente(CF)

);

CREATE TABLE Prenotazione(
	Orario time NOT NULL,
	Data date NOT NULL,
	Durata time NOT NULL,
	primary key (Orario, Data)
);

CREATE TABLE Effettuazione(
	Data date NOT NULL,
	Orario time NOT NULL, 
	Iscritto varchar(10) NOT NULL,
	primary key (Data, Orario, Iscritto),
	foreign key (Orario,Data) references Prenotazione(Orario,Data),
	foreign key (Iscritto) references Iscritto(CodTessera)
);
CREATE TABLE OccupazionePalestra(
	Iscritto varchar(30) NOT NULL,
	OraPrenotazione time NOT NULL,
	DataPrenotazione date NOT NULL,
	OrarioEntrata time NOT NULL,
	primary key (Iscritto),
	foreign key (Iscritto) references Iscritto(CodTessera),
	foreign key (OraPrenotazione,DataPrenotazione) references Prenotazione(Orario,Data));


CREATE TABLE Peso(
	IDPeso varchar(5) NOT NULL,
	Area varchar(30) NOT NULL,
	Marca varchar(30) NOT NULL,
	Pesokg float NOT NULL,
	primary key (IDPeso),
	foreign key (Area) references Area(Nome)
);

CREATE TABLE Route(
	IDPercorso varchar(10) NOT NULL, 
	Routesetter varchar(30) NOT NULL,
	Area varchar(30) NOT NULL,
	Colore varchar(30) NOT NULL,
	Difficoltà varchar(1) NOT NULL,
	DataTracciatura date NOT NULL,
	primary key (IDPercorso),
	foreign key (Area) references Area(Nome),
	foreign key (Routesetter) references Routesetter(Soprannome)
);

CREATE TABLE InventarioPrese(
	IDPresa varchar(10) NOT NULL,
	Route varchar(10),
	Colore varchar(30) NOT NULL,
	Marca varchar(30) NOT NULL,
	Materiale varchar(30) NOT NULL,
	InUso bool NOT NULL,
	Rotta bool,
	DaLavare bool,
	primary key (IDPresa),
	foreign key (Route) references Route(IDPercorso)
);







Insert into Utente (Cognome, Nome, LuogoDiNascita, DataDinascita, CF, Città, Provincia, CAP, Indirizzo, Telefono, Paese) values ('Cilea','Remo','Bidonì','1976-05-31','CLIRME76E31A856S','Sant Angelo del Pesco','IS','86080','Via S.Auteri, 164',0865409366,'Italia'),
('Melpi','Petronio','Sant Ambrogio in Valpolicella','1998-08-04','MLPPRN98M04I259H','Comun Nuovo','BG','24040','Via L.Boccherini, 221',035343254,'Italia'),
('Ascani','Iris','Alberobello','1969-06-1','SCNRSI69H58A149F','Bascapè','PV','27010','Via P.Giaccone, 151',0382234185,'Italia'),
('Vincenti','Gerardo','Roio del Sangro','2008-09-07','VNCGRD08P07H495I','Pecetto Torinese','TO','10020','Via L.Vasi, 84',011670260,'Italia'),
('Fornarino','Senofonte','Dizzasco','2005-12-20','FRNSFN05T20D310Z','Fiuminata','MC','62020','Via Don, 266',0733281130,'Italia'),
('Cursietti','Camilla','Cerva','1977-08-09','CRSCLL77M49C542M','Tramonti','SA','84010','Via L.Manfredi, 141',089685527,'Germania'),
('Mondolfo','Romolo','Montecassiano','2009-07-03','MNDRML09L03F454D','Quittengo','VC','13060','Strada Ortensie, 42',0161673057,'Italia'),
('Pietrantonio','Gregorio','Montenero di Bisaccia','1966-04-05','PTRGGR66D05F576T','Amaseno','FR','03021','Via M.Viscontini, 289/d',0775638924,'Italia'),
('Tasco','Gustavo','Bagnacavallo','1963-05-02','TSCGTV63E02A547O','Guspini','CA','09036','Via M.Stabile, 184',070320287,'Italia'),
('Belvedere','Polidoro','Saviano','1961-11-22','BLVPDR61S22I469J','Avella','AV','83021','Via A.Rubino, 82',0825796070,'Italia'),
('Peruzzi','Simonetta','Marano Vicentino','1975-09-19','PRZSNT75P59E912A','Castroregio','CS','87070','Via L.Stazione, 147',0984923484,'Italia'),
('Pozzoli','Apollinare','Brissago-Valtravaglia','1977-10-08','PZZPLN77R08B191O','Dolcedo','IM','18024','Cavalcavia S.Francesco d Assisi, 103',0183852407,'Italia'),
('Menicucci','Anita','Mirabello Monferrato','1991-04-07','MNCNTA91D47F232B','Tiana','NU','08020','Via C.Goldoni, 57/j',0784523151,'Italia'),
('Buscaglia','Alceste','Capriati a Volturno','1982-09-01','BSCLST82P01B704M','Castel del Piano','GR','58033','Via L.Mancuso, 8',0564897923,'Italia'),
('Guzzon','Ottaviano','Santhià','2014-03-19','GZZTVN14C19I337P','Valgrisenche','AO','11010','Via L.Cicognara, 85',0165321157,'Italia'),
('Lissandrin','Marina','Pimentel','2009-12-12','LSSMRN09T52G669T','Scandicci','FI','50018','Via M.Cremosano, 189',055398404,'Italia'),
('Cifone','Anna','Lunamatrona','1997-03-28','CFNNNA97C68E742V','Acerno','SA','84042','Via Pantelleria, 261',089703965,'Italia'),
('Properzio','Serafina','Cersosimo','1971-05-27','PRPSFN71E67C539A','Velezzo Lomellina','PV','27020','Via E.Montale, 172',0382490904,'Francia'),
('Aglieri','Priscilla','Tromello','1982-01-21','GLRPSC82A61L449G','Proserpio','CO','22030','Via S.Spinuzza, 145',031267894,'Italia'),
('Ruzzanti','Guglielmo','Chiopris-Viscone','1980-03-14','RZZGLL80C14C641C','Ghedi','BS','25016','Località V.Salmeri, 144',030428703,'Italia'),
('Taini','Ambra','Desio','1988-10-13','TNAMBR88R53D286F','Revello','CN','12036','Via G.Boeri, 159',017491504,'Italia'),
('Vignato','Geronimo','Bojano','1980-12-01','VGNGNM80T01A930C','Cerreto Langhe','CN','12050','Via D.Marchese, 157/h',0173529819,'Italia'),
('Maggiani','Amone','Montemonaco','1979-12-29','MGGMNA79T29F570E','Vivaro Romano','RM','00020','Via Tuberose, 244',06702389,'Italia'),
('Bernazzani','Aimone','Dasà','2000-01-15','BRNMNA00A15D253B','Arcugnano','VI','36057','Via P.Paoli, 76',0444247609,'Italia'),
('Passera','Angelo','Sordevolo','1978-04-03','PSSNGL78D03I847D','Viganella','NO','28030','Via Melegnano, 44',0321450591,'Italia'),
('Motta','Monica','Isola delle Femmine','1994-02-04','MTTMNC94B44E350K','Cannero Riviera','NO','28051','Via Loredan, 231',0321998668,'Inghilterra'),
('Tufanisco','Ivan','Torre Bormida','2013-09-23','TFNVNI13P23L252Z','Apricale','IM','18030','Via E.Ibsen, 152',0183280939,'Italia'),
('Quintarelli','Zaira','Viagrande','1988-04-16','QNTZRA88D56L828P','Capolona','AR','52010','Via D.Madonna, 251',0575372261,'Italia'),
('Gaggeri','Valerio','Paduli','1974-02-03','GGGVLR74B03G227G','Erto e Casso','PN','33080','Via Cardinal Ferrari, 120',0434103415,'Italia'),
('Legnano','Costantino','Magliano dè Marsi','2012-11-21','LGNCTN12S21E811V','Pianico','BG','24060','Via C.Cafiero, 125',035107393,'Germania'),
('Legato','Libero','Alagna Valsesia','2007-03-20','LGTLBR07C20A119M','Triuggio','MI','20050','Via Antonio da Recanate, 223',02870053,'Italia'),
('Mangia','Callisto','Fallo','1969-01-11','MNGCLS69A11D480N','Spigno Saturnia','LT','04020','Via V.Amarilli, 163',0773919277,'Italia'),
('Tremonti','Andrea','Spirano','1994-03-14','TRMNDR94C14I919V','Carpi','MO','41012','Via F.Lionti, 20',059575471,'Italia'),
('Varischi','Isidoro','Acquasparta','1978-01-06','VRSSDR78A06A045K','Carzano','TN','38050','Alzaia A.Rizzo, 155',0461258204,'Italia'),
('Rosolino','Gherardo','Fermo','1990-03-24','RSLGRR90C24D542T','Milazzo','ME','98057','Via Pier Lombardo, 37',090293887,'Italia'),
('Lazzaro','Guido','Casaletto Spartano','1994-04-07','LZZGDU94D07B888Z','Pontirolo Nuovo','BG','24040','Via U.Foscolo, 20',035780033,'Francia'),
('Caligiuri','Goffredo','Enna','1960-03-28','CLGGFR60C28C342W','Muccia','MC','62034','Viale P.Sarpi, 203/i',0733994144,'Italia'),
('Calvello','Ippolito','Casaletto di Sopra','2012-01-16','CLVPLT12A16B890J','Ultimo','BZ','39016','Via F.Nascè, 63/f',0471704062,'Italia'),
('Biancacci','Franca','Marino','2003-05-05','BNCFNC03E45E958U','Peio','TN','38020','Via Canzi, 128',0461995273,'Italia');

Insert into Area(Nome, Capienza) values
('Sala pesi principale', 60),
('Sala pesi ausiliaria', 20),
('Zona arrampicata expert', 40),
('Zona arrampicata intermediate',40),
('Zona arrampicata beginners', 40),
('Zona baby',10),
('Sala yoga',20);

Insert into Trainer (Utente, Stipendio) values
('PRZSNT75P59E912A', 1776),
('GGGVLR74B03G227G', 1741),
('VRSSDR78A06A045K', 1734),
('LZZGDU94D07B888Z', 1728),
('PTRGGR66D05F576T', 1786),
('MNCNTA91D47F232B', 1777),
('BSCLST82P01B704M', 1728),
('GLRPSC82A61L449G', 1757),
('VGNGNM80T01A930C', 1656),
('PSSNGL78D03I847D', 1749);

Insert into Corso (CodCorso,Giorno, Orario, Area, Trainer, Difficoltà, Età) values
('YOG01','Mar-Gio','17:30-19:30','Sala yoga', 'PRZSNT75P59E912A','Base','Tutte'),
('EXP01','Lun-Mer-Ven','18:30-20:30','Zona arrampicata expert','GGGVLR74B03G227G','Difficile','14-18 anni'),
('INT01','Lun-Mer-Ven','16:30-18:30','Zona arrampicata intermediate', 'VRSSDR78A06A045K','Intermedio','8-14 anni'),
('INT02','Mar-Ven','19-21','Zona arrampicata intermediate', 'LZZGDU94D07B888Z','Intermedio','18+ anni'),
('PES01','Lun-Gio','19-21','Sala pesi principale', 'PTRGGR66D05F576T','Base','16+ anni'),
('BEG01','Mer-Ven','16:30-18:30','Zona arrampicata beginners', 'MNCNTA91D47F232B','Base','8-14 anni'),
('BEG02','Lun-Ven','19:30-21:30','Zona arrampicata beginners', 'BSCLST82P01B704M','Base','14+ anni');

Insert into Iscritto(CodTessera,ScadenzaCertMedico,CodCorso,NumNoleggioScarpette,CF) values
(12469,'2021-08-16','INT01',' 4','CLVPLT12A16B890J'),
(14712,'2021-09-13','PES01',' 3','RSLGRR90C24D542T'),
(16955,'2021-01-05','YOG01','1','LGTLBR07C20A119M'),
(19198,'2021-10-17',NULL,' 3','QNTZRA88D56L828P'),
(21441,'2021-06-20','EXP01','1','TFNVNI13P23L252Z'),
(23684,'2021-06-14','PES01',' 5','PSSNGL78D03I847D'),
(25927,'2021-05-18','INT01',' 5','MGGMNA79T29F570E'),
(28170,'2021-06-14',NULL,' 3','VGNGNM80T01A930C'),
(30413,'2021-09-25','INT01',' 3','VRSSDR78A06A045K'),
(32656,'2021-01-20',NULL,'1','TNAMBR88R53D286F'),
(34899,'2021-12-20','INT01',' 5','LZZGDU94D07B888Z'),
(37142,'2021-02-03','PES01',' 5','RZZGLL80C14C641C'),
(39385,'2021-10-02',NULL,' 4','PRPSFN71E67C539A'),
(41628,'2021-03-25','EXP01',' 4','CFNNNA97C68E742V'),
(43871,'2021-08-28','BEG02',' 3','GZZTVN14C19I337P'),
(46114,'2021-11-01',NULL,' 5','PZZPLN77R08B191O'),
(48357,'2021-07-10','BEG02',' 3','BLVPDR61S22I469J'),
(50600,'2021-06-17','YOG01',' 5','TSCGTV63E02A547O'),
(52843,'2021-02-23',NULL,' 2','FRNSFN05T20D310Z');

Insert into DettagliPacchetto(Nome,Costo,Durata) values
('mensile', 45, '30 giorni'),
('trimestrale',120,'90 giorni'),
('annuale',300,'fino al termine dell’anno'),
('10 ingressi',90,'utilizzabili fino al termine dell’anno');

Insert into Abbonamento (CodTessera, Nome, Data) values
(12469,'mensile','2021-08-23'),
(14712,'annuale',NULL),
(16955,'trimestrale','2021-08-16'),
(19198,'trimestrale','2021-06-10'),
(21441,'mensile','2021-08-03'),
(23684,'mensile','2021-08-27');

Insert into Ingressi (CodTessera, Nome, NumIngressi) values
(43871,'10 ingressi',3),
(46114,'10 ingressi',4),
(48357,'10 ingressi',1),
(50600,'10 ingressi',8),
(52843,'10 ingressi',6);

Insert into Agonista (CodTessera, Categoria, Scheda, ApeIndex, Altezza) values
('21441','U18','Standard',3,175),
('34899','U14','Leggera',-1,153),
('41628','U16','Intensa',0,164),
('12469','U20','Standard',4,178),
('48357','Senior','Nessuna',2,172);

Insert into Competizione(Data,Agonista,NomeCampionato,Luogo, Classifica,Numzone,Numtop) values
('2022-05-02','21441','Coppa Italia','Via E.Peressutti, 189/g',5,2,1),
('2021-07-21','34899','Campionato regionale','Via P.Giannone, 197',64,4, 3),
('2021-08-17','41628','IFSC World Cup','Via S.Francesca Romana, 273',40,4,0),
('2018-03-15','12469','Campionato regionale','Via D.Barone, 189',2,4, 3),
('2020-09-25','48357','Coppa Italia','Via G.Bennici, 212/g',37,5,1);

Insert into RouteDiGara (NumeroRoute,Data, Agonista,Luogo, InclinazioneMuro, TipoPresa, Dinamicità, Completamento) values
(1,'2022-05-02','21441','Via E.Peressutti, 189/g',45,'Svasi','Dinamico',0),
(2,'2022-05-02','21441','Via E.Peressutti, 189/g',20,'Tacche','Misto',0.5),
(3,'2022-05-02','21441','Via E.Peressutti, 189/g',-3,'Misto','Statico',0),
(4,'2022-05-02','21441','Via E.Peressutti, 189/g',0,'Misto','Dinamico',1),
(5,'2022-05-02','21441','Via E.Peressutti, 189/g',30,'Svasi','Misto',0),
(1,'2021-07-21','34899','Via P.Giannone, 197',30, 'tacche', 'Statico',1),
(2,'2021-07-21','34899','Via P.Giannone, 197',20, 'Misto', 'Statico',0),
(3,'2021-07-21','34899','Via P.Giannone, 197',0, 'Svasi', 'Statico',0.5),
(4,'2021-07-21','34899','Via P.Giannone, 197',50, 'Misto', 'Dinamico',1),
(5,'2021-07-21','34899','Via P.Giannone, 197',35, 'tacche', 'Misto',1),
(1,'2021-08-17','41628','Via S.Francesca Romana, 273', -3,'Svasi', 'Statico',0.5),
(2,'2021-08-17','41628','Via S.Francesca Romana, 273', 10,'Tacche', 'Dinamico',0.5),
(3,'2021-08-17','41628','Via S.Francesca Romana, 273', -5,'Misto', 'Misto',0),
(4,'2021-08-17','41628','Via S.Francesca Romana, 273', 50,'Misto', 'Statico',0.5),
(5,'2021-08-17','41628','Via S.Francesca Romana, 273', 40,'Buchi', 'Dinamico',0.5),
(1,'2018-03-15','12469','Via D.Barone, 189',50,'Buchi', 'Statico',0.5),
(2,'2018-03-15','12469','Via D.Barone, 189',30, 'Tacche', 'Misto',1),
(3,'2018-03-15','12469','Via D.Barone, 189',0, 'Svasi', 'Dinamico',1),
(4,'2018-03-15','12469','Via D.Barone, 189',-5, 'Misto', 'Dinamico',1),
(5,'2018-03-15','12469','Via D.Barone, 189',10, 'Svasi', 'Statico',0),
(1,'2020-09-25','48357','Via G.Bennici, 212/g',10,'Svasi','Dinamico',0.5),
(2,'2020-09-25','48357','Via G.Bennici, 212/g',20,'Buchi','Statico',1),
(3,'2020-09-25','48357','Via G.Bennici, 212/g',-3,'Svasi','Misto',0.5),
(4,'2020-09-25','48357','Via G.Bennici, 212/g',40,'Misto','Dinamico',0.5),
(5,'2020-09-25','48357','Via G.Bennici, 212/g',0,'Tacche','Misto',0.5);

Insert into Routesetter (Soprannome, Stipendio, CF) values
('Tony',1490,'CRSCLL77M49C542M'),
('Jonny',1030,'PTRGGR66D05F576T'),
('Ken',1380,'PRPSFN71E67C539A'),
('Penny',1050,'GLRPSC82A61L449G');

Insert into Gestione (Routesetter, Area) values
('Jonny', 'Zona arrampicata expert'),
('Tony', 'Zona arrampicata intermediate'),
('Ken', 'Zona arrampicata beginners'),
('Penny', 'Zona baby');

Insert into Receptionist(Utente, Stipendio, Turni) values
('QNTZRA88D56L828P', 1662,'Lun1-Mar1'),
('TRMNDR94C14I919V', 1672,'Mer1-Gio1'),
('VRSSDR78A06A045K', 1660,'Ven1-Sab1'),
('RSLGRR90C24D542T', 1681,'Dom1-Dom2'),
('BNCFNC03E45E958U', 1696,'Lun2-Mar2'),
('CRSCLL77M49C542M', 1679,'Mer2-Gio2'),
('TSCGTV63E02A547O', 1682,'Ven2-Sab2');

Insert into Peso (IDPeso, Area, Marca, Pesokg) values 
(6304, 'Sala pesi ausiliaria', 'Technogym', 2.5),
(6968, 'Sala pesi ausiliaria', 'RDX', 2.5),
(6614, 'Sala pesi principale', 'Rogue', 15),
(6610, 'Sala pesi ausiliaria', 'Technogym', 20),
(6297, 'Sala pesi ausiliaria', 'PowerGear', 5),
(6910, 'Sala pesi ausiliaria', 'PowerGear', 20),
(6782, 'Sala pesi ausiliaria', 'Technogym', 10),
(6353, 'Sala pesi principale', 'PowerGear', 1.25),
(6176, 'Sala pesi principale', 'StrengthShop', 10),
(6787, 'Sala pesi principale', 'Technogym', 25);

Insert into Prenotazione (Orario, Data, Durata)  values
('12:30:00','2022-03-22','2:00:00'),
('13:00:00','2022-03-22','2:00:00'),
('13:30:00','2022-03-22','2:00:00'),
('14:00:00','2022-03-22','2:00:00'),
('14:30:00','2022-03-22','2:00:00'),
('15:00:00','2022-03-22','2:00:00'),
('15:30:00','2022-03-22','2:00:00'),
('16:00:00','2022-03-22','2:00:00'),
('16:30:00','2022-03-22','2:00:00'),
('17:00:00','2022-03-22','2:00:00'),
('17:30:00','2022-03-22','2:00:00'),
('18:00:00','2022-03-22','2:00:00'),
('18:30:00','2022-03-22','2:00:00'),
('19:00:00','2022-03-22','2:00:00'),
('19:30:00','2022-03-22','2:00:00'),
('20:00:00','2022-03-22','2:00:00'),
('20:30:00','2022-03-22','2:00:00'),
('21:00:00','2022-03-22','1:30:00'),
('21:30:00','2022-03-22','1:00:00'),
('12:30:00','2022-03-23','2:00:00'),
('13:00:00','2022-03-23','2:00:00'),
('13:30:00','2022-03-23','2:00:00'),
('14:00:00','2022-03-23','2:00:00'),
('14:30:00','2022-03-23','2:00:00'),
('15:00:00','2022-03-23','2:00:00'),
('15:30:00','2022-03-23','2:00:00'),
('16:00:00','2022-03-23','2:00:00'),
('16:30:00','2022-03-23','2:00:00'),
('17:00:00','2022-03-23','2:00:00'),
('17:30:00','2022-03-23','2:00:00'),
('18:00:00','2022-03-23','2:00:00'),
('18:30:00','2022-03-23','2:00:00'),
('19:00:00','2022-03-23','2:00:00'),
('19:30:00','2022-03-23','2:00:00'),
('20:00:00','2022-03-23','2:00:00'),
('20:30:00','2022-03-23','2:00:00'),
('21:00:00','2022-03-23','1:30:00'),
('21:30:00','2022-03-23','1:00:00');

Insert into Effettuazione(Orario, Data, Iscritto) values
('16:30:00','2022-03-22','16955'),
('17:00:00','2022-03-22','19198'),
('17:30:00','2022-03-22','21441'),
('18:00:00','2022-03-22','23684'),
('18:30:00','2022-03-22','37142'),
('19:00:00','2022-03-22','25927'),
('19:00:00','2022-03-22','30413'),
('19:00:00','2022-03-22','32656'),
('19:30:00','2022-03-22','34899'),
('19:30:00','2022-03-22','41628'),
('20:00:00','2022-03-22','46114'),
('14:00:00','2022-03-23','48357'),
('14:00:00','2022-03-23','16955'),
('18:00:00','2022-03-23','19198'),
('18:30:00','2022-03-23','23684'),
('19:00:00','2022-03-23','25927'),
('19:30:00','2022-03-23','30413'),
('20:00:00','2022-03-23','34899');

Insert into OccupazionePalestra(OraPrenotazione, DataPrenotazione, Iscritto, OrarioEntrata) values
('18:00:00','2022-03-22','23684','18:07:00'),
('18:30:00','2022-03-22','37142','18:23:00'),
('19:00:00','2022-03-22','25927','19:14:00'),
('19:00:00','2022-03-22','30413','19:02:00'),
('19:00:00','2022-03-22','32656','18:59:00'),
('19:30:00','2022-03-22','34899','19:35:00'),
('19:30:00','2022-03-22','41628','19:41:00');

Insert into Route (IDPercorso, Routesetter, Area, DataTracciatura, Colore, Difficoltà) values
(2301,'Ken','Zona arrampicata intermediate','2021-06-21','Rosa','E'),
(2733,'Tony','Zona arrampicata expert','2021-07-21','Nero','B'),
(3165,'Tony','Zona arrampicata expert','2021-06-11','Nero','D'),
(3597,'Jonny','Zona arrampicata intermediate','2021-07-01','Giallo','D'),
(4029,'Ken','Zona arrampicata beginners','2021-06-04','Blu','C'),
(4461,'Penny','Zona arrampicata beginners','2021-06-21','Verde','A');

Insert into InventarioPrese(IDPresa, Marca, Materiale, InUso, Rotta, DaLavare, Route, Colore) values
(5439,'Smog','Plastica',true,null,null,2301,'Rosa'),
(5576,'soill','Plastica',false,false,true,null,'Giallo'),
(5713,'Cheeta','Fibra di vetro',true,null,null,2733,'Nero'),
(5850,'soill','Fibra di vetro',true,null,null,3165,'Nero'),
(5987,'soill','Fibra di vetro',true,null,null,3165,'Nero'),
(6124,'soill','Fibra di vetro',true,null,null,3165,'Nero'),
(6261,'Smog','legno',true,null,null,2301,'Rosa'),
(6398,'Smog','legno',true,null,null,2301,'Rosa'),
(6535,'Smog','Plastica',true,null,null,3597,'Giallo'),
(6672,'Smog','Plastica',true,null,null,3597,'Giallo'),
(6809,'soill','Fibra di vetro',false,false,false,null,'Blu'),
(6946,'Smog','Plastica',true,null,null,3597,'Giallo'),
(7083,'Cheeta','Fibra di vetro',true,null,null,2733,'Nero'),
(7220,'Euroholds','legno',true,null,null,4029,'Blu'),
(7357,'Euroholds','legno',true,null,null,4029,'Blu'),
(7494,'Euroholds','legno',true,null,null,4029,'Blu'),
(7631,'soill','Fibra di vetro',false,true,true,null,'Rosa'),
(7768,'Cheeta','Fibra di vetro',true,null,null,4461,'Verde'),
(7905,'soill','Plastica',true,null,null,4461,'Verde'),
(8042,'soill','Plastica',true,null,null,4461,'Verde');


create index idx_Route on Route(IDPercorso);

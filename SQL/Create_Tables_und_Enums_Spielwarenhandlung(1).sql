CREATE TABLE ALTERSBERSCHRAENKUNGE(
    ALTERSBESCHRAENKUNGID INT NOT NULL,
    ALTERSBESCHRAENKUNG INT NOT NULL,
    PRIMARY KEY(ALTERSBESCHRAENKUNGID)
);

INSERT INTO altersberschraenkunge (altersbeschraenkungid,altersbeschraenkung)
Values (1,0);

INSERT INTO altersberschraenkunge (altersbeschraenkungid,altersbeschraenkung)
Values (2,3);

INSERT INTO altersberschraenkunge (altersbeschraenkungid,altersbeschraenkung)
Values (3,6);

INSERT INTO altersberschraenkunge (altersbeschraenkungid,altersbeschraenkung)
Values (4,12);

INSERT INTO altersberschraenkunge (altersbeschraenkungid,altersbeschraenkung)
Values (5,16);

INSERT INTO altersberschraenkunge (altersbeschraenkungid,altersbeschraenkung)
Values (6,18);


Create table TAETIGKEITSBEREICHE(
    TAETIGKEITSBEREICHID INT NOT NULL,
    TAETIGKEITSBEREICH VARCHAR2(30) UNIQUE,
    PRIMARY KEY (TAETIGKEITSBEREICHID)
);

INSERT INTO taetigkeitsbereiche(taetigkeitsbereichid,taetigkeitsbereich)
Values (1,'Kasse');

INSERT INTO taetigkeitsbereiche(taetigkeitsbereichid,taetigkeitsbereich)
Values (2,'Lager');

INSERT INTO taetigkeitsbereiche(taetigkeitsbereichid,taetigkeitsbereich)
Values (3,'Onlineshop');

INSERT INTO taetigkeitsbereiche(taetigkeitsbereichid,taetigkeitsbereich)
Values (4,'Beratung');


create table BEZAHLSTATUSE(
    BEZAHLSTATUSID INT NOT NULL,
    BEZAHLSTATUS VARCHAR2(30) UNIQUE,
    PRIMARY KEY (BEZAHLSTATUSID)
);

INSERT INTO BEZAHLSTATUSE (bezahlstatusid,bezahlstatus)
VALUES (1,'Bezahlt');

INSERT INTO BEZAHLSTATUSE (bezahlstatusid,bezahlstatus)
VALUES (2,'Teilweise bezahlt');

INSERT INTO BEZAHLSTATUSE (bezahlstatusid,bezahlstatus)
VALUES (3,'Nicht bezahlt');


create table WERBETYPE (
    WERBETYPID INT NOT NULL,
    WERBETYP VARCHAR2(30) UNIQUE,
    PRIMARY KEY (WERBETYPID)
);

INSERT INTO werbetype(werbetypid,werbetyp)
VALUES (1,'Fernsehwerbung');

INSERT INTO werbetype(werbetypid,werbetyp)
VALUES (2,'Fyler');

INSERT INTO werbetype(werbetypid,werbetyp)
VALUES (3,'Schaufenster');

INSERT INTO werbetype(werbetypid,werbetyp)
VALUES (4,'Radio');


create table WOCHENTAGEE(
    WOCHENTAGEID INT NOT NULL,
    WOCHENTAG VARCHAR2(30) UNIQUE,
    PRIMARY KEY (WOCHENTAGEID)
);

INSERT INTO wochentagee(wochentageid,wochentag)
VALUES (1,'Montag');

INSERT INTO wochentagee(wochentageid,wochentag)
VALUES (2,'Dienstag');

INSERT INTO wochentagee(wochentageid,wochentag)
VALUES (3,'Mittwoch');

INSERT INTO wochentagee(wochentageid,wochentag)
VALUES (4,'Donnerstag');

INSERT INTO wochentagee(wochentageid,wochentag)
VALUES (5,'Freitag');

INSERT INTO wochentagee(wochentageid,wochentag)
VALUES (6,'Samstag');

INSERT INTO wochentagee(wochentageid,wochentag)
VALUES (7,'Sonntag');


Create table ANREDEE(
    ANREDEID INT NOT NULL,
    ANREDE VARCHAR2(30) UNIQUE,
    PRIMARY KEY (ANREDEID)
);

INSERT INTO anredee (anredeid,anrede)
VALUES (1,'Herr');

INSERT INTO anredee (anredeid,anrede)
VALUES (2,'Frau');

INSERT INTO anredee (anredeid,anrede)
VALUES (3,'Keine Angabe');


create table STATUSE(
    STATUSID INT NOT NULL,
    STATUS VARCHAR2(30) UNIQUE,
    PRIMARY KEY (STATUSID)
);

INSERT INTO STATUSE (statusid,status)
Values (1,'Auftrag erhalten');

INSERT INTO STATUSE (statusid,status)
Values (2,'Verschickt');

INSERT INTO STATUSE (statusid,status)
Values (3,'Angekommen');


CREATE TABLE LAGERORTE (
    LAGERORTID INT NOT NULL,
    LAGERORT VARCHAR2(30) UNIQUE,
    PRIMARY KEY (LAGERORTID)
);

INSERT INTO LAGERORTE(lagerortid,lagerort)
VALUES (1,'Laden');

INSERT INTO LAGERORTE(lagerortid,lagerort)
VALUES (2,'Lager');


Create table BESTELLUNGSORTE(
    BESTELLUNGSORTID INT NOT NULL,
    BESTELLUNGSORT VARCHAR2(30) UNIQUE,
    PRIMARY KEY(BESTELLUNGSORTID)
);

INSERT INTO bestellungsorte (bestellungsortid,BESTELLUNGSORT)
VALUES (1,'Onlineshop');

INSERT INTO bestellungsorte (bestellungsortid,BESTELLUNGSORT)
VALUES (2,'Laden');

create table Sponsor(
    SponsorId int primary key not null,
    Anrede int not null,
    Vorname VARCHAR2(50) not null,
    Nachname VARCHAR2(50) not null,
    Geburtsdatum Date,
    Strasse VARCHAR2(50),
    Hausnummer int,
    Ort VARCHAR2(50),
    Postleitzahl VARCHAR2(50),
    Land VARCHAR2(50),
    Email VARCHAR2(50) not null,
    Telefon VARCHAR2(50) not null,
    FOREIGN KEY (Anrede) REFERENCES anredee
);

create table Lieferant(
    FirmaID int primary key not null,
    Firma VARCHAR2(50) not null,
    Anrede int not null,
    Vorname VARCHAR2(50) not null,
    Nachname VARCHAR2(50) not null,
    Geburtsdatum DATE,
    Strasse VARCHAR2(50) not null,
    Hausnummer int not null,
    Ort VARCHAR2(50) not null,
    Postleitzahl VARCHAR2(50) not null,
    Land VARCHAR2(50) not null,
    Email VARCHAR2(50) not null,
    Telefon VARCHAR2(50) not null,
    FOREIGN KEY (Anrede) REFERENCES anredee
);

create table Artikel(
    ArtikelId int primary key not null,
    Artikelname VARCHAR2(50) Unique not null,
    Verkaufspreis DOUBLE PRECISION not null,
    MindestAnzahl int not null,
    Altersbeschraenkung int not null, 
    FOREIGN KEY (Altersbeschraenkung) REFERENCES ALTERSBERSCHRAENKUNGE
);

create table Kategorie(
    KategorieId int primary key not null,		
    Bezeichnung VARCHAR2(50) UNIQUE not null
);

create table Mitarbeiter(
    PersonalId INTEGER PRIMARY KEY NOT NULL,
    Anrede INTEGER not null,
    Vorname VARCHAR2(50) not null,
    Nachname VARCHAR2(50) not null,
    Geburtsdatum DATE not null,
    Straﬂe VARCHAR2(50) not null,
    Hausnummer INTEGER not null,
    Ort VARCHAR2(50) not null,
    Postleitzahl VARCHAR2(50) not null,
    Land VARCHAR2(50) not null,
    Email VARCHAR2(50) not null,
    Telefon VARCHAR2(50) not null,
    Gehalt DOUBLE PRECISION not null,
    StundenzahlProWoche INTEGER not null,
    Taetigkeitsbereich INTEGER not null,
    foreign key(Anrede) REFERENCES anredee,
    foreign key(Taetigkeitsbereich) REFERENCES taetigkeitsbereichE
);


CREATE TABLE Kunde (
    KundenId INTEGER PRIMARY KEY NOT NULL,
    Anrede INTEGER not null,
    Vorname VARCHAR2(50) not null,
    Nachname VARCHAR2(50) not null,
    Geburtsdatum DATE not null,
    Straﬂe VARCHAR2(50) not null,
    Hausnummer INTEGER not null,
    Ort VARCHAR2(50) not null,
    Postleitzahl VARCHAR2(50) not null,
    Land VARCHAR2(50) not null,
    Email VARCHAR2(50) not null,
    Telefon VARCHAR2(50) not null,
    RegistrierungsDatum DATE not null,
    foreign key(Anrede) REFERENCES anredee
);

create table Prominenz(
    ProminenzId int primary key not null,
    Anrede int not null,
    Vorname varchar2(50) not null,
    Nachname VARCHAR2(50) not null,
    Geburtsdatum DATE,
    Straﬂe VARCHAR2(50),
    Hausnummer int,
    Ort VARCHAR2(50),
    Postleitzahl VARCHAR2(50),
    Land VARCHAR2(50),
    Email VARCHAR2(50) not null,
    Telefon VARCHAR2(50) not null,
    Bezahlung double PRECISION,
    foreign key(Anrede) REFERENCES anredee
);

CREATE TABLE EVENT(
    EVENTID INT NOT NULL,
    BEGINN Timestamp not null,
    ENDE Timestamp not null,
    TICKETPREIS DOUBLE PRECISION,
    EINNAHMEN DOUBLE PRECISION,
    AUSGABEN DOUBLE PRECISION,
    SPONSORSHIP DOUBLE PRECISION,
    PROMINENZID INT,
    SPONSORID INT,
    KategorieId INT not null,
    FOREIGN KEY (PROMINENZID) REFERENCES PROMINENZ,
    FOREIGN KEY (SPONSORID) REFERENCES SPONSOR,
    FOREIGN KEY (KategorieId) REFERENCES KATEGORIE,
    PRIMARY KEY (EVENTID)
);

create table MitarbeiterVerfuegbarkeit(
    PersonalId int not null,
    Wochentage int not null,
    FOREIGN key(PersonalId) REFERENCES  Mitarbeiter,
    FOREIGN key(Wochentage) REFERENCES Wochentagee,
    PRIMARY KEY (PersonalId, Wochentage)
);

create table Spezialisiert(
    PersonalId int not null,
    KategorieId int not null,
    FOREIGN key(PersonalId) REFERENCES  Mitarbeiter,
    FOREIGN key(KategorieId) REFERENCES Kategorie,
    PRIMARY KEY (PersonalId, KategorieId)
);

create table Arbeitet(
    PersonalId int not null,
    EventId int not null,
    FOREIGN key(PersonalId) REFERENCES  Mitarbeiter,
    FOREIGN key(EventId) REFERENCES Event,
    PRIMARY KEY (PersonalId, EventId)
);


create table Besucht(
    KundenId int not null,
    EventID int not null,
    FOREIGN key(KundenId) REFERENCES Kunde,
    FOREIGN key(EventId) REFERENCES Event,
    PRIMARY KEY (KundenId, EventId)
);

create table Praeferenz(
    KundenId int not null,
    KategorieId int not null,
    FOREIGN key(KundenId) REFERENCES Kunde,
    FOREIGN key(KategorieId) REFERENCES Kategorie,
    PRIMARY KEY (KundenId, KategorieId)
);

create table Bekanntheit(
    ProminenzId int not null,
    KategorieId int not null,
    FOREIGN key(ProminenzId) REFERENCES Prominenz,
    FOREIGN key(KategorieId) REFERENCES Kategorie,
    PRIMARY KEY (ProminenzId, KategorieId)
);

create table Bietet(
    FirmaID Int,
    ArtikelId int,
    Einkaufspreis DOUBLE PRECISION not null,
    Lieferzeit int not null,
    FOREIGN key (ArtikelId) REFERENCES artikel,
    FOREIGN key (FirmaID) REFERENCES lieferant,
    PRIMARY KEY (FirmaID, ArtikelId) 
);

create table Zugehoerigkeit(
    ArtikelId int,
    KategorieId int,
    FOREIGN key (ArtikelId) REFERENCES artikel,
    FOREIGN key (KategorieId) REFERENCES Kategorie,
    PRIMARY KEY (KategorieId, ArtikelId) 
);


create table Rabattaktion(
    RabattId int,
    Beginn timestamp not null, 
    Ende timestamp not null,
    Rabatt DOUBLE PRECISION not null,
    KategorieId int not null,
    FOREIGN key (KategorieId) REFERENCES Kategorie,
    PRIMARY KEY (RabattId)
);

create table Lagerort(
    Lagerort int, 
    RegalId int,
    PositionsId int,
    Anzahlartikel int not null,
    ArtikelId int,
    FOREIGN key (ArtikelId) REFERENCES artikel,
    FOREIGN key (Lagerort) REFERENCES lagerorte,
    PRIMARY KEY (Lagerort, RegalId, PositionsId)
);

create table Bestellungkunde(
    BestellId int, 
    Versandstatus int,
    Datum Date not null,
    Bezahlstatus int not null,
    Bestellungsort int,
    KundenId int not null,
    FOREIGN key (Versandstatus) REFERENCES statuse,
    FOREIGN key (Bezahlstatus) REFERENCES bezahlstatuse,
    FOREIGN key (Bestellungsort) REFERENCES bestellungsorte,
    FOREIGN key (KundenId) REFERENCES kunde,
    PRIMARY KEY (BestellId)
);

create table Bestellungkundeposition(
    BestellId int,
    ArtikelId int,
    Bestellungspreis DOUBLE PRECISION not null,
    FOREIGN key (ArtikelId) REFERENCES artikel,
    FOREIGN key (BestellId) REFERENCES Bestellungkunde,
    PRIMARY KEY (BestellId, ArtikelId)
);

create table Bestellunglieferant(
    BestellId int, 
    Versandstatus int,
    Datum Date not null,
    Bezahlstatus int not null,
    FirmaID int not null,
    FOREIGN key (Versandstatus) REFERENCES statuse,
    FOREIGN key (Bezahlstatus) REFERENCES bezahlstatuse,
    FOREIGN key (FirmaID) REFERENCES lieferant,
    PRIMARY KEY (BestellId)
);


CREATE TABLE BESTELLUNGLIEFERANTPOSITION(
    BESTELLID INT NOT NULL,
    ARTIKELID INT NOT NULL,
    BESTELLUNGSEINKAUFSPREIS DOUBLE PRECISION not null,
    LIEFERZEIT INT,
    FOREIGN KEY(BESTELLID)REFERENCES BESTELLUNGLIEFERANT,
    FOREIGN KEY(ARTIKELID)REFERENCES ARTIKEL,
    PRIMARY KEY(BESTELLID,ARTIKELID)
);

create table Reservierung(
    ReservierungsId int not null,
    Beginn timestamp not null,
    Ende timestamp not null,
    Datum date not null,
    KundeId int not null,
    PRIMARY KEY(ReservierungsId),
    FOREIGN KEY(KundeId) REFERENCES Kunde
);

create table Reservierungsposition(
    ReservierungsId int,
    ArtikelId int,
    Reservierpreis DOUBLE PRECISION not null,
    FOREIGN key (ArtikelId) REFERENCES artikel,
    FOREIGN key (ReservierungsId) REFERENCES reservierung,
    PRIMARY key (ReservierungsId, ArtikelId)
);

CREATE TABLE EINLADUNG(
   EINLADUNGSID INT NOT NULL,
   VERSANDDATUM DATE not null,
   EVENTID INT not null,
   KUNDENID INT not null,
   PRIMARY KEY(EINLADUNGSID),
   FOREIGN KEY(EVENTID)REFERENCES EVENT,
   FOREIGN KEY(KUNDENID)REFERENCES KUNDE
);

CREATE TABLE WERBUNG(
    WERBEID INT NOT NULL,
    WERBETYPE INT not null,
    BEGINN timestamp not null,
    ENDE timestamp not null,
    AUSGABEN DOUBLE PRECISION,
    KategorieId int not null,
    FOREIGN KEY(KategorieId)REFERENCES KATEGORIE,
    FOREIGN KEY(WERBETYPE)REFERENCES WERBETYPE,
    PRIMARY KEY(WERBEID)
);

CREATE TABLE RELEVANZ(
    SPONSORID INT NOT NULL,
    KategorieId int not null,
    FOREIGN KEY(SPONSORID) REFERENCES SPONSOR,
    FOREIGN KEY(KategorieId)REFERENCES KATEGORIE,
    PRIMARY KEY(SPONSORID, KategorieId)
);

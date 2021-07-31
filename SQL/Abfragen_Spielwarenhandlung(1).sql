
--1. Welche Produkte sind anhand der Verkäufe am beliebtesten?
select artikel.artikelname, count(bestellungkundeposition.artikelid)as num
from bestellungkundeposition, artikel
where bestellungkundeposition.artikelid = artikel.artikelid
GROUP BY artikel.artikelname
having count(bestellungkundeposition.artikelid) = (select max(y.num)
from (select count(bestellungkundeposition.artikelid)as num
from bestellungkundeposition, artikel
where bestellungkundeposition.artikelid = artikel.artikelid
GROUP BY artikel.artikelname)y);

--2. Welche Kategorien sind anhand der Präferenzen der Kunden am beliebtesten?
select kategorie.bezeichnung as bezeichner,count(praeferenz.kategorieid)as num
from praeferenz, kategorie
where praeferenz.kategorieid = kategorie.kategorieid
GROUP BY kategorie.bezeichnung
having count(praeferenz.kategorieid) = (select max(y.num)
from (select count(praeferenz.kategorieid)as num    
from praeferenz, kategorie
where praeferenz.kategorieid = kategorie.kategorieid
GROUP BY kategorie.bezeichnung)y);

--3. Wie ist das Verhältnis vom Gewinn im Online Shop, zum Gewinn im Laden? 
--Berechnung: Online/Laden -> SQL kann keinen Bruch darstellen deshalb Dezimalzahl.
select (gesOnline/gesLaden) as verhaeltnissOnlineLaden from (select sum(y.num) as gesLaden from(select bestellungkunde.bestellid, kundenid, sum(BESTELLUNGSPREIS)as num, bestellungkunde.bestellungsort from bestellungkundeposition, bestellungkunde
where  bestellungsort = 2 and  bestellungkundeposition.bestellid = bestellungkunde.bestellid
group by bestellungkunde.bestellid, kundenid, bestellungkunde.bestellungsort)y) laden,
(select sum(x.num)as gesOnline from(select bestellungkunde.bestellid, kundenid, sum(BESTELLUNGSPREIS)as num, bestellungkunde.bestellungsort from bestellungkundeposition, bestellungkunde
where  bestellungsort = 1 and  bestellungkundeposition.bestellid = bestellungkunde.bestellid
group by bestellungkunde.bestellid, kundenid, bestellungkunde.bestellungsort)x) onlineshop;

--4.  Wie wirkt sich ein Event(typ) “y” auf die Umsätze in der dazugehörigen Kategorie “x” im Zeitraum “z” aus?
select (NVL(umsatzDanach.umsatze,0)- NVL(umsatzdavor.umsatzvorevent,0)) as Mehr_Umsatz, umsatzDanach.kate as Kategorieid, umsatzDanach.Kategorie from (
select sum(umsatzKategorie.preis) as umsatzE, umsatzKategorie.bezeichnung as Kategorie,umsatzKategorie.Kategorie as kate  from(
select event.kategorieid as Kategorie, kategorie.bezeichnung as bezeichnung ,to_date(to_char(event.beginn,'DD.MM.YYYY'))as Beginn, to_date(to_char(event.ende+8,'DD.MM.YYYY'))as Ende, bestellungkunde.datum, bestellungkundeposition.bestellungspreis as preis from event, bestellungkundeposition,zugehoerigkeit, bestellungkunde, kategorie
where event.eventid=7 
and bestellungkunde.datum between to_date(to_char(event.beginn,'DD.MM.YYYY')) and to_date(to_char(event.ende+8,'DD.MM.YYYY'))
and event.kategorieid=zugehoerigkeit.kategorieid 
and bestellungkundeposition.artikelid=zugehoerigkeit.artikelid 
and event.kategorieid=kategorie.kategorieid
and bestellungkunde.bestellid= bestellungkundeposition.bestellid) umsatzKategorie
GROUP by umsatzKategorie.bezeichnung,umsatzKategorie.Kategorie) umsatzDanach, (
select sum(umsatzKategoriedavor.preisD)as UmsatzvorEvent from(
select event.kategorieid,to_date(to_char(event.beginn,'DD.MM.YYYY')), to_date(to_char(event.ende,'DD.MM.YYYY')), bestellungkundeposition.artikelid, bestellungkundeposition.bestellid, bestellungkunde.datum, bestellungkundeposition.bestellungspreis as preisD from event, bestellungkundeposition,zugehoerigkeit, bestellungkunde
where event.eventid=7 and bestellungkunde.datum between to_date(to_char(event.beginn-8,'DD.MM.YYYY')) and to_date(to_char(event.beginn,'DD.MM.YYYY'))
and event.kategorieid=zugehoerigkeit.kategorieid 
and bestellungkundeposition.artikelid=zugehoerigkeit.artikelid 
and bestellungkunde.bestellid= bestellungkundeposition.bestellid) umsatzKategoriedavor) umsatzDavor ;

--5. Was sind Alternativen zu einem ausverkauften Produkt basierend auf den Interessen des Kunden? (Anhand der Übereinstimmung der Kategorien des Produkts mit anderen beliebten Produkten)
--Ausverkauftes Produkt = Tischkicker Extreme
--Kunde mit ID = 40
select praeferenz.kundenid, praeferenz.kategorieid, beliebteProdukte.artikelid, artikel.artikelname 
from praeferenz, zugehoerigkeit, artikel,(
select count(bestellungkundeposition.artikelid), bestellungkundeposition.artikelid as artikelid 
from bestellungkundeposition
where bestellungkundeposition.artikelid in (
select a2.artikelid from  artikel a1,zugehoerigkeit z1, artikel a2, zugehoerigkeit z2
where a1.artikelname='Tischkicker Extreme' 
and a1.artikelid=z1.artikelid
and a2.artikelname !='Tischkicker Extreme' 
and a2.artikelid=z2.artikelid
and z1.kategorieid = z2.kategorieid
group by a2.artikelid)
group by bestellungkundeposition.artikelid
order by count(bestellungkundeposition.artikelid) desc
fetch first 5 rows only) beliebteProdukte
where praeferenz.kundenid=40
and beliebteProdukte.artikelid=zugehoerigkeit.artikelid
and beliebteProdukte.artikelid= artikel.artikelid
and zugehoerigkeit.kategorieid = praeferenz.kategorieid;

--6. Wie viele Neukunden werden im Durschnitt durch ein Event der Kategorie ”x” generiert? (Die Erstellung neuer Kundenkonten bei einem Event wird unter “Neukunde” in Event gezählt)
select avg(neuk.neukunden) as Durchschnittliche_Neukunden from (
select NVL(count(k1.kundenid),0)as neukunden, e1.eventid from event e1 left join kunde k1 
on k1.registrierungsdatum between to_date(to_char(e1.beginn,'DD.MM.YYYY')) and to_date(to_char(e1.ende+8,'DD.MM.YYYY'))
group by e1.eventid) neuk;

--7. Welche Kategorien “x” von Events haben das beste Nutzenverhältnis in Bezug auf die Verkäufe im Verhältnis zu den Kosten der Events?
select avg((NVL((event.einnahmen+verkauf.umsatze),0)-NVL(event.ausgaben,0))) as Einnahmen, event.kategorieid, kategorie.bezeichnung from event,kategorie,(
select NVL(sum(umsatzKategorie.preis),0) as umsatzE, umsatzKategorie.bezeichnung as Kategorie,event.eventid as Event  from(
select event.eventid as Event,bestellungkunde.bestellid, event.kategorieid as Kategorieid, kategorie.bezeichnung as bezeichnung ,to_date(to_char(event.beginn,'DD.MM.YYYY'))as Beginn, to_date(to_char(event.ende+8,'DD.MM.YYYY'))as Ende, bestellungkunde.datum, bestellungkundeposition.bestellungspreis as preis 
from event, bestellungkundeposition,zugehoerigkeit, bestellungkunde, kategorie
where bestellungkunde.datum between to_date(to_char(event.beginn,'DD.MM.YYYY')) and to_date(to_char(event.ende+8,'DD.MM.YYYY'))
and event.kategorieid=zugehoerigkeit.kategorieid 
and bestellungkundeposition.artikelid=zugehoerigkeit.artikelid 
and event.kategorieid=kategorie.kategorieid
and bestellungkunde.bestellid= bestellungkundeposition.bestellid) umsatzKategorie right join event on event.eventid=umsatzKategorie.event
GROUP by umsatzKategorie.bezeichnung,event.eventid) verkauf
where event.eventid= verkauf.event
and event.kategorieid=kategorie.kategorieid
group by event.kategorieid, kategorie.bezeichnung 
order by einnahmen desc
fetch first 5 rows only;


--8. Wie steigern sich die Einnahmen von Produkt “x”, wenn es beworben wird, reduziert wird oder beides?
--Produkt 19 -> kat 9 

--Werbung Umsatz
select (kaufdanach.bestellungdanach-kaufdavor.bestellungdavor) as gewinnDurchWerbung from (
select NVL(sum(bestellungkundeposition.bestellungspreis),0) as  bestellungdanach from werbung,bestellungkunde, bestellungkundeposition
where werbung.werbeid=52
and bestellungkundeposition.artikelid=19
and bestellungkunde.bestellid= bestellungkundeposition.bestellid
and bestellungkunde.datum between to_date(to_char(werbung.beginn,'DD.MM.YYYY')) and to_date(to_char(werbung.ende,'DD.MM.YYYY')))kaufdanach,
(select NVL(sum(bestellungkundeposition.bestellungspreis),0) as bestellungdavor from werbung,bestellungkunde, bestellungkundeposition
where werbung.werbeid=52
and bestellungkundeposition.artikelid=19
and bestellungkunde.bestellid= bestellungkundeposition.bestellid
and bestellungkunde.datum between to_date(to_char(werbung.beginn-(to_date(to_char(werbung.ende,'DD.MM.YYYY')) -to_date(to_char(werbung.beginn,'DD.MM.YYYY'))),'DD.MM.YYYY')) and to_date(to_char(werbung.beginn,'DD.MM.YYYY'))) kaufDavor;

--Rabatt Umsatz
select (kaufdanach.bestellungdanach-kaufdavor.bestellungdavor) as gewinnDurchRabattaktion from (
select NVL(sum(bestellungkundeposition.bestellungspreis),0) as  bestellungdanach from rabattaktion,bestellungkunde, bestellungkundeposition
where rabattaktion.rabattid=52
and bestellungkundeposition.artikelid=19
and bestellungkunde.bestellid= bestellungkundeposition.bestellid
and bestellungkunde.datum between to_date(to_char(rabattaktion.beginn,'DD.MM.YYYY')) and to_date(to_char(rabattaktion.ende,'DD.MM.YYYY')))kaufdanach,
(select NVL(sum(bestellungkundeposition.bestellungspreis),0) as bestellungdavor from rabattaktion,bestellungkunde, bestellungkundeposition
where rabattaktion.rabattid=52
and bestellungkundeposition.artikelid=19
and bestellungkunde.bestellid= bestellungkundeposition.bestellid
and bestellungkunde.datum between to_date(to_char(rabattaktion.beginn-(to_date(to_char(rabattaktion.ende,'DD.MM.YYYY')) -to_date(to_char(rabattaktion.beginn,'DD.MM.YYYY'))),'DD.MM.YYYY')) and to_date(to_char(rabattaktion.beginn,'DD.MM.YYYY'))) kaufDavor;

--Rabatt u Werbung Umsatz
select (kaufdanach.bestellungdanach-kaufdavor.bestellungdavor) as gewinnRabattaktionUndWerbung from (
select NVL(sum(bestellungkundeposition.bestellungspreis),0) as  bestellungdanach from rabattaktion,bestellungkunde, bestellungkundeposition
where rabattaktion.rabattid=51
and bestellungkundeposition.artikelid=19
and bestellungkunde.bestellid= bestellungkundeposition.bestellid
and bestellungkunde.datum between to_date(to_char(rabattaktion.beginn,'DD.MM.YYYY')) and to_date(to_char(rabattaktion.ende,'DD.MM.YYYY')))kaufdanach,
(select NVL(sum(bestellungkundeposition.bestellungspreis),0) as bestellungdavor from rabattaktion,bestellungkunde, bestellungkundeposition
where rabattaktion.rabattid=51
and bestellungkundeposition.artikelid=19
and bestellungkunde.bestellid= bestellungkundeposition.bestellid
and bestellungkunde.datum between to_date(to_char(rabattaktion.beginn-(to_date(to_char(rabattaktion.ende,'DD.MM.YYYY')) -to_date(to_char(rabattaktion.beginn,'DD.MM.YYYY'))),'DD.MM.YYYY')) and to_date(to_char(rabattaktion.beginn,'DD.MM.YYYY'))) kaufDavor;

--9. Welcher Mitarbeiter eignet sich, basierend auf Spezialgebiet und Verfügbarkeit, für welches Event?
select eventid, beginn, vorname, nachname from event, spezialisiert, mitarbeiterverfuegbarkeit, mitarbeiter
where event.kategorieid = spezialisiert.kategorieid
and mitarbeiterverfuegbarkeit.personalid = spezialisiert.personalid
and to_char(cast(beginn as date), 'd') = mitarbeiterverfuegbarkeit.wochentage
and mitarbeiterverfuegbarkeit.personalid = mitarbeiter.personalid
order by event.eventid;

--10. Wie viel Geld gibt ein Kunde im Durchschnitt pro Einkauf aus?
select avg(summeBestellung.num) as AusgabeDurchschnitt from(select bestellungkunde.bestellid, kundenid, sum(BESTELLUNGSPREIS)as num from bestellungkundeposition, bestellungkunde
where bestellungkundeposition.bestellid = bestellungkunde.bestellid
group by bestellungkunde.bestellid, kundenid) summeBestellung;

--11. Was ist die optimale Dauer (Zeitraum) einer Werbung “x”, für einen optimalen Gewinn?
--Um einen besseren Vergleich zu erlangen haben wir Werbetyp und Kategorie als Kriterium gewählt 
-- Berechnung:(einnahmen-werbekosten)/Dauer ->gewinn Pro tag -> optimale = von existierenden Werbekampagnen die, die am meisten einnahem pro tag genereiert hat
select werbung.werbetype, werbung.kategorieid as Kategorie, (to_date(to_char(werbung.ende,'DD.MM.YYYY')) -to_date(to_char(werbung.beginn,'DD.MM.YYYY'))) as OptimaleDauer from werbung,(
select sum(umsatzWerbung.preis) as einnahmen, umsatzwerbung.werbung as werbung from(
select to_date(to_char(werbung.beginn,'DD.MM.YYYY'))as Beginn, to_date(to_char(werbung.ende,'DD.MM.YYYY'))as Ende, bestellungkunde.datum, bestellungkundeposition.bestellungspreis as preis,  werbung.werbeid as werbung
from werbung , bestellungkundeposition,zugehoerigkeit, bestellungkunde
where werbung.werbetype= 1 and werbung.kategorieid=9 
and bestellungkunde.datum between to_date(to_char(werbung.beginn,'DD.MM.YYYY')) and to_date(to_char(werbung.ende,'DD.MM.YYYY'))
and werbung.kategorieid=zugehoerigkeit.kategorieid 
and bestellungkundeposition.artikelid=zugehoerigkeit.artikelid 
and bestellungkunde.bestellid= bestellungkundeposition.bestellid) umsatzWerbung
GROUP by umsatzwerbung.werbung) einnahmen
where werbung.werbeid=einnahmen.werbung and ((einnahmen.einnahmen- werbung.ausgaben)/(to_date(to_char(werbung.ende,'DD.MM.YYYY')) -to_date(to_char(werbung.beginn,'DD.MM.YYYY'))))= ( select max(gewinnTag.gewinnProTag)from (
select ((einnahmen.einnahmen- werbung.ausgaben)/(to_date(to_char(werbung.ende,'DD.MM.YYYY')) -to_date(to_char(werbung.beginn,'DD.MM.YYYY')))) as gewinnProTag, werbung.werbeid from werbung,(
select sum(umsatzWerbung.preis) as einnahmen, umsatzwerbung.werbung as werbung from(
select to_date(to_char(werbung.beginn,'DD.MM.YYYY'))as Beginn, to_date(to_char(werbung.ende,'DD.MM.YYYY'))as Ende, bestellungkunde.datum, bestellungkundeposition.bestellungspreis as preis,  werbung.werbeid as werbung
from werbung , bestellungkundeposition,zugehoerigkeit, bestellungkunde
where werbung.werbetype= 1 and werbung.kategorieid=9 
and bestellungkunde.datum between to_date(to_char(werbung.beginn,'DD.MM.YYYY')) and to_date(to_char(werbung.ende,'DD.MM.YYYY'))
and werbung.kategorieid=zugehoerigkeit.kategorieid 
and bestellungkundeposition.artikelid=zugehoerigkeit.artikelid 
and bestellungkunde.bestellid= bestellungkundeposition.bestellid) umsatzWerbung
GROUP by umsatzwerbung.werbung) einnahmen
where werbung.werbeid=einnahmen.werbung)gewinnTag);

--12. Welche Kategorie “x” ist bei der Altersgruppe “y” besonders beliebt?
select count(praeferenz.kategorieid) as num, kategorie.bezeichnung from kunde,praeferenz, kategorie
where extract(year from geburtsdatum) between 2004 and 2010
and kunde.kundenid=praeferenz.kundenid
and praeferenz.kategorieid=kategorie.kategorieid
GROUP BY kategorie.bezeichnung
having count(praeferenz.kategorieid) =
(select max(pop.num) from (select count(praeferenz.kategorieid) as num, praeferenz.kategorieid from kunde,praeferenz
where extract(year from geburtsdatum) between 2004 and 2010
and kunde.kundenid=praeferenz.kundenid
GROUP BY praeferenz.kategorieid)pop);

--13. Wie viel mehr Geld geben Kunden aus, die “x” Events besucht haben? x = 2
select (avg(kundeevent.bestellungsum)-avg(kundeohneevent.bestellungsumme)) as GibtKundederEventsmehrAus from (
select sum(bestellungkundeposition.bestellungspreis) as bestellungsum, bestellungkunde.bestellid from bestellungkunde, bestellungkundeposition
where bestellungkunde.bestellid = bestellungkundeposition.bestellid 
and bestellungkunde.kundenid in (
select kundenid from besucht
group by kundenid
having count(eventid)=2)
group by bestellungkunde.bestellid)kundeEvent, (
select sum(bestellungkundeposition.bestellungspreis) as bestellungsumme, bestellungkunde.bestellid from bestellungkunde, bestellungkundeposition
where bestellungkunde.bestellid = bestellungkundeposition.bestellid 
and bestellungkunde.kundenid in (
select k.kundenid from besucht b right join kunde k 
on b.kundenid = k.kundenid
where b.kundenid is null)
group by bestellungkunde.bestellid)kundeohneEvent;

--14. Welche 3 Produkte “x” generieren den meisten Gewinn in der Kategorie “y”?
select sum(bestellungspreis) as summe ,bestellungkundeposition.artikelid, artikel.artikelname from bestellungkundeposition, artikel
where bestellungkundeposition.artikelid in(
select artikel.artikelid from kategorie, artikel, zugehoerigkeit
where kategorie.bezeichnung='Stardew Valley' 
and kategorie.kategorieid=zugehoerigkeit.kategorieid 
and artikel.artikelid=zugehoerigkeit.artikelid)
and artikel.artikelid= bestellungkundeposition.artikelid
group by bestellungkundeposition.artikelid, artikel.artikelname
order by summe desc
fetch first 3 rows only;

--15. Wann sollte das Produkt “x” nachbestellt werden? (Basierend auf Verkaufstrend des letzten Monats, Minimal Bestand, und erwarteter Lieferzeit)
--Berechnung: ((lagerbestand-mindestbestand)/verkaufstrendLetzterMonat)-lieferzeit
--Produkt = 19
select to_char(sysdate+cast((((lagerbestand.lagerbestand- artikel.mindestanzahl)/verkaufstrend.durchschnitt)-lieferzeit.minlieferzeit)as int),'DD.MM.YYYY') as Bestelldatum, lieferzeit.produkt from (
select min(bietet.lieferzeit) as minLieferzeit,artikel.artikelname as Produkt from artikel, bietet
where artikel.artikelid= 19
and artikel.artikelid= bietet.artikelid
group by artikel.artikelname) lieferzeit,(
select sum(lagerort.anzahlartikel)as lagerbestand from artikel, lagerort
where artikel.artikelid= 19
and artikel.artikelid= lagerort.artikelid) lagerbestand,(
select count(bestellungkundeposition.artikelid)/31 as durchschnitt
from bestellungkundeposition, bestellungkunde, artikel 
where bestellungkunde.datum between to_date(to_char(sysdate-31,'DD.MM.YYYY')) and to_date(to_char(sysdate,'DD.MM.YYYY'))
and bestellungkunde.bestellid = bestellungkundeposition.bestellid
and artikel.artikelid=19
and bestellungkundeposition.artikelid=artikel.artikelid) verkaufstrend, artikel
where artikel.artikelid=19;
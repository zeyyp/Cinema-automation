--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 16.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: azalmafonksiyonu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.azalmafonksiyonu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
update "ToplamFilm" set sayi=sayi-1;
return old;
end;
$$;


ALTER FUNCTION public.azalmafonksiyonu() OWNER TO postgres;

--
-- Name: filmekle(character varying, character varying, character varying, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.filmekle(pfilmkodu character varying, pfilmadi character varying, pyonetmen character varying, pimdb double precision) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "Film" ("FilmKodu","Adi", "Yonetmen", "IMDb")
    VALUES (pfilmkodu,pfilmadi, pyonetmen, pimdb);
END;
$$;


ALTER FUNCTION public.filmekle(pfilmkodu character varying, pfilmadi character varying, pyonetmen character varying, pimdb double precision) OWNER TO postgres;

--
-- Name: filmekletrigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.filmekletrigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Yeni bir film ekleniyorsa EklenenFilmler tablosuna film adını ekle
    INSERT INTO "eklenenfilmler" ("FilmAdi") VALUES (NEW."Adi");
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.filmekletrigger() OWNER TO postgres;

--
-- Name: filmgetir2(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.filmgetir2(pfilmadi character varying) RETURNS TABLE("FilmKodu" character varying, "Adi" character varying, "Yonetmen" character varying, "IMDb" double precision)
    LANGUAGE plpgsql
    AS $$
	BEGIN
	    RETURN QUERY
	    
	    select "Film"."FilmKodu","Film"."Adi","Film"."Yonetmen","Film"."IMDb"
	     from "Film"
	     WHERE
	    "Film"."Adi" = pfilmadi;
	     end;
	     $$;


ALTER FUNCTION public.filmgetir2(pfilmadi character varying) OWNER TO postgres;

--
-- Name: filmguncelle2(character varying, character varying, character varying, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.filmguncelle2(pfilmkodu character varying, pfilmadi character varying, pyonetmen character varying, pimdb double precision) RETURNS TABLE("FilmKodu" character varying, "Adi" character varying, "Yonetmen" character varying, "IMDb" double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    UPDATE "Film"
    SET
        "Adi" = pfilmadi,
        "Yonetmen" = pyonetmen,
        "IMDb" = pimdb
    WHERE
       "Film"."FilmKodu" = pfilmkodu;

    -- Güncellenen film bilgilerini döndür
    RETURN QUERY
    SELECT "Film"."FilmKodu", "Film"."Adi", "Film"."Yonetmen", "Film"."IMDb"
    FROM "Film"
    WHERE
        "Film"."FilmKodu" = pfilmkodu;
END;
$$;


ALTER FUNCTION public.filmguncelle2(pfilmkodu character varying, pfilmadi character varying, pyonetmen character varying, pimdb double precision) OWNER TO postgres;

--
-- Name: filmsil(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.filmsil(pfilmkodu character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$  
DECLARE
    sayac_afis int;
    sayac_filmTur int;
    sayac_filmUlke int;
    sayac_filmMusteri int;
    sayac_filmSeans int;
    
 BEGIN
    

 SELECT count( * ) INTO sayac_afis FROM "Afis" WHERE "Afis"."FilmKodu" = pfilmkodu;
    IF sayac_afis >0 THEN 
    DELETE FROM "Afis" WHERE "Afis"."FilmKodu" = pfilmkodu;
    
    end if;
    
    
    SELECT count( * ) INTO sayac_filmUlke FROM "FilmUlke" WHERE "FilmUlke"."FilmKodu" = pfilmkodu;
    IF sayac_filmUlke >0 THEN 
    DELETE FROM "FilmUlke" WHERE "FilmUlke"."FilmKodu" = pfilmkodu;
    
    end if;
 
SELECT count( * ) INTO sayac_filmTur FROM "FilmTur" WHERE "FilmTur"."FilmKodu" = pfilmkodu;
    IF sayac_filmTur >0 THEN 
    DELETE FROM "FilmTur" WHERE "FilmTur"."FilmKodu" = pfilmkodu;
    
    end if;
 
 
 SELECT count( * ) INTO sayac_filmMusteri FROM "FilmMusteri" WHERE "FilmMusteri"."FilmKodu" = pfilmkodu;
    IF sayac_filmMusteri >0 THEN 
    DELETE FROM "FilmMusteri" WHERE "FilmMusteri"."FilmKodu" = pfilmkodu;
    
    end if;
 
 
 SELECT count( * ) INTO sayac_filmSeans FROM "FilmSeans" WHERE "FilmSeans"."FilmKodu" = pfilmkodu;
    IF sayac_filmSeans >0 THEN 
    DELETE FROM "FilmSeans" WHERE "FilmSeans"."FilmKodu" = pfilmkodu;
    
    end if;
 
 DELETE from "Film" WHERE "FilmKodu" = pfilmkodu;
 
 END;
 $$;


ALTER FUNCTION public.filmsil(pfilmkodu character varying) OWNER TO postgres;

--
-- Name: filmsiltrigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.filmsiltrigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Film tablosundan film siliniyorsa trigger çalışır
    IF TG_OP = 'DELETE' THEN
        INSERT INTO "silinenfilmler" ("Adi") VALUES (OLD."Adi");
    END IF;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.filmsiltrigger() OWNER TO postgres;

--
-- Name: saticikayittut(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.saticikayittut() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    
    INSERT INTO "SaticiKayit" ("Adi") VALUES (NEW."Adi");
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.saticikayittut() OWNER TO postgres;

--
-- Name: toplamfonksiyonu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toplamfonksiyonu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
update "ToplamFilm" set sayi=sayi+1;
return new;
end;
$$;


ALTER FUNCTION public.toplamfonksiyonu() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Afis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Afis" (
    "AfisKodu" character varying(4) NOT NULL,
    "Yonetmen" character varying(20),
    "FilmAdi" character varying(10),
    "GosterimTarihi" timestamp without time zone,
    "FilmKodu" character varying(4)
);


ALTER TABLE public."Afis" OWNER TO postgres;

--
-- Name: Bilet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Bilet" (
    "BiletKodu" character varying(4) NOT NULL,
    "Tarihi" timestamp without time zone,
    "MusteriTC" character(11),
    "SaticiTC" character(11),
    "FaturaKodu" character varying(4)
);


ALTER TABLE public."Bilet" OWNER TO postgres;

--
-- Name: Fatura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Fatura" (
    "FaturaKodu" character varying(4) NOT NULL,
    "Ucreti" double precision,
    "Tarihi" timestamp without time zone,
    "OdemeKodu" character varying(4)
);


ALTER TABLE public."Fatura" OWNER TO postgres;

--
-- Name: Film; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Film" (
    "FilmKodu" character varying(4) NOT NULL,
    "Adi" character varying(10),
    "Yonetmen" character varying(10),
    "IMDb" double precision
);


ALTER TABLE public."Film" OWNER TO postgres;

--
-- Name: FilmMusteri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."FilmMusteri" (
    "FilmKodu" character varying(4) NOT NULL,
    "MusteriTC" character(11) NOT NULL
);


ALTER TABLE public."FilmMusteri" OWNER TO postgres;

--
-- Name: FilmSeans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."FilmSeans" (
    "SeansKodu" character varying(3) NOT NULL,
    "FilmKodu" character varying(4) NOT NULL
);


ALTER TABLE public."FilmSeans" OWNER TO postgres;

--
-- Name: FilmTur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."FilmTur" (
    "FilmKodu" character varying(4) NOT NULL,
    "TurAdi" character varying(15) NOT NULL
);


ALTER TABLE public."FilmTur" OWNER TO postgres;

--
-- Name: FilmUlke; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."FilmUlke" (
    "FilmKodu" character varying(4) NOT NULL,
    "UlkeKodu" character varying(4) NOT NULL
);


ALTER TABLE public."FilmUlke" OWNER TO postgres;

--
-- Name: Kart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Kart" (
    "OdemeKodu" character varying(4) NOT NULL
);


ALTER TABLE public."Kart" OWNER TO postgres;

--
-- Name: Koltuk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Koltuk" (
    "KoltukKodu" character varying(3) NOT NULL,
    "SalonNo" integer
);


ALTER TABLE public."Koltuk" OWNER TO postgres;

--
-- Name: Musteri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Musteri" (
    "MusteriTC" character(11) NOT NULL,
    "Adi" character varying(10),
    "Soyadi" character varying(10),
    "Yasi" integer,
    CONSTRAINT musteritc_length CHECK ((length("MusteriTC") = 11))
);


ALTER TABLE public."Musteri" OWNER TO postgres;

--
-- Name: Nakit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Nakit" (
    "OdemeKodu" character varying(4) NOT NULL
);


ALTER TABLE public."Nakit" OWNER TO postgres;

--
-- Name: OdemeTuru; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."OdemeTuru" (
    "OdemeKodu" character varying(4) NOT NULL,
    "OdemeCesit" character varying(1)
);


ALTER TABLE public."OdemeTuru" OWNER TO postgres;

--
-- Name: Salon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Salon" (
    "SalonNo" integer NOT NULL
);


ALTER TABLE public."Salon" OWNER TO postgres;

--
-- Name: SalonSeans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SalonSeans" (
    "SalonNo" integer NOT NULL,
    "SeansKodu" character varying(3) NOT NULL
);


ALTER TABLE public."SalonSeans" OWNER TO postgres;

--
-- Name: Satici; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Satici" (
    "SaticiTC" character(11) NOT NULL,
    "Adi" character varying(10),
    "Soyadi" character varying(10),
    CONSTRAINT saticitc_length CHECK ((length("SaticiTC") = 11))
);


ALTER TABLE public."Satici" OWNER TO postgres;

--
-- Name: SaticiKayit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SaticiKayit" (
    "Adi" character varying NOT NULL
);


ALTER TABLE public."SaticiKayit" OWNER TO postgres;

--
-- Name: Seans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Seans" (
    "SeansKodu" character varying(3) NOT NULL,
    "Saat" time without time zone
);


ALTER TABLE public."Seans" OWNER TO postgres;

--
-- Name: ToplamFilm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ToplamFilm" (
    sayi integer NOT NULL
);


ALTER TABLE public."ToplamFilm" OWNER TO postgres;

--
-- Name: Tur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Tur" (
    "TurAdi" character varying(15) NOT NULL
);


ALTER TABLE public."Tur" OWNER TO postgres;

--
-- Name: Ulke; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ulke" (
    "UlkeKodu" character varying(4) NOT NULL,
    "Adi" character varying(10),
    "Baskenti" character varying(10)
);


ALTER TABLE public."Ulke" OWNER TO postgres;

--
-- Name: eklenenfilmler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eklenenfilmler (
    "FilmAdi" character varying NOT NULL
);


ALTER TABLE public.eklenenfilmler OWNER TO postgres;

--
-- Name: silinenfilmler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silinenfilmler (
    "Adi" character varying NOT NULL
);


ALTER TABLE public.silinenfilmler OWNER TO postgres;

--
-- Data for Name: Afis; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Afis" VALUES
	('5', 'Taika', 'Avangers', '2023-12-15 21:00:00', '4');


--
-- Data for Name: Bilet; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Bilet" VALUES
	('10', '2023-12-12 00:00:00', '23783462181', '12290836463', 'F1'),
	('20', '2023-12-10 00:00:00', '98127382900', '34523672882', 'F2'),
	('30', '2023-12-01 00:00:00', '29027352891', '77221110022', 'F3');


--
-- Data for Name: Fatura; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Fatura" VALUES
	('F1', 100, '2023-12-12 00:00:00', 'O1'),
	('F2', 180, '2023-12-10 00:00:00', 'O2'),
	('F3', 140, '2023-12-01 00:00:00', 'O3');


--
-- Data for Name: Film; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Film" VALUES
	('100', 'Atatürk', 'Sadettin', 10),
	('1', 'Avatar', 'Jon', 9),
	('6', 'Xman', 'Jack', 8),
	('3', 'Thor', 'Taika', 5),
	('4', 'Avanger', 'Russo', 9.6),
	('7', 'Dark', 'Jonas', 8.8);


--
-- Data for Name: FilmMusteri; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."FilmMusteri" VALUES
	('4', '98127382900');


--
-- Data for Name: FilmSeans; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."FilmSeans" VALUES
	('50', '4');


--
-- Data for Name: FilmTur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."FilmTur" VALUES
	('4', 'Polisiye');


--
-- Data for Name: FilmUlke; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."FilmUlke" VALUES
	('4', '49');


--
-- Data for Name: Kart; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Kart" VALUES
	('O1'),
	('O3');


--
-- Data for Name: Koltuk; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Koltuk" VALUES
	('A01', 1),
	('A02', 1),
	('A03', 1),
	('B01', 2),
	('B02', 2),
	('B03', 2),
	('C01', 3),
	('C02', 3),
	('C03', 3),
	('D01', 4),
	('D02', 4),
	('D03', 4),
	('E01', 5),
	('E02', 5),
	('E03', 5);


--
-- Data for Name: Musteri; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Musteri" VALUES
	('23783462181', 'Ali', 'Cicek', 32),
	('29027352891', 'Beyza', 'Yıldız', 18),
	('98127382900', 'Pınar', 'Aydın', 22),
	('12378886520', 'Can', 'Siyah', 25);


--
-- Data for Name: Nakit; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Nakit" VALUES
	('O2');


--
-- Data for Name: OdemeTuru; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."OdemeTuru" VALUES
	('O1', 'K'),
	('O2', 'N'),
	('O3', 'K');


--
-- Data for Name: Salon; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Salon" VALUES
	(1),
	(2),
	(3),
	(4),
	(5);


--
-- Data for Name: SalonSeans; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."SalonSeans" VALUES
	(1, '11'),
	(2, '30'),
	(3, '21'),
	(4, '50'),
	(5, '40'),
	(1, '1');


--
-- Data for Name: Satici; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Satici" VALUES
	('12290836463', 'Burçak', 'Kara'),
	('77221110022', 'Mustafa', 'Demir'),
	('34523672882', 'Feyza', 'Ezber'),
	('10023672882', 'Doğa', 'Su'),
	('10822367282', 'Zeynep', 'Su'),
	('17822367282', 'Ali', 'Su');


--
-- Data for Name: SaticiKayit; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."SaticiKayit" VALUES
	('Doğa'),
	('Zeynep'),
	('Ali');


--
-- Data for Name: Seans; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Seans" VALUES
	('11', '15:00:00'),
	('21', '14:30:00'),
	('30', '13:00:00'),
	('40', '18:30:00'),
	('50', '21:00:00'),
	('1', '11:00:00');


--
-- Data for Name: ToplamFilm; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."ToplamFilm" VALUES
	(14),
	(11);


--
-- Data for Name: Tur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Tur" VALUES
	('komedi'),
	('Animasyon'),
	('Belgesel'),
	('Polisiye'),
	('Bilim Kurgu');


--
-- Data for Name: Ulke; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Ulke" VALUES
	('90', 'Turkiye', 'Ankara'),
	('49', 'Almanya', 'Berlin'),
	('48', 'Polonya', 'Varsova'),
	('1', 'Amerika', 'Vasikton'),
	('33', 'Fransa', 'Paris');


--
-- Data for Name: eklenenfilmler; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.eklenenfilmler VALUES
	('a'),
	('Avatar'),
	('Thor'),
	('Ayla'),
	('rre'),
	('Meg'),
	('Xman'),
	('Love'),
	('You'),
	('Tree'),
	('Thor'),
	('Truva'),
	('Titanic'),
	('Dark');


--
-- Data for Name: silinenfilmler; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.silinenfilmler VALUES
	('Thor'),
	('Everest'),
	('Batman'),
	('rre'),
	('Love'),
	('Tree'),
	('Ayla'),
	('Thor'),
	('Meg'),
	('You'),
	('Truva'),
	('sayac'),
	('Titanic');


--
-- Name: Afis AfisPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Afis"
    ADD CONSTRAINT "AfisPK" PRIMARY KEY ("AfisKodu");


--
-- Name: Bilet BiletKodu; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bilet"
    ADD CONSTRAINT "BiletKodu" PRIMARY KEY ("BiletKodu");


--
-- Name: Fatura FaturaKodu; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Fatura"
    ADD CONSTRAINT "FaturaKodu" PRIMARY KEY ("FaturaKodu");


--
-- Name: FilmMusteri FilmMusteri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmMusteri"
    ADD CONSTRAINT "FilmMusteri_pkey" PRIMARY KEY ("FilmKodu", "MusteriTC");


--
-- Name: Film FilmPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Film"
    ADD CONSTRAINT "FilmPK" PRIMARY KEY ("FilmKodu");


--
-- Name: FilmSeans FilmSeans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmSeans"
    ADD CONSTRAINT "FilmSeans_pkey" PRIMARY KEY ("SeansKodu", "FilmKodu");


--
-- Name: FilmTur FilmTur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmTur"
    ADD CONSTRAINT "FilmTur_pkey" PRIMARY KEY ("FilmKodu", "TurAdi");


--
-- Name: FilmUlke FilmUlke_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmUlke"
    ADD CONSTRAINT "FilmUlke_pkey" PRIMARY KEY ("FilmKodu", "UlkeKodu");


--
-- Name: Kart KartPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kart"
    ADD CONSTRAINT "KartPK" PRIMARY KEY ("OdemeKodu");


--
-- Name: Musteri MusteriTC; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Musteri"
    ADD CONSTRAINT "MusteriTC" PRIMARY KEY ("MusteriTC");


--
-- Name: Nakit NakitPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nakit"
    ADD CONSTRAINT "NakitPK" PRIMARY KEY ("OdemeKodu");


--
-- Name: OdemeTuru OdemeKoduPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OdemeTuru"
    ADD CONSTRAINT "OdemeKoduPK" PRIMARY KEY ("OdemeKodu");


--
-- Name: Salon SalonPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Salon"
    ADD CONSTRAINT "SalonPK" PRIMARY KEY ("SalonNo");


--
-- Name: SalonSeans SalonSeans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SalonSeans"
    ADD CONSTRAINT "SalonSeans_pkey" PRIMARY KEY ("SalonNo", "SeansKodu");


--
-- Name: Satici SaticiTC; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Satici"
    ADD CONSTRAINT "SaticiTC" PRIMARY KEY ("SaticiTC");


--
-- Name: Seans SeansPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seans"
    ADD CONSTRAINT "SeansPK" PRIMARY KEY ("SeansKodu");


--
-- Name: Tur Tur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tur"
    ADD CONSTRAINT "Tur_pkey" PRIMARY KEY ("TurAdi");


--
-- Name: Ulke UlkePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ulke"
    ADD CONSTRAINT "UlkePK" PRIMARY KEY ("UlkeKodu");


--
-- Name: Koltuk koltukPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Koltuk"
    ADD CONSTRAINT "koltukPK" PRIMARY KEY ("KoltukKodu");


--
-- Name: Film azalmatrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER azalmatrig AFTER INSERT ON public."Film" FOR EACH ROW EXECUTE FUNCTION public.azalmafonksiyonu();


--
-- Name: Film film_ekle_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER film_ekle_trigger AFTER INSERT ON public."Film" FOR EACH ROW EXECUTE FUNCTION public.filmekletrigger();


--
-- Name: Film film_sil_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER film_sil_trigger AFTER INSERT ON public."Film" FOR EACH ROW EXECUTE FUNCTION public.filmsiltrigger();


--
-- Name: Film film_sil_trigger2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER film_sil_trigger2 AFTER DELETE ON public."Film" FOR EACH ROW EXECUTE FUNCTION public.filmsiltrigger();


--
-- Name: Satici satici_kayit_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER satici_kayit_trigger AFTER INSERT ON public."Satici" FOR EACH ROW EXECUTE FUNCTION public.saticikayittut();


--
-- Name: Film toplamtrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER toplamtrig AFTER INSERT ON public."Film" FOR EACH ROW EXECUTE FUNCTION public.toplamfonksiyonu();


--
-- Name: Film toplamtrig2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER toplamtrig2 AFTER INSERT ON public."Film" FOR EACH ROW EXECUTE FUNCTION public.toplamfonksiyonu();


--
-- Name: Afis AfisFK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Afis"
    ADD CONSTRAINT "AfisFK1" FOREIGN KEY ("FilmKodu") REFERENCES public."Film"("FilmKodu");


--
-- Name: Bilet BiletFK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bilet"
    ADD CONSTRAINT "BiletFK1" FOREIGN KEY ("MusteriTC") REFERENCES public."Musteri"("MusteriTC");


--
-- Name: Bilet BiletFK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bilet"
    ADD CONSTRAINT "BiletFK2" FOREIGN KEY ("SaticiTC") REFERENCES public."Satici"("SaticiTC");


--
-- Name: Bilet BiletFK3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bilet"
    ADD CONSTRAINT "BiletFK3" FOREIGN KEY ("FaturaKodu") REFERENCES public."Fatura"("FaturaKodu");


--
-- Name: Fatura FaturaFK10; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Fatura"
    ADD CONSTRAINT "FaturaFK10" FOREIGN KEY ("OdemeKodu") REFERENCES public."OdemeTuru"("OdemeKodu");


--
-- Name: FilmMusteri FilmMusteri_FilmKodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmMusteri"
    ADD CONSTRAINT "FilmMusteri_FilmKodu_fkey" FOREIGN KEY ("FilmKodu") REFERENCES public."Film"("FilmKodu");


--
-- Name: FilmMusteri FilmMusteri_MusteriTC_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmMusteri"
    ADD CONSTRAINT "FilmMusteri_MusteriTC_fkey" FOREIGN KEY ("MusteriTC") REFERENCES public."Musteri"("MusteriTC");


--
-- Name: FilmSeans FilmSeans_FilmKodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmSeans"
    ADD CONSTRAINT "FilmSeans_FilmKodu_fkey" FOREIGN KEY ("FilmKodu") REFERENCES public."Film"("FilmKodu");


--
-- Name: FilmSeans FilmSeans_SeansKodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmSeans"
    ADD CONSTRAINT "FilmSeans_SeansKodu_fkey" FOREIGN KEY ("SeansKodu") REFERENCES public."Seans"("SeansKodu");


--
-- Name: FilmTur FilmTur_FilmKodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmTur"
    ADD CONSTRAINT "FilmTur_FilmKodu_fkey" FOREIGN KEY ("FilmKodu") REFERENCES public."Film"("FilmKodu");


--
-- Name: FilmTur FilmTur_TurAdi_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmTur"
    ADD CONSTRAINT "FilmTur_TurAdi_fkey" FOREIGN KEY ("TurAdi") REFERENCES public."Tur"("TurAdi");


--
-- Name: FilmUlke FilmUlke_FilmKodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmUlke"
    ADD CONSTRAINT "FilmUlke_FilmKodu_fkey" FOREIGN KEY ("FilmKodu") REFERENCES public."Film"("FilmKodu");


--
-- Name: FilmUlke FilmUlke_UlkeKodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FilmUlke"
    ADD CONSTRAINT "FilmUlke_UlkeKodu_fkey" FOREIGN KEY ("UlkeKodu") REFERENCES public."Ulke"("UlkeKodu");


--
-- Name: Kart KartFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kart"
    ADD CONSTRAINT "KartFK" FOREIGN KEY ("OdemeKodu") REFERENCES public."OdemeTuru"("OdemeKodu") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Nakit NakitFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nakit"
    ADD CONSTRAINT "NakitFK" FOREIGN KEY ("OdemeKodu") REFERENCES public."OdemeTuru"("OdemeKodu") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SalonSeans SalonSeans_SalonNo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SalonSeans"
    ADD CONSTRAINT "SalonSeans_SalonNo_fkey" FOREIGN KEY ("SalonNo") REFERENCES public."Salon"("SalonNo");


--
-- Name: SalonSeans SalonSeans_SeansKodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SalonSeans"
    ADD CONSTRAINT "SalonSeans_SeansKodu_fkey" FOREIGN KEY ("SeansKodu") REFERENCES public."Seans"("SeansKodu");


--
-- Name: Koltuk koltukFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Koltuk"
    ADD CONSTRAINT "koltukFK" FOREIGN KEY ("SalonNo") REFERENCES public."Salon"("SalonNo");


--
-- PostgreSQL database dump complete
--


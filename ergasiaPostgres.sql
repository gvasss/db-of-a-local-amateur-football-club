--
--1.1
--

---- TABLE TEAM ----

CREATE TABLE IF NOT EXISTS public."team"
(
    "TEAM_ID" integer NOT NULL,
    "NAME" character varying COLLATE pg_catalog."default" NOT NULL,
    "STADIUM" character varying COLLATE pg_catalog."default",
    "DSCR" character varying COLLATE pg_catalog."default",
    "HOME_WINS" integer,
    "AWAY_WINS" integer,
    "HOME_LOSSES" integer,
    "AWAY_LOSSES" integer,
    "HOME_DRAWS" integer,
    "AWAY_DRAWS" integer,
    CONSTRAINT "TEAM_pkey" PRIMARY KEY ("TEAM_ID")
)

-- DATA FOR TEAM

INSERT INTO public."team"(
	"TEAM_ID", "NAME", "STADIUM", "DSCR", "HOME_WINS", "AWAY_WINS", "HOME_LOSSES", "AWAY_LOSSES", "HOME_DRAWS", "AWAY_DRAWS")
	VALUES 
	(6,'Aek','OPAP Arena','Descripsion Aek',2,2,1,1,1,1)
    (2,'Olympiacos','Georgios Karaiskaki','Descripsion Olympiacos',3,1,1,3,0,0)
    (3,'Panathinaikos','Leoforos','Descripsion Panathinaikos',4,4,0,0,0,0)
    (4,'Aris','Dikelidis','Descripsion Aris',3,3,0,0,1,1)
    (5,'Volos','Pannthesaliko','Descripsion Volos',2,2,2,2,0,0);

---- TABLE PLAYER ----

CREATE TABLE IF NOT EXISTS public."player"
(
    "PLAYER_ID" integer NOT NULL,
    "FIRST_NAME" character varying(10) COLLATE pg_catalog."default" NOT NULL,
    "LAST_NAME" character varying(10) COLLATE pg_catalog."default" NOT NULL,
    "TEAM_ID" integer,
    "POSITION" character varying COLLATE pg_catalog."default",
    "YELLOW_CARDS" integer,
    "RED_CARDS" integer,
    "GOALS" integer,
    "MINUTES" integer,
    "ACTIVE" boolean,
    CONSTRAINT "PLAYER_pkey" PRIMARY KEY ("PLAYER_ID"),
    CONSTRAINT "PLAYER_TEAM_ID_fkey" FOREIGN KEY ("TEAM_ID")
        REFERENCES public."TEAM" ("TEAM_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "PLAYER_FIRST_NAME_check" CHECK ("FIRST_NAME"::text ~ '^[[:alnum:][:punct:]]{1,10}$'::text),
    CONSTRAINT "PLAYER_LAST_NAME_check" CHECK ("LAST_NAME"::text ~ '^[[:alnum:][:punct:]]{1,10}$'::text)
)

-- TRIGGER FOR PLAYER

-- Create a trigger function to check the player count for a team (excluding inactive players)
CREATE OR REPLACE FUNCTION PLAYER_COUNT()
  RETURNS TRIGGER AS
$$
DECLARE
  TEAM_COUNT INTEGER;
BEGIN
  -- Get the count of active players for the current team (excluding the coach)
  SELECT COUNT(*) INTO TEAM_COUNT
  FROM public."player"
  WHERE "TEAM_ID" = NEW."TEAM_ID" AND "ACTIVE" = NEW."ACTIVE";

  -- Check if the team already has 11 active players (excluding the coach)
  IF TEAM_COUNT >= 11 THEN
    RAISE EXCEPTION 'Maximum player count reached for the team.';
  END IF;

  RETURN NEW;
END;
$$
LANGUAGE plpgsql;
-- Create a trigger on the PLAYER table to invoke the check_player_count function before insert
CREATE TRIGGER PLAYER_COUNT_TRIGGER
  BEFORE INSERT ON public."player"
  FOR EACH ROW
  EXECUTE FUNCTION PLAYER_COUNT();

-- DATA FOR PLAYER

insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (1, 'Άγγελος', 'Κατσαρός', 1, 'Defensive lineman', 3, 1, 12, 146, 'FALSE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (2, 'Ανδρέας', 'Τζώρτζης', 2, 'Cornerback', 5, 1, 4, 1134, 'FALSE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (3, 'Σταύρος', 'Αργυρός', 3, 'Linebacker', 4, 1, 9, 740, 'FALSE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (4, 'Ηλίας', 'Κατσαρός', 4, 'Safety', 3, 2, 15, 764, 'FALSE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (5, 'Δημήτριος', 'Καράς', 5, 'Linebacker', 1, 1, 8, 393, 'FALSE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (6, 'Μιχαήλ', 'Αργυρός', 1, 'Cornerback', 1, 3, 6, 641, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (7, 'Γεώργιος', 'Λάσκαρης', 2, 'Offensive lineman', 3, 2, 13, 962, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (8, 'Λεωνίδας', 'Ιωάννου', 3, 'Linebacker', 1, 3, 11, 1135, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (9, 'Αντώνιος', 'Σταύρος', 4, 'Offensive lineman', 1, 2, 5, 1545, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (10, 'Βασίλειος', 'Δημητρίου', 5, 'Kicker', 2, 3, 9, 1206, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (11, 'Μιχαήλ', 'Παππάς', 1, 'Kicker', 1, 1, 8, 1419, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (12, 'Μιχαήλ', 'Δημητρίου', 2, 'Defensive lineman', 4, 3, 1, 168, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (13, 'Μιχαήλ', 'Γεωργίου', 3, 'Cornerback', 4, 1, 12, 1644, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (14, 'Γρηγόριος', 'Αργυρός', 4, 'Wide receiver', 3, 1, 12, 843, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (15, 'Χρήστος', 'Παππάς', 5, 'Linebacker', 5, 1, 3, 366, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (16, 'Λεωνίδας', 'Τζώρτζης', 1, 'Tight end', 2, 3, 4, 1055, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (17, 'Βασίλειος', 'Παππάς', 2, 'Tight end', 4, 2, 12, 1615, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (18, 'Σταύρος', 'Δημητρίου', 3, 'Offensive lineman', 4, 2, 8, 1170, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (19, 'Ιωάννης', 'Σταύρος', 4, 'Kicker', 3, 1, 6, 513, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (20, 'Ιωάννης', 'Ανδρεάδης', 5, 'Offensive lineman', 4, 1, 2, 882, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (21, 'Νικόλαος', 'Ανδρεάδης', 1, 'Tight end', 1, 2, 12, 1007, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (22, 'Ιωάννης', 'Μανώλης', 2, 'Quarterback', 3, 2, 15, 44, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (23, 'Κυριάκος', 'Ιωάννου', 3, 'Defensive lineman', 4, 2, 2, 541, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (24, 'Κυριάκος', 'Μαυρίδης', 4, 'Quarterback', 5, 3, 15, 250, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (25, 'Γεώργιος', 'Κούρος', 5, 'Safety', 4, 1, 14, 577, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (26, 'Ηλίας', 'Σταύρος', 1, 'Safety', 5, 1, 7, 1287, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (27, 'Θεόδωρος', 'Λάσκαρης', 2, 'Tight end', 3, 3, 15, 283, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (28, 'Ιωάννης', 'Μανώλης', 3, 'Linebacker', 3, 3, 8, 1799, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (29, 'Βασίλειος', 'Ανδρεάδης', 4, 'Linebacker', 5, 3, 14, 261, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (30, 'Ανδρέας', 'Αργυρός', 5, 'Tight end', 2, 2, 13, 183, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (31, 'Γεώργιος', 'Ιωάννου', 1, 'Tight end', 2, 2, 14, 1800, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (32, 'Αντώνιος', 'Καράς', 2, 'Offensive lineman', 5, 2, 8, 1059, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (33, 'Γρηγόριος', 'Κατσαρός', 3, 'Wide receiver', 3, 1, 13, 615, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (34, 'Πέτρος', 'Κατσαρός', 4, 'Offensive lineman', 4, 3, 7, 1775, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (35, 'Λεωνίδας', 'Αργυρός', 5, 'Offensive lineman', 3, 1, 11, 753, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (36, 'Κώστας', 'Λάσκαρης', 1, 'Defensive lineman', 2, 1, 13, 1036, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (37, 'Στέφανος', 'Ανδρεάδης', 2, 'Tight end', 5, 2, 6, 1285, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (38, 'Αντώνιος', 'Κατσαρός', 3, 'Linebacker', 4, 3, 13, 172, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (39, 'Βασίλειος', 'Παππάς', 4, 'Wide receiver', 5, 1, 15, 392, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (40, 'Δημήτριος', 'Πετρίδης', 5, 'Linebacker', 2, 2, 5, 1408, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (41, 'Ιωάννης', 'Μανώλης', 1, 'Kicker', 3, 3, 1, 901, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (42, 'Πέτρος', 'Πετρίδης', 2, 'Safety', 5, 2, 12, 596, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (43, 'Γεώργιος', 'Καράς', 3, 'Offensive lineman', 3, 3, 14, 902, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (44, 'Αθανάσιος', 'Μαυρίδης', 4, 'Defensive lineman', 2, 3, 13, 1787, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (45, 'Κώστας', 'Δημητρίου', 5, 'Tight end', 5, 1, 1, 844, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (46, 'Κυριάκος', 'Λάσκαρης', 1, 'Running back', 4, 3, 13, 687, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (47, 'Ιωάννης', 'Αργυρός', 2, 'Offensive lineman', 5, 1, 10, 1024, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (48, 'Κώστας', 'Γεωργίου', 3, 'Quarterback', 3, 2, 15, 206, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (49, 'Βασίλειος', 'Μαυρίδης', 4, 'Kicker', 3, 3, 5, 938, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (50, 'Αντώνιος', 'Καράς', 5, 'Running back', 4, 1, 11, 1218, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (51, 'Κώστας', 'Λάσκαρης', 1, 'Offensive lineman', 2, 1, 3, 1632, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (52, 'Πέτρος', 'Παππάς', 2, 'Linebacker', 5, 2, 8, 1800, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (53, 'Νικόλαος', 'Αργυρός', 3, 'Cornerback', 4, 1, 12, 275, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (54, 'Δημήτριος', 'Κούρος', 4, 'Linebacker', 2, 1, 3, 1310, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (55, 'Σταύρος', 'Ανδρεάδης', 5, 'Wide receiver', 4, 3, 13, 1533, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (56, 'Άγγελος', 'Παππάς', 1, 'Quarterback', 2, 2, 6, 782, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (57, 'Γεώργιος', 'Κούρος', 2, 'Cornerback', 3, 3, 7, 633, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (58, 'Μάριος', 'Μανώλης', 3, 'Defensive lineman', 2, 1, 11, 1168, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (59, 'Θεόδωρος', 'Αργυρός', 4, 'Kicker', 4, 1, 9, 469, 'TRUE');
insert into public."player" ("PLAYER_ID", "FIRST_NAME", "LAST_NAME", "TEAM_ID", "POSITION", "YELLOW_CARDS", "RED_CARDS", "GOALS", "MINUTES", "ACTIVE") values (60, 'Γρηγόριος', 'Σταύρος', 5, 'Offensive lineman', 1, 2, 4, 6, 'TRUE');

---- TABLE COACH ----

CREATE TABLE IF NOT EXISTS public."coach"
(
    "COACH_ID" integer NOT NULL,
    "PLAYER_ID" integer NOT NULL,
    "TEAM_ID" integer NOT NULL,
    CONSTRAINT "COACH_pkey" PRIMARY KEY ("COACH_ID"),
    CONSTRAINT "COACH_PLAYER_ID_fkey" FOREIGN KEY ("PLAYER_ID")
        REFERENCES public."PLAYER" ("PLAYER_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "COACH_TEAM_ID_fkey" FOREIGN KEY ("TEAM_ID")
        REFERENCES public."TEAM" ("TEAM_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- DATA FPR COACH

insert into public."coach" ("COACH_ID", "PLAYER_ID", "TEAM_ID") values (1, 1, 1);
insert into public."coach" ("COACH_ID", "PLAYER_ID", "TEAM_ID") values (2, 2, 2);
insert into public."coach" ("COACH_ID", "PLAYER_ID", "TEAM_ID") values (3, 3, 3);
insert into public."coach" ("COACH_ID", "PLAYER_ID", "TEAM_ID") values (4, 4, 4);
insert into public."coach" ("COACH_ID", "PLAYER_ID", "TEAM_ID") values (5, 5, 5);

---- TABLE MATCH ----

CREATE TABLE IF NOT EXISTS public."match"
(
    "MATCH_ID" integer NOT NULL,
    "HOME_TEAM_ID" integer NOT NULL,
    "AWAY_TEAM_ID" integer NOT NULL,
    "HOME_SCORE" integer,
    "AWAY_SCORE" integer,
    "MATCH_DATE" date[],
    CONSTRAINT "MATCH_pkey" PRIMARY KEY ("MATCH_ID"),
	CONSTRAINT "UNQ_TEAM_MATCH_DATE" UNIQUE ("HOME_TEAM_ID", "AWAY_TEAM_ID", "MATCH_DATE")
)

-- TRIGGER FOR MATCH

-- Create a trigger function
CREATE OR REPLACE FUNCTION check_match_date()
    RETURNS TRIGGER AS
$$
DECLARE
    last_match_date date;
	date_diff interval;
	comparison_interval INTERVAL := INTERVAL '10';
BEGIN
    -- Retrieve the date of the last match for the home team/home team
    SELECT MAX("MATCH_DATE")
    INTO last_match_date
    FROM public."match"
    WHERE "HOME_TEAM_ID" = NEW."HOME_TEAM_ID";

    -- Check if there is a 10-day gap between the last match and the new match
    IF last_match_date IS NOT NULL THEN
        SELECT NEW."MATCH_DATE" - last_match_date INTO date_diff;
		RAISE NOTICE 'Last match date for home team/home team: %', last_match_date;
        RAISE NOTICE 'New match date for home team/home team: %', NEW."MATCH_DATE";
        RAISE NOTICE 'Date difference: %', comparison_interval;
		RAISE NOTICE 'Date difference: %', date_diff;

        IF date_diff < comparison_interval THEN
            RAISE EXCEPTION 'There must be a 10-day gap between matches for the home team/home team.';
        END IF;
    END IF;
	
	-- Retrieve the date of the last match for the home team/away team
	SELECT MAX("MATCH_DATE")
    INTO last_match_date
    FROM public."match"
    WHERE "AWAY_TEAM_ID" = NEW."HOME_TEAM_ID";

    -- Check if there is a 10-day gap between the last match and the new match
    IF last_match_date IS NOT NULL THEN
        SELECT NEW."MATCH_DATE" - last_match_date INTO date_diff;
		RAISE NOTICE 'New match date for home team/home team: %', NEW."MATCH_DATE";
        IF date_diff < comparison_interval THEN
            RAISE EXCEPTION 'There must be a 10-day gap between matches for the home team/away team.';
        END IF;
    END IF;
	
    -- Retrieve the date of the last match for the away team/home team
    SELECT MAX("MATCH_DATE")
    INTO last_match_date
    FROM public."match"
    WHERE "HOME_TEAM_ID" = NEW."AWAY_TEAM_ID";

    -- Check if there is a 10-day gap between the last match and the new match
    IF last_match_date IS NOT NULL THEN
        SELECT NEW."MATCH_DATE" - last_match_date INTO date_diff;
		RAISE NOTICE 'New match date for home team/home team: %', NEW."MATCH_DATE";
        IF date_diff < comparison_interval THEN
            RAISE EXCEPTION 'There must be a 10-day gap between matches for the away team/home team.';
        END IF;
    END IF;
	
	-- Retrieve the date of the last match for the away team/away team
    SELECT MAX("MATCH_DATE")
    INTO last_match_date
    FROM public."match"
    WHERE "AWAY_TEAM_ID" = NEW."AWAY_TEAM_ID";

    -- Check if there is a 10-day gap between the last match and the new match
    IF last_match_date IS NOT NULL THEN
        SELECT NEW."MATCH_DATE" - last_match_date INTO date_diff;
		RAISE NOTICE 'New match date for home team/home team: %', NEW."MATCH_DATE";
        IF date_diff < comparison_interval THEN
            RAISE EXCEPTION 'There must be a 10-day gap between matches for the away team/away team.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER enforce_10_day_gap
    BEFORE INSERT ON public."match"
    FOR EACH ROW
    EXECUTE FUNCTION check_match_date();

-- DATA FOR MATCH

insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (1, 1, 2, 2, 2, '11/09/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (2, 1, 3, 4, 2, '21/09/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (3, 1, 4, 3, 1, '01/10/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (4, 1, 5, 4, 2, '11/10/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (5, 2, 1, 5, 3, '21/10/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (6, 2, 3, 5, 5, '10/11/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (7, 2, 4, 3, 1, '20/11/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (8, 2, 5, 5, 2, '30/11/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (9, 3, 1, 1, 5, '10/12/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (10, 3, 2, 1, 3, '20/12/2022');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (11, 3, 4, 1, 5, '09/01/2023');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (12, 3, 5, 3, 1, '19/01/2023');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (13, 4, 1, 2, 1, '29/01/2023');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (14, 4, 2, 4, 2, '08/02/2023');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (15, 4, 3, 5, 4, '18/02/2023');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (16, 4, 5, 1, 4, '10/03/2023');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (17, 5, 1, 1, 5, '20/03/2023');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (18, 5, 2, 5, 3, '30/03/2023');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (19, 5, 3, 3, 4, '09/04/2023');
insert into public."match" ("MATCH_ID", "HOME_TEAM_ID", "AWAY_TEAM_ID", "HOME_SCORE", "AWAY_SCORE", "MATCH_DATE") values (20, 5, 4, 2, 3, '19/04/2023');

---- TABLE PLAYER_STAT ----

CREATE TABLE IF NOT EXISTS public."player_stat"
(
    "STAT_ID" integer NOT NULL,
    "PLAYER_ID" integer NOT NULL,
    "MATCH_ID" integer NOT NULL,
    "MINUTES" integer NOT NULL,
    "TIME" integer NOT NULL,
    "GOAL" integer,
    "GOAL_CANCEL" integer,
    "YELLOW_CARD" integer,
    "RED_CARD" integer,
    "PENALTY" integer,
    "CORNER" integer,
    CONSTRAINT "PLAYER_STAT_pkey" PRIMARY KEY ("STAT_ID", "PLAYER_ID", "MATCH_ID"),
    CONSTRAINT "PLAYER_STAT_MATCH_ID_fkey" FOREIGN KEY ("MATCH_ID")
        REFERENCES public."match" ("MATCH_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "PLAYER_STAT_PLAYER_ID_fkey" FOREIGN KEY ("PLAYER_ID")
        REFERENCES public."player" ("PLAYER_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "PLAYER_STAT_check" CHECK ("GOAL" IS NOT NULL AND "GOAL_CANCEL" IS NULL AND "YELLOW_CARD" IS NULL AND "RED_CARD" IS NULL AND "PENALTY" IS NULL AND "CORNER" IS NULL OR "GOAL" IS NULL),
    CONSTRAINT "PLAYER_STAT_check1" CHECK ("GOAL" IS NULL AND "GOAL_CANCEL" IS NOT NULL AND "YELLOW_CARD" IS NULL AND "RED_CARD" IS NULL AND "PENALTY" IS NULL AND "CORNER" IS NULL OR "GOAL_CANCEL" IS NULL),
    CONSTRAINT "PLAYER_STAT_check2" CHECK ("GOAL" IS NULL AND "GOAL_CANCEL" IS NULL AND "YELLOW_CARD" IS NOT NULL AND "RED_CARD" IS NULL AND "PENALTY" IS NULL AND "CORNER" IS NULL OR "YELLOW_CARD" IS NULL),
    CONSTRAINT "PLAYER_STAT_check3" CHECK ("GOAL" IS NULL AND "GOAL_CANCEL" IS NULL AND "YELLOW_CARD" IS NULL AND "RED_CARD" IS NOT NULL AND "PENALTY" IS NULL AND "CORNER" IS NULL OR "RED_CARD" IS NULL),
    CONSTRAINT "PLAYER_STAT_check4" CHECK ("GOAL" IS NULL AND "GOAL_CANCEL" IS NULL AND "YELLOW_CARD" IS NULL AND "RED_CARD" IS NULL AND "PENALTY" IS NOT NULL AND "CORNER" IS NULL OR "PENALTY" IS NULL),
    CONSTRAINT "PLAYER_STAT_check5" CHECK ("GOAL" IS NULL AND "GOAL_CANCEL" IS NULL AND "YELLOW_CARD" IS NULL AND "RED_CARD" IS NULL AND "PENALTY" IS NULL AND "CORNER" IS NOT NULL OR "CORNER" IS NULL)
)

-- DATA FOR PLAYER_STAT

insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (1, 18, 20, 40, 43, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (2, 20, 14, 28, 84, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (3, 42, 11, 79, 22, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (4, 30, 5, 54, 1, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (5, 20, 15, 61, 42, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (6, 55, 9, 65, 52, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (7, 9, 16, 84, 37, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (8, 41, 15, 3, 14, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (9, 12, 6, 4, 54, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (10, 59, 13, 85, 42, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (11, 32, 15, 29, 81, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (12, 21, 1, 45, 20, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (13, 41, 8, 26, 64, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (14, 34, 20, 13, 17, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (15, 39, 2, 39, 54, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (16, 6, 16, 33, 26, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (17, 46, 12, 82, 66, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (18, 38, 18, 36, 53, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (19, 53, 2, 28, 59, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (20, 7, 16, 22, 71, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (21, 27, 6, 36, 40, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (22, 17, 17, 77, 56, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (23, 26, 16, 21, 31, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (24, 41, 1, 27, 53, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (25, 49, 16, 5, 5, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (26, 28, 20, 2, 53, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (27, 22, 7, 3, 3, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (28, 5, 7, 59, 31, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (29, 25, 16, 80, 34, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (30, 40, 20, 84, 89, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (31, 52, 13, 19, 20, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (32, 29, 9, 31, 57, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (33, 6, 14, 59, 5, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (34, 19, 4, 20, 64, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (35, 50, 8, 48, 84, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (36, 39, 14, 52, 41, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (37, 52, 17, 18, 61, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (38, 18, 10, 1, 12, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (39, 29, 17, 60, 50, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (40, 23, 12, 84, 55, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (41, 47, 10, 17, 89, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (42, 7, 1, 84, 59, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (43, 54, 12, 36, 83, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (44, 38, 11, 9, 21, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (45, 56, 7, 66, 24, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (46, 28, 6, 65, 18, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (47, 48, 2, 45, 12, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (48, 54, 3, 26, 87, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (49, 23, 5, 10, 86, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (50, 38, 14, 36, 12, null, null, 1, null, null, null);

insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (51, 6, 1, 84, 55, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (52, 11, 1, 81, 89, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (53, 16, 1, 84, 59, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (54, 21, 1, 36, 83, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (55, 26, 1, 90, 21, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (56, 31, 1, 66, 24, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (57, 36, 1, 65, 18, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (58, 41, 1, 45, 12, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (59, 46, 1, 75, 87, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (60, 51, 1, 90, 86, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (61, 56, 1, 36, 12, null, null, 1, null, null, null);

insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (62, 7, 1, 84, 55, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (63, 12, 1, 81, 89, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (64, 17, 1, 84, 59, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (65, 22, 1, 36, 83, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (66, 27, 1, 90, 21, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (67, 32, 1, 66, 24, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (68, 37, 1, 65, 18, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (69, 41, 1, 45, 12, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (70, 47, 1, 75, 87, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (71, 52, 1, 90, 86, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (72, 57, 1, 36, 12, null, null, 1, null, null, null);

insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (73, 8, 11, 84, 55, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (74, 13, 11, 81, 89, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (75, 18, 11, 84, 59, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (76, 23, 11, 36, 83, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (77, 28, 11, 90, 21, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (78, 33, 11, 66, 24, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (79, 38, 11, 65, 18, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (80, 43, 11, 45, 12, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (81, 48, 11, 75, 87, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (82, 53, 11, 90, 86, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (83, 58, 11, 36, 12, null, null, 1, null, null, null);

insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (84, 9, 11, 84, 55, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (85, 14, 11, 81, 89, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (86, 19, 11, 84, 59, null, null, null, null, null, 1);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (87, 24, 11, 36, 83, null, null, null, null, 1, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (88, 29, 11, 90, 21, null, null, null, 1, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (89, 34, 11, 66, 24, null, null, 1, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (90, 39, 11, 65, 18, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (91, 44, 11, 45, 12, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (92, 49, 11, 75, 87, 1, null, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (93, 54, 11, 90, 86, null, 1, null, null, null, null);
insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (94, 59, 11, 36, 12, null, null, 1, null, null, null);

insert into public."player_stat" ("STAT_ID", "PLAYER_ID", "MATCH_ID", "MINUTES", "TIME", "GOAL", "GOAL_CANCEL", "YELLOW_CARD", "RED_CARD", "PENALTY", "CORNER") values (95, 41, 1, 45, 20, 1, null, null, null, null, null);



--
--1.3.a
--
CREATE OR REPLACE VIEW public."MATCH_SCHEDULE" AS
SELECT
    M."MATCH_DATE",
    TH."STADIUM" AS STADIUM,
    TH."NAME" AS HOME_TEAM,
    TA."NAME" AS AWAY_TEAM,
    M."HOME_SCORE",
    M."AWAY_SCORE",
    NULL AS PLAYER_NAME,
    NULL AS POSITION,
    NULL AS MINUTES,
    NULL AS "GOAL(MINUTES)",
    NULL AS YELLOW_CARD,
    NULL AS RED_CARD,
    HP.HOME_PLAYERS,
    AP.AWAY_PLAYERS
FROM
    "match" M
    INNER JOIN "team" TH ON M."HOME_TEAM_ID" = TH."TEAM_ID"
    INNER JOIN "team" TA ON M."AWAY_TEAM_ID" = TA."TEAM_ID"
    LEFT JOIN (
        SELECT PH."TEAM_ID", STRING_AGG(PH."FIRST_NAME" || ' ' || PH."LAST_NAME", ', ') AS HOME_PLAYERS
        FROM "player" PH
        GROUP BY PH."TEAM_ID"
    ) HP ON HP."TEAM_ID" = TH."TEAM_ID"
    LEFT JOIN (
        SELECT PA."TEAM_ID", STRING_AGG(PA."FIRST_NAME" || ' ' || PA."LAST_NAME", ', ') AS AWAY_PLAYERS
        FROM "player" PA
        GROUP BY PA."TEAM_ID"
    ) AP ON AP."TEAM_ID" = TA."TEAM_ID"
WHERE
    M."MATCH_DATE" = '2022-09-11'
GROUP BY
    M."MATCH_DATE",
    TH."STADIUM",
    TH."NAME",
    TA."NAME",
    M."HOME_SCORE",
    M."AWAY_SCORE",
    HP.HOME_PLAYERS,
    AP.AWAY_PLAYERS

UNION ALL

SELECT
    M."MATCH_DATE",
    TH."STADIUM" AS STADIUM,
    CASE WHEN P."TEAM_ID" = M."HOME_TEAM_ID" THEN TH."NAME" ELSE NULL END AS HOME_TEAM,
    CASE WHEN P."TEAM_ID" = M."AWAY_TEAM_ID" THEN TA."NAME" ELSE NULL END AS AWAY_TEAM,
    NULL AS HOME_SCORE,
    NULL AS AWAY_SCORE,
    P."FIRST_NAME" || ' ' || P."LAST_NAME" AS PLAYER_NAME,
    P."POSITION",
	PS."MINUTES",
	CONCAT(
        PS."GOAL",
        CASE WHEN PS."GOAL" IS NOT NULL AND PS."RED_CARD" IS NULL THEN ' (' || PS."TIME" || ')' END
    ) AS "GOAL(MINUTES)",
    PS."YELLOW_CARD",
    PS."RED_CARD",
	NULL AS HOME_PLAYERS,
    NULL AS AWAY_PLAYERS
FROM
    "match" M
    INNER JOIN "team" TH ON M."HOME_TEAM_ID" = TH."TEAM_ID"
    INNER JOIN "team" TA ON M."AWAY_TEAM_ID" = TA."TEAM_ID"
    LEFT JOIN "player_stat" PS ON M."MATCH_ID" = PS."MATCH_ID"
    LEFT JOIN "player" P ON PS."PLAYER_ID" = P."PLAYER_ID"
WHERE
    M."MATCH_DATE" = '2022-09-11'
	AND (PS."GOAL" IS NOT NULL OR PS."RED_CARD" IS NOT NULL OR PS."YELLOW_CARD" IS NOT NULL)
GROUP BY
    M."MATCH_DATE",
    TH."STADIUM",
    TH."NAME",
    TA."NAME",
	CASE WHEN P."TEAM_ID" = M."HOME_TEAM_ID" THEN TH."NAME" ELSE NULL END,
    CASE WHEN P."TEAM_ID" = M."AWAY_TEAM_ID" THEN TA."NAME" ELSE NULL END,
    PS."GOAL",
    PS."TIME",
    P."FIRST_NAME",
    P."LAST_NAME",
    PS."MINUTES",
    P."POSITION",
    PS."YELLOW_CARD",
    PS."RED_CARD";

--
--1.3.b
--
CREATE VIEW "ANUAL_FOOTBALL_CHAMPIONSHIP" AS
SELECT
  m."MATCH_DATE",
  TH."NAME" AS "HOME_TEAM",
  TA."NAME" AS "AWAY_TEAM",
  TH."STADIUM" AS "STADIUM",
  m."HOME_SCORE",
  m."AWAY_SCORE"
FROM
  public."match" m
JOIN
  public."team" TH ON m."HOME_TEAM_ID" = TH."TEAM_ID"
JOIN
  public."team" TA ON m."AWAY_TEAM_ID" = TA."TEAM_ID"
WHERE
  m."MATCH_DATE" BETWEEN '{2022-09-01}' AND '{2023-06-30}';


--
--2.1
--
SELECT p."FIRST_NAME" || ' ' || p."LAST_NAME" AS "ΠΡΟΠΟΝΗΤΗΣ"
FROM "match" m
JOIN "player" p ON m."HOME_TEAM_ID" = p."TEAM_ID" OR m."AWAY_TEAM_ID" = p."TEAM_ID"
WHERE m."MATCH_ID" = 1
  AND p."TEAM_ID" = 1 AND p."ACTIVE" = false

--
--2.2
--
SELECT
  p."FIRST_NAME" || ' ' || p."LAST_NAME" AS "ΠΑΙΚΤΗΣ",
  ps."TIME" AS "ΧΡΟΝΙΚΗ_ΣΤΙΓΜΗ",
  ps."GOAL" AS "ΓΚΟΛ",
  ps."PENALTY" AS "ΠΕΝΑΛΤΙ"
FROM
  public."player_stat" ps
JOIN
  public."player" p ON ps."PLAYER_ID" = p."PLAYER_ID"
WHERE
  ps."MATCH_ID" = 1
  AND (ps."GOAL" IS NOT NULL OR ps."PENALTY" IS NOT NULL);

--
--2.3
--
SELECT
  SUM(ps."GOAL") AS "ΣΥΝΟΛΟ_ΓΚΟΛ",
  SUM(ps."PENALTY") AS "ΣΥΝΟΛΟ_ΠΕΝΑΛΤΙ",
  SUM(ps."YELLOW_CARD") || ' / ' || SUM(ps."RED_CARD") AS "ΚΙΤΡΙΝΕΣ_ΚΑΡΤΕΣ / ΚΟΚΚΙΝΕΣ_ΚΑΡΤΕΣ",
  SUM(ps."MINUTES") AS "ΣΥΝΟΛΟ_ΛΕΠΤΑ_ΑΓΩΝΑ",
  p."POSITION" AS "ΘΕΣΗ_ΠΑΙΚΤΗ"
FROM
  public."player_stat" ps
JOIN
  public."player" p ON ps."PLAYER_ID" = p."PLAYER_ID"
WHERE
  p."PLAYER_ID" = 18
GROUP BY
  p."POSITION";

--
-- 2.4
--
SELECT
  COUNT(*) AS "ΣΥΝΟΛΙΚΟΙ_ΑΓΩΝΕΣ",
  SUM(CASE WHEN m."HOME_TEAM_ID" = 1 THEN 1 ELSE 0 END) AS "ΓΗΠΕΔΟΥΧΟΣ",
  SUM(CASE WHEN m."AWAY_TEAM_ID" = 1 THEN 1 ELSE 0 END) AS "ΦΙΛΟΞΕΝΟΥΜΕΝΟΣ",
  SUM(CASE WHEN m."HOME_TEAM_ID" = 1 AND m."HOME_SCORE" > m."AWAY_SCORE" THEN 1
           WHEN m."AWAY_TEAM_ID" = 1 AND m."AWAY_SCORE" > m."HOME_SCORE" THEN 1
           ELSE 0 END) AS "ΝΙΚΕΣ",	      
  SUM(CASE WHEN m."HOME_TEAM_ID" = 1 AND m."HOME_SCORE" < m."AWAY_SCORE" THEN 1
           WHEN m."AWAY_TEAM_ID" = 1 AND m."AWAY_SCORE" < m."HOME_SCORE" THEN 1
           ELSE 0 END) AS "ΑΡΙΘΜΟΣ_ΗΤΤΕΣ",
  SUM(CASE WHEN m."HOME_TEAM_ID" = 1 AND m."HOME_SCORE" = m."AWAY_SCORE" THEN 1
           WHEN m."AWAY_TEAM_ID" = 1 AND m."AWAY_SCORE" = m."HOME_SCORE" THEN 1
           ELSE 0 END) AS "ΙΣΟΠΑΛΙΕΣ",   	   
  SUM(CASE WHEN m."HOME_TEAM_ID" = 1 AND m."HOME_SCORE" > m."AWAY_SCORE" THEN 1 ELSE 0 END) AS "ΝΙΚΕΣ_ΕΝΤΟΣ",
  SUM(CASE WHEN m."HOME_TEAM_ID" = 1 AND m."HOME_SCORE" < m."AWAY_SCORE" THEN 1 ELSE 0 END) AS "ΗΤΤΕΣ_ΕΝΤΟΣ",
  SUM(CASE WHEN m."HOME_TEAM_ID" = 1 AND m."HOME_SCORE" = m."AWAY_SCORE" THEN 1 ELSE 0 END) AS "ΙΣΟΠΑΛΙΕΣ_ΕΝΤΟΣ",
  SUM(CASE WHEN m."AWAY_TEAM_ID" = 1 AND m."AWAY_SCORE" > m."HOME_SCORE" THEN 1 ELSE 0 END) AS "ΝΙΚΕΣ_ΕΚΤΟΣ",
  SUM(CASE WHEN m."AWAY_TEAM_ID" = 1 AND m."AWAY_SCORE" < m."HOME_SCORE" THEN 1 ELSE 0 END) AS "ΗΤΤΕΣ_ΕΚΤΟΣ",
  SUM(CASE WHEN m."AWAY_TEAM_ID" = 1 AND m."AWAY_SCORE" = m."HOME_SCORE" THEN 1 ELSE 0 END) AS "ΙΣΟΠΑΛΙΕΣ_ΕΚΤΟΣ"
FROM public."match" AS m
WHERE
  (m."HOME_TEAM_ID" = 1 OR m."AWAY_TEAM_ID" = 1);  


--
--3.1
--
CREATE TABLE IF NOT EXISTS public."DELETED_TEAM"
(
    "TEAM_ID" integer,
    "NAME" character varying COLLATE pg_catalog."default" NOT NULL,
    "STADIUM" character varying COLLATE pg_catalog."default",
    "DSCR" character varying COLLATE pg_catalog."default",
    "HOME_WINS" integer,
    "AWAY_WINS" integer,
    "HOME_LOSSES" integer,
    "AWAY_LOSSES" integer,
    "HOME_DRAWS" integer,
    "AWAY_DRAWS" integer,
    CONSTRAINT "DELETE_TEAM_pkey" PRIMARY KEY ("TEAM_ID")
);

-- Δημιουργία trigger
CREATE OR REPLACE FUNCTION "TEAM_DELETE_TRIGGER"()
    RETURNS TRIGGER AS $$
BEGIN
    -- Εισαγωγή διαγραμμένων γραμμών στον table DELETED_TEAM
    INSERT INTO public."DELETED_TEAM" ("TEAM_ID", "NAME", "STADIUM", "DSCR", "HOME_WINS", "AWAY_WINS", "HOME_LOSSES", "AWAY_LOSSES", "HOME_DRAWS", "AWAY_DRAWS")
    VALUES (OLD."TEAM_ID", OLD."NAME", OLD."STADIUM", OLD."DSCR", OLD."HOME_WINS", OLD."AWAY_WINS", OLD."HOME_LOSSES", OLD."AWAY_LOSSES", OLD."HOME_DRAWS", OLD."AWAY_DRAWS");

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Σύνδεση του trigger με τον table "TEAM"
CREATE TRIGGER "TEAM_DELETE_TRIGGER"
AFTER DELETE ON public."TEAM"
FOR EACH ROW
EXECUTE FUNCTION "TEAM_DELETE_TRIGGER"();

--
--3.2
--
DECLARE
  cur CURSOR FOR
    SELECT "ΠΑΙΚΤΗΣ", "ΧΡΟΝΙΚΟ_ΔΙΑΣΤΗΜΑ", "ΟΜΑΔΑ", "ΑΓΩΝΑΣ", SUM("ΓΚΟΛ") AS "ΣΥΝΟΛΟ_ΓΚΟΛ",
           SUM("ΠΕΝΑΛΤΙ") AS "ΣΥΝΟΛΟ_ΠΕΝΑΛΤΙ", SUM("ΚΑΡΤΕΣ") AS "ΣΥΝΟΛΟ_ΚΑΡΤΕΣ",
           SUM("ΛΕΠΤΑ_ΑΓΩΝΑ") AS "ΣΥΝΟΛΟ_ΛΕΠΤΑ", ARRAY_AGG("ΘΕΣΗ") AS "ΘΕΣΗ"
    FROM "ΣΤΑΤΙΣΤΙΚΑ_ΠΑΙΚΤΩΝ"
    GROUP BY "ΠΑΙΚΤΗΣ", "ΧΡΟΝΙΚΟ_ΔΙΑΣΤΗΜΑ", "ΟΜΑΔΑ", "ΑΓΩΝΑΣ";

  rec RECORD;
  counter INT := 0;

BEGIN
  OPEN cur;

  LOOP
    FETCH cur INTO rec;

    EXIT WHEN NOT FOUND;

    counter := counter + 1;

    -- Εμφανίζουμε τις γραμμές σε ομάδες των 10
    IF counter MOD 10 = 1 THEN
      RAISE NOTICE '----------------- Ομάδα % -----------------', counter / 10;
    END IF;

    -- Εμφανίζουμε τα στατιστικά στοιχεία του παίκτη
    RAISE NOTICE 'Παίκτης: %, Χρονικό Διάστημα: %, Ομάδα: %, Αγώνας: %',
                 rec."ΠΑΙΚΤΗΣ", rec."ΧΡΟΝΙΚΟ_ΔΙΑΣΤΗΜΑ", rec."ΟΜΑΔΑ", rec."ΑΓΩΝΑΣ";
    RAISE NOTICE 'Σύνολο Γκολ: %, Σύνολο Πέναλτι: %, Σύνολο Κάρτες: %, Σύνολο Λεπτά Αγώνα: %',
                 rec."ΣΥΝΟΛΟ_ΓΚΟΛ", rec."ΣΥΝΟΛΟ_ΠΕΝΑΛΤΙ", rec."ΣΥΝΟΛΟ_ΚΑΡΤΕΣ", rec."ΣΥΝΟΛΟ_ΛΕΠΤΑ";
    RAISE NOTICE 'Θέσεις: %', rec."ΘΕΣΗ";

  END LOOP;

  CLOSE cur;
END;
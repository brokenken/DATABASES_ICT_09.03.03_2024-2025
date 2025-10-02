--
-- PostgreSQL database dump
--

\restrict VJogjMaY2JkmOy6kbs8ZKr1SJHFHL2FVvubjJVryMUmvAY966AaZCw9hVz9mNnQ

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-10-02 12:17:15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 16810)
-- Name: hotel_schema; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA hotel_schema;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 229 (class 1259 OID 16870)
-- Name: amenity; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.amenity (
    amenity_id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 16869)
-- Name: amenity_amenity_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.amenity_amenity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 228
-- Name: amenity_amenity_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.amenity_amenity_id_seq OWNED BY hotel_schema.amenity.amenity_id;


--
-- TOC entry 247 (class 1259 OID 17022)
-- Name: dailyroomstatus; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.dailyroomstatus (
    drs_id integer NOT NULL,
    room_id integer NOT NULL,
    status_date date NOT NULL,
    status character varying(20) NOT NULL,
    price_for_date numeric(10,2),
    promotion_id integer,
    CONSTRAINT dailyroomstatus_status_check CHECK (((status)::text = ANY ((ARRAY['free'::character varying, 'booked'::character varying, 'occupied'::character varying, 'out_of_service'::character varying])::text[])))
);


--
-- TOC entry 219 (class 1259 OID 16812)
-- Name: hotel; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.hotel (
    hotel_id integer NOT NULL,
    name character varying(100) NOT NULL,
    address character varying(200) NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16828)
-- Name: room; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.room (
    room_id integer NOT NULL,
    hotel_id integer NOT NULL,
    room_number character varying(10) NOT NULL,
    room_type_id integer NOT NULL,
    is_available boolean DEFAULT true
);


--
-- TOC entry 221 (class 1259 OID 16819)
-- Name: roomtype; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.roomtype (
    room_type_id integer NOT NULL,
    type_name character varying(50),
    capacity integer NOT NULL,
    CONSTRAINT roomtype_capacity_check CHECK ((capacity > 0)),
    CONSTRAINT roomtype_type_name_check CHECK (((type_name)::text = ANY ((ARRAY['стандарт'::character varying, 'люкс'::character varying])::text[])))
);


--
-- TOC entry 248 (class 1259 OID 17041)
-- Name: availableroomsforagents; Type: VIEW; Schema: hotel_schema; Owner: -
--

CREATE VIEW hotel_schema.availableroomsforagents AS
 SELECT h.name AS hotel_name,
    h.address,
    r.room_number,
    rt.type_name,
    rt.capacity,
    drs.price_for_date,
    drs.status_date
   FROM (((hotel_schema.dailyroomstatus drs
     JOIN hotel_schema.room r ON ((drs.room_id = r.room_id)))
     JOIN hotel_schema.roomtype rt ON ((r.room_type_id = rt.room_type_id)))
     JOIN hotel_schema.hotel h ON ((r.hotel_id = h.hotel_id)))
  WHERE (((drs.status)::text = 'free'::text) AND (drs.status_date = CURRENT_DATE));


--
-- TOC entry 234 (class 1259 OID 16901)
-- Name: booking; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.booking (
    booking_id integer NOT NULL,
    room_id integer NOT NULL,
    guest_id integer NOT NULL,
    checkin_date date NOT NULL,
    checkout_date date NOT NULL,
    status character varying(20),
    promotion_id integer,
    CONSTRAINT booking_status_check CHECK (((status)::text = ANY ((ARRAY['booked'::character varying, 'checked_in'::character varying, 'checked_out'::character varying, 'cancelled'::character varying])::text[])))
);


--
-- TOC entry 233 (class 1259 OID 16900)
-- Name: booking_booking_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.booking_booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 233
-- Name: booking_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.booking_booking_id_seq OWNED BY hotel_schema.booking.booking_id;


--
-- TOC entry 242 (class 1259 OID 16972)
-- Name: cleaningschedule; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.cleaningschedule (
    cleaning_id integer NOT NULL,
    room_id integer NOT NULL,
    cleaning_date date NOT NULL,
    status character varying(20) NOT NULL,
    maid_id integer NOT NULL,
    CONSTRAINT cleaningschedule_status_check CHECK (((status)::text = ANY ((ARRAY['убран'::character varying, 'не убран'::character varying])::text[])))
);


--
-- TOC entry 241 (class 1259 OID 16971)
-- Name: cleaningschedule_cleaning_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.cleaningschedule_cleaning_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 241
-- Name: cleaningschedule_cleaning_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.cleaningschedule_cleaning_id_seq OWNED BY hotel_schema.cleaningschedule.cleaning_id;


--
-- TOC entry 246 (class 1259 OID 17021)
-- Name: dailyroomstatus_drs_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.dailyroomstatus_drs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 246
-- Name: dailyroomstatus_drs_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.dailyroomstatus_drs_id_seq OWNED BY hotel_schema.dailyroomstatus.drs_id;


--
-- TOC entry 236 (class 1259 OID 16924)
-- Name: employee; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.employee (
    employee_id integer NOT NULL,
    hotel_id integer NOT NULL,
    full_name character varying(150) NOT NULL,
    "position" character varying(50) NOT NULL,
    rate_count integer NOT NULL,
    CONSTRAINT employee_rate_count_check CHECK ((rate_count >= 1))
);


--
-- TOC entry 235 (class 1259 OID 16923)
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.employee_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 235
-- Name: employee_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.employee_employee_id_seq OWNED BY hotel_schema.employee.employee_id;


--
-- TOC entry 240 (class 1259 OID 16955)
-- Name: employmentcontract; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.employmentcontract (
    contract_id integer NOT NULL,
    employee_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    contract_number character varying(100),
    is_fixed_term boolean DEFAULT false,
    terms text
);


--
-- TOC entry 239 (class 1259 OID 16954)
-- Name: employmentcontract_contract_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.employmentcontract_contract_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 239
-- Name: employmentcontract_contract_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.employmentcontract_contract_id_seq OWNED BY hotel_schema.employmentcontract.contract_id;


--
-- TOC entry 232 (class 1259 OID 16894)
-- Name: guest; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.guest (
    guest_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    patronymic character varying(50),
    address character varying(200)
);


--
-- TOC entry 231 (class 1259 OID 16893)
-- Name: guest_guest_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.guest_guest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 231
-- Name: guest_guest_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.guest_guest_id_seq OWNED BY hotel_schema.guest.guest_id;


--
-- TOC entry 218 (class 1259 OID 16811)
-- Name: hotel_hotel_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.hotel_hotel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 218
-- Name: hotel_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.hotel_hotel_id_seq OWNED BY hotel_schema.hotel.hotel_id;


--
-- TOC entry 249 (class 1259 OID 17046)
-- Name: hotelmonthlyrevenue; Type: VIEW; Schema: hotel_schema; Owner: -
--

CREATE VIEW hotel_schema.hotelmonthlyrevenue AS
 WITH last_month AS (
         SELECT (date_trunc('month'::text, (CURRENT_DATE)::timestamp with time zone) - '1 mon'::interval) AS start_dt,
            (date_trunc('month'::text, (CURRENT_DATE)::timestamp with time zone) - '1 day'::interval) AS end_dt
        )
 SELECT h.name AS hotel_name,
    sum(drs.price_for_date) AS total_revenue
   FROM (((hotel_schema.dailyroomstatus drs
     JOIN hotel_schema.room r ON ((drs.room_id = r.room_id)))
     JOIN hotel_schema.hotel h ON ((r.hotel_id = h.hotel_id)))
     JOIN last_month lm ON (((drs.status_date >= lm.start_dt) AND (drs.status_date <= lm.end_dt))))
  WHERE ((drs.status)::text = 'occupied'::text)
  GROUP BY h.name
  ORDER BY (sum(drs.price_for_date)) DESC;


--
-- TOC entry 244 (class 1259 OID 16992)
-- Name: payment; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.payment (
    payment_id integer NOT NULL,
    booking_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_date date DEFAULT CURRENT_DATE,
    method character varying(50),
    CONSTRAINT payment_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT payment_method_check CHECK (((method)::text = ANY ((ARRAY['cash'::character varying, 'card'::character varying])::text[])))
);


--
-- TOC entry 243 (class 1259 OID 16991)
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.payment_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 243
-- Name: payment_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.payment_payment_id_seq OWNED BY hotel_schema.payment.payment_id;


--
-- TOC entry 225 (class 1259 OID 16848)
-- Name: promotion; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.promotion (
    promotion_id integer NOT NULL,
    percent integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    CONSTRAINT promotion_check CHECK ((end_date > start_date)),
    CONSTRAINT promotion_percent_check CHECK (((percent > 0) AND (percent <= 100)))
);


--
-- TOC entry 224 (class 1259 OID 16847)
-- Name: promotion_promotion_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.promotion_promotion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 224
-- Name: promotion_promotion_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.promotion_promotion_id_seq OWNED BY hotel_schema.promotion.promotion_id;


--
-- TOC entry 245 (class 1259 OID 17006)
-- Name: promotionroomtype; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.promotionroomtype (
    promotion_id integer NOT NULL,
    room_type_id integer NOT NULL
);


--
-- TOC entry 238 (class 1259 OID 16937)
-- Name: registration; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.registration (
    registration_id integer NOT NULL,
    booking_id integer NOT NULL,
    employee_id integer NOT NULL,
    registration_date date DEFAULT CURRENT_DATE
);


--
-- TOC entry 237 (class 1259 OID 16936)
-- Name: registration_registration_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.registration_registration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 237
-- Name: registration_registration_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.registration_registration_id_seq OWNED BY hotel_schema.registration.registration_id;


--
-- TOC entry 222 (class 1259 OID 16827)
-- Name: room_room_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.room_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 222
-- Name: room_room_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.room_room_id_seq OWNED BY hotel_schema.room.room_id;


--
-- TOC entry 227 (class 1259 OID 16857)
-- Name: roompricehistory; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.roompricehistory (
    price_id integer NOT NULL,
    room_type_id integer NOT NULL,
    price numeric(10,2) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    CONSTRAINT roompricehistory_price_check CHECK ((price >= (0)::numeric))
);


--
-- TOC entry 226 (class 1259 OID 16856)
-- Name: roompricehistory_price_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.roompricehistory_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 226
-- Name: roompricehistory_price_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.roompricehistory_price_id_seq OWNED BY hotel_schema.roompricehistory.price_id;


--
-- TOC entry 220 (class 1259 OID 16818)
-- Name: roomtype_room_type_id_seq; Type: SEQUENCE; Schema: hotel_schema; Owner: -
--

CREATE SEQUENCE hotel_schema.roomtype_room_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 220
-- Name: roomtype_room_type_id_seq; Type: SEQUENCE OWNED BY; Schema: hotel_schema; Owner: -
--

ALTER SEQUENCE hotel_schema.roomtype_room_type_id_seq OWNED BY hotel_schema.roomtype.room_type_id;


--
-- TOC entry 230 (class 1259 OID 16878)
-- Name: roomtypeamenity; Type: TABLE; Schema: hotel_schema; Owner: -
--

CREATE TABLE hotel_schema.roomtypeamenity (
    room_type_id integer NOT NULL,
    amenity_id integer NOT NULL
);


--
-- TOC entry 4742 (class 2604 OID 16873)
-- Name: amenity amenity_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.amenity ALTER COLUMN amenity_id SET DEFAULT nextval('hotel_schema.amenity_amenity_id_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 16904)
-- Name: booking booking_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.booking ALTER COLUMN booking_id SET DEFAULT nextval('hotel_schema.booking_booking_id_seq'::regclass);


--
-- TOC entry 4750 (class 2604 OID 16975)
-- Name: cleaningschedule cleaning_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.cleaningschedule ALTER COLUMN cleaning_id SET DEFAULT nextval('hotel_schema.cleaningschedule_cleaning_id_seq'::regclass);


--
-- TOC entry 4753 (class 2604 OID 17025)
-- Name: dailyroomstatus drs_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.dailyroomstatus ALTER COLUMN drs_id SET DEFAULT nextval('hotel_schema.dailyroomstatus_drs_id_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 16927)
-- Name: employee employee_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.employee ALTER COLUMN employee_id SET DEFAULT nextval('hotel_schema.employee_employee_id_seq'::regclass);


--
-- TOC entry 4748 (class 2604 OID 16958)
-- Name: employmentcontract contract_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.employmentcontract ALTER COLUMN contract_id SET DEFAULT nextval('hotel_schema.employmentcontract_contract_id_seq'::regclass);


--
-- TOC entry 4743 (class 2604 OID 16897)
-- Name: guest guest_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.guest ALTER COLUMN guest_id SET DEFAULT nextval('hotel_schema.guest_guest_id_seq'::regclass);


--
-- TOC entry 4736 (class 2604 OID 16815)
-- Name: hotel hotel_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.hotel ALTER COLUMN hotel_id SET DEFAULT nextval('hotel_schema.hotel_hotel_id_seq'::regclass);


--
-- TOC entry 4751 (class 2604 OID 16995)
-- Name: payment payment_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.payment ALTER COLUMN payment_id SET DEFAULT nextval('hotel_schema.payment_payment_id_seq'::regclass);


--
-- TOC entry 4740 (class 2604 OID 16851)
-- Name: promotion promotion_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.promotion ALTER COLUMN promotion_id SET DEFAULT nextval('hotel_schema.promotion_promotion_id_seq'::regclass);


--
-- TOC entry 4746 (class 2604 OID 16940)
-- Name: registration registration_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.registration ALTER COLUMN registration_id SET DEFAULT nextval('hotel_schema.registration_registration_id_seq'::regclass);


--
-- TOC entry 4738 (class 2604 OID 16831)
-- Name: room room_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.room ALTER COLUMN room_id SET DEFAULT nextval('hotel_schema.room_room_id_seq'::regclass);


--
-- TOC entry 4741 (class 2604 OID 16860)
-- Name: roompricehistory price_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.roompricehistory ALTER COLUMN price_id SET DEFAULT nextval('hotel_schema.roompricehistory_price_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 16822)
-- Name: roomtype room_type_id; Type: DEFAULT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.roomtype ALTER COLUMN room_type_id SET DEFAULT nextval('hotel_schema.roomtype_room_type_id_seq'::regclass);


--
-- TOC entry 4993 (class 0 OID 16870)
-- Dependencies: 229
-- Data for Name: amenity; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.amenity (amenity_id, name) FROM stdin;
1	Wi-Fi
2	Телевизор
3	Минибар
4	Кондиционер
\.


--
-- TOC entry 4998 (class 0 OID 16901)
-- Dependencies: 234
-- Data for Name: booking; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.booking (booking_id, room_id, guest_id, checkin_date, checkout_date, status, promotion_id) FROM stdin;
3	5	3	2025-09-12	2025-09-14	booked	\N
4	2	1	2025-09-25	2025-09-27	checked_out	\N
5	8	3	2025-09-28	2025-09-30	checked_out	\N
6	5	2	2025-09-26	2025-09-29	checked_out	\N
7	1	1	2025-09-30	2025-10-01	booked	\N
8	1	1	2025-10-01	2025-10-03	checked_in	\N
9	2	2	2025-10-10	2025-10-12	booked	\N
12	1	1	2025-10-05	2025-10-07	booked	\N
13	1	1	2025-10-05	2025-10-07	booked	\N
1	2	1	2025-09-10	2025-09-15	checked_in	\N
2	3	2	2025-09-05	2025-09-10	checked_out	\N
14	1	1	2024-01-15	2024-01-20	booked	\N
\.


--
-- TOC entry 5006 (class 0 OID 16972)
-- Dependencies: 242
-- Data for Name: cleaningschedule; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.cleaningschedule (cleaning_id, room_id, cleaning_date, status, maid_id) FROM stdin;
1	2	2025-09-10	убран	1
2	3	2025-09-10	не убран	3
3	5	2025-09-10	убран	3
\.


--
-- TOC entry 5011 (class 0 OID 17022)
-- Dependencies: 247
-- Data for Name: dailyroomstatus; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.dailyroomstatus (drs_id, room_id, status_date, status, price_for_date, promotion_id) FROM stdin;
3	5	2025-09-10	booked	10000.00	\N
4	1	2025-09-30	free	5000.00	\N
6	5	2025-09-30	free	10000.00	\N
7	6	2025-09-30	free	10000.00	\N
8	8	2025-09-30	free	15000.00	\N
9	2	2025-08-05	occupied	9000.00	\N
10	3	2025-08-06	occupied	20000.00	\N
11	2	2025-08-07	occupied	9000.00	\N
14	4	2025-09-30	booked	5000.00	\N
16	2	2025-10-01	occupied	7000.00	\N
17	3	2025-10-01	occupied	7000.00	\N
18	1	2025-10-01	occupied	7000.00	\N
19	4	2025-10-01	occupied	7000.00	\N
20	1	2025-10-05	booked	\N	\N
21	1	2025-10-06	booked	\N	\N
22	1	2025-10-07	booked	\N	\N
1	2	2025-09-10	occupied	9000.00	\N
2	3	2025-09-10	free	20000.00	\N
5	3	2025-09-30	free	20000.00	\N
15	10	2025-09-30	occupied	20000.00	\N
26	1	2024-01-15	booked	\N	\N
27	1	2024-01-16	booked	\N	\N
28	1	2024-01-17	booked	\N	\N
29	1	2024-01-18	booked	\N	\N
30	1	2024-01-19	booked	\N	\N
31	1	2024-01-20	booked	\N	\N
\.


--
-- TOC entry 5000 (class 0 OID 16924)
-- Dependencies: 236
-- Data for Name: employee; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.employee (employee_id, hotel_id, full_name, "position", rate_count) FROM stdin;
1	1	Светлана Горничная	горничная	1
2	1	Алексей Регистратор	регистратор	1
3	2	Мария Горничная	горничная	1
4	2	Игорь Регистратор	регистратор	1
5	3	Ольга Горничная	горничная	1
\.


--
-- TOC entry 5004 (class 0 OID 16955)
-- Dependencies: 240
-- Data for Name: employmentcontract; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.employmentcontract (contract_id, employee_id, start_date, end_date, contract_number, is_fixed_term, terms) FROM stdin;
1	1	2025-01-01	\N	C-1001	f	Постоянная ставка
2	2	2025-01-01	\N	C-1002	f	Постоянная ставка
3	3	2025-06-01	2025-09-30	C-2001	t	Сезонная работа
4	4	2025-01-01	\N	C-2002	f	Постоянная ставка
5	5	2025-06-01	2025-09-30	C-3001	t	Сезонная работа
\.


--
-- TOC entry 4996 (class 0 OID 16894)
-- Dependencies: 232
-- Data for Name: guest; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.guest (guest_id, first_name, last_name, patronymic, address) FROM stdin;
1	Иван	Иванов	Иванович	Москва, ул. Ленина, 5
2	Пётр	Петров	Петрович	Санкт-Петербург, ул. Невский, 12
3	Анна	Сидорова	Александровна	Казань, ул. Баумана, 3
4	Ivan	Ivanov	Ivanovich	MSK
\.


--
-- TOC entry 4983 (class 0 OID 16812)
-- Dependencies: 219
-- Data for Name: hotel; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.hotel (hotel_id, name, address) FROM stdin;
1	Отель Москва	ул. Тверская, 1, Москва
2	Отель Санкт-Петербург	Невский проспект, 10, Санкт-Петербург
3	Отель Казань	ул. Баумана, 15, Казань
\.


--
-- TOC entry 5008 (class 0 OID 16992)
-- Dependencies: 244
-- Data for Name: payment; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.payment (payment_id, booking_id, amount, payment_date, method) FROM stdin;
1	1	45000.00	2025-09-30	card
2	2	40000.00	2025-09-30	cash
3	1	5000.00	2025-10-01	card
\.


--
-- TOC entry 4989 (class 0 OID 16848)
-- Dependencies: 225
-- Data for Name: promotion; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.promotion (promotion_id, percent, start_date, end_date) FROM stdin;
2	20	2025-12-01	2025-12-31
3	20	2025-10-01	2025-10-31
\.


--
-- TOC entry 5009 (class 0 OID 17006)
-- Dependencies: 245
-- Data for Name: promotionroomtype; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.promotionroomtype (promotion_id, room_type_id) FROM stdin;
2	4
\.


--
-- TOC entry 5002 (class 0 OID 16937)
-- Dependencies: 238
-- Data for Name: registration; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.registration (registration_id, booking_id, employee_id, registration_date) FROM stdin;
2	6	4	2025-09-26
3	5	5	2025-09-28
\.


--
-- TOC entry 4987 (class 0 OID 16828)
-- Dependencies: 223
-- Data for Name: room; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.room (room_id, hotel_id, room_number, room_type_id, is_available) FROM stdin;
2	1	102	2	t
3	1	201	3	t
5	2	101	2	t
6	2	102	2	t
7	2	201	3	t
8	3	101	1	t
9	3	102	2	t
4	1	202	4	f
10	3	201	3	f
1	1	101	1	f
\.


--
-- TOC entry 4991 (class 0 OID 16857)
-- Dependencies: 227
-- Data for Name: roompricehistory; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.roompricehistory (price_id, room_type_id, price, start_date, end_date) FROM stdin;
2	2	11025.00	2025-01-01	2025-10-01
3	3	22050.00	2025-01-01	2025-10-01
4	4	27562.50	2025-01-01	2025-10-01
1	1	5512.50	2025-01-01	2025-09-30
6	1	5500.00	2025-10-01	\N
5	1	5500.00	2025-10-01	2025-09-30
\.


--
-- TOC entry 4985 (class 0 OID 16819)
-- Dependencies: 221
-- Data for Name: roomtype; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.roomtype (room_type_id, type_name, capacity) FROM stdin;
1	стандарт	1
2	стандарт	2
3	люкс	2
4	люкс	3
\.


--
-- TOC entry 4994 (class 0 OID 16878)
-- Dependencies: 230
-- Data for Name: roomtypeamenity; Type: TABLE DATA; Schema: hotel_schema; Owner: -
--

COPY hotel_schema.roomtypeamenity (room_type_id, amenity_id) FROM stdin;
1	1
1	2
2	1
2	2
3	1
3	3
3	4
4	1
4	2
4	3
4	4
\.

--
-- TOC entry 4778 (class 2606 OID 16877)
-- Name: amenity amenity_name_key; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.amenity
    ADD CONSTRAINT amenity_name_key UNIQUE (name);


--
-- TOC entry 4780 (class 2606 OID 16875)
-- Name: amenity amenity_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.amenity
    ADD CONSTRAINT amenity_pkey PRIMARY KEY (amenity_id);


--
-- TOC entry 4786 (class 2606 OID 16907)
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (booking_id);


--
-- TOC entry 4796 (class 2606 OID 16978)
-- Name: cleaningschedule cleaningschedule_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.cleaningschedule
    ADD CONSTRAINT cleaningschedule_pkey PRIMARY KEY (cleaning_id);


--
-- TOC entry 4798 (class 2606 OID 16980)
-- Name: cleaningschedule cleaningschedule_room_id_cleaning_date_key; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.cleaningschedule
    ADD CONSTRAINT cleaningschedule_room_id_cleaning_date_key UNIQUE (room_id, cleaning_date);


--
-- TOC entry 4804 (class 2606 OID 17028)
-- Name: dailyroomstatus dailyroomstatus_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.dailyroomstatus
    ADD CONSTRAINT dailyroomstatus_pkey PRIMARY KEY (drs_id);


--
-- TOC entry 4806 (class 2606 OID 17030)
-- Name: dailyroomstatus dailyroomstatus_room_id_status_date_key; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.dailyroomstatus
    ADD CONSTRAINT dailyroomstatus_room_id_status_date_key UNIQUE (room_id, status_date);


--
-- TOC entry 4788 (class 2606 OID 16930)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 4792 (class 2606 OID 16965)
-- Name: employmentcontract employmentcontract_contract_number_key; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.employmentcontract
    ADD CONSTRAINT employmentcontract_contract_number_key UNIQUE (contract_number);


--
-- TOC entry 4794 (class 2606 OID 16963)
-- Name: employmentcontract employmentcontract_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.employmentcontract
    ADD CONSTRAINT employmentcontract_pkey PRIMARY KEY (contract_id);


--
-- TOC entry 4784 (class 2606 OID 16899)
-- Name: guest guest_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.guest
    ADD CONSTRAINT guest_pkey PRIMARY KEY (guest_id);


--
-- TOC entry 4766 (class 2606 OID 16817)
-- Name: hotel hotel_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (hotel_id);


--
-- TOC entry 4800 (class 2606 OID 17000)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 4774 (class 2606 OID 16855)
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (promotion_id);


--
-- TOC entry 4802 (class 2606 OID 17010)
-- Name: promotionroomtype promotionroomtype_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.promotionroomtype
    ADD CONSTRAINT promotionroomtype_pkey PRIMARY KEY (promotion_id, room_type_id);


--
-- TOC entry 4790 (class 2606 OID 16943)
-- Name: registration registration_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.registration
    ADD CONSTRAINT registration_pkey PRIMARY KEY (registration_id);


--
-- TOC entry 4770 (class 2606 OID 16836)
-- Name: room room_hotel_id_room_number_key; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.room
    ADD CONSTRAINT room_hotel_id_room_number_key UNIQUE (hotel_id, room_number);


--
-- TOC entry 4772 (class 2606 OID 16834)
-- Name: room room_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (room_id);


--
-- TOC entry 4776 (class 2606 OID 16863)
-- Name: roompricehistory roompricehistory_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.roompricehistory
    ADD CONSTRAINT roompricehistory_pkey PRIMARY KEY (price_id);


--
-- TOC entry 4768 (class 2606 OID 16826)
-- Name: roomtype roomtype_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.roomtype
    ADD CONSTRAINT roomtype_pkey PRIMARY KEY (room_type_id);


--
-- TOC entry 4782 (class 2606 OID 16882)
-- Name: roomtypeamenity roomtypeamenity_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.roomtypeamenity
    ADD CONSTRAINT roomtypeamenity_pkey PRIMARY KEY (room_type_id, amenity_id);


ALTER TABLE ONLY hotel_schema.booking
    ADD CONSTRAINT booking_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES hotel_schema.guest(guest_id);


--
-- TOC entry 4813 (class 2606 OID 17075)
-- Name: booking booking_promotion_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.booking
    ADD CONSTRAINT booking_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES hotel_schema.promotion(promotion_id) ON DELETE CASCADE;


--
-- TOC entry 4814 (class 2606 OID 16908)
-- Name: booking booking_room_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.booking
    ADD CONSTRAINT booking_room_id_fkey FOREIGN KEY (room_id) REFERENCES hotel_schema.room(room_id);


--
-- TOC entry 4819 (class 2606 OID 16986)
-- Name: cleaningschedule cleaningschedule_maid_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.cleaningschedule
    ADD CONSTRAINT cleaningschedule_maid_id_fkey FOREIGN KEY (maid_id) REFERENCES hotel_schema.employee(employee_id);


--
-- TOC entry 4820 (class 2606 OID 16981)
-- Name: cleaningschedule cleaningschedule_room_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.cleaningschedule
    ADD CONSTRAINT cleaningschedule_room_id_fkey FOREIGN KEY (room_id) REFERENCES hotel_schema.room(room_id) ON DELETE CASCADE;


--
-- TOC entry 4824 (class 2606 OID 17036)
-- Name: dailyroomstatus dailyroomstatus_promotion_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.dailyroomstatus
    ADD CONSTRAINT dailyroomstatus_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES hotel_schema.promotion(promotion_id);


--
-- TOC entry 4825 (class 2606 OID 17031)
-- Name: dailyroomstatus dailyroomstatus_room_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.dailyroomstatus
    ADD CONSTRAINT dailyroomstatus_room_id_fkey FOREIGN KEY (room_id) REFERENCES hotel_schema.room(room_id) ON DELETE CASCADE;


--
-- TOC entry 4815 (class 2606 OID 16931)
-- Name: employee employee_hotel_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.employee
    ADD CONSTRAINT employee_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES hotel_schema.hotel(hotel_id) ON DELETE CASCADE;


--
-- TOC entry 4818 (class 2606 OID 16966)
-- Name: employmentcontract employmentcontract_employee_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.employmentcontract
    ADD CONSTRAINT employmentcontract_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES hotel_schema.employee(employee_id) ON DELETE CASCADE;


--
-- TOC entry 4821 (class 2606 OID 17001)
-- Name: payment payment_booking_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.payment
    ADD CONSTRAINT payment_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES hotel_schema.booking(booking_id);


--
-- TOC entry 4822 (class 2606 OID 17011)
-- Name: promotionroomtype promotionroomtype_promotion_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.promotionroomtype
    ADD CONSTRAINT promotionroomtype_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES hotel_schema.promotion(promotion_id) ON DELETE CASCADE;


--
-- TOC entry 4823 (class 2606 OID 17016)
-- Name: promotionroomtype promotionroomtype_room_type_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.promotionroomtype
    ADD CONSTRAINT promotionroomtype_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES hotel_schema.roomtype(room_type_id) ON DELETE CASCADE;


--
-- TOC entry 4816 (class 2606 OID 16944)
-- Name: registration registration_booking_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.registration
    ADD CONSTRAINT registration_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES hotel_schema.booking(booking_id);


--
-- TOC entry 4817 (class 2606 OID 16949)
-- Name: registration registration_employee_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.registration
    ADD CONSTRAINT registration_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES hotel_schema.employee(employee_id);


--
-- TOC entry 4807 (class 2606 OID 16837)
-- Name: room room_hotel_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.room
    ADD CONSTRAINT room_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES hotel_schema.hotel(hotel_id) ON DELETE CASCADE;


--
-- TOC entry 4808 (class 2606 OID 16842)
-- Name: room room_room_type_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.room
    ADD CONSTRAINT room_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES hotel_schema.roomtype(room_type_id);


--
-- TOC entry 4809 (class 2606 OID 16864)
-- Name: roompricehistory roompricehistory_room_type_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.roompricehistory
    ADD CONSTRAINT roompricehistory_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES hotel_schema.roomtype(room_type_id) ON DELETE CASCADE;


--
-- TOC entry 4810 (class 2606 OID 16888)
-- Name: roomtypeamenity roomtypeamenity_amenity_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.roomtypeamenity
    ADD CONSTRAINT roomtypeamenity_amenity_id_fkey FOREIGN KEY (amenity_id) REFERENCES hotel_schema.amenity(amenity_id) ON DELETE CASCADE;


--
-- TOC entry 4811 (class 2606 OID 16883)
-- Name: roomtypeamenity roomtypeamenity_room_type_id_fkey; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: -
--

ALTER TABLE ONLY hotel_schema.roomtypeamenity
    ADD CONSTRAINT roomtypeamenity_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES hotel_schema.roomtype(room_type_id);


-- Completed on 2025-10-02 12:17:15

--
-- PostgreSQL database dump complete
--

\unrestrict VJogjMaY2JkmOy6kbs8ZKr1SJHFHL2FVvubjJVryMUmvAY966AaZCw9hVz9mNnQ


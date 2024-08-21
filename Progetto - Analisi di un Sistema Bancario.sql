SHOW DATABASES LIKE 'banca'
select * from banca.cliente as c
select * from banca.conto as co
select * from banca.tipo_conto as tc
select * from banca.tipo_transazione as tt
select * from banca.transazioni as t

/* Età */

create temporary table eta as
select 
id_cliente,
year(curdate()) - year(data_nascita) as eta
from banca.cliente

select * from eta


/* Numero di transazioni in uscita su tutti i conti */

create temporary table num_trans_uscita as
select
c.id_cliente,
count(t.id_tipo_trans) as num_transazioni_uscita
from
banca.cliente as c
join banca.conto co on c.id_cliente = co.id_cliente
join banca.transazioni t on co.id_conto = t.id_conto
join banca.tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
where 
tt.segno = '-'
group by c.id_cliente

select * from num_trans_uscita


/* Numero di transazioni in entrata su tutti i conti */

create temporary table num_trans_entrata as
select
c.id_cliente,
count(t.id_tipo_trans) as num_transazioni_entrata
from
banca.cliente c
join banca.conto co on c.id_cliente = co.id_cliente
join banca.transazioni t on co.id_conto = t.id_conto
join banca.tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
where 
tt.segno = '+'
group by 
c.id_cliente

select * from num_trans_entrata


/* Importo transato in uscita su tutti i conti */

create temporary table importo_uscita as 
select
c.id_cliente,
sum(t.importo) as importo_tot_uscita
from
banca.cliente c 
join banca.conto co on c.id_cliente = co.id_cliente
join banca.transazioni t on co.id_conto = t.id_conto
join banca.tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
where
tt.segno = '-'
group by
c.id_cliente

select * from importo_uscita


/* Importo transato in entrata su tutti i conti */

create temporary table importo_entrata as
select
c.id_cliente,
sum(t.importo) as importo_tot_entrata
from
banca.cliente c
join banca.conto co on c.id_cliente = co.id_cliente
join banca.transazioni t on co.id_conto = t.id_conto
join banca.tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
where
tt.segno = '+'
group by
c.id_cliente

select * from importo_entrata


/* Numero totale di conti posseduti */

create temporary table conti_posseduti as
select
c.id_cliente,
count(co.id_conto) as num_conti_posseduti
from
banca.cliente c
join banca.conto co on c.id_cliente = co.id_cliente
group by
c.id_cliente

select * from conti_posseduti


/* Numero di conti posseduti per tipologia */

create temporary table conti_per_tipologia as
select
c.id_cliente,
sum(case when tc.desc_tipo_conto = 'Conto Base' then 1 else 0 end) as num_conto_0,
sum(case when tc.desc_tipo_conto = 'Conto Business' then 1 else 0 end) as num_conto_1,
sum(case when tc.desc_tipo_conto = 'Conto Privati' then 1 else 0 end) as num_conto_2,
sum(case when tc.desc_tipo_conto = 'Conto Famiglie' then 1 else 0 end) as num_conto_3
from
banca.cliente c 
join banca.conto co on c.id_cliente = co.id_cliente
join banca.tipo_conto tc on co.id_tipo_conto = tc.id_tipo_conto
group by
c.id_cliente

select * from conti_per_tipologia


/* Numero di transazioni in uscita per tipologia di transazione */

create temporary table trans_uscita_per_tipologia as 
select
c.id_cliente,
sum(case when tt.desc_tipo_trans = 'Acquisto su Amazon' and tt.segno = '-' then 1 else 0 end) as trans_uscita_tipo_3,
sum(case when tt.desc_tipo_trans = 'Rata mutuo' and tt.segno = '-' then 1 else 0 end) as trans_uscita_tipo_4,
sum(case when tt.desc_tipo_trans = 'Hotel' and tt.segno = '-' then 1 else 0 end) as trans_uscita_tipo_5,
sum(case when tt.desc_tipo_trans = 'Biglietto aereo' and tt.segno = '-' then 1 else 0 end) as trans_uscita_tipo_6,
sum(case when tt.desc_tipo_trans = 'Supermercato' and tt.segno = '-' then 1 else 0 end) as trans_uscita_tipo_7
from
banca.cliente c
join banca.conto co on c.id_cliente = co.id_cliente
join banca.transazioni t on co.id_conto = t.id_conto
join banca.tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
group by
c.id_cliente


select * from trans_uscita_per_tipologia


/* Numero di transazioni in entrata per tipologia di transazione */

create temporary table trans_entrata_per_tipologia as
select
c.id_cliente,
sum(case when tt.desc_tipo_trans = 'Stipendio' and tt.segno = '+' then 1 else 0 end) as trans_entrata_tipo_0,
sum(case when tt.desc_tipo_trans = 'Pensione' and tt.segno = '+' then 1 else 0 end) as trans_entrata_tipo_1,
sum(case when tt.desc_tipo_trans = 'Dividendi' and tt.segno = '+' then 1 else 0 end) as trans_entrata_tipo_2
from
banca.cliente c
join banca.conto co on c.id_cliente = co.id_cliente
join banca.transazioni t on co.id_conto = t.id_conto
join banca.tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
group by
c.id_cliente

select * from trans_entrata_per_tipologia


/* Importo transato in uscita per tipologia di conto */ 

create temporary table importo_uscita_per_tipologia as
select
c.id_cliente,
sum(case when tc.desc_tipo_conto = 'Conto Base' and tt.segno = '-' then t.importo else 0 end) as importo_uscita_tipo_0,
sum(case when tc.desc_tipo_conto = 'Conto Business' and tt.segno = '-' then t.importo else 0 end) as importo_uscita_tipo_1,
sum(case when tc.desc_tipo_conto = 'Conto Privati' and tt.segno = '-' then t.importo else 0 end) as importo_uscita_tipo_2,
sum(case when tc.desc_tipo_conto = 'Conto Famiglie' and tt.segno = '-' then t.importo else 0 end) as importo_uscita_tipo_3
from
banca.cliente c
join banca.conto co on c.id_cliente = co.id_cliente
join banca.tipo_conto tc on co.id_tipo_conto = tc.id_tipo_conto
join banca.transazioni t on co.id_conto = t.id_conto
join banca.tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
group by
c.id_cliente

select * from importo_uscita_per_tipologia


/* Importo transato in entrata per tipologia di conto */

create temporary table importo_entrata_per_tipologia as
select
c.id_cliente,
sum(case when tc.desc_tipo_conto = 'Conto Base' and tt.segno = '+' then t.importo else 0 end) as importo_entrata_tipo_0,
sum(case when tc.desc_tipo_conto = 'Conto Business' and tt.segno = '+' then t.importo else 0 end) as importo_entrata_tipo_1,
sum(case when tc.desc_tipo_conto = 'Conto Privati' and tt.segno = '+' then t.importo else 0 end) as importo_entrata_tipo_2,
sum(case when tc.desc_tipo_conto = 'Conto Famiglie' and tt.segno = '+' then t.importo else 0 end) as importo_entrata_tipo_3
from
banca.cliente c
join banca.conto co on c.id_cliente = co.id_cliente
join banca.tipo_conto tc on co.id_tipo_conto = tc.id_tipo_conto
join banca.transazioni t on co.id_conto = t.id_conto
join banca.tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
group by
c.id_cliente

select * from importo_entrata_per_tipologia



CREATE TABLE indicatori_clienti AS
SELECT 
    e.id_cliente,
    e.eta,
    COALESCE(tu.num_transazioni_uscita, 0) AS num_transazioni_uscita,
    COALESCE(te.num_transazioni_entrata, 0) AS num_transazioni_entrata,
    COALESCE(iu.importo_tot_uscita, 0) AS importo_tot_uscita,
    COALESCE(ie.importo_tot_entrata, 0) AS importo_tot_entrata,
    COALESCE(cp.num_conti_posseduti, 0) AS num_conti_posseduti,
    COALESCE(ctp.num_conto_0, 0) AS num_conto_base,
    COALESCE(ctp.num_conto_1, 0) AS num_conto_business,
    COALESCE(ctp.num_conto_2, 0) AS num_conto_privati,
    COALESCE(ctp.num_conto_3, 0) AS num_conto_famiglie,
    COALESCE(tutt.trans_uscita_tipo_3, 0) AS trans_uscita_acquisto_amazon,
    COALESCE(tutt.trans_uscita_tipo_4, 0) AS trans_uscita_rata_mutuo,
    COALESCE(tutt.trans_uscita_tipo_5, 0) AS trans_uscita_hotel,
    COALESCE(tutt.trans_uscita_tipo_6, 0) AS trans_uscita_biglietto_aereo,
    COALESCE(tutt.trans_uscita_tipo_7, 0) AS trans_uscita_supermercato,
    COALESCE(tett.trans_entrata_tipo_0, 0) AS trans_entrata_stipendio,
    COALESCE(tett.trans_entrata_tipo_1, 0) AS trans_entrata_pensione,
    COALESCE(tett.trans_entrata_tipo_2, 0) AS trans_entrata_dividendi,
    COALESCE(iup.importo_uscita_tipo_0, 0) AS importo_uscita_conto_base,
    COALESCE(iup.importo_uscita_tipo_1, 0) AS importo_uscita_conto_business,
    COALESCE(iup.importo_uscita_tipo_2, 0) AS importo_uscita_conto_privati,
    COALESCE(iup.importo_uscita_tipo_3, 0) AS importo_uscita_conto_famiglie,
    COALESCE(iep.importo_entrata_tipo_0, 0) AS importo_entrata_conto_base,
    COALESCE(iep.importo_entrata_tipo_1, 0) AS importo_entrata_conto_business,
    COALESCE(iep.importo_entrata_tipo_2, 0) AS importo_entrata_conto_privati,
    COALESCE(iep.importo_entrata_tipo_3, 0) AS importo_entrata_conto_famiglie
FROM
    eta e
    LEFT JOIN num_trans_uscita tu ON e.id_cliente = tu.id_cliente
    LEFT JOIN num_trans_entrata te ON e.id_cliente = te.id_cliente
    LEFT JOIN importo_uscita iu ON e.id_cliente = iu.id_cliente
    LEFT JOIN importo_entrata ie ON e.id_cliente = ie.id_cliente
    LEFT JOIN conti_posseduti cp ON e.id_cliente = cp.id_cliente
    LEFT JOIN conti_per_tipologia ctp ON e.id_cliente = ctp.id_cliente
    LEFT JOIN trans_uscita_per_tipologia tutt ON e.id_cliente = tutt.id_cliente
    LEFT JOIN trans_entrata_per_tipologia tett ON e.id_cliente = tett.id_cliente
    LEFT JOIN importo_uscita_per_tipologia iup ON e.id_cliente = iup.id_cliente
    LEFT JOIN importo_entrata_per_tipologia iep ON e.id_cliente = iep.id_cliente

SELECT * FROM indicatori_clienti



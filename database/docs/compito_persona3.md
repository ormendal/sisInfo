# Compito Persona 3 – Query e scenari di test

## Obiettivo
Scrivere il file `database/03_query_principali.sql` con tutte le query necessarie al funzionamento del sistema e il file `docs/test_scenari.md` con la descrizione di 3 scenari d’uso verificati.

## Teoria di riferimento
- **DQL (Data Query Language)**: `SELECT … FROM … JOIN … WHERE … GROUP BY … ORDER BY`
- **JOIN**: `INNER JOIN`, `LEFT JOIN` (fondamentale per calcolare i posti liberi includendo i voli senza prenotazioni)
- **Funzioni di aggregazione**: `COUNT`, `SUM`, `AVG` (con `GROUP BY`)
- **DML**: `INSERT`, `UPDATE` (per simulare azioni come prenotazione, pagamento, check‑in)

## Elenco delle query da scrivere
Nel file `03_query_principali.sql` dovrai includere **tutte** le seguenti query, ciascuna preceduta da un commento che spiega:
- Cosa fa la query
- Quali parametri vanno sostituiti (indicati con `-- parametro: nome`)

Le query richieste:

1. **Ricerca voli** – Filtra per origine, destinazione, data (es. `'MIL'`, `'ROM'`, `'2026-05-20'`). Restituisce codice volo, compagnia, orari, posti liberi.
2. **Controllo overbooking** – Dato un `volo_id`, restituisce i posti liberi.
3. **Inserimento nuova prenotazione** – `INSERT` di esempio con stato `'prenotata'`.
4. **Pagamento** – `UPDATE` che cambia lo stato da `'prenotata'` a `'pagata'`.
5. **Check‑in online** – `UPDATE` a `'imbarcato'` e `INSERT` in `carte_imbarco` con `operatore_id = NULL`.
6. **Check‑in al banco** – Cerca una prenotazione pagata per documento del passeggero, poi esegue `UPDATE` e `INSERT` con `operatore_id` valorizzato.
7. **Cruscotto passeggero** – Tutte le prenotazioni di un dato passeggero (per `passeggero_id`), con dettagli del volo e della carta d’imbarco (se presente).
8. **Cruscotto compagnia** – Voli di una compagnia (per `compagnia_id`) con conteggio posti liberi.
9. **Monitoraggio gate** – Stato di ogni gate e codice del volo assegnato (se presente).
10. **Modifica stato gate** – `UPDATE` dello stato di un gate.

## Cosa devi fare

### 1. Preparati l’ambiente di test
Ottieni i file `01_crea_database.sql` e `02_dati_esempio.sql` (dal repository o dai tuoi compagni) e crea un database di test:
```bash
sqlite3 test.db < database/01_crea_database.sql
sqlite3 test.db < database/02_dati_esempio.sql

# Esempio di query per la ricerca voli
```sql
-- 1. RICERCA VOLI
-- Parametri: origine, destinazione, data
SELECT v.codice_volo, c.nome AS compagnia, v.data_ora_partenza, v.data_ora_arrivo,
       v.posti_totali - COUNT(p.id) AS posti_liberi
FROM voli v
JOIN compagnie_aeree c ON v.compagnia_id = c.id
LEFT JOIN prenotazioni p ON p.volo_id = v.id AND p.stato IN ('prenotata','pagata')
WHERE v.stato = 'programmato'
  AND v.origine = 'MIL'
  AND v.destinazione = 'ROM'
  AND DATE(v.data_ora_partenza) = '2026-05-20'
GROUP BY v.id;
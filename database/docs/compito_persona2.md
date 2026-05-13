# Compito Persona 2 – Popolamento del database con dati di esempio

## Obiettivo
Creare il file `database/02_dati_esempio.sql` che contiene comandi `INSERT` per riempire tutte le tabelle del database con dati **realistici, coerenti e sufficienti** a testare le funzionalità del sistema.

## Teoria di riferimento
- **DML (Data Manipulation Language)**: `INSERT INTO … VALUES …`
- **Ordine di inserimento**: devi rispettare le dipendenze referenziali. Inserisci prima i dati nelle tabelle “padre” e poi in quelle “figlie”.
- **Coerenza dei dati**: ogni valore di chiave esterna deve esistere nella tabella referenziata.

## Requisiti minimi dei dati
I tuoi dati devono coprire tutti i casi d’uso. Dovrai inserire **almeno**:

- **2 compagnie aeree** (es. Air Dolomiti, Ryanair)
- **3 gate** con stati diversi: `'libero'`, `'occupato'`, `'manutenzione'`
- **5 voli**:
  - Diverse tratte (es. MIL-ROM, ROM-NAP)
  - Date future e passate
  - Almeno un volo `'programmato'`, uno `'partito'`, uno `'arrivato'`
  - Capacità differenti (es. 72, 180, 50 posti)
  - Almeno un volo senza gate assegnato (`gate_id = NULL`)
- **10 passeggeri** con documenti unici (es. `AB1234567`)
- **Utenti** (almeno 5):
  - Un admin
  - Un operatore
  - Un utente compagnia (con `compagnia_id` che punta a una compagnia esistente)
  - Due utenti passeggero (con `passeggero_id` che punta a due passeggeri diversi)
  - Per le password usa un placeholder come `'hash_fittizio'`
- **Prenotazioni** (almeno 12):
  - Stati diversi: `'prenotata'`, `'pagata'`, `'cancellata'`, `'imbarcato'`
  - Per un volo con pochi posti (es. 50), inserisci più prenotazioni `'prenotata'`/`'pagata'` di quanti siano i posti, in modo da simulare un volo quasi pieno o esaurito
- **Carte d’imbarco** (almeno 3):
  - Solo per prenotazioni in stato `'imbarcato'`
  - Almeno una con `operatore_id = NULL` (check‑in online)
  - Almeno una con `operatore_id` valorizzato (check‑in al banco)

## Cosa devi fare

### 1. Prepara l’ambiente
Chiedi a Persona 1 il file `01_crea_database.sql` (o prendilo dal repository) e usalo per creare un database vuoto su cui testare.

### 2. Scrivi `database/02_dati_esempio.sql`
- Inserisci i dati nell’ordine corretto:
  1. `compagnie_aeree`
  2. `gate`
  3. `voli`
  4. `passeggeri`
  5. `utenti`
  6. `prenotazioni`
  7. `carte_imbarco`
- Usa `INSERT INTO … VALUES` elencando i valori nell’ordine delle colonne (oppure specificando i nomi delle colonne).
- Per i voli e le prenotazioni, inventa codici unici (es. `EN1234`, `PNR001`).
- Le date e gli orari devono essere nel formato `'YYYY-MM-DD HH:MM:SS'`.

**Esempi parziali** (NON copiarli direttamente – sono solo esempi di sintassi e struttura):

```sql
-- Compagnie
INSERT INTO compagnie_aeree (id, nome) VALUES (1, 'Air Dolomiti');

-- Gate
INSERT INTO gate (id, codice, stato) VALUES (1, 'G1', 'libero');

-- Voli
INSERT INTO voli (id, codice_volo, compagnia_id, gate_id, origine, destinazione, data_ora_partenza, data_ora_arrivo, posti_totali, stato)
VALUES (1, 'EN1234', 1, 1, 'MIL', 'ROM', '2026-05-20 08:30:00', '2026-05-20 09:45:00', 72, 'programmato');
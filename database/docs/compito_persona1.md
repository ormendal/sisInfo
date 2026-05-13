# Compito Persona 1 – Schema del database e vincoli di integrità

## Obiettivo
Progettare e realizzare il file `database/01_crea_database.sql` che contiene la definizione completa del database (tabelle, vincoli, indici).  

## Teoria di riferimento
- **DDL (Data Definition Language)**: `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`
- **Vincoli di integrità**:
  - `PRIMARY KEY` – identifica univocamente ogni riga
  - `FOREIGN KEY` – collega due tabelle, impedendo valori “orfani”
  - `CHECK` – impone una condizione booleana sui valori di una colonna
  - `UNIQUE` – vieta duplicati in una colonna
  - `NOT NULL` – impedisce valori nulli
  - Azioni referenziali: `ON DELETE CASCADE` (elimina a cascata) e `ON DELETE SET NULL` (annulla il riferimento)
- **Indici**: strutture ausiliarie per velocizzare le query (`CREATE INDEX`)

## Struttura del database
Il database ha 7 tabelle. Nel file `README.md` trovi lo schema completo con tutti i campi, i tipi, le chiavi e i vincoli.  
Il tuo compito è tradurre quello schema in comandi SQL corretti e funzionanti.

Le tabelle devono essere create nell’ordine giusto per rispettare le dipendenze (prima quelle senza chiavi esterne, poi le altre).  
L’ordine consigliato è:
1. `compagnie_aeree`
2. `gate`
3. `voli` (dipende da compagnie e gate)
4. `passeggeri`
5. `utenti` (dipende da compagnie e passeggeri)
6. `prenotazioni` (dipende da passeggeri e voli)
7. `carte_imbarco` (dipende da prenotazioni, gate, utenti)

Alla fine devi creare anche gli **indici** indicati nello schema.

## Cosa devi fare

### 1. Scrivi `database/01_crea_database.sql`
- Inizia con `PRAGMA foreign_keys = ON;` (importante per far funzionare le chiavi esterne in SQLite).
- Scrivi i comandi `CREATE TABLE` per tutte e 7 le tabelle.
- Per ogni tabella, rispetta esattamente:
  - Nome delle colonne
  - Tipo dati (es. `INTEGER`, `TEXT`, `DATETIME`, `REAL`)
  - Vincoli di colonna (`PRIMARY KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`)
  - Vincoli di tabella (`FOREIGN KEY … REFERENCES … ON DELETE …`)
- Aggiungi i tre indici previsti.

**Esempio parziale (solo per mostrare la sintassi, non copiarlo interamente!)**:
```sql
CREATE TABLE compagnie_aeree (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL
);
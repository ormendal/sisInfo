<h1>Sistema Informativo Aeroportuale</h1>
<p class="subtitle">Elaborato per Sistemi Informativi – Modellazione di basi dati e pianificazione architetturale</p>
# Sistema Informativo Aeroportuale - Bozza Progettuale

## 1. Scopo del sistema
Realizzare un sistema informativo per un aeroporto di piccole/medie dimensioni, con interfaccia web, che consenta:
- **Passeggeri**: cercare voli, prenotare biglietti, pagare, check‑in online, consultare la propria situazione.
- **Compagnie aeree**: creare e gestire i propri voli, monitorare l’occupazione.
- **Operatori aeroportuali**: gestire i gate, supervisionare il traffico aereo, effettuare il check‑in fisico al banco.

Il database è **SQLite**, con un massimo di **10 tabelle** (ne utilizziamo 7, lasciando spazio a futuri ampliamenti).

---

## 2. Database – Schema (7 tabelle)

### Tabella 1: `compagnie_aeree`
| Campo | Tipo | Vincoli | Note |
|-------|------|---------|------|
| id | INTEGER | PK | |
| nome | TEXT | NOT NULL | Nome della compagnia |

### Tabella 2: `gate`
| Campo | Tipo | Vincoli | Note |
|-------|------|---------|------|
| id | INTEGER | PK | |
| codice | TEXT | UNIQUE, NOT NULL | es. "G1" |
| stato | TEXT | CHECK('libero','occupato','manutenzione') | |

### Tabella 3: `voli`
| Campo | Tipo | Vincoli | Note |
|-------|------|---------|------|
| id | INTEGER | PK | |
| codice_volo | TEXT | UNIQUE, NOT NULL | es. "EN1234" |
| compagnia_id | INTEGER | FK→compagnie_aeree.id, NOT NULL | |
| gate_id | INTEGER | FK→gate.id, NULL | gate assegnato |
| origine | TEXT | NOT NULL | codice IATA (es. "MIL") |
| destinazione | TEXT | NOT NULL | codice IATA (es. "ROM") |
| data_ora_partenza | DATETIME | NOT NULL | |
| data_ora_arrivo | DATETIME | NOT NULL | |
| posti_totali | INTEGER | CHECK(>0) | capacità del volo |
| stato | TEXT | CHECK('programmato','partito','arrivato') | |

### Tabella 4: `passeggeri`
| Campo | Tipo | Vincoli | Note |
|-------|------|---------|------|
| id | INTEGER | PK | |
| nome | TEXT | NOT NULL | |
| cognome | TEXT | NOT NULL | |
| documento | TEXT | UNIQUE, NOT NULL | nr. passaporto o CI |

### Tabella 5: `prenotazioni`
| Campo | Tipo | Vincoli | Note |
|-------|------|---------|------|
| id | INTEGER | PK | |
| passeggero_id | INTEGER | FK→passeggeri.id, NOT NULL | |
| volo_id | INTEGER | FK→voli.id, NOT NULL | |
| codice_prenotazione | TEXT | UNIQUE, NOT NULL | PNR (6 caratteri) |
| data_prenotazione | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | |
| prezzo | REAL | CHECK(≥0) | costo biglietto |
| stato | TEXT | CHECK('prenotata','pagata','cancellata','imbarcato') | |

### Tabella 6: `carte_imbarco`
| Campo | Tipo | Vincoli | Note |
|-------|------|---------|------|
| id | INTEGER | PK | |
| prenotazione_id | INTEGER | FK→prenotazioni.id, UNIQUE | una carta per prenotazione |
| numero_posto | TEXT | | es. "12A" |
| gate_imbarco_id | INTEGER | FK→gate.id | gate effettivo di imbarco |
| data_emissione | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | istante del check‑in |
| operatore_id | INTEGER | FK→utenti.id, NULL | NULL se check‑in online |

### Tabella 7: `utenti`
| Campo | Tipo | Vincoli | Note |
|-------|------|---------|------|
| id | INTEGER | PK | |
| username | TEXT | UNIQUE, NOT NULL | |
| password_hash | TEXT | NOT NULL | per l'autenticazione |
| ruolo | TEXT | CHECK('admin','operatore','compagnia','passeggero') | |
| compagnia_id | INTEGER | FK→compagnie_aeree.id, NULL | solo se ruolo='compagnia' |
| passeggero_id | INTEGER | FK→passeggeri.id, NULL | solo se ruolo='passeggero' |

---

## 3. Schema ER testuale

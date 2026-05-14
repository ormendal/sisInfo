-- Script di creazione del database vuoto
PRAGMA foreign_keys = ON;

-- 1. COMPAGNIE AEREE
CREATE TABLE compagnie_aeree (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL
);

-- 2. GATE
CREATE TABLE gate (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codice TEXT NOT NULL UNIQUE,
    stato TEXT NOT NULL CHECK(stato IN ('libero', 'occupato', 'manutenzione'))
);

-- 3. VOLI
CREATE TABLE voli (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codice_volo TEXT NOT NULL UNIQUE,
    compagnia_id INTEGER NOT NULL,
    gate_id INTEGER,
    origine TEXT NOT NULL,
    destinazione TEXT NOT NULL,
    data_ora_partenza DATETIME NOT NULL,
    data_ora_arrivo DATETIME NOT NULL,
    posti_totali INTEGER NOT NULL CHECK(posti_totali > 0),
    stato TEXT NOT NULL CHECK(stato IN ('programmato', 'partito', 'arrivato')),
    FOREIGN KEY (compagnia_id) REFERENCES compagnie_aeree(id) ON DELETE CASCADE,
    FOREIGN KEY (gate_id) REFERENCES gate(id) ON DELETE SET NULL
);

-- 4. PASSEGGERI
CREATE TABLE passeggeri (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    cognome TEXT NOT NULL,
    documento TEXT NOT NULL UNIQUE
);

-- 5. PRENOTAZIONI
CREATE TABLE prenotazioni (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    passeggero_id INTEGER NOT NULL,
    volo_id INTEGER NOT NULL,
    codice_prenotazione TEXT NOT NULL UNIQUE,
    data_prenotazione DATETIME NOT NULL DEFAULT (datetime('now')),
    prezzo REAL NOT NULL CHECK(prezzo >= 0),
    stato TEXT NOT NULL CHECK(stato IN ('prenotata', 'pagata', 'cancellata', 'imbarcato')),
    FOREIGN KEY (passeggero_id) REFERENCES passeggeri(id) ON DELETE CASCADE,
    FOREIGN KEY (volo_id) REFERENCES voli(id) ON DELETE CASCADE
);

-- 6. CARTE D'IMBARCO
CREATE TABLE carte_imbarco (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    prenotazione_id INTEGER NOT NULL UNIQUE,
    numero_posto TEXT,
    gate_imbarco_id INTEGER,
    data_emissione DATETIME NOT NULL DEFAULT (datetime('now')),
    operatore_id INTEGER,
    FOREIGN KEY (prenotazione_id) REFERENCES prenotazioni(id) ON DELETE CASCADE,
    FOREIGN KEY (gate_imbarco_id) REFERENCES gate(id) ON DELETE SET NULL,
    FOREIGN KEY (operatore_id) REFERENCES utenti(id) ON DELETE SET NULL
);

-- 7. UTENTI
CREATE TABLE utenti (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    ruolo TEXT NOT NULL CHECK(ruolo IN ('admin', 'operatore', 'compagnia', 'passeggero')),
    compagnia_id INTEGER,
    passeggero_id INTEGER,
    FOREIGN KEY (compagnia_id) REFERENCES compagnie_aeree(id) ON DELETE CASCADE,
    FOREIGN KEY (passeggero_id) REFERENCES passeggeri(id) ON DELETE CASCADE
);

-- INDICI
CREATE INDEX idx_voli_orig_dest_data ON voli(origine, destinazione, data_ora_partenza);
CREATE INDEX idx_prenotazioni_volo_id ON prenotazioni(volo_id);
CREATE INDEX idx_prenotazioni_passeggero_id ON prenotazioni(passeggero_id);
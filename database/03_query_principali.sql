-- Query principali del sistema
-- =============================================
-- QUERY PRINCIPALI DEL SISTEMA AEROPORTUALE
-- =============================================

-- 1. RICERCA VOLI
-- Filtra per origine, destinazione, data. Calcola i posti liberi.
-- Parametri: 'MIL', 'ROM', '2026-05-20'
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

-- 2. CONTROLLO OVERBOOKING
-- Dato un id_volo, restituisce i posti ancora liberi.
-- Parametro: volo_id = 3
SELECT v.posti_totali - COUNT(p.id) AS posti_liberi
FROM voli v
LEFT JOIN prenotazioni p ON p.volo_id = v.id AND p.stato IN ('prenotata','pagata')
WHERE v.id = 3
GROUP BY v.id;

-- 3. INSERIMENTO NUOVA PRENOTAZIONE
-- Esempio: il passeggero 1 (Mario Rossi) prenota il volo 2.
INSERT INTO prenotazioni (passeggero_id, volo_id, codice_prenotazione, prezzo, stato)
VALUES (1, 2, 'PNR101', 49.99, 'prenotata');

-- 4. PAGAMENTO
-- Aggiorna lo stato della prenotazione da 'prenotata' a 'pagata'.
-- Parametro: prenotazione_id = 1
UPDATE prenotazioni SET stato = 'pagata' WHERE id = 1;

-- 5. CHECK-IN ONLINE
-- Si assume che la prenotazione 2 sia stata pagata.
UPDATE prenotazioni SET stato = 'imbarcato' WHERE id = 2;
INSERT INTO carte_imbarco (prenotazione_id, numero_posto, gate_imbarco_id, operatore_id)
VALUES (2, '14A', 1, NULL);  -- operatore_id NULL = check-in online

-- 6. CHECK-IN AL BANCO
-- a) Cerca la prenotazione pagata per un dato documento.
-- Parametro: documento = 'CD9876543'
SELECT p.id AS prenotazione_id, pa.nome, pa.cognome, v.codice_volo
FROM prenotazioni p
JOIN passeggeri pa ON p.passeggero_id = pa.id
JOIN voli v ON p.volo_id = v.id
WHERE pa.documento = 'CD9876543'
  AND p.stato = 'pagata';

-- b) Esegue il check-in per la prenotazione trovata (supponiamo id=4).
UPDATE prenotazioni SET stato = 'imbarcato' WHERE id = 4;
INSERT INTO carte_imbarco (prenotazione_id, numero_posto, gate_imbarco_id, operatore_id)
VALUES (4, '18B', 2, 3);  -- operatore_id 3 = operatore1

-- 7. CRUSCOTTO PASSEGGERO
-- Mostra tutte le prenotazioni di un passeggero con i dettagli del volo e della carta d'imbarco.
-- Parametro: passeggero_id = 1
SELECT p.codice_prenotazione, p.stato, v.codice_volo, v.origine, v.destinazione,
       v.data_ora_partenza, p.prezzo,
       c.numero_posto, g.codice AS gate_imbarco
FROM prenotazioni p
JOIN voli v ON p.volo_id = v.id
LEFT JOIN carte_imbarco c ON c.prenotazione_id = p.id
LEFT JOIN gate g ON c.gate_imbarco_id = g.id
WHERE p.passeggero_id = 1
ORDER BY p.data_prenotazione DESC;

-- 8. CRUSCOTTO COMPAGNIA
-- Voli di una compagnia con il conteggio dei posti liberi.
-- Parametro: compagnia_id = 1
SELECT v.codice_volo, v.origine, v.destinazione, v.data_ora_partenza,
       v.posti_totali - COUNT(p.id) AS posti_liberi, v.stato
FROM voli v
LEFT JOIN prenotazioni p ON p.volo_id = v.id AND p.stato IN ('prenotata','pagata')
WHERE v.compagnia_id = 1
GROUP BY v.id
ORDER BY v.data_ora_partenza;

-- 9. MONITORAGGIO GATE
-- Mostra lo stato di ogni gate e il volo eventualmente assegnato.
SELECT g.codice, g.stato, v.codice_volo AS volo_assegnato
FROM gate g
LEFT JOIN voli v ON g.id = v.gate_id AND v.stato = 'programmato'
ORDER BY g.codice;

-- 10. MODIFICA STATO GATE
-- Aggiorna lo stato di un gate.
-- Parametro: gate_id = 1, nuovo_stato = 'occupato'
UPDATE gate SET stato = 'occupato' WHERE id = 1;
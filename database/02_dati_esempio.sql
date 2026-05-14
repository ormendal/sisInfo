-- Popolamento con dati di esempio
-- =============================================
-- POPOLAMENTO DATABASE AEROPORTUALE
-- =============================================

-- 1. COMPAGNIE
INSERT INTO compagnie_aeree (id, nome) VALUES
(1, 'Air Dolomiti'),
(2, 'Ryanair');

-- 2. GATE
INSERT INTO gate (id, codice, stato) VALUES
(1, 'G1', 'libero'),
(2, 'G2', 'occupato'),
(3, 'G3', 'manutenzione');

-- 3. VOLI
INSERT INTO voli (id, codice_volo, compagnia_id, gate_id, origine, destinazione, data_ora_partenza, data_ora_arrivo, posti_totali, stato) VALUES
(1, 'EN1234', 1, 1, 'MIL', 'ROM', '2026-05-20 08:30:00', '2026-05-20 09:45:00', 72, 'programmato'),
(2, 'FR5678', 2, 2, 'ROM', 'MIL', '2026-05-20 10:00:00', '2026-05-20 11:15:00', 180, 'programmato'),
(3, 'EN1235', 1, NULL, 'MIL', 'NAP', '2026-05-21 07:00:00', '2026-05-21 08:20:00', 50, 'programmato'),
(4, 'FR9000', 2, 1, 'NAP', 'MIL', '2026-05-19 18:00:00', '2026-05-19 19:30:00', 180, 'partito'),
(5, 'EN2000', 1, 2, 'MIL', 'ROM', '2026-05-18 09:00:00', '2026-05-18 10:15:00', 72, 'arrivato');

-- 4. PASSEGGERI
INSERT INTO passeggeri (id, nome, cognome, documento) VALUES
(1, 'Mario', 'Rossi', 'AB1234567'),
(2, 'Laura', 'Bianchi', 'CD9876543'),
(3, 'Giuseppe', 'Verdi', 'EF1122334'),
(4, 'Anna', 'Neri', 'GH5566778'),
(5, 'Marco', 'Gialli', 'IL9900112'),
(6, 'Francesca', 'Blu', 'MN2233445'),
(7, 'Luca', 'Marrone', 'OP3344556'),
(8, 'Sofia', 'Viola', 'QR4455667'),
(9, 'Davide', 'Arancione', 'ST5566778'),
(10, 'Elena', 'Rosa', 'UV6677889');

-- 5. UTENTI (password_hash fittizio per test)
INSERT INTO utenti (id, username, password_hash, ruolo, compagnia_id, passeggero_id) VALUES
(1, 'admin', 'fakehash_admin', 'admin', NULL, NULL),
(2, 'compagnia1', 'fakehash_comp1', 'compagnia', 1, NULL),
(3, 'operatore1', 'fakehash_op1', 'operatore', NULL, NULL),
(4, 'passeggero1', 'fakehash_pax1', 'passeggero', NULL, 1),
(5, 'passeggero2', 'fakehash_pax2', 'passeggero', NULL, 2),
(6, 'passeggero3', 'fakehash_pax3', 'passeggero', NULL, 3),
(7, 'passeggero4', 'fakehash_pax4', 'passeggero', NULL, 4),
(8, 'passeggero5', 'fakehash_pax5', 'passeggero', NULL, 5);

-- 6. PRENOTAZIONI
INSERT INTO prenotazioni (id, passeggero_id, volo_id, codice_prenotazione, data_prenotazione, prezzo, stato) VALUES
(1, 1, 1, 'PNR001', '2026-05-13 10:00:00', 89.99, 'pagata'),
(2, 2, 1, 'PNR002', '2026-05-13 11:00:00', 89.99, 'prenotata'),
(3, 3, 1, 'PNR003', '2026-05-13 12:00:00', 89.99, 'cancellata'),
(4, 4, 2, 'PNR004', '2026-05-13 13:00:00', 49.99, 'pagata'),
(5, 5, 2, 'PNR005', '2026-05-13 14:00:00', 49.99, 'imbarcato'),
(6, 6, 3, 'PNR006', '2026-05-13 15:00:00', 79.99, 'prenotata'),
(7, 7, 3, 'PNR007', '2026-05-13 16:00:00', 79.99, 'prenotata'),
(8, 8, 3, 'PNR008', '2026-05-13 17:00:00', 79.99, 'prenotata'),
(9, 9, 3, 'PNR009', '2026-05-13 18:00:00', 79.99, 'prenotata'),
(10, 10, 3, 'PNR010', '2026-05-13 19:00:00', 79.99, 'prenotata'),
(11, 1, 3, 'PNR011', '2026-05-13 20:00:00', 79.99, 'prenotata'),
(12, 2, 3, 'PNR012', '2026-05-13 21:00:00', 79.99, 'prenotata'),
(13, 3, 4, 'PNR013', '2026-05-12 10:00:00', 29.99, 'imbarcato'),
(14, 4, 5, 'PNR014', '2026-05-11 10:00:00', 99.99, 'imbarcato');

-- 7. CARTE D'IMBARCO (solo per prenotazioni 'imbarcato')
INSERT INTO carte_imbarco (id, prenotazione_id, numero_posto, gate_imbarco_id, data_emissione, operatore_id) VALUES
(1, 5, '10A', 2, '2026-05-13 18:00:00', 3),    -- check-in al banco da operatore1
(2, 13, '22C', 1, '2026-05-12 16:00:00', NULL),  -- check-in online
(3, 14, '5A', 2, '2026-05-11 15:00:00', 3);     -- check-in al banco
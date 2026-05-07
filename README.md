<h1>Sistema Informativo Aeroportuale</h1>
<p class="subtitle">Elaborato per Sistemi Informativi – Modellazione di basi dati e pianificazione architetturale</p>

<!-- 1. Descrizione sintetica -->
<h2>1. Descrizione sintetica del dominio</h2>
<p>Un aeroporto intende gestire l'assegnazione delle proprie risorse fisiche (piste, gate, terminal) ai voli operati dalle compagnie aeree, e al tempo stesso permettere a queste ultime di amministrare in autonomia prenotazioni, biglietti, passeggeri e bagagli. Il sistema centralizza la logistica aeroportuale e delega alle compagnie la gestione commerciale dei propri voli, assicurando che le risorse condivise non vengano mai assegnate in conflitto.</p>

<!-- 2. Entità principali -->
<h2>2. Entità principali</h2>

<h3>Lato aeroporto</h3>
<ul>
  <li><strong>Terminal</strong> – area fisica dell’aeroporto</li>
  <li><strong>Gate</strong> – punto di imbarco, appartiene a un terminal</li>
  <li><strong>Pista</strong> – superficie per decollo/atterraggio</li>
  <li><strong>SlotOrario</strong> – finestra temporale assegnata a un volo su una pista</li>
  <li><strong>PersonaleAeroportuale</strong> – operatori, gestori gate, controllori</li>
</ul>

<h3>Lato compagnia / volo</h3>
<ul>
  <li><strong>CompagniaAerea</strong> – operatore che utilizza le risorse aeroportuali</li>
  <li><strong>Aereo</strong> – velivolo con capacità per classe</li>
  <li><strong>Volo</strong> – collegamento tra due aeroporti in data/ora specifica</li>
  <li><strong>Equipaggio</strong> – personale di bordo con ruolo</li>
  <li><strong>Rotta</strong> – coppia origine/destinazione operata da una compagnia</li>
</ul>

<h3>Lato passeggero</h3>
<ul>
  <li><strong>Passeggero</strong> – utente finale</li>
  <li><strong>Prenotazione</strong> – ordine che può coprire più posti</li>
  <li><strong>Biglietto</strong> – posto specifico su un volo, con classe</li>
  <li><strong>Bagaglio</strong> – associato a passeggero e volo</li>
  <li><strong>Rimborso</strong> – generato da cancellazione volo</li>
</ul>

<!-- 3. Schema relazionale -->
<h2>3. Schema relazionale</h2>
<p>Di seguito sono elencate le relazioni con chiavi primarie (PK) e chiavi esterne (FK).</p>

<h3>Terminal</h3>
<pre>Terminal(<strong>idTerminal PK</strong>, nome, numGate)</pre>

<h3>Gate</h3>
<pre>Gate(<strong>idGate PK</strong>, numero, idTerminal FK→Terminal, stato)
-- stato: 'libero' | 'occupato' | 'manutenzione'</pre>

<h3>Pista</h3>
<pre>Pista(<strong>idPista PK</strong>, codice, stato)
-- stato: 'operativa' | 'manutenzione'</pre>

<h3>CompagniaAerea</h3>
<pre>CompagniaAerea(<strong>idCompagnia PK</strong>, nome, codiceIATA, terminalPreferenziale FK→Terminal)</pre>

<h3>Aereo</h3>
<pre>Aereo(<strong>idAereo PK</strong>, modello, idCompagnia FK→CompagniaAerea, capEconomy, capBusiness, capFirst)</pre>

<h3>Rotta</h3>
<pre>Rotta(<strong>idRotta PK</strong>, idCompagnia FK→CompagniaAerea, aeroportoOrigine, aeroportoDestinazione)</pre>

<h3>Volo</h3>
<pre>Volo(<strong>idVolo PK</strong>, codiceVolo, idRotta FK→Rotta, idAereo FK→Aereo, idGate FK→Gate,
     dataOraPartenza, dataOraArrivo, stato)
-- stato: 'programmato' | 'in ritardo' | 'cancellato' | 'concluso'</pre>

<h3>SlotOrario</h3>
<pre>SlotOrario(<strong>idSlot PK</strong>, idPista FK→Pista, idVolo FK→Volo, inizio, fine, tipo)
-- tipo: 'decollo' | 'atterraggio'
-- VINCOLO: nessun altro slot sulla stessa pista si sovrappone temporalmente</pre>

<h3>Equipaggio</h3>
<pre>Equipaggio(<strong>idPersona PK</strong>, nome, cognome, idCompagnia FK→CompagniaAerea, ruolo)
-- ruolo: 'comandante' | 'copilota' | 'assistente'</pre>

<h3>AssegnazioneEquipaggio</h3>
<pre>AssegnazioneEquipaggio(<strong>idVolo FK→Volo, idPersona FK→Equipaggio</strong>, PRIMARY KEY (idVolo, idPersona))</pre>

<h3>Passeggero</h3>
<pre>Passeggero(<strong>idPasseggero PK</strong>, nome, cognome, email, documentoIdentita)</pre>

<h3>Prenotazione</h3>
<pre>Prenotazione(<strong>idPrenotazione PK</strong>, idPasseggero FK→Passeggero, dataPrenotazione, stato)
-- stato: 'confermata' | 'annullata'</pre>

<h3>Biglietto</h3>
<pre>Biglietto(<strong>idBiglietto PK</strong>, idPrenotazione FK→Prenotazione, idVolo FK→Volo, posto, classe, prezzo)
-- classe: 'economy' | 'business' | 'first'
-- VINCOLO: posti venduti per classe &le; capacità aereo per quella classe</pre>

<h3>Bagaglio</h3>
<pre>Bagaglio(<strong>idBagaglio PK</strong>, idBiglietto FK→Biglietto, peso, stato)
-- stato: 'registrato' | 'imbarcato' | 'riconsegnato' | 'smarrito'</pre>

<h3>Rimborso</h3>
<pre>Rimborso(<strong>idRimborso PK</strong>, idBiglietto FK→Biglietto, importo, dataRimborso, motivo)</pre>

<h3>PersonaleAeroportuale</h3>
<pre>PersonaleAeroportuale(<strong>idPersonale PK</strong>, nome, cognome, ruolo, idTerminal FK→Terminal)
-- ruolo: 'gestore gate' | 'operatore torre' | 'amministratore'</pre>

<!-- 4. Descrizione ruoli utente -->
<h2>4. Descrizione dei ruoli utente</h2>
<table>
  <tr><th>Ruolo</th><th>Descrizione</th></tr>
  <tr><td>Amministratore aeroporto</td><td>Gestisce terminal, gate, piste, personale e assegna risorse ai voli</td></tr>
  <tr><td>Operatore torre di controllo</td><td>Gestisce gli slot orari sulle piste, monitora conflitti</td></tr>
  <tr><td>Gestore gate</td><td>Aggiorna lo stato dei gate, registra gli imbarchi</td></tr>
  <tr><td>Compagnia aerea</td><td>Gestisce i propri voli, aerei, equipaggio, passeggeri, biglietti, bagagli</td></tr>
  <tr><td>Passeggero</td><td>Visualizza e gestisce le proprie prenotazioni e biglietti</td></tr>
</table>

<!-- 5. Tabella operazioni CRUD -->
<h2>5. Tabella delle operazioni CRUD per ruolo</h2>
<p>Legenda: <strong>C</strong> = Create, <strong>R</strong> = Read, <strong>U</strong> = Update, <strong>D</strong> = Delete. Le operazioni sono riferite alle entità.</p>
<table>
  <tr><th>Entità</th><th>Admin</th><th>Op. Torre</th><th>Gest. Gate</th><th>Compagnia</th><th>Passeggero</th></tr>
  <tr><td>Terminal</td><td>CRUD</td><td>R</td><td>R</td><td>R</td><td>–</td></tr>
  <tr><td>Gate</td><td>CRUD</td><td>R</td><td>RU</td><td>R</td><td>–</td></tr>
  <tr><td>Pista</td><td>CRUD</td><td>RU</td><td>–</td><td>R</td><td>–</td></tr>
  <tr><td>SlotOrario</td><td>CRD</td><td>CRUD</td><td>R</td><td>R</td><td>–</td></tr>
  <tr><td>CompagniaAerea</td><td>CRUD</td><td>R</td><td>R</td><td>R (propria)</td><td>–</td></tr>
  <tr><td>Aereo</td><td>R</td><td>–</td><td>–</td><td>CRUD (propri)</td><td>–</td></tr>
  <tr><td>Volo</td><td>RRRU</td><td>CRUD</td><td>R</td><td>CRUD (propri)</td><td>R</td></tr>
  <tr><td>Equipaggio</td><td>–</td><td>–</td><td>–</td><td>CRUD (proprio)</td><td>–</td></tr>
  <tr><td>Prenotazione</td><td>R</td><td>–</td><td>–</td><td>R</td><td>CRUD (propria)</td></tr>
  <tr><td>Biglietto</td><td>R</td><td>–</td><td>R</td><td>RU</td><td>R (proprio)</td></tr>
  <tr><td>Bagaglio</td><td>–</td><td>–</td><td>RU</td><td>CRUD</td><td>R (proprio)</td></tr>
  <tr><td>Rimborso</td><td>R</td><td>–</td><td>–</td><td>CR</td><td>R (proprio)</td></tr>
</table>

<!-- 6. Architettura -->
<h2>6. Proposta di architettura dell'applicazione</h2>
<div style="display: flex; flex-direction: column; gap: 15px; background: #f8f9fa; padding: 20px; border-radius: 8px;">
  <div><strong>INTERFACCIA UTENTE</strong><br>
    • Portale passeggero (web / mobile)<br>
    • Dashboard compagnia aerea<br>
    • Pannello operatori aeroporto<br>
    • Tabellone arrivi/partenze (pubblico)
  </div>
  <div style="text-align: center; font-weight: bold; color: #003366;">↕ HTTP / REST API ↕</div>
  <div><strong>LOGICA APPLICATIVA</strong><br>
    • Autenticazione e controllo ruoli<br>
    • Verifica disponibilità gate/slot<br>
    • Controllo overbooking per classe<br>
    • Gestione stati volo e notifiche<br>
    • Calcolo rimborsi su cancellazione
  </div>
  <div style="text-align: center; font-weight: bold; color: #003366;">↕ ACCESSO AI DATI ↕</div>
  <div><strong>ACCESSO AI DATI</strong><br>
    • Query parametrizzate per ruolo<br>
    • Viste dedicate per passeggero<br>
    • Stored procedure per slot e CRUD
  </div>
  <div style="text-align: center; font-weight: bold; color: #003366;">↕ DATABASE RELAZIONALE ↕</div>
  <div><strong>DATABASE RELAZIONALE</strong><br>
    • Schema + vincoli di integrità<br>
    • Trigger per controllo overbooking<br>
    • Trigger per conflitti slot pista
  </div>
</div>

<!-- 7. Motivazione parti intercambiabili -->
<h2>7. Motivazione delle parti intercambiabili</h2>
<ul>
  <li><strong>Interfaccia utente:</strong> può essere sostituita (es. da app mobile a totem aeroportuale) senza modificare logica o database, poiché comunica esclusivamente tramite API REST.</li>
  <li><strong>Layer di accesso ai dati:</strong> adattabile a un ORM diverso o a un database alternativo (es. PostgreSQL → MySQL) senza cambiare la logica applicativa, purché lo schema resti invariato.</li>
  <li><strong>Database:</strong> espone viste e stored procedure che disaccoppiano la struttura interna dalle query dell’applicazione: una ristrutturazione delle tabelle non richiede la riscrittura del frontend.</li>
  <li><strong>Modulo notifiche:</strong> separato dalla logica core, può essere sostituito con qualsiasi provider esterno (email, SMS, push notification) senza impatto sul resto del sistema.</li>
</ul>

<!-- 8. Query SQL significative -->
<h2>8. Query SQL significative</h2>

<h3>Q1 – Tabellone partenze in tempo reale</h3>
<pre>SELECT v.codiceVolo, r.aeroportoDestinazione, v.dataOraPartenza, v.stato, g.numero AS gate
FROM Volo v
JOIN Rotta r ON v.idRotta = r.idRotta
JOIN Gate g ON v.idGate = g.idGate
WHERE DATE(v.dataOraPartenza) = CURRENT_DATE
  AND r.aeroportoOrigine = 'FCO'
ORDER BY v.dataOraPartenza;</pre>

<h3>Q2 – Verifica conflitti di slot su una pista</h3>
<pre>SELECT sl.idSlot, sl.idVolo, s2.idVolo AS voloInConflitto
FROM SlotOrario sl
JOIN SlotOrario s2
  ON sl.idPista = s2.idPista
 AND sl.idSlot &lt;&gt; s2.idSlot
 AND sl.inizio &lt; s2.fine
 AND sl.fine &gt; s2.inizio;</pre>

<h3>Q3 – Controllo overbooking per classe su un volo</h3>
<pre>SELECT v.codiceVolo, b.classe,
       COUNT(b.idBiglietto) AS postiVenduti,
       CASE b.classe
           WHEN 'economy'  THEN a.capEconomy
           WHEN 'business' THEN a.capBusiness
           WHEN 'first'    THEN a.capFirst
       END AS capienza
FROM Biglietto b
JOIN Volo  v ON b.idVolo  = v.idVolo
JOIN Aereo a ON v.idAereo = a.idAereo
WHERE v.idVolo = :idVolo
GROUP BY b.classe, a.capEconomy, a.capBusiness, a.capFirst, v.codiceVolo
HAVING COUNT(b.idBiglietto) &gt;= capienza;</pre>

<h3>Q4 – Storico voli di un passeggero con stato bagagli</h3>
<pre>SELECT v.codiceVolo, r.aeroportoOrigine, r.aeroportoDestinazione,
       v.dataOraPartenza, bg.stato AS statoBagaglio
FROM Passeggero p
JOIN Prenotazione pr ON p.idPasseggero = pr.idPasseggero
JOIN Biglietto  b ON pr.idPrenotazione = b.idPrenotazione
JOIN Volo  v ON b.idVolo  = v.idVolo
JOIN Rotta  r ON v.idRotta  = r.idRotta
LEFT JOIN Bagaglio bg ON bg.idBiglietto = b.idBiglietto
WHERE p.idPasseggero = :idPasseggero
ORDER BY v.dataOraPartenza DESC;</pre>

<h3>Q5 – Gate liberi in una fascia oraria specifica</h3>
<pre>SELECT g.idGate, g.numero, t.nome AS terminal
FROM Gate g
JOIN Terminal t ON g.idTerminal = t.idTerminal
WHERE g.stato &lt;&gt; 'manutenzione'
  AND g.idGate NOT IN (
      SELECT v.idGate
      FROM Volo v
      WHERE v.stato NOT IN ('cancellato','concluso')
        AND v.dataOraPartenza BETWEEN :inizioFascia AND :fineFascia
  );</pre>

<h3>Q6 – Passeggeri da rimborsare per voli cancellati nelle ultime 24 ore</h3>
<pre>SELECT p.nome, p.cognome, p.email,
       b.idBiglietto, b.prezzo AS importoDaRimborsare,
       v.codiceVolo
FROM Volo v
JOIN Biglietto  b ON b.idVolo  = v.idVolo
JOIN Prenotazione pr ON b.idPrenotazione = pr.idPrenotazione
JOIN Passeggero  p ON pr.idPasseggero  = p.idPasseggero
LEFT JOIN Rimborso r ON r.idBiglietto = b.idBiglietto
WHERE v.stato = 'cancellato'
  AND v.dataOraPartenza &gt;= NOW() - INTERVAL '24 hours'
  AND r.idRimborso IS NULL;</pre>

</body>
</html>

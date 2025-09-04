// index.js (Node.js 20.x)

//Exportiert die Handler_Funktion, die von AWS Lambda automatisch aufgerufen wird
exports.handler = async (event) => {
    //liest den Slack Bot Token aus den Umgebungsvariablen der Lambda 
    const token = process.env.SLACK_BOT_TOKEN;
    //Liest die Channel-ID aus der den Umgebungsvariablen
    const channel = process.env.SLACK_CHANNEL_ID;

    if (!token || !channel) throw new Error("SLACK_BOT_TOKEN oder SLACK_CHANNEL_ID fehlt!");

    const text =
        (event && event.text) ||
        `Hier grüßt die Lambda! ${new Date().toISOString()}`;

    // Schritt 1: Bot dem Channel beitreten lassen (nur bei öffentlichen Channels nötig)
     const joinRes = await fetch("https://slack.com/api/conversations.join", {
        method: "POST",
        headers: {
            "Authorization": `Bearer ${token}`,
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ channel})
     });


        //Sendet die Nachricht an die Slack-API (chat.postMessage-Endpunkt)
        //fetch() wird in Node.js 20 nativ unterstützt, daher brauchen wir keine extra Bibliothek

        const res = await fetch("https://slack.com/api/chat.postMessage", {
            method: "POST", // HTTP-Methode: POST, weil wir Daten senden
            headers: {
                // Authorization-Header: enthält das Slack Bot Token
                Authorization: `Bearer ${token}`,
                // Content-Type: sagt Slack, dass wir JSON im Body schicken
                "Content-Type": "application/json; charset=utf-8",
            },
            // Body (Nachrichtendaten): enthält Channel_ID und den eigentlichen Text
            body: JSON.stringify({ channel, text }),
        });

        // Antwort von Slack als JSON parsen (z.B. {ok: true, channel: "C...", ts "..."})
        const data = await res.json();

        // Falls Slack ein Fehler-Objekt zurückgibt (ok=false), werfen wir einen Fehler
        if (!data.ok) {
            throw new Error(`Slack API error: ${data.error}`);
        }

        //Wenn alles geklappt hat, gibt die Lambda eine Bestätigung zurück
        // Enthält ok=true und den Zeitstempel (ts) der Nachricht in Slack

        return { ok: true, ts: data.ts};



};
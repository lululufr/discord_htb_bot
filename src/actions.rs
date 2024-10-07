use csv::ReaderBuilder;
use serenity::async_trait;
use serenity::model::channel::Message;
use serenity::prelude::*;
use std::error::Error;
use std::fs::File;

pub(crate) struct Handler;

#[async_trait]
impl EventHandler for Handler {
    async fn message(&self, ctx: Context, msg: Message) {
        if msg.content.starts_with('!') {
            // Commande register
            if msg.content.len() >= 9 && &msg.content[1..9] == "register" {
                let saying = if msg.content.len() > 9 {
                    format!("Bonjour {}", &msg.content[10..])
                } else {
                    "Commande incomplète".to_string()
                };

                if let Err(err) = msg.channel_id.say(&ctx.http, saying).await {
                    println!("Erreur lors de l'envoi du message: {:?}", err);
                }
            }

            // Commande my_info
            if msg.content.len() >= 8 && &msg.content[1..8] == "my_info" {
                let user_info = if let Some(info) = read_user_info(&msg.author.name).ok() {
                    info
                } else {
                    "Informations utilisateur non trouvées".to_string()
                };

                if let Err(err) = msg.channel_id.say(&ctx.http, user_info).await {
                    println!("Erreur lors de l'envoi du message: {:?}", err);
                }
            }
        }
    }
}

// Fonction pour lire les informations de l'utilisateur dans un fichier CSV
fn read_user_info(username: &str) -> Result<String, Box<dyn Error>> {
    let file = File::open("users.csv")?;
    let mut rdr = ReaderBuilder::new().delimiter(b';').from_reader(file);

    for result in rdr.records() {
        let record = result?;
        // Supposons que le fichier CSV contient les informations sous la forme : username;info
        if &record[0] == username {
            return Ok(record[1].to_string());
        }
    }

    Err("Utilisateur non trouvé".into())
}

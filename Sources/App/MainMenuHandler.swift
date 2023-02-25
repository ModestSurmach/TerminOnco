//
//  File.swift
//  
//
//  Created by Modest Surmach on 25.02.2023.
//

import Vapor
import telegram_vapor_bot

final class MainMenuHandler {
    
    static func addHandlers(app: Vapor.Application, bot: TGBotPrtcl) {
        startHandler(app: app, bot: bot)
    }
    
    private static func startHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGMessageHandler(filters: .all && !.command.names(["/start"])) { update,bot in 
            let params = TGSendMessageParams(chatId: .chat(update.message!.chat.id), text: "Hi")
            try bot.sendMessage(params: params)
        }
        bot.connection.dispatcher.add(handler)
    }
    
    
}

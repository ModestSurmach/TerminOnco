//
//  File.swift
//  
//
//  Created by Modest Surmach on 26.02.2023.
//

import Foundation
import Vapor
import telegram_vapor_bot


var name: String?
var itsName = false

var dateOfBirthday: String?
var itsDateOfBithday = false

var phone: String?
var itsPhone = false



final class PrimaryAppointmentHandler {
    
    
    static func addHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        primaryAppointmentHandler(app: app, bot: bot)
        dateOfBirthHandler(app: app, bot: bot)
        
        fioHandler(app: app, bot: bot)
        phoneNumberHandler(app: app, bot: bot)
        
    }
    
    
    
    private static func primaryAppointmentHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        
        let textSendMessage =
"""
            Заполнить
"""
        
        
        let handler = TGCallbackQueryHandler(pattern: "PrimaryAppointment") { update, bot in
            guard let userId = update.callbackQuery?.message?.chat.id else { fatalError("user id not found") }
            
            
            
            var nameButton: [TGInlineKeyboardButton] = [.init(text: "ФИО:", callbackData: "fioHandler")]
            let phoneButton: [TGInlineKeyboardButton] = [.init(text: "Телефон", callbackData: "phoneNumber")]
            var dateOfBirthButton: [TGInlineKeyboardButton] = [.init(text: "Введите дату рождения", callbackData: "birtheyData")]

            let buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
            let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)

            let params: TGSendMessageParams = .init(chatId: .chat(userId), text: textSendMessage, replyMarkup: .inlineKeyboardMarkup(keybord))
            

            try bot.sendMessage(params: params)
            
            
            
            let handler1 = TGMessageHandler { update, bot in
                if itsName == true {
                    name = update.message?.text
                    
                    print("FIO: \(name)")
                    nameButton = [.init(text: "ФИО: \(name!)", callbackData: "fioHandler")]
                    let buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
                    let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
                    let params: TGSendMessageParams = .init(chatId: .chat(userId), text: textSendMessage, replyMarkup: .inlineKeyboardMarkup(keybord))
                    itsName = false
                    try bot.sendMessage(params: params)
                } else if itsDateOfBithday == true {
                    
                    dateOfBirthday = update.message?.text
                    print("Date Birthday: \(dateOfBirthday)")
                    
                    dateOfBirthButton = [.init(text: dateOfBirthday!, callbackData: "birtheyData")]
                    let buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
                    let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
                    let params: TGSendMessageParams = .init(chatId: .chat(userId), text: textSendMessage, replyMarkup: .inlineKeyboardMarkup(keybord))
                    
                    itsDateOfBithday = false
                    try bot.sendMessage(params: params)
                    
                    } else {}
    }
            bot.connection.dispatcher.add(handler1)
            
            
        }
             bot.connection.dispatcher.add(handler)
        

    }
    

        
    
    private static func fioHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCallbackQueryHandler(pattern: "fioHandler") { update, bot in
            guard let userId = update.callbackQuery?.message?.chat.id else { fatalError("user id not found") }
            let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Введите ФИО")
            itsName = true
            try bot.sendMessage(params: params)
        }
        
        bot.connection.dispatcher.add(handler)
    }

    
      private static func dateOfBirthHandler(app: Vapor.Application, bot: TGBotPrtcl) {
          let handler = TGCallbackQueryHandler(pattern: "birtheyData") { update, bot in
              guard let userId = update.callbackQuery?.message?.chat.id else { fatalError("user id not found") }
              let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Введите дату рождения")
              itsDateOfBithday = true
              try bot.sendMessage(params: params)
          }
          
          bot.connection.dispatcher.add(handler)

          }
    
    private static func phoneNumberHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        
    }
          
          
          
          

        
    }

    
    
//    static func sendForm(app: Vapor, bot: TGBotPrtcl) {
//        let handler = TGMessageHandler { update, bot in
//            let params = TGSendPhotoParams(chatId: .chat(update.message?.chat)
//        }
//    }


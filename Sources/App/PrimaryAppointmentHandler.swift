//
//  File.swift
//  
//
//  Created by Modest Surmach on 26.02.2023.
//

import Foundation
import Vapor
import telegram_vapor_bot
import AppKit


var name: String?
var itsName = false

var dateOfBirthday: String?
var itsDateOfBithday = false

var phone: String?
var itsPhone = false




func clearData() {
    name = nil
    dateOfBirthday = nil
    phone = nil
}


final class PrimaryAppointmentHandler {
    
    
    static func addHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        primaryAppointmentHandler(app: app, bot: bot)
        dateOfBirthHandler(app: app, bot: bot)
        
        fioHandler(app: app, bot: bot)
        phoneNumberHandler(app: app, bot: bot)
        
        sendMail(app: app, bot: bot)
        
    }
    
    
 // MARK: -
    
    private static func primaryAppointmentHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        
        let textSendMessage =
"""
            Заполнить
"""
        
        
        let handler = TGCallbackQueryHandler(pattern: "PrimaryAppointment") { update, bot in
            guard let userId = update.callbackQuery?.message?.chat.id else { fatalError("user id not found") }
            
            var nameButton: [TGInlineKeyboardButton] = [.init(text: "ФИО:", callbackData: "fioHandler")]
            var phoneButton: [TGInlineKeyboardButton] = [.init(text: "Телефон", callbackData: "phoneNumber")]
            var dateOfBirthButton: [TGInlineKeyboardButton] = [.init(text: "Введите дату рождения", callbackData: "birtheyData")]

            var buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
            

            let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)

            let params: TGSendMessageParams = .init(chatId: .chat(userId), text: textSendMessage, replyMarkup: .inlineKeyboardMarkup(keybord))
            

            try bot.sendMessage(params: params)
            
            
            
            let handler1 = TGMessageHandler { update, bot in
                if itsName == true {
                    name = update.message?.text

                    nameButton = [.init(text: "ФИО: \(name!)", callbackData: "fioHandler")]
                    
                    var buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
                    
                    if name != nil && dateOfBirthday != nil && phone != nil {
                        let sendButton: [TGInlineKeyboardButton] = [.init(text: "Отправить заявку", callbackData: "mailSend")]
                        
                        buttons.append(sendButton)
                        print(buttons)
                    }

                    let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
                    let params: TGSendMessageParams = .init(chatId: .chat(userId), text: textSendMessage, replyMarkup: .inlineKeyboardMarkup(keybord))
                    itsName = false
                    try bot.sendMessage(params: params)
                } else if itsDateOfBithday == true {
                    
                    dateOfBirthday = update.message?.text
                    
                    
                    dateOfBirthButton = [.init(text: "Дата рождения: \(dateOfBirthday!)", callbackData: "birtheyData")]
                    var buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
                    
                    if name != nil && dateOfBirthday != nil && phone != nil {
                        let sendButton: [TGInlineKeyboardButton] = [.init(text: "Отправить заявку", callbackData: "mailSend")]
                        
                        buttons.append(sendButton)
                    }
                    
                    let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
                    let params: TGSendMessageParams = .init(chatId: .chat(userId), text: textSendMessage, replyMarkup: .inlineKeyboardMarkup(keybord))
                    
                    itsDateOfBithday = false
                    try bot.sendMessage(params: params)
                    
                    } else if itsPhone == true{
                        
                        phone = update.message?.text
                        
                        phoneButton = [.init(text: "Телефон: \(phone!)", callbackData: "phoneNumber")]
                        
                        var buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
                        
                        if name != nil && dateOfBirthday != nil && phone != nil {
                            let sendButton: [TGInlineKeyboardButton] = [.init(text: "Отправить заявку", callbackData: "mailSend")]
                            
                            buttons.append(sendButton)
                        }
                        
                        let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
                        let params: TGSendMessageParams = .init(chatId: .chat(userId), text: textSendMessage, replyMarkup: .inlineKeyboardMarkup(keybord))
                        
                        itsPhone = false
                        try bot.sendMessage(params: params)
                    } else {}
    }
            bot.connection.dispatcher.add(handler1)
            
            
        }
             bot.connection.dispatcher.add(handler)
        

    }
    

// MARK: -
    
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
        
        
        let handler = TGCallbackQueryHandler(pattern: "phoneNumber") { update, bot in
            guard let userId = update.callbackQuery?.message?.chat.id else { fatalError("user id not found") }
            let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Номер телефона")
            itsPhone = true
            try bot.sendMessage(params: params)
            
        }
        bot.connection.dispatcher.add(handler)
    }
          
          
    private static func sendMail(app: Vapor.Application, bot: TGBotPrtcl) {
        
        let handler = TGCallbackQueryHandler(pattern: "mailSend") { update, bot in
            guard let userId = update.callbackQuery?.message?.chat.id else { fatalError("user id not found") }
            let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Запрос отправлен")
          
           try bot.sendMessage(params: params)
            

            clearData()
        }
        bot.connection.dispatcher.add(handler)
    }
          

        
    }



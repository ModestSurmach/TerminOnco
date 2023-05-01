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
import SwiftUI




var name = ""
var name1: String?

var itsName = false
var userName: String?

var dateOfBirthday = ""
var itsDateOfBithday = false
var dateOfBirthday1: String?

var phone = ""
var itsPhone = false
var phone1: String?

var checkingDataText =
"""
ФИО: \(name)
Дата рождения: \(dateOfBirthday)
Телефон: \(phone)
"""

var checkUpdate = 0 {
    didSet {
        checkingDataText =
    """
    ФИО: \(name)
    Дата рождения: \(dateOfBirthday)
    Телефон: \(phone)
    """
    name1 = name
    dateOfBirthday1 = dateOfBirthday
    phone1 = phone
    
    }
}



func clearData() {
    name = ""
    dateOfBirthday = ""
    phone = ""
}


final class PrimaryAppointmentHandler {
    
    
    static func addHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        primaryAppointmentHandler(app: app, bot: bot)
        dateOfBirthHandler(app: app, bot: bot)
        
        fioHandler(app: app, bot: bot)
        phoneNumberHandler(app: app, bot: bot)
        
        checkingData(spp: app, bot: bot)
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
                    name = (update.message?.text)!
                    userName = update.message?.chat.username
                    print("name \(userName)")
                    
                    nameButton = [.init(text: "ФИО: \(name)", callbackData: "fioHandler")]
                    
                    var buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
                    
                    if name != "" && dateOfBirthday != "" && phone != "" {
                        let sendButton: [TGInlineKeyboardButton] = [.init(text: "Отправить заявку", callbackData: "checkingData")]
                        
                        buttons.append(sendButton)
                        print(buttons)
                    }

                    let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
                    let params: TGSendMessageParams = .init(chatId: .chat(userId), text: textSendMessage, replyMarkup: .inlineKeyboardMarkup(keybord))
                    itsName = false
                    try bot.sendMessage(params: params)
                } else if itsDateOfBithday == true {
                    
                    dateOfBirthday = (update.message?.text)!
                    
                    
                    dateOfBirthButton = [.init(text: "Дата рождения: \(dateOfBirthday)", callbackData: "birtheyData")]
                    var buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
                    
                    if name != "" && dateOfBirthday != "" && phone != "" {
                        let sendButton: [TGInlineKeyboardButton] = [.init(text: "Отправить заявку", callbackData: "checkingData")]
                        checkUpdate + 1
                        buttons.append(sendButton)
                    }
                    
                    let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
                    let params: TGSendMessageParams = .init(chatId: .chat(userId), text: textSendMessage, replyMarkup: .inlineKeyboardMarkup(keybord))
                    
                    itsDateOfBithday = false
                    try bot.sendMessage(params: params)
                    
                    } else if itsPhone == true{
                        
                        phone = (update.message?.text)!
                        
                        phoneButton = [.init(text: "Телефон: \(phone)", callbackData: "phoneNumber")]
                        
                        var buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
                        
                        if name != "" && dateOfBirthday != "" && phone != "" {
                            let sendButton: [TGInlineKeyboardButton] = [.init(text: "Отправить заявку", callbackData: "checkingData")]
                            
                            
                            
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
          
    
    //MARK: -
    
    private static func checkingData(spp: Vapor.Application, bot: TGBotPrtcl) {
        

        
        let handler = TGCallbackQueryHandler(pattern: "checkingData") { update, bot in
            guard let userId = update.callbackQuery?.message?.chat.id else { fatalError("user id not found") }
            
            let buttonOk: [TGInlineKeyboardButton] = [.init(text: "Отправить", callbackData: "mailSend")]
            let buttonCancel: [TGInlineKeyboardButton] = [.init(text: "Изменить", callbackData: "newInfo")]
            let buttons: [[TGInlineKeyboardButton]] = [buttonOk, buttonCancel]
            
            let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
            checkUpdate + 1
            let params: TGSendMessageParams = .init(chatId: .chat(userId), text: checkingDataText, replyMarkup: .inlineKeyboardMarkup(keyboard))
            
            try bot.sendMessage(params: params)
            
            
            
            let handler2 = TGCallbackQueryHandler(pattern: "newInfo") { update, bot in
                guard let userId = update.callbackQuery?.message?.chat.id else { fatalError("user id not found") }
                
                name1 = name
                dateOfBirthday1 = dateOfBirthday
                phone1 = phone
                
                var nameButton: [TGInlineKeyboardButton] = [.init(text: "ФИО: \(name1!)", callbackData: "fioHandler")]
                var phoneButton: [TGInlineKeyboardButton] = [.init(text: "Телефон: \(phone1!)", callbackData: "phoneNumber")]
                var dateOfBirthButton: [TGInlineKeyboardButton] = [.init(text: "Дата рождения: \(dateOfBirthday1!)", callbackData: "birtheyData")]
                
                let buttons: [[TGInlineKeyboardButton]] = [nameButton, phoneButton, dateOfBirthButton]
                
                
                let keybord: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
                
                let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Pomen", replyMarkup: .inlineKeyboardMarkup(keybord))
                
                
                try bot.sendMessage(params: params)
                
            }
            bot.connection.dispatcher.add(handler2)
        }
        bot.connection.dispatcher.add(handler)
        
    }
        
    private static func sendMail(app: Vapor.Application, bot: TGBotPrtcl) {
        
        let handler = TGCallbackQueryHandler(pattern: "mailSend") { update, bot in
            guard let userId = update.callbackQuery?.message?.chat.id else { fatalError("user id not found") }
            let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Запрос отправлен")
            
           
            
           try bot.sendMessage(params: params)
            
            
            
            
            
            func sendEmail(to recipients: [String], subject: String, body: String) {
                let service = NSSharingService(named: .composeEmail)!
                service.recipients = recipients
                service.subject = subject
                service.perform(withItems: [body])
            }

            // Usage
            
            let queue = DispatchQueue.main
            queue.async {
                
                sendEmail(
                    to: ["mosurmach@yandex.ru"],
                    subject: "Vea software",
                    body: "This is an email for auto testing through code."
                )
            }
//            clearData()
        }
        bot.connection.dispatcher.add(handler)
    }
          

        
    }



//
//  File.swift
//  
//
//  Created by Modest Surmach on 25.02.2023.
//

import Foundation

var currentStopWordsList: [String] = []

var choosingAppointmentStopWords: [String] = ["/start", "start", "Start", "/Start"]

func stopWordsList() {
    currentStopWordsList = choosingAppointmentStopWords
}

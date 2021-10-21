//
//  Config.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

public class GenieAPI {
    public static var apiToken: String?
    static let bundle = Bundle.main.bundleIdentifier ?? ""
    static let CTWLK_API_ROOT = "https://app.mycatwalk.com/mobile"
    static var sessionId: String?
}

public class Customization {
    static var defaultErrorTitle: String = "Assistente diz"
    static var noTrendingItemsErrorMessage: String = "Oops... não encontrei peças!"
    static var noSimilarsErrorMessage: String = "Oops... não encontrei peças parecidas!"
    static var noLooksErrorMessage: String = "Oops... não encontrei combinações!"
    static var defaultErrorMessage: String = "Parece haver um erro na sua requisição. Por favor, tente novamente mais tarde."
    static var noSizesErrorMessage: String = "Oops... não encontrei mais tamanhos para esta peça!"
    static var noColorsErrorMessage: String = "Oops... não encontrei outras cores para esta peça!"
    
    public static var boldFontName: String = "Greycliff-CF-Bold"
    public static var lightFontName: String = "Greycliff-CF-Light"
    public static var regularFontName: String = "Greycliff-CF-Regular"
    public static var italicFontName: String = "Greycliff-CF-RegularOblique"
    
    public static var menuButtonBackgroundColor: UIColor = .white
    public static var menuButtonFontColor: UIColor = .FontPurple
    public static var menuScreenBackgroundColor: UIColor = .blue
    public static var menuScreenTitleColor: UIColor = .white
    
    public static var generalButtonBackgroundColor: UIColor = .blue
    public static var generalButtonFontColor: UIColor = .white
    
    public static var chatScreenBackgroundColor: UIColor = .blue
    public static var chatScreenTitleColor: UIColor = .white
    public static var chatScreenAssistantMessageColor: UIColor = .white
    public static var chatScreenUserMessageColor: UIColor = .white
}

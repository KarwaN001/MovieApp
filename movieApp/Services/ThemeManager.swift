//
//  ThemeManager.swift
//  movieApp
//
//  Created by Karwan on 26/10/2025.
//

import UIKit
import RxSwift
import RxCocoa

enum AppTheme: String, Codable {
    case light
    case dark
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

protocol ThemeManagerProtocol {
    var currentTheme: BehaviorRelay<AppTheme> { get }
    func toggleTheme()
    func applyTheme(_ theme: AppTheme)
}

final class ThemeManager: ThemeManagerProtocol {
    static let shared = ThemeManager()
    
    private let themeKey = "APP_THEME"
    let currentTheme: BehaviorRelay<AppTheme>
    
    private init() {
        let savedTheme: AppTheme
        if let data = UserDefaults.standard.data(forKey: themeKey),
           let theme = try? JSONDecoder().decode(AppTheme.self, from: data) {
            savedTheme = theme
        } else {
            savedTheme = .light
        }
        
        currentTheme = BehaviorRelay(value: savedTheme)
        
        applyTheme(savedTheme)
    }
    
    func toggleTheme() {
        let newTheme: AppTheme = currentTheme.value == .light ? .dark : .light
        applyTheme(newTheme)
    }
    
    func applyTheme(_ theme: AppTheme) {
        currentTheme.accept(theme)
        
        if let data = try? JSONEncoder().encode(theme) {
            UserDefaults.standard.setValue(data, forKey: themeKey)
        }
        
        // Apply to all windows
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = theme.userInterfaceStyle
            }
        }
    }
}

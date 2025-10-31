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
    var currentTheme: Driver<AppTheme> { get }
    func toggleTheme()
    func applyTheme(_ theme: AppTheme)
}

final class ThemeManager: ThemeManagerProtocol {
    static let shared = ThemeManager()
    
    // MARK: - Properties
    var currentTheme: Driver<AppTheme> {
        currentThemeRelay.asDriver()
    }
    
    private let currentThemeRelay: BehaviorRelay<AppTheme>
    private let themeKey: String
    private let userDefaults: UserDefaults
    
    // MARK: - Init
    init(
        themeKey: String = "APP_THEME",
        userDefaults: UserDefaults = .standard
    ) {
        self.themeKey = themeKey
        self.userDefaults = userDefaults
        
        // Load saved theme
        let savedTheme: AppTheme
        if let data = userDefaults.data(forKey: themeKey),
           let theme = try? JSONDecoder().decode(AppTheme.self, from: data) {
            savedTheme = theme
        } else {
            savedTheme = .light
        }
        
        self.currentThemeRelay = BehaviorRelay(value: savedTheme)
        
        // Apply initial theme
        applyThemeToUI(savedTheme)
    }
    
    // MARK: - Public Methods
    func toggleTheme() {
        let currentValue = currentThemeRelay.value
        let newTheme: AppTheme = currentValue == .light ? .dark : .light
        applyTheme(newTheme)
    }
    
    func applyTheme(_ theme: AppTheme) {
        currentThemeRelay.accept(theme)
        
        // Save to UserDefaults
        if let data = try? JSONEncoder().encode(theme) {
            userDefaults.setValue(data, forKey: themeKey)
        }
        
        // Apply to UI
        applyThemeToUI(theme)
    }
    
    // MARK: - Private Methods
    private func applyThemeToUI(_ theme: AppTheme) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = theme.userInterfaceStyle
                }
            }
        }
    }
}

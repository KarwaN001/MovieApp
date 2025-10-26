//
//  ThemeToggleButton.swift
//  movieApp
//
//  Created by Karwan on 26/10/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ThemeToggleButton: UIButton {
    
    private let themeManager: ThemeManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(themeManager: ThemeManagerProtocol = ThemeManager.shared) {
        self.themeManager = themeManager
        super.init(frame: .zero)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        layer.borderColor = UIColor.separator.cgColor
        
        updateIcon(for: themeManager.currentTheme.value)
    }
    
    private func setupBindings() {
        // Observe theme changes and update icon
        themeManager.currentTheme
            .asDriver()
            .drive(onNext: { [weak self] theme in
                self?.updateIcon(for: theme)
            })
            .disposed(by: disposeBag)
        
        // Handle button tap - toggle theme
        rx.tap
            .subscribe(onNext: { [weak self] in
                self?.themeManager.toggleTheme()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateIcon(for theme: AppTheme) {
        let iconName = theme == .light ? "moon.fill" : "sun.max.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        setImage(icon, for: .normal)
        tintColor = .label
    }
}


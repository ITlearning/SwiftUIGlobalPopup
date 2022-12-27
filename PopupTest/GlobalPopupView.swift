//
//  GlobalPopupView.swift
//  SSCK3
//
//  Created by Tabber on 2022/12/27.
//

import UIKit
import SwiftUI
import SnapKit

enum PresentAlignment {
    case top
    case mid
    case bottom
}

enum ImagePresentType {
    case center
    case full
}


struct GlobalPopupView: UIViewRepresentable {
    
    static var shared = GlobalPopupView()
    
    var image: UIImage?
    var title: String?
    var message: String?
    
    var view = UIKitGlobalPopupView()
    
    mutating func show(image: UIImage, title: String, message: String, alignment: PresentAlignment = .top) {
        self.image = image
        self.title = title
        self.message = message
        view.presentPopup(image: image, title: title, message: message, alignment: alignment)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}


struct GlobalImagePopupView: UIViewRepresentable {
    
    static var shared = GlobalImagePopupView()
    
    var image: UIImage?
    var title: String?
    var message: String?
    
    var view = UIKitGlobalImagePopupView()
    
    mutating func show(image: UIImage, title: String?, message: String?, alignment: ImagePresentType = .center) {
        self.image = image
        self.title = title
        self.message = message
        view.presentPopup(image: image, title: title, message: message, alignment: alignment)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}


// MARK: - 팝업 뷰 정의 코드

// MARK: 이미지 팝업 (가운데 작게, 크게)
class UIKitGlobalImagePopupView: UIView {
    private var imageViewer: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .light)
        
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainTitleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageViewer,titleStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    var alignment: ImagePresentType = .center
    
    private let screenWidth = UIScreen.main.bounds.width/2
    
    @objc
    func closeAction() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            
            self.backgroundColor = .black.withAlphaComponent(0.0)
            
            self.baseView.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset((UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + self.screenWidth)
                $0.width.equalTo(self.screenWidth)
                $0.height.equalTo(self.screenWidth)
            }
            
            
            
            self.baseView.superview?.layoutSubviews()
            
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    private var baseView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.layer.cornerRadius = 8
        
        return v
    }()
    
    private var originalPosition: CGPoint?
    private var lastPosition: CGPoint?

    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentPopup(image: UIImage, title: String?, message: String?, alignment: ImagePresentType = .center) {
        
        self.removeFromSuperview()
        configureLayout(alignment: alignment)
        self.alignment = alignment
        self.imageViewer.image = image
        self.mainTitleLabel.text = title
        self.subTitleLabel.text = message
    }
    
    
    func showAction(alignment: ImagePresentType = .center) {
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.backgroundColor = .black.withAlphaComponent(0.5)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            switch alignment {
            case .center:
                self.baseView.snp.remakeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.centerY.equalToSuperview()
                    $0.height.equalTo(self.screenWidth)
                    $0.width.equalTo(self.screenWidth)
                }
                
                self.baseView.superview?.layoutSubviews()
            case .full:
                self.baseView.snp.remakeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.centerY.equalToSuperview()
                    $0.height.equalTo(self.screenWidth)
                    $0.width.equalTo(self.screenWidth)
                }
                
                self.baseView.superview?.layoutSubviews()
            }
            
        })
    }
    
    private func configureLayout(alignment: ImagePresentType = .center) {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        self.backgroundColor = .black.withAlphaComponent(0.0)
        
        self.addSubview(self.baseView)
        self.baseView.addSubview(self.mainStackView)
        self.addSubview(self.closeButton)
        
        self.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        switch alignment {
        case .center:
            self.snp.remakeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
        default:
            self.snp.remakeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        self.baseView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset((UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + self.screenWidth)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(self.screenWidth)
            $0.width.equalTo(self.screenWidth)
            
        }
        
        self.mainStackView.snp.makeConstraints {
            $0.centerY.equalTo(self.baseView.snp.centerY)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.closeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.baseView.snp.bottom).offset(40)
            $0.centerX.equalTo(self.baseView.snp.centerX)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }

        self.imageViewer.layer.cornerRadius = 3
        self.imageViewer.clipsToBounds = true
        
        self.imageViewer.snp.makeConstraints {
            $0.height.equalTo(self.screenWidth)
            $0.width.equalTo(self.screenWidth)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.showAction(alignment: alignment)
        })
    }
    
}

// MARK: - 클래식 팝업 (토스트로 뜨는 뷰)
class UIKitGlobalPopupView: UIView {
    
    private var imageViewer: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .light)
        
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainTitleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageViewer,titleStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    var alignment: PresentAlignment = .top
    
    @objc
    func closeAction() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            switch self.alignment {
            case .top:
                self.snp.remakeConstraints {
                    $0.top.equalToSuperview().offset(-60)
                    $0.leading.equalToSuperview().offset(20)
                    $0.width.equalTo(UIScreen.main.bounds.width - 40)
                    $0.height.equalTo(60)
                }
                self.superview?.layoutSubviews()
            case .mid:
                self.snp.remakeConstraints {
                    $0.top.equalToSuperview().offset(-60)
                    $0.leading.equalToSuperview().offset(20)
                    $0.width.equalTo(UIScreen.main.bounds.width - 40)
                    $0.height.equalTo(60)
                }
                self.superview?.layoutSubviews()
            case .bottom:
                self.snp.remakeConstraints {
                    $0.bottom.equalToSuperview().inset(-60)
                    $0.leading.equalToSuperview().offset(20)
                    $0.width.equalTo(UIScreen.main.bounds.width - 40)
                    $0.height.equalTo(60)
                }
                
                self.superview?.layoutSubviews()
            }
        })
    }
    
    private var baseView: UIView = {
        let v = UIView()
        v.backgroundColor = .black.withAlphaComponent(0.8)
        v.layer.cornerRadius = 8
        
        return v
    }()
    
    private var originalPosition: CGPoint?
    private var lastPosition: CGPoint?
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentPopup(image: UIImage, title: String?, message: String?, alignment: PresentAlignment = .top) {
        
        self.removeFromSuperview()
        configureLayout(alignment: alignment)
        self.alignment = alignment
        self.imageViewer.image = image
        self.mainTitleLabel.text = title
        self.subTitleLabel.text = message
    }
    
    
    func showAction(alignment: PresentAlignment = .top) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            switch alignment {
            case .top:
                self.snp.remakeConstraints {
                    $0.top.equalToSuperview().offset((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 20)
                    $0.leading.equalToSuperview().offset(20)
                    $0.width.equalTo(UIScreen.main.bounds.width - 40)
                    $0.height.equalTo(60)
                }
                self.superview?.layoutSubviews()
            case .mid:
                self.snp.remakeConstraints {
                    $0.centerY.equalToSuperview()
                    $0.leading.equalToSuperview().offset(20)
                    $0.width.equalTo(UIScreen.main.bounds.width - 40)
                    $0.height.equalTo(60)
                }
                self.superview?.layoutSubviews()
            case .bottom:
                self.snp.remakeConstraints {
                    $0.bottom.equalToSuperview().inset((UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + 20)
                    $0.leading.equalToSuperview().offset(20)
                    $0.width.equalTo(UIScreen.main.bounds.width - 40)
                    $0.height.equalTo(60)
                }
                self.superview?.layoutSubviews()
            }
        })
    }
    
    private func configureLayout(alignment: PresentAlignment = .top) {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        
        self.addGestureRecognizer(panGestureRecognizer)
        
        self.addSubview(self.baseView)
        self.baseView.addSubview(self.mainStackView)
        self.baseView.addSubview(self.closeButton)
        
        switch alignment {
        case .top:
            self.snp.makeConstraints {
                $0.top.equalToSuperview().offset(-60)
                $0.leading.equalToSuperview().offset(20)
                $0.width.equalTo(UIScreen.main.bounds.width - 40)
                $0.height.equalTo(60)
            }
        case .mid:
            self.snp.makeConstraints {
                $0.top.equalToSuperview().offset(-60)
                $0.leading.equalToSuperview().offset(20)
                $0.width.equalTo(UIScreen.main.bounds.width - 40)
                $0.height.equalTo(60)
            }
        case .bottom:
            self.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(-60)
                $0.leading.equalToSuperview().offset(20)
                $0.width.equalTo(UIScreen.main.bounds.width - 40)
                $0.height.equalTo(60)
            }
        }
        
        self.baseView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        self.mainStackView.snp.makeConstraints {
            $0.centerY.equalTo(self.baseView.snp.centerY)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        self.imageViewer.layer.cornerRadius = 8
        self.imageViewer.clipsToBounds = true
        
        self.imageViewer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(45)
            $0.width.equalTo(45)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.showAction(alignment: alignment)
        })
    }
    
    
    @objc
    func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            self.originalPosition = self.baseView.frame.origin
        case .changed:
            let translation = panGesture.translation(in: self)
            self.baseView.frame.origin.y = (translation.y)
            self.lastPosition = translation
        case .ended:
            guard let originalPosition = self.originalPosition else { return }
            let velocity = panGesture.velocity(in: self)
            
            
            switch self.alignment {
            case .top, .mid:
                guard velocity.y <= -20 else {
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                        self.baseView.frame.origin = originalPosition
                    })
                    lastPosition = nil
                    return
                }
            case .bottom:
                
                print(velocity.y)
                
                guard velocity.y >= 40 else {
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                        self.baseView.frame.origin = originalPosition
                    })
                    return
                }
            }
            
            self.closeAction()
        default:
            return
        }
    }
    
}


// MARK: - Extension
extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}


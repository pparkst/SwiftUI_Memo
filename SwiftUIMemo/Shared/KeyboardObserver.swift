//
//  KeyboardObserver.swift
//  SwiftUIMemo
//
//  Created by pparkst on 2020/11/28.
//  Copyright © 2020 pparkst. All rights reserved.
//

import UIKit
import Combine
//SwiftUI 와 같이 발표된 Combind 사용

class KeyboardObserver: ObservableObject {
    struct Context {
        let animationDuration: TimeInterval
        let height: CGFloat
        
        //키보드가 숨겨진 기본 값을 저장
        static let hide = Self(animationDuration: 0.25, height: 0)
    }
    
    //Published를 사용하여 값이 업데이트되면 연관되어있는 View가 자동 Update
    @Published var context = Context.hide
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let willShow = NotificationCenter.default.publisher(for:UIResponder.keyboardWillShowNotification )
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        
        //merge를 사용하여 두 Publisher를 합침
        willShow.merge(with: willHide)
        .compactMap(parse) //willShow와 willHide가 전달되면 parse메소드가 실행되고
            .assign(to: \.context, on: self) //parse메소드에서 return 하는 결과가 context에 자동으로 저장됨
            .store(in: &cancellables) //키보드 옵저버 객체가 사라지면 관련된 메모리가 자동으로 정리됨
    }
    
    //옵셔널 컨텍스트를 리턴
    func parse(notification: Notification) -> Context? {
        //userInfo를 상수에 저장
        guard let userInfo = notification.userInfo else { return nil }
        let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
        //safeAreainset을 상수에 저장
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        
        var height: CGFloat = 0 //높이를 저장할 변수
        
        
        if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            //userInfo dic에서 Frame값을 꺼낸 다음
            let frame = value.cgRectValue
            
            if frame.origin.y < UIScreen.main.bounds.height {
            //keyboard가 표시되는 시점이라면
                height = frame.height - (safeAreaInsets?.bottom ?? 0)
            }
        }
        
        return Context(animationDuration: animationDuration, height: height)
    }
}


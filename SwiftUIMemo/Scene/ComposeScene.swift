//
//  ComposeScene.swift
//  SwiftUIMemo
//
//  Created by pparkst on 2020/11/27.
//  Copyright © 2020 pparkst. All rights reserved.
//

import SwiftUI

struct ComposeScene: View {
    @EnvironmentObject var keyboard: KeyboardObserver
    @EnvironmentObject var store: MemoStore
    @State private var content: String = ""
    
    @Binding var showComposer: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                TextView(text: $content)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, keyboard.context.height)
                    //여기서의 context는 Published 특성으로 선언하여 속성의 값이 변경되면 padding도 함께 변경된다
                    .animation(.easeInOut(duration: keyboard.context.animationDuration))
                    //animation은 easeInOut으로, 시간은 keyboard의 animation과 동일한 시간으로 지정(preview에서는 키보드가 표시되지않음)
                    .background(Color.yellow)
                //SwiftUI에서는 컨테이너를 중앙에 배치함 중요!
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("새 메모", displayMode: .inline)
            .navigationBarItems(leading: DismissButton(show: $showComposer), trailing: SaveButton(show: $showComposer, content: $content))
        }
    }
}

fileprivate struct DismissButton: View {
    @Binding var show: Bool
    
    var body: some View {
        Button(action: {
            self.show = false
        }, label: {
            Text("취소")
        })
    }
}

fileprivate struct SaveButton: View {
    @Binding var show: Bool
    
    @EnvironmentObject var store: MemoStore
    @Binding var content: String
    
    
    var body: some View {
        Button(action: {
            self.store.insert(memo: self.content)
            
            self.show = false
        }, label: {
            Text("저장")
        })
    }
}

struct ComposeScene_Previews: PreviewProvider {
    static var previews: some View {
        //여기에 전달하는 showComposer의 값이 없음 없을때는 .constant 바인딩을 전달함
        ComposeScene(showComposer: .constant(false))
                    .environmentObject(MemoStore())
        .environmentObject(KeyboardObserver())
        
    }
}

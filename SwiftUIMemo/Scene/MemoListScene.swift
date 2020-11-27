//
//  ContentView.swift
//  SwiftUIMemo
//
//  Created by pparkst on 2020/11/27.
//  Copyright © 2020 pparkst. All rights reserved.
//

import SwiftUI

struct MemoListScene: View {
    //SceneDelegate에서 MemoStore(Instance)를 커스텀 공유데이터로 설정함
    //View가 생성되는 시점에 공유 데이터를 확인하고 Store속성과 동일한 형식을 가진 객체가 등록되어있다면 변수에 자동으로 저장해줌
    //SwiftUI에서는 이런방식으로 하나의 데이터를 여러 View에서 공유함
    @EnvironmentObject var store: MemoStore
    //여기에서 SceneDelegate에서 주입해주었기에 아래의 ModalButton View에도 자동으로 주입됨
    //그러나 ComposeScene는 sheet를 이용하여 modal방식으로 띄워주고있는데 이때는 자동으로 주입되지않음
    @EnvironmentObject var formatter: DateFormatter
    
    @State var showComposer: Bool = false
    
    
    var body: some View {
        NavigationView { //상단 네비툴
            List {
                ForEach(store.list) { memo in
                    NavigationLink(destination: DetailScene(memo: memo), label: {
                        MemoCell(memo: memo)
                    })
                }
                .onDelete(perform: store.delete)
            }
            .navigationBarTitle("내 메모") //상단 타이틀
            .navigationBarItems(trailing: ModalButton(show: $showComposer))
            //$를 붙임으로 값이 복사가아니라 바인딩이 전달됨
            //전달하는 곳에서는 $를 붙이고
            //전달받는 곳에서는 @Binding을 붙임
            .sheet(isPresented: $showComposer, content: {
                ComposeScene(showComposer: self.$showComposer)
                    .environmentObject(self.store)
                    //위에 작성하듯이 ComposeScene는 Modal방식으로 호출하기에 store가 자동으로 주입되지않으므로 enviromentObject로 주입함, 주입하면서 새로 생성하는게 아닌 사용중인 store를 넣어서 리소스 감소
                    .environmentObject(KeyboardObserver())
            })
            //navigation의 버튼을 클릭함으로 ShowComposer의 값이 변경되고
            //값이 변경되면 sheet에서 감지하여 content에 ComposeScene Modal을 띄움
        }
    }
}

fileprivate struct ModalButton: View {
    @Binding var show: Bool
    //위의 View에서 넘어온 값이 저장되는게 아니라 바인딩이 저장됨
    
    var body: some View {
        Button(action: {
            self.show = true
            //이렇게 바인딩의 show 값을 true로 바꾸면 상단 View의 ShowComposer의 값이 바뀜
        }, label: {
            Image(systemName: "plus")
        })
    }
}

struct MemoListScene_Previews: PreviewProvider {
    static var previews: some View {
        MemoListScene()
        .environmentObject(MemoStore())
        //Preview에서 사용할 MemoStore를 커스텀 공유데이터로 등록
            .environmentObject(DateFormatter.memoDateFormatter)
    }
}



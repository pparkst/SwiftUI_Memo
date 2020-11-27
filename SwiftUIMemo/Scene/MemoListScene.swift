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
    @EnvironmentObject var formatter: DateFormatter
    
    var body: some View {
        NavigationView { //상단 네비툴
            List(store.list) { memo in
                MemoCell(memo: memo)
            }
        .navigationBarTitle("내 메모") //상단 타이틀
        }
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



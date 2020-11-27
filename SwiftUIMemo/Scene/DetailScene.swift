//
//  DetailScene.swift
//  SwiftUIMemo
//
//  Created by pparkst on 2020/11/28.
//  Copyright © 2020 pparkst. All rights reserved.
//

import SwiftUI

struct DetailScene: View {
    @ObservedObject var memo: Memo
    //ObservedObject를 선언하면 내부의 Published의 값이 변경될때 View를 자동으로 Update함
    
    @EnvironmentObject var store: MemoStore
    @EnvironmentObject var formatter: DateFormatter
    
    var body: some View {
        VStack {
            ScrollView {
                //ScrollView는 별도로 방향을 지정하지않으면 수직임
                VStack {
                    //HStack, Spacer을 추가함으로 메모를 왼쪽으로 당김
                    HStack {
                        Text(self.memo.content)
                            .padding()
                        Spacer()
                    }
                    
                    Text("\(self.memo.insertDate, formatter: formatter)" )
                    .padding()
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
            }
        }
        .navigationBarTitle("메모 보기")
    }
}

struct DetailScene_Previews: PreviewProvider {
    static var previews: some View {
        DetailScene(memo: Memo(content: "SwiftUI"))
        .environmentObject(MemoStore())
            .environmentObject(DateFormatter.memoDateFormatter)
    }
}

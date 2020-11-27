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
    
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    
    @Environment(\.presentationMode) var presentaionMode
    //MemoListScene에서 보면 DetailScene는 Modal방식인 sheet를 사용한게아닌 NavigationLink로 View를 이동했기때문에 sheet형식에서 사용중인 showComposer와 같이 false를 보내주어 숨길 수 없으므로 presentaionMode를 사용함
    
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
            
            HStack {
                Button(action:  {
                    self.showDeleteAlert.toggle()
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(Color(UIColor.systemRed))
                })
                    .padding()
                    .alert(isPresented: self.$showDeleteAlert, content: {
                        Alert(title: Text("삭제 확인"), message: Text("메모를 삭제할까요?"), primaryButton:
                            .destructive(Text("삭제"),
                                                 action: {
                                                    self.store.delete(memo: self.memo)
                                                    self.presentaionMode.wrappedValue.dismiss()
                            }),
                              secondaryButton: .cancel())
                    })
                Spacer()
                
                Button(action:  {
                    self.showEditSheet.toggle()
                }, label: {
                    Image(systemName: "square.and.pencil")
                })
                .padding()
                .sheet(isPresented: $showEditSheet
                    , content: {
                        ComposeScene(showComposer: self.$showEditSheet, memo: self.memo)
                            .environmentObject(self.store)
                        .environmentObject(KeyboardObserver())
                })
            }
            .padding(.leading) // left
            .padding(.trailing) // right
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

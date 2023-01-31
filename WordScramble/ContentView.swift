//
//  ContentView.swift
//  WordScramble
//
//  Created by Jared Thompkins on 1/31/23.
//

import SwiftUI

struct ContentView: View {
    @State var usedWords = [String]()
    @State var rootWord = ""
    @State var newWord = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                Section {
                    ForEach(usedWords, id: \.self) { i in
                        HStack {
                            Image(systemName: "\(i.count).circle")
                            Text(i)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "BTFail22"
                return
            }
        }
        fatalError("Could not load start.txt.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempword = rootWord
        
        for letter in word {
            if let pos = tempword.firstIndex(of: letter) {
                tempword.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
}
































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

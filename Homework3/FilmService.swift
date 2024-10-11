//
//  FilmService.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import Foundation

class FilmService: FilmServiceProtocol {
    
    func fetchFilms() async throws -> [Film] {
        // 1. URLを作成し、データを取得
        guard let url = URL(string: "https://ghibliapi.vercel.app/films") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 2. HTTPレスポンスのステータスコードをチェック
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // 3. 取得したデータをJSONデコードし、Filmオブジェクトの配列を返す
        let films = try JSONDecoder().decode([Film].self, from: data)
        return films
    }
}



//asyncとawaitは、非同期処理を簡潔に記述するためにSwiftに導入されたキーワードです。非同期処理とは、他のタスクをブロックせずに、処理が完了するまで待つ方法を意味します。これにより、アプリのパフォーマンスを向上させたり、レスポンスの速さを保つことができます。通常、データをネットワークから取得するような操作（API呼び出しなど）は時間がかかる可能性があります。もしこのような操作が同期的（ブロックする方法）に行われた場合、例えばユーザーがアプリを使っている間、画面が固まって何も反応しなくなることがあります。asyncとawaitを使うと、このような時間のかかる処理を別のスレッドで非同期に行い、メインのスレッド（UIスレッド）は他の処理を続けることができます。こうすることで、ユーザーはアプリがスムーズに動いているように感じます。awaitは非同期な関数からの結果を待つために使います。awaitを使うことで、非同期な操作（例えばネットワークからのデータ取得）が完了するのを待ち、その結果を受け取ることができます。ただし、awaitを使う場合、その関数自体もasyncでなければなりません

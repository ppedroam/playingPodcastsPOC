//
//  SongsDto.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 28/10/20.
//

import Foundation

struct SongsDto: Codable {
    let songs: [TrackDto]?
}

struct TrackDto: Codable {
    let title: String?
    let data: String?
}

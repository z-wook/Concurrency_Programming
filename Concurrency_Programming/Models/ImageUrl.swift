//
//  ImageUrl.swift
//  Concurrency_Programming
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

enum ImageURL: String, CaseIterable {
    case first = "https://images.unsplash.com/photo-1464802686167-b939a6910659?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2050&q=80"
    case second = "https://images.unsplash.com/photo-1496224303445-89779ef1ed23?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1931&q=80"
    case third = "https://images.unsplash.com/photo-1459478309853-2c33a60058e7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3870&q=80"
    
    var url: String { return rawValue }
}

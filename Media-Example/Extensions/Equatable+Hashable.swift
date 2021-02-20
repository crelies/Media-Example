//
//  Equatable+Hashable.swift
//  Media-Example
//
//  Created by Christian Elies on 20.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore

extension Album: Equatable {
    public static func == (lhs: Album, rhs: Album) -> Bool {
        lhs.id == rhs.id
    }
}

extension Album: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Photo: Equatable {
    public static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}

extension Photo: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Video: Equatable {
    public static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id
    }
}

extension Video: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension LivePhoto: Equatable {
    public static func == (lhs: LivePhoto, rhs: LivePhoto) -> Bool {
        lhs.id == rhs.id
    }
}

extension LivePhoto: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Audio: Equatable {
    public static func == (lhs: Audio, rhs: Audio) -> Bool {
        lhs.id == rhs.id
    }
}

extension Audio: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

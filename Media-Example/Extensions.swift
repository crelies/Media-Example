//
//  Extensions.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation
import Media

extension Album: Identifiable {
    public var id: String { identifier }
}

extension Audio: Identifiable {
    public var id: String { identifier.localIdentifier }
}

extension LivePhoto: Identifiable {
    public var id: String { identifier.localIdentifier }
}

extension Photo: Identifiable {
    public var id: String { identifier.localIdentifier }
}

extension Video: Identifiable {
    public var id: String { identifier.localIdentifier }
}

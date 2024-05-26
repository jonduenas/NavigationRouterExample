//
//  RootViewC.swift
//  NavigationRouterExample
//
//  Created by Jon Duenas on 5/25/24.
//

import SwiftUI
import SwiftUINavigation

@MainActor
@Observable
final class ModelC: HashableObject {
    weak var router: (any Router)?
}

struct RootViewC: View {
    @Bindable var model: ModelC

    var body: some View {
        Text("RootViewC")
    }
}

#Preview {
    RootViewC(model: ModelC())
}

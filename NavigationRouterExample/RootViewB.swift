//
//  RootViewB.swift
//  NavigationRouterExample
//
//  Created by Jon Duenas on 5/25/24.
//

import SwiftUI
import SwiftUINavigation

@MainActor
@Observable
final class RouterB: RouterRoutableC {
    var path: [Destination]

    init(path: [Destination] = []) {
        self.path = path
    }

    func navigate(to route: RouteC) {
        switch route {
        case .viewC:
            let model = ModelC()
            model.router = self
            path.append(.viewC(model))
        }
    }
}

@MainActor
@Observable
final class ModelB: HashableObject {
    weak var router: (any RouterRoutableC)?
    let number: Int

    init(number: Int = 0) {
        self.number = number
    }

    func navigateToCTapped() {
        router?.navigate(to: .viewC)
    }
}

struct RootViewB: View {
    @Bindable var model: ModelB

    var body: some View {
        VStack {
            Text(model.number, format: .number)
            Button("Navigate To C") {
                model.navigateToCTapped()
            }
        }
        .navigationDestination(for: Destination.self) { destination in
            destination.build()
        }
        .navigationTitle("B")
    }
}

#Preview {
    RootViewB(model: ModelB())
}

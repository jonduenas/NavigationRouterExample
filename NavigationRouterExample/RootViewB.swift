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
final class RouterB: Router {
    var path: [Destination]

    init(path: [Destination] = []) {
        self.path = path
    }

    func navigate(to route: Route) {
        // This doesn't work because switch must be exhaustive
        // But making it exhaustive means supporting routing to
        // A, which should be impossible. B should have no knowledge
        // of A.
        switch route {
        case .viewB:
            let model = ModelB()
            model.router = self
            path.append(.viewB(model))
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
    // This needs to be any Router so it can be set to the router that presents it
    // Using generics causes cascade of having to specify Router type everywhere
    weak var router: (any Router)?
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

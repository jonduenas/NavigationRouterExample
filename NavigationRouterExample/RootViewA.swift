//
//  RootViewA.swift
//  NavigationRouterExample
//
//  Created by Jon Duenas on 5/25/24.
//

import SwiftUI
import SwiftUINavigation

// RouterA and ModelA work because RouterA can go anywhere.
// But, what happens when RouterA pushes RootViewB with ModelB?
// ModelB needs to now work with RouterA. But RouterA exposes
// routes to A when B should only be able to navigate back or to C

@MainActor
@Observable
final class RouterA: RouterRoutableABC, RouterRoutableC {
    typealias R = RouteA
    
    var path: [Destination]

    init(path: [Destination] = []) {
        self.path = path
    }

    func navigate(to route: RouteA) {
        switch route {
        case .viewA(let string):
            let model = ModelA(title: string)
            model.router = self
            path.append(.viewA(model))
        case .viewB(let int):
            let model = ModelB(number: int)
            model.router = self
            path.append(.viewB(model))
        case .viewC:
            navigateToC()
        }
    }

    func navigate(to route: RouteC) {
        switch route {
        case .viewC:
            navigateToC()
        }
    }

    private func navigateToC() {
        path.append(.viewC(ModelC()))
    }
}

@MainActor
@Observable
final class ModelA: HashableObject {
    weak var router: RouterA?
    let title: String

    init(title: String = "RootViewA") {
        self.title = title
    }

    func navigateToBTapped() {
        router?.navigate(to: .viewB(123))
    }

    func navigateToCTapped() {
        router?.navigate(to: RouteA.viewC)
    }
}

struct RootViewA: View {
    @Bindable var model: ModelA

    var body: some View {
        VStack {
            Text(model.title)
            Button("Navigate To B") {
                model.navigateToBTapped()
            }

            Button("Navigate To C") {
                model.navigateToCTapped()
            }
        }
        .navigationDestination(for: Destination.self) { destination in
            destination.build()
        }
        .navigationTitle("A")
    }
}

#Preview {
    RootViewA(model: ModelA())
}

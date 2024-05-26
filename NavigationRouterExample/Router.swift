//
//  Router.swift
//  NavigationRouterExample
//
//  Created by Jon Duenas on 5/25/24.
//

import SwiftUI
import Foundation

@MainActor
protocol Router: Observable, AnyObject {
    associatedtype R: Route
    var path: [Destination] { get set }
    func navigate(to route: R)
    func popLast()
    func popToRoot()
}

extension Router {
    func popLast() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}

protocol RoutableABC: RoutableA, RoutableB, RoutableC {}

@MainActor
protocol RouterRoutableABC: Router where R: RoutableABC {
    func navigate(to route: RouteA)
}

@MainActor
protocol RouterRoutableC: Router where R: RoutableC {
    func navigate(to route: RouteC)
}

// enum Route {
//    case viewA(String)
//    case viewB(Int)
//    case viewC
// }

protocol Route: Hashable {}

protocol RoutableA: Route {
    static func viewA(_ string: String) -> Self
}

protocol RoutableB: Route {
    static func viewB(_ int: Int) -> Self
}

protocol RoutableC: Route {
    static var viewC: Self { get }
}

enum RouteA: RoutableABC {
    case viewA(String)
    case viewB(Int)
    case viewC
}

enum RouteB: RoutableB, RoutableC {
    case viewB(Int)
    case viewC
}

enum RouteC: RoutableC {
    case viewC
}

enum Destination: Hashable {
    case viewA(ModelA)
    case viewB(ModelB)
    case viewC(ModelC)

    @ViewBuilder
    func build() -> some View {
        switch self {
        case .viewA(let modelA):
            RootViewA(model: modelA)
        case .viewB(let modelB):
            RootViewB(model: modelB)
        case .viewC(let modelC):
            RootViewC(model: modelC)
        }
    }
}

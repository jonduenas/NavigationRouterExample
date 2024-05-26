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
    // Tried this
    // associatedtype R: Route
    // func navigate(to route: R)

    var path: [Destination] { get set }
    func navigate(to route: Route)
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

enum Route {
    case viewA(String)
    case viewB(Int)
    case viewC
}

// Attempt to use composable protocols works until getting to ModelB. No way to specify
// Router Route protocol conformance without using generics in type that need to be
// specified everywhere the type is used, which won't always be known.

// protocol Route: Hashable {}

// protocol RoutableA: Route {
//    static func viewA(_ string: String) -> Self
// }
//
// protocol RoutableB: Route {
//    static func viewB(_ int: Int) -> Self
// }
//
// protocol RoutableC: Route {
//    static var viewC: Self { get }
// }

// enum RouteA: RoutableA, RoutableB, RoutableC {
//    case viewA(String)
//    case viewB(Int)
//    case viewC
// }
//
// enum RouteB: RoutableB, RoutableC {
//    case viewB(Int)
//    case viewC
// }

enum Destination: Hashable {
    case viewA(ModelA)
    // If using generics on type, this would have to look like
    // case viewB(ModelB<???>)
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

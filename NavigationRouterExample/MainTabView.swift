//
//  MainTabView.swift
//  NavigationRouterExample
//
//  Created by Jon Duenas on 5/25/24.
//

import SwiftUI

@MainActor
@Observable
final class AppModel {
    let appRouter: AppRouter
    let modelA: ModelA
    let modelB: ModelB
    let modelC: ModelC

    init() {
        self.appRouter = AppRouter(routerA: RouterA(), routerB: RouterB())
        self.modelA = ModelA()
        modelA.router = appRouter.routerA
        self.modelB = ModelB()
        modelB.router = appRouter.routerB
        self.modelC = ModelC()
    }
}

@MainActor
@Observable
final class AppRouter {
    let routerA: RouterA
    let routerB: RouterB

    init(routerA: RouterA, routerB: RouterB) {
        self.routerA = routerA
        self.routerB = routerB
    }
}

struct MainTabView: View {
    let appModel: AppModel

    var body: some View {
        TabView {
            @Bindable var routerA = appModel.appRouter.routerA
            NavigationStack(path: $routerA.path) {
                RootViewA(model: appModel.modelA)
            }
            .tabItem { Label("A", systemImage: "a.circle") }

            @Bindable var routerB = appModel.appRouter.routerB
            NavigationStack(path: $routerB.path) {
                RootViewB(model: appModel.modelB)
            }
            .tabItem { Label("B", systemImage: "b.circle") }

            NavigationStack {
                RootViewC(model: appModel.modelC)
            }
            .tabItem { Label("C", systemImage: "c.circle") }
        }
    }
}

#Preview {
    MainTabView(appModel: AppModel())
}

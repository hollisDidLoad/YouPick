//
//  InternetManager.swift
//  YouPick
//
//  Created by Hollis Kwan on 11/14/22.
//

import Foundation
import Network

class InternetManager {
    static let shared = InternetManager()
    private init () {
        pathMonth = NWPathMonitor()
    }
    
    private let queue = DispatchQueue.global()
    private let pathMonth: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    public private(set) var connectionType: ConnectionType = .unknown
    
    public func startMonitoring() {
        pathMonth.start(queue: queue)
        pathMonth.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    public func stopMonitoring() {
        pathMonth.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}


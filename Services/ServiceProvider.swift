//
//  ServiceProvider.swift
//  NaoSdkSwiftApiClient
//
//  Created by Pole Star on 15/01/2020.
//  Copyright © 2020 Pole Star. All rights reserved.
//

import UIKit
import NAOSDKModule

public class ServiceProvider: NSObject, NAOSyncDelegate, NAOSensorsDelegate {
    
    var apikey: String
    var status: Bool
    
    // Callbacks declarations
    static public var onSynchronizationFailure:((_ message: String) -> ())?
    static public var onErrorEventWithErrorCode:(( _ message: String) -> ())?

    required public init(apikey: String) {
        self.status = false
        self.apikey = apikey
    }
    
    lazy var getKey: () -> String = {
        return self.apikey
    }
    
    public func start() {}
    
    public func  stop() {}
    // MARK: - NAOSensorsDelegate
    
    public func requiresWifiOn() {
        //Post the requiresWifiOn notification
        NotificationCenter.default.post(name: NSNotification.Name("notifyWifiOnRequest"), object: nil)
    }
    
    public func requiresBLEOn() {
        //Post the requiresBLEOn notification
        NotificationCenter.default.post(name: NSNotification.Name("notifyBLEOnRequest"), object: nil)
    }
    
    public func requiresLocationOn() {
        //Post the requiresLocationOn notification
        NotificationCenter.default.post(name: NSNotification.Name("notifyLocationOnRequest"), object: nil)
    }
    
    public func requiresCompassCalibration() {
        //Post the requiresCompassCalibration notification
        NotificationCenter.default.post(name: NSNotification.Name("notifyCompassCalibrationRequest"), object: nil)
    }
    
     // MARK: - NAOSyncDelegate --
    
    public func didSynchronizationSuccess() {
        //Post the didSynchronizationSuccess notification
        NotificationCenter.default.post(name: NSNotification.Name("notifySynchronizationSuccess"), object: nil)
        status = true
    }
    
    public func didSynchronizationFailure(_ errorCode: DBNAOERRORCODE, msg message: String!) {
        ServiceProvider.onErrorEventWithErrorCode?("The synchronization fails! \(String(describing: message)) with error code \(errorCode)")
        status = false
    }
}

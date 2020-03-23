//
//  GeofencingHandler.swift
//  NaoSdkSwiftApiClient
//
//  Created by Pole Star on 15/01/2020.
//  Copyright © 2020 Pole Star. All rights reserved.
//

import UIKit
import NAOSDKModule

public class GeofencingHandler: ServiceProvider, NAOGeofenceHandleDelegate{
    
    var geofencingHandler: NAOGeofencingHandle? = nil
    
    // Callbacks declarations
    public var onAlertEventWithMessage:((_ message: String) -> ())?
    
    required public init(apikey: String) {
        super.init(apikey: apikey)
        
        self.geofencingHandler = NAOGeofencingHandle(key: apikey, delegate: self, sensorsDelegate: self)
        self.geofencingHandler?.synchronizeData(self)
    }
    
    override public func start() {
        if (!self.status){
            self.geofencingHandler?.start()
        }
        self.status = true
    }
    
    override public func stop() {
        if (self.status){
            self.geofencingHandler?.stop()
        }
        self.status = false
    }
    
    // MARK: - NAOGeofenceHandleDelegate
    public func didEnterGeofence(_ regionId: Int32, andName regionName: String!) {
        onAlertEventWithMessage?("Enters geofence: \(regionId)\t\(String(describing: regionName))")
    }
    
    public func didExitGeofence(_ regionId: Int32, andName regionName: String!) {
        onAlertEventWithMessage?("Exits geofence: \(regionId)\t\(String(describing: regionName))")
    }
    
    public func didFire(_ alert: NaoAlert!) {
        let alertContent = alert.content
        if !alertContent!.isEmpty {
            onAlertEventWithMessage?("Alert received: \(String(describing: alert.content))")
        }
    }
    
    public func didFailWithErrorCode(_ errCode: DBNAOERRORCODE, andMessage message: String!) {
        ServiceProvider.onErrorEventWithErrorCode?("NAOGeofencingHandle fails: \(String(describing: message)) with error code \(errCode)")
    }
    
    deinit {
        print("GeofencingHandler deinitialized")
    }
}

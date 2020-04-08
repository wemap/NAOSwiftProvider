//
//  LocationProvider.swift
//  NaoSdkSwiftApiClient
//
//  Created by Pole Star on 15/01/2020.
//  Copyright © 2020 Pole Star. All rights reserved.
//

import UIKit
import NAOSDKModule

public class LocationProvider: ServiceProvider, NAOLocationHandleDelegate, NAOSyncDelegate, NAOSensorsDelegate {
    
    
    var locationHandle: NAOLocationHandle? = nil
    
    // LocationProviderDelegate
    public weak var delegate: LocationProviderDelegate?
    
    required public init(apikey: String) {
        super.init(apikey: apikey)
        
        self.locationHandle = NAOLocationHandle(key: apikey, delegate: self, sensorsDelegate: self)
        self.locationHandle?.synchronizeData(self)
    }
    
    override public func start() {
        if (!self.status){
            self.locationHandle?.start()
        }
        delegate?.didApikeyReceived (apikey)
    }
    
    override public func stop() {
        if (self.status){
            self.locationHandle?.stop()
        }
        self.status = false
    }
    
    // MARK: - NAOLocationHandleDelegate --
     
    public func didEnterSite (_ name: String){
        //Post the didEnterSite notification
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.didEnterSite(name)
            }
        }
    }


    public func didExitSite (_ name: String){
        //Post the didExitSite notification
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.didExitSite(name)
            }
        }
    }

    public func didLocationChange(_ location: CLLocation!) {
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.didLocationChange(location)
            }
        }
    }

    public func didLocationStatusChanged(_ status: DBTNAOFIXSTATUS) {
        var statusMessage = ""
        switch (status) {
            case DBTNAOFIXSTATUS.NAO_FIX_UNAVAILABLE:
                statusMessage = "LOCATION STATUS: FIX_UNAVAILABLE"
                break;
            case DBTNAOFIXSTATUS.NAO_FIX_AVAILABLE:
                statusMessage = "LOCATION STATUS: UNAVAILABLE"
                break;
            case DBTNAOFIXSTATUS.NAO_TEMPORARY_UNAVAILABLE:
                statusMessage = "LOCATION STATUS: TEMPORARY_UNAVAILABLE"
                break;
            case DBTNAOFIXSTATUS.NAO_OUT_OF_SERVICE:
                statusMessage = "LOCATION STATUS: OUT_OF_SERVICE"
                break;
            default:
                statusMessage = "LOCATION STATUS: UNKNOWN"
                break;
        }
        
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.didLocationStatusChanged(statusMessage)
            }
        }
        
    }
    
    // MARK: - NAOSensorsDelegate
    
    public func requiresWifiOn() {
        //Post the requiresWifiOn notification
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.requiresWifiOn()
            }
        }
    }
    
    public func requiresBLEOn() {
        //Post the requiresBLEOn notification
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.requiresBLEOn()
            }
        }
    }
    
    public func requiresLocationOn() {
        //Post the requiresLocationOn notification
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.requiresLocationOn()
            }
        }
    }
    
    public func requiresCompassCalibration() {
        //Post the requiresCompassCalibration notification
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.requiresCompassCalibration()
            }
        }
    }
    
     // MARK: - NAOSyncDelegate --
    
    public func didSynchronizationSuccess() {
        //Post the didSynchronizationSuccess notification
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.didSynchronizationSuccess()
            }
        }
    }
    
    public func didSynchronizationFailure(_ errorCode: DBNAOERRORCODE, msg message: String!) {
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.didSynchronizationFailure("The synchronization fail: \(String(describing: message)) with error code \(errorCode)")
            }
        }
    }
    
    public func didFailWithErrorCode(_ errCode: DBNAOERRORCODE, andMessage message: String!) {
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.didLocationFailWithErrorCode("NAOLocationHandle fails: \(String(describing: message)) with error code \(errCode)")
            }
        }
    }

    deinit {
        print("LocationProvider deinitialized")
    }
}


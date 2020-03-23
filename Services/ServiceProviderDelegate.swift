//
//  ServiceProviderDelegate.swift
//  NAOSwiftProvider
//
//  Created by Pole Star on 02/03/2020.
//

import Foundation
import UIKit
import NAOSDKModule

public protocol ServiceProviderDelegate: AnyObject{
    
    func requiresWifiOn()

    func requiresBLEOn()

    func requiresLocationOn()

    func requiresCompassCalibration()

     // MARK: - NAOSyncDelegate --

    func didSynchronizationSuccess()

    func didSynchronizationFailure(_ errorCode: DBNAOERRORCODE, msg message: String!)
}





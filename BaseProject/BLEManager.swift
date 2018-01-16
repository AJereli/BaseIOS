//
//  BLEManager.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 15/01/2018.
//  Copyright © 2018 Valeev A. All rights reserved.
//

import Foundation
import CoreBluetooth
import BlueCapKit


class BLEManager {
    public enum AppError : Error    {
        case dataCharactertisticNotFound
        case enabledCharactertisticNotFound
        case updateCharactertisticNotFound
        case serviceNotFound
        case invalidState
        case resetting
        case poweredOff
        case unknown
        case alreadyScanning
    }
    
    
    //initialize a central manager with a restore key. The restore key allows to resuse the same central manager in future calls
    let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "CentralMangerKey" as NSString])
  
    static private let _instanse: BLEManager = BLEManager()
    
    static var share:BLEManager {return _instanse}
    
    private init (){
        //A future stram that notifies us when the state of the central manager changes
      //  let stateChangeFuture = manager.whenStateChanges()
     
    }

    func reset () {
        manager.reset()
    }
    
    func stopScanning (){
        if manager.isScanning{
            manager.stopScanning()
        }
    }
    
    func connect (to peripheral:Peripheral, connectionTimeout:TimeInterval = TimeInterval.infinity, capacity:Int = Int.max){
        peripheral.connect()
        
//        let discoveryFuture = peripheral.connect().flatMap { _ -> Future<Void> in
//
//            return peripheral.discoverAllServices()
//            }.flatMap { _ -> Future<Void> in
//                let discoveredPeripheral = peripheral
//
//
//                guard let services = discoveredPeripheral.services else {
//                    throw AppError.serviceNotFound
//                }
//
//
//                //we have discovered the service, the next step is to discover the "ec0e" characteristic
//                return service.discoverCharacteristics([dateCharacteristicUUID])
//        }
    }
    
    func scanPeripheral() -> FutureStream<Peripheral> {
        
        let scan = manager.whenStateChanges().flatMap { state -> FutureStream<Peripheral> in
            if !self.manager.isScanning {
                switch state {
                case .poweredOn:
                    DispatchQueue.main.async {
                        print("start scanning")
                    }
                    //scan for peripherlas
                    return self.manager.startScanning()
                case .poweredOff:
                    throw AppError.poweredOff
                case .unauthorized, .unsupported:
                    throw AppError.invalidState
                case .resetting:
                    throw AppError.resetting
                case .unknown:
                    //generally this state is ignored
                    throw AppError.unknown
                }
            }else {
                throw AppError.alreadyScanning
            }
            
        }
        scan.onFailure { error in
            guard let appErr = error as? AppError else{return}
            switch appErr {
            case .poweredOff:
                print ("POWER BLE OFF")
            case .invalidState:
                print ("Invalid BLE state")
            case .resetting:
                self.manager.reset()
            default:
                print ("default case ")
                break;
            }
            
        }
        return scan
    }
  
    
    
}

//
//  TestVCntrl.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 11/01/2018.
//  Copyright © 2018 Valeev A. All rights reserved.
//

import UIKit
import CoreBluetooth
import BlueCapKit




class TestVCntrl: ViewCntrlBase ,UITableViewDelegate, UITableViewDataSource{
    
    public enum AppError : Error    {
        case dataCharactertisticNotFound
        case enabledCharactertisticNotFound
        case updateCharactertisticNotFound
        case serviceNotFound
        case invalidState
        case resetting
        case poweredOff
        case unknown
    }
  
    @IBOutlet var tableView: UITableView!
    
    var dataCharacteristic : Characteristic?
  
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var scanningIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueToWriteTextField: UITextField!
    @IBOutlet weak var notifiedValueLabel: UILabel!
    
    var allPeripheral:Set<Peripheral> = Set<Peripheral>()
    
    let manager = BLEManager.share

    @IBAction func startSearchingAct(_ sender: Any) {
        allPeripheral.removeAll()
        tableView.reloadData()
        scanningIndicator.startAnimating()
        let scanP =  manager.scanPeripheral()
        
        
        scanP.flatMap { p -> Future<Void> in
            self.allPeripheral.insert(p)
            self.tableView.reloadData()
            return p.discoverAllServices()
        }
    }
    @IBAction func endSearchingAct(_ sender: Any) {
        scanningIndicator.stopAnimating()
        manager.stopScanning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPeripheral.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ctrl = segue.destination as? BLEDeviceInfoVCntrl, let peripheral = sender as? Peripheral else {
            return
        }
        ctrl.peripheral = peripheral
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "segueBLEDevice", sender: allPeripheral.at(indexPath.row))

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BLEDeviceCell.defaultReuseIdentifier, for: indexPath) as! BLEDeviceCell
        let index = allPeripheral.index(allPeripheral.startIndex, offsetBy: indexPath.row)
        let info = "Name: \(allPeripheral[index].name)\nid: \(allPeripheral[index].identifier)"
        cell.setCell(info)
        return cell
    }

    func testBLE (){
        
        let serviceUUID = CBUUID(string:"ec00")
        var peripheral: Peripheral?
        let dateCharacteristicUUID = CBUUID(string:"ec0e")
        
        //initialize a central manager with a restore key. The restore key allows to resuse the same central manager in future calls
        let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "CentralMangerKey" as NSString])
        
        //A future stram that notifies us when the state of the central manager changes
        let stateChangeFuture = manager.whenStateChanges()
        
        let scanFuture = stateChangeFuture.flatMap { state -> FutureStream<Peripheral> in
            switch state {
            case .poweredOn:
                DispatchQueue.main.async {
                    self.connectionStatusLabel.text = "start scanning"
                    print(self.connectionStatusLabel.text!)
                }
                //scan for peripherlas that advertise the ec00 service
                return manager.startScanning(forServiceUUIDs: [serviceUUID])
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
        }
        
        scanFuture.onFailure { error in
            guard let appError = error as? AppError else {
                return
            }
            switch appError {
            case .invalidState:
                break
            case .resetting:
                print("manager.reset()")
                manager.reset()
            case .poweredOff:
                self.showAlertMessage(title: "Error", message: "BT power off")
                break
            case .unknown:
                break
            default:
                break;
            }
        }
        
        //We will connect to the first scanned peripheral
        let connectionFuture = scanFuture.flatMap { p -> FutureStream<Void> in
            //stop the scan as soon as we find the first peripheral
            manager.stopScanning()
            peripheral = p
            
            guard let peripheral = peripheral else {
                throw AppError.unknown
            }
            
            DispatchQueue.main.async {
                self.connectionStatusLabel.text = "Found peripheral \(peripheral.identifier.uuidString). Trying to connect"
                print(self.connectionStatusLabel.text!)
            }
            //connect to the peripheral in order to trigger the connected mode
            return peripheral.connect(connectionTimeout: 10, capacity: 5)
        }
        
        //we will next discover the "ec00" service in order be able to access its characteristics
        let discoveryFuture = connectionFuture.flatMap { _ -> Future<Void> in
            guard let peripheral = peripheral else {
                throw AppError.unknown
            }
            return peripheral.discoverServices([serviceUUID])
            }.flatMap { _ -> Future<Void> in
                guard let discoveredPeripheral = peripheral else {
                    throw AppError.unknown
                }
                guard let service = discoveredPeripheral.services(withUUID:serviceUUID)?.first else {
                    throw AppError.serviceNotFound
                }
                peripheral = discoveredPeripheral
                DispatchQueue.main.async {
                    self.connectionStatusLabel.text = "Discovered service \(service.uuid.uuidString). Trying to discover characteristics"
                    print(self.connectionStatusLabel.text!)
                }
                //we have discovered the service, the next step is to discover the "ec0e" characteristic
                return service.discoverCharacteristics([dateCharacteristicUUID])
        }
        
        /**
         1- checks if the characteristic is correctly discovered
         2- Register for notifications using the dataFuture variable
         */
        let dataFuture = discoveryFuture.flatMap { _ -> Future<Void> in
            guard let discoveredPeripheral = peripheral else {
                throw AppError.unknown
            }
            guard let dataCharacteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicUUID)?.first else {
                throw AppError.dataCharactertisticNotFound
            }
            self.dataCharacteristic = dataCharacteristic
            DispatchQueue.main.async {
                self.connectionStatusLabel.text = "Discovered characteristic \(dataCharacteristic.uuid.uuidString). COOL :)"
                print(self.connectionStatusLabel.text!)
            }
            //when we successfully discover the characteristic, we can show the characteritic view
            DispatchQueue.main.async {
                self.hideLoadOverlay()
                self.contentView.isHidden = false
            }
            //read the data from the characteristic
            self.read()
            //Ask the characteristic to start notifying for value change
            return dataCharacteristic.startNotifying()
            }.flatMap { _ -> FutureStream<Data?> in
                guard let discoveredPeripheral = peripheral else {
                    throw AppError.unknown
                }
                guard let characteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicUUID)?.first else {
                    throw AppError.dataCharactertisticNotFound
                }
                //regeister to recieve a notifcation when the value of the characteristic changes and return a future that handles these notifications
                return characteristic.receiveNotificationUpdates(capacity: 10)
        }
        
        //The onSuccess method is called every time the characteristic value changes
        dataFuture.onSuccess { data in
            let s = String(data:data!, encoding: .utf8)
            DispatchQueue.main.async {
                self.notifiedValueLabel.text = "notified value is \(String(describing: s))"
            }
        }
        
        //handle any failure in the previous chain
        dataFuture.onFailure { error in
            switch error {
            case PeripheralError.disconnected:
                peripheral?.reconnect()
            case AppError.serviceNotFound:
                break
            case AppError.dataCharactertisticNotFound:
                break
            default:
                break
            }
        }
        }
        
    
    
    
    @IBAction func onWriteTapped(_ sender: Any) {
        self.write()
    }
    
    @IBAction func onRefreshTap(_ sender: Any) {
        self.read()
    }
    
    func read(){
        //read a value from the characteristic
        let readFuture = self.dataCharacteristic?.read(timeout: 5)
        readFuture?.onSuccess { (_) in
            //the value is in the dataValue property
            let s = String(data:(self.dataCharacteristic?.dataValue)!, encoding: .utf8)
            DispatchQueue.main.async {
                self.valueLabel.text = "Read value is \(String(describing: s))"
                print(self.valueLabel.text!)
            }
        }
        readFuture?.onFailure { (_) in
            self.valueLabel.text = "read error"
        }
    }
    
    func write(){
        self.valueToWriteTextField.resignFirstResponder()
        guard let text = self.valueToWriteTextField.text else{
            return;
        }
        //write a value to the characteristic
        let writeFuture = self.dataCharacteristic?.write(data:text.data(using: .utf8)!)
        writeFuture?.onSuccess(completion: { (_) in
            print("write succes")
        })
        writeFuture?.onFailure(completion: { (e) in
            print("write failed")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

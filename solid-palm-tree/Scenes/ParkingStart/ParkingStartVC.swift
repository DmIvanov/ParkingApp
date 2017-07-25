//
//  ParkingStartVC.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit
import MapKit

class ParkingStartVC: UIViewController {

    // MARK: - Properties
    let dataSource = ParkingStartVCDataSource()

    @IBOutlet private var selectedZoneLabel: UILabel!
    @IBOutlet private var defaultVehicleLabel: UILabel!
    @IBOutlet private var mapView: MKMapView!

    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.updateZones()
        refreshDefaultVehicle()
        refreshSelectedZone()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(zonesDidUpdate),
            name: DSZonesDidUpdateNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }


    // MARK: - Public
    func setDataService(service: DataService) {
        dataSource.setDataService(service: service)
    }


    // MARK: - Private
    fileprivate func refreshDefaultVehicle() {
        defaultVehicleLabel.text = dataSource.defaultVehicleText()
    }

    fileprivate func refreshSelectedZone() {
        selectedZoneLabel.text = dataSource.selectedZoneText()
    }

    @objc private func zonesDidUpdate() {
        setZones()
    }

    private func setZones() {
        let zones = dataSource.zones()
        let aPins = pins(fromZones: zones)
        mapView.addAnnotations(aPins)
        mapView.showAnnotations(aPins, animated: true)
    }

    private func pins(fromZones zones: [ParkingZone]) -> [MKPointAnnotation] {
        var pins = [MKPointAnnotation]()
        for zone in zones {
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: zone.lat, longitude: zone.long)
            pin.title = zone.address
            pins.append(pin)
        }
        return pins
    }


    // MARK: - Actions
    @IBAction private func startParkingPressed() {
        let actionResult = dataSource.parkingAction()
        if (actionResult.error != nil) {
            let alert = UIAlertController(
                title: "Impossible to start parking",
                message: actionResult.error!,
                preferredStyle: .alert
            )
            present(alert, animated: true, completion: {
                let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.alertTapped))
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(tapRecogniser)
            })
        } else if (actionResult.action != nil) {
            let parkingActionVC = SceneFactory.listVC()
            let parkingActionDataSource = ParkingActionDataSource(
                parkingAction: actionResult.action!,
                dataService: dataSource.dataService!,
                vc: parkingActionVC
            )
            parkingActionVC.dataSource = parkingActionDataSource
            navigationController?.pushViewController(parkingActionVC, animated: true)
            dataSource.actionStarted(action: actionResult.action!)
        }
    }

    func alertTapped() {
        dismiss(animated: true, completion: nil)
    }
}


extension ParkingStartVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let aTitle = view.annotation?.title else {return}
        guard let title = aTitle else {return}
        dataSource.setSelectedZone(withTitle: title)
        refreshSelectedZone()
    }
}

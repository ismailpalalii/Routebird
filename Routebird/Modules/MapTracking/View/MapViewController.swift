//
//  MapViewController.swift
//  Routebird
//
//  Created by İsmail Palalı on 12.06.2025.
//

import Foundation
import MapKit
import SnapKit
import CoreLocation

final class MapViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let mapView = MKMapView()
    private let startStopButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.text = "speed_placeholder".localized
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.88)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let locateButton = UIButton(type: .system)
    
    // MARK: - ViewModel
    
    private let viewModel = MapViewModel()
    
    // MARK: - Services
    
    private let locationService = LocationService()
    
    // MARK: - State
    
    private var hasCenteredMap = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        locationService.delegate = self
        configureUI()
        configureActions()
        viewModel.loadRoute()
        locationService.startTracking()
    }
    
    // MARK: - UI Setup
    
    private func configureUI() {
        view.backgroundColor = .white
        configureMapView()
        configureButtons()
        configureSpeedLabel()
        configureLocateButton()
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureButtons() {
        // Configure button styles
        startStopButton.setTitle("start".localized, for: .normal)
        startStopButton.setTitleColor(.white, for: .normal)
        startStopButton.backgroundColor = UIColor.systemGreen
        startStopButton.layer.cornerRadius = 12
        startStopButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        resetButton.setTitle("reset".localized, for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = UIColor.systemGray
        resetButton.layer.cornerRadius = 12
        resetButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        // Add to horizontal stack view
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 32
        buttonStackView.distribution = .fillEqually
        
        buttonStackView.addArrangedSubview(startStopButton)
        buttonStackView.addArrangedSubview(resetButton)
        
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.height.equalTo(48)
        }
    }
    
    private func configureSpeedLabel() {
        view.addSubview(speedLabel)
        speedLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(210)
            make.height.equalTo(32)
        }
    }
    
    private func configureLocateButton() {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
            locateButton.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: .normal)
        } else {
            locateButton.setTitle("Locate", for: .normal)
        }
        locateButton.tintColor = .systemGreen
        locateButton.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        locateButton.layer.cornerRadius = 20
        locateButton.clipsToBounds = true
        view.addSubview(locateButton)
        locateButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-128)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(40)
        }
        locateButton.addTarget(self, action: #selector(didTapLocate), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    private func configureActions() {
        startStopButton.addTarget(self, action: #selector(didTapStartStop), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
    }
    
    @objc private func didTapStartStop() {
        // MARK: - Check location permission
        if !viewModel.isTracking && !locationService.hasLocationPermission() {
            let alert = UIAlertController(
                title: "location_permission_needed".localized,
                message: "location_permission_message".localized,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
            alert.addAction(UIAlertAction(title: "open_settings".localized, style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            present(alert, animated: true)
            return
        }
        viewModel.toggleTracking()
        let isTracking = viewModel.isTracking
        startStopButton.setTitle(isTracking ? "stop".localized : "start".localized, for: .normal)
        startStopButton.backgroundColor = isTracking ? .systemRed : .systemGreen
        
        speedLabel.isHidden = !isTracking
        if isTracking {
            updateSpeedLabel()
            showToast(message: "tracking_started".localized)
        } else {
            showToast(message: "tracking_stopped".localized)
        }
    }
    
    @objc private func didTapLocate() {
        if let userLocation = mapView.userLocation.location {
            centerMapOn(userLocation)
        }
    }

    @objc private func didTapReset() {
        let alert = UIAlertController(
            title: "clear_route_title".localized,
            message: "clear_route_message".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        alert.addAction(UIAlertAction(title: "clear".localized, style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.resetRoute()
            self.viewModel.isTracking = false
            self.startStopButton.setTitle("start".localized, for: .normal)
            self.startStopButton.backgroundColor = .systemGreen
            self.showToast(message: "route_cleared".localized)
            self.speedLabel.isHidden = true
        }))
        present(alert, animated: true)
    }
    
    private func centerMapOn(_ location: CLLocation) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 800,
            longitudinalMeters: 800
        )
        mapView.setRegion(region, animated: true)
    }
    
    private func updateSpeedLabel() {
        guard viewModel.isTracking else {
            speedLabel.isHidden = true
            return
        }
        let speed = viewModel.getCurrentSpeedKmh() ?? 0
        speedLabel.text = "speed_placeholder".localizedFormat(speed)
        speedLabel.isHidden = false
    }
}

// MARK: - MapViewModelDelegate

extension MapViewController: MapViewModelDelegate {
    func didAddNewMarker(_ marker: Marker) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = marker.coordinate
        annotation.title = marker.title
        annotation.subtitle = marker.subtitle
        mapView.addAnnotation(annotation)
        updateSpeedLabel()
    }
    
    func didResetRoute() {
        mapView.removeAnnotations(mapView.annotations)
        speedLabel.text = "speed_placeholder".localized
    }
    
    func didResolveAddress(_ address: String, for marker: Marker) {
        let alert = UIAlertController(title: "address".localized, message: address, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default))
        present(alert, animated: true)
    }
    
    func didEncounterError(_ error: RoutebirdError) {
        let alert = UIAlertController(
            title: "error".localized,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "BirdMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "birdFeather")
        annotationView?.frame.size = CGSize(width: 36, height: 36)
        annotationView?.centerOffset = CGPoint(x: 0, y: -18)
        
        return annotationView
    }
}

// MARK: - LocationServiceDelegate

extension MapViewController: LocationServiceDelegate {
    func locationService(_ service: LocationService, didUpdateLocation location: CLLocation) {
        if !hasCenteredMap {
            centerMapOn(location)
            hasCenteredMap = true
        }
        viewModel.updateLocation(location)
    }
}

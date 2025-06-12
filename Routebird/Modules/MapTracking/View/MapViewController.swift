//
//  MapViewController.swift
//  Routebird
//
//  Created by İsmail Palalı on 12.06.2025.
//

import Foundation
import MapKit
import SnapKit

final class MapViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let mapView = MKMapView()
    private let startStopButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    
    // MARK: - View Model
    
    private let viewModel = MapViewModel()
    
    // MARK: - Service
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
        locationService.startTracking()
    }
    
    // MARK: - UI Configuration

    private func configureUI() {
        view.backgroundColor = .white
        configureMapView()
        configureButtons()
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
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(.white, for: .normal)
        startStopButton.backgroundColor = UIColor.systemGreen
        startStopButton.layer.cornerRadius = 12
        startStopButton.titleLabel?.font = .boldSystemFont(ofSize: 16)

        resetButton.setTitle("Reset", for: .normal)
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
    // MARK: - Actions

    private func configureActions() {
        startStopButton.addTarget(self, action: #selector(didTapStartStop), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
    }

    @objc private func didTapStartStop() {
        viewModel.toggleTracking()

        let isTracking = viewModel.isTracking
        startStopButton.setTitle(isTracking ? "Stop" : "Start", for: .normal)
        startStopButton.backgroundColor = isTracking ? .systemRed : .systemGreen
    }

    @objc private func didTapReset() {
        viewModel.resetRoute()
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.backgroundColor = .systemGreen
    }
    
    private func centerMapOn(_ location: CLLocation) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 800,
            longitudinalMeters: 800
        )
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - MapViewModelDelegate

extension MapViewController: MapViewModelDelegate {
    func didAddNewMarker(_ marker: Marker) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = marker.coordinate
        annotation.title = "Marker"
        mapView.addAnnotation(annotation)
    }

    func didResetRoute() {
        mapView.removeAnnotations(mapView.annotations)
    }

    func didResolveAddress(_ address: String, for marker: Marker) {
        let alert = UIAlertController(title: "Address", message: address, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard
            let coordinate = view.annotation?.coordinate,
            let marker = viewModel.markers.first(where: {
                $0.coordinate.latitude == coordinate.latitude &&
                $0.coordinate.longitude == coordinate.longitude
            })
        else { return }
        viewModel.resolveAddress(for: marker)
    }
}

// MARK: - LocationServiceDelegate
extension MapViewController: LocationServiceDelegate {
    func locationService(_ service: LocationService, didUpdateLocation location: CLLocation) {
        centerMapOn(location)
        hasCenteredMap = true
        viewModel.updateLocation(location)
    }
}

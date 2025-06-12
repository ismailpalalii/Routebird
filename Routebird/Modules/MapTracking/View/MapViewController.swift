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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureActions()
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
           //TODO
        }

        @objc private func didTapReset() {
           //TODO
        }
}

//
//  MapViewController.swift
//  Space Rocks
//
//  Created by Radim Langer on 02/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate: AnyObject {
    func mapViewControllerDidChangeRegion(_ controller: MapViewController, _ visibleMeteorites: [Meteorite])
    func mapViewControllerDidSelectMeteorite(_ controller: MapViewController, _ meteorite: Meteorite)
    func mapViewControllerDidDeselectMeteorite(_ controller: MapViewController)
}

final class MapViewController: UIViewController {

    weak var delegate: MapViewControllerDelegate?

    @IBOutlet var mapView: MKMapView!

    var meteorites = [Meteorite]() {
        didSet {
            addAnotations()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

    }

    private func addAnotations() {

        let annotations = meteorites.map {
            mkPointAnnotation(
                coordinate: $0.coordinate,
                title: $0.name!,
                subtitle: $0.fallInfo!
            )
        }

        mapView.addAnnotations(annotations)
    }

    func selectAnnotation(meteorite: Meteorite) {

        let annotation = mapView.annotations.filter { $0.coordinate == meteorite.coordinate }

        guard let annotationToSelect = annotation.first else { return }

        zoom(coordinate: meteorite.coordinate)
        mapView.selectAnnotation(annotationToSelect, animated: true)
    }

    private func zoom(coordinate: CLLocationCoordinate2D) {

        let mapPoint = MKMapPointForCoordinate(coordinate)

        let insets = UIEdgeInsets(top: 0, left: view.frame.width / 2, bottom: 0, right: 0)

        let mapSize = MKMapSize(width: mapView.visibleMapRect.size.width / 2, height: mapView.visibleMapRect.size.height / 2)
        let mapRect = MKMapRect(origin: mapPoint, size: mapSize)
        mapView.setVisibleMapRect(mapRect, edgePadding: insets, animated: true)
    }

    func mkPointAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        return annotation
    }

    func deselectSelectedAnnotation() {
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationIdentifier = "AnnotationIdentifier"

        let annotationView: MKAnnotationView

        if #available(iOS 11.0, *) {

            let markerAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKMarkerAnnotationView
                                       ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)

            markerAnnotationView.glyphImage = #imageLiteral(resourceName: "meteorImage")
            markerAnnotationView.animatesWhenAdded = true
            annotationView = markerAnnotationView
        } else {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
                             ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }

        return annotationView
    }


    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        let visibleAnnotations = mapView.visibleAnnotations

        let visibleMeteorites = meteorites.filter { meteorite in
            visibleAnnotations.first(where: { annotation in
                meteorite.coordinate == annotation.coordinate 
            }) != nil
        }

        delegate?.mapViewControllerDidChangeRegion(self, visibleMeteorites)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard
            let selectedMeteorite = meteorites.first(where: { $0.coordinate == view.annotation?.coordinate }),
            let coordinate = view.annotation?.coordinate
        else {
            return
        }

        zoom(coordinate: coordinate)
        delegate?.mapViewControllerDidSelectMeteorite(self, selectedMeteorite)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        delegate?.mapViewControllerDidDeselectMeteorite(self)
    }
}

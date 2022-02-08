//
//  AnnotationModel.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/07.
//

import Foundation
import MapKit
import Contacts

// MKAnnotation 프로토콜을 구현하기 위해서 title, subtitle, coordinate 등 필요

class AnnotationModel: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var markerTintColor: UIColor {
        switch discipline {
        case "red":
            return .red
        case "blue":
            return .blue
        case "green":
            return .green
        default:
            return .brown
        }
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

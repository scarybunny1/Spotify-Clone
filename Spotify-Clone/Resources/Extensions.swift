//
//  File.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 28/12/22.
//

import UIKit

extension UIView{
    
    var width: CGFloat{
        return frame.size.width
    }
    
    var height: CGFloat{
        return frame.size.height
    }
    
    var left: CGFloat{
        return frame.origin.x
    }
    
    var right: CGFloat{
        return left + width
    }
    
    var top: CGFloat{
        return frame.origin.y
    }
    
    var bottom: CGFloat{
        return top + height
    }
}

extension DateFormatter{
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
}

extension String{
    static func formattedDate(from string: Self) -> String{
        guard let date = DateFormatter.dateFormatter.date(from: string) else{
            return string
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}

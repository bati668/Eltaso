//
//  URLComponents.swift
//  Eltaso
//
//  Created by 史　翔新 on 2016/12/06.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import Foundation

extension URLComponents: EltasoCompatible { }

extension EltasoContainer where Containee == URLComponents {
	
	public static func `init`(queryItems: [URLQueryItem]) -> URLComponents {
		var components = URLComponents()
		components.queryItems = queryItems
		return components
	}
	
}

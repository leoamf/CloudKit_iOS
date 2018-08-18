//
//  NewQueryTypeSelectorTableViewController.swift
//  CloudKitchenSink
//
//  Created by aluno on 18/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit

class NewQueryTypeSelectorTableViewController: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let queryType = NewQueryType(rawValue: identifier) else {
            fatalError("Unknown query type \(String(describing: segue.identifier))")
        }
        
        guard let destination = segue.destination as? NewQueryTableViewController else {
            fatalError("Query type segue destination must be a NewQueryTableViewController")
        }
        
        destination.queryType = queryType
    }
    
}


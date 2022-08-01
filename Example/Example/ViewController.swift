//
//  ViewController.swift
//  Example
//
//  Created by Francisco Javier Saldivar Rubio on 31/07/22.
//

import UIKit
import AnnotationSerializer
import AnnotationSwift

struct Model: Serialize {
    @SerializeName("Named")
    var string: String!
    
    @GroupSet(SerializeName<String>("namedUperCase"),
              LowCase<String>())
    var string2: String!
}

final class ViewController: UIViewController {
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTap(_ sender: Any) {
        let model: Model = .init()
        model.string = input.text
        model.string2 = input.text
        textView.text = model.toJsonString()
    }

}


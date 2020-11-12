//
//  SecondViewController.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        self.navigationItem.title = "TELA SECUNDARIA"
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.backgroundColor = .white
        button.setTitle("PROXIMA PAGINA", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.tintColor = .blue
        button.center = view.center
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc
    private func buttonPressed(sender: UIButton) {
        let controller = UIViewController()
        controller.view.backgroundColor = .blue
        controller.navigationItem.title = "TELA 3"
        navigationController?.pushViewController(controller, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

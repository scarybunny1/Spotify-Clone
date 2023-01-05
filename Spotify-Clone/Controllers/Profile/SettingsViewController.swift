//
//  SettingsViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        return tv
    }()

    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        configureModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension SettingsViewController{
    private func style(){
        setUpTableView()
    }
    
    private func layout(){
        view.addSubview(tableView)
    }
    
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configureModels(){
        sections.append(Section(title: "Profile", option: [Option(title: "View Your Profile", handler: {[weak self] in
            DispatchQueue.main.async{
                self?.viewProfile()
            }
        })]))
        sections.append(Section(title: "Account", option: [Option(title: "Sign Out", handler: {[weak self] in
            DispatchQueue.main.async{
                self?.signoutTapped()
            }
        })]))
    }
    
    private func viewProfile(){
        let vc =  ProfileViewController()
        vc.title = "Profile"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signoutTapped(){
        
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = sections[indexPath.section].option[indexPath.row]
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model = sections[indexPath.section].option[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

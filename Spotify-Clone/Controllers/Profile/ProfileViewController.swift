//
//  ProfileViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.isHidden = true
        return tv
    }()
    
    var models: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProfile()
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func fetchProfile(){
        APIManager.shared.getCurrentUserProfile {[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.updateUI(with: user)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.failedToGetProfile()
                    }
                }
            }
        }
    }
    
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        //configure table models
        models.append("Full Name: \(model.display_name)")
        models.append("Email Address: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Plan: \(model.product)")
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeader(with urlString: String?){
        guard let urlString = urlString, let url = URL(string: urlString) else{
            return
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 1.5))
        let imageSize: CGFloat = headerView.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: url)
        
        tableView.tableHeaderView = headerView
    }
    
    private func failedToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
}

//MARK:  TableView delegate and datasource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
}

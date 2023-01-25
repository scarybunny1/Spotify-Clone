//
//  SearchResultsViewController.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import UIKit

enum ResultsSection: Int{
    case tracks
    case albums
    case artists
    case playlists
    
    var title: String{
        switch self{
        case .tracks:
            return "Tracks"
        case .albums:
            return "Albums"
        case .artists:
            return "Artists"
        case .playlists:
            return "Playlists"
        }
    }
}

protocol SearchResultsViewControllerDelegate{
    func didTapResult(_ result: SearchResults)
}

class SearchResultsViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.register(DefaultSearchResultsTableViewCell.self, forCellReuseIdentifier: DefaultSearchResultsTableViewCell.identifier)
        
        tv.register(SearchResultsSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultsSubtitleTableViewCell.identifier)
        tv.isHidden = true
        return tv
    }()
    
    private var results = [[SearchResults]]()
    
    var delegate: SearchResultsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func update(with results: [[SearchResults]]){
        self.results = results
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }

    private func setUpTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if results[section].count > 0{
            return ResultsSection(rawValue: section)?.title
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.section][indexPath.row]
        switch model {
        case .albums(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultsSubtitleTableViewCell.identifier
            ) as! SearchResultsSubtitleTableViewCell
            cell.configure(
                with: SearchResultsSubtitleTableViewCellViewModel(
                    title: model.name,
                    subTitle: model.artists.first?.name ?? "",
                    imageUrl: URL(
                        string: model.images.first?.url ?? ""
                    )
                )
            )
            return cell
        case .artists(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DefaultSearchResultsTableViewCell.identifier
            ) as! DefaultSearchResultsTableViewCell
            cell.configure(
                with: DefaultSearchResultsTableViewCellViewModel(
                    title: model.name,
                    imageUrl: URL(
                        string: model.images?.first?.url ?? ""
                    )
                )
            )
            return cell
        case .playlists(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultsSubtitleTableViewCell.identifier
            ) as! SearchResultsSubtitleTableViewCell
            cell.configure(
                with: SearchResultsSubtitleTableViewCellViewModel(
                    title: model.name,
                    subTitle: model.owner.display_name,
                    imageUrl: URL(
                        string: model.images.first?.url ?? ""
                    )
                )
            )
            return cell
        case .tracks(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultsSubtitleTableViewCell.identifier
            ) as! SearchResultsSubtitleTableViewCell
            cell.configure(
                with: SearchResultsSubtitleTableViewCellViewModel(
                    title: model.name,
                    subTitle: model.artists.first?.name ?? "",
                    imageUrl: URL(
                        string: model.album?.images.first?.url ?? ""
                    )
                )
            )
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let result = results[indexPath.section][indexPath.row]
        delegate?.didTapResult(result)
    }
}

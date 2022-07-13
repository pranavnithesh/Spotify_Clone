//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 22/05/21.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    var playlists = [Playlist]()
    private let noPlayListsView = ActionLabelView()
    public var selectionHandler: ((Playlist) -> Void)?
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped )
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setupNoPlaylistsView()
        fetchPlaylists()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlayListsView.frame = CGRect(x: 20, y: 0, width: view.width-40, height: 150)
        noPlayListsView.center = view.center
        tableView.frame = view.bounds
    }
    
    private func updateUI() {
        if playlists.isEmpty {
            //Show Label
            noPlayListsView.isHidden = false
            tableView.isHidden = true
        } else {
            //Show Table
            tableView.reloadData()
            noPlayListsView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setupNoPlaylistsView() {
        view.addSubview(noPlayListsView)
        noPlayListsView.delegate = self
        noPlayListsView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlists yet..", actionTitle: "Create"))
    }
    
    private func fetchPlaylists() {
        APICaller.shared.getCurrentUserPlaylists { [weak self ] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(title: "New Playlists", message: "Enter Playlists name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlists.."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            APICaller.shared.createPlaylist(with: text) { [weak self] success in
                if success {
                    HapticManager.shared.vibrate(for: .success)
                    //Refresh lists of Playlists
                    self?.fetchPlaylists()
                } else {
                    HapticManager.shared.vibrate(for: .error)
                    print("Failed to create Playlist")
                }
            }
            
        }))
        present(alert, animated: true )
    }
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        // Show creation UI for playlists
        showCreatePlaylistAlert()
    }
}

extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title:  playlist.name, subtitle: playlist.owner.display_name, imageURL: URL(string: playlist.images.first?.url ?? "")))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticManager.shared.vibrateForSelection()
        let playlist = playlists[indexPath.row]
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true 
        navigationController?.pushViewController(vc, animated: true)
    }
}

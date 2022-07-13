//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 06/05/21.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
    func didTapClose()
}

class PlayerViewController: UIViewController {
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = PlayerControlView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top , width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10, y: imageView.bottom+10, width: view.width-20, height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didTapClose()
    }
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        controlsView.configure(with: PlayerControlViewViewModel(title: dataSource?.songName, subtitle: dataSource?.subtitle ))
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapCancel() {
        delegate?.didTapClose()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
        //Action
    }
    
    func refreshUI() {
        configure()
    }
}

extension PlayerViewController: PlayerControlViewDelegate {
    func playerControlViewDidTapPlayPauseButton(_ playerControlView: PlayerControlView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlViewDidTapBackwardButton(_ playerControlView: PlayerControlView) {
        delegate?.didTapBackward()
    }
    
    func playerControlViewDidTapNextButton(_ playerControlView: PlayerControlView) {
        delegate?.didTapForward()
    }
    func playerControlView(_ playerControlView: PlayerControlView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
}

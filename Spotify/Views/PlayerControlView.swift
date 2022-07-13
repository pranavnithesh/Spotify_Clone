//
//  PlayerControlView.swift
//  Spotify
//
//  Created by Pranav Nithesh J on 22/05/21.
//

import UIKit

protocol PlayerControlViewDelegate: AnyObject {
    func playerControlViewDidTapPlayPauseButton(_ playerControlView: PlayerControlView)
    func playerControlViewDidTapBackwardButton(_ playerControlView: PlayerControlView)
    func playerControlViewDidTapNextButton(_ playerControlView: PlayerControlView)
    func playerControlView(_ playerControlView: PlayerControlView, didSlideSlider value: Float )
}

struct PlayerControlViewViewModel {
    let title: String?
    let subtitle: String?
}

class PlayerControlView: UIView {
    private var isPlaying = true
    weak var delegate: PlayerControlViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backbutton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextbutton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPausebutton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(backbutton)
        addSubview(playPausebutton)
        addSubview(nextbutton)
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        backbutton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextbutton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPausebutton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlView(self, didSlideSlider: value)
    }
    
    @objc private func didTapBack() {
        delegate?.playerControlViewDidTapBackwardButton(self)
    }
    
    @objc private func didTapNext() {
        delegate?.playerControlViewDidTapNextButton(self)
    }
    
    @objc private func didTapPlayPause () {
        self.isPlaying = !isPlaying
        delegate?.playerControlViewDidTapPlayPauseButton(self)
        
        //Update icon
        let pause = UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPausebutton.setImage(isPlaying ? pause : play, for: .normal )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom+20, width: width-20, height: 44 )
        let buttonSize: CGFloat = 60
        
        playPausebutton.frame = CGRect(x: (width-buttonSize)/2, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
        backbutton.frame = CGRect(x: playPausebutton.left-80-buttonSize , y: playPausebutton.top, width: buttonSize, height: buttonSize)
        nextbutton.frame = CGRect(x: playPausebutton.right+80, y: playPausebutton.top, width: buttonSize, height: buttonSize)
    }
    
    func configure(with viewModel: PlayerControlViewViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

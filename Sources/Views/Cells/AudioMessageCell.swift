/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import AVFoundation

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class AudioMessageCell: MessageContentCell {

    
    var seekingBallColor: UIColor?
    var seekingTrackColor: UIColor?
    private var seekerPanGestureRecognizer : UIPanGestureRecognizer?
    
    /// The play button view to display on audio messages.
    public lazy var playButton: UIButton = {
        let playButton = UIButton(type: .custom)
        let playImage = UIImage.messageKitImageWith(type: .play)
        let pauseImage = UIImage.messageKitImageWith(type: .pause)
        playButton.setImage(playImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.setImage(pauseImage?.withRenderingMode(.alwaysTemplate), for: .selected)
        return playButton
    }()
    
    
    private lazy var seekingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var progressContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()

    

    
    
    private lazy var audioSeekingProgressBar: UISlider = {
        let slider = UISlider()
        let circleImage = makeCircleWith(size: CGSize(width: 15, height: 15),
                                         backgroundColor: UIColor.black)
        slider.setThumbImage(circleImage, for: .normal)
        slider.minimumTrackTintColor = UIColor.blue
        slider.maximumTrackTintColor = UIColor.green
        
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.isContinuous = true
        
        slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        return slider
    }()
    
    @objc func sliderValueDidChange(_ sender:UISlider) {
        
    }
    

    /// The time duration lable to display on audio messages.
    public lazy var durationLabel: UILabel = {
        let durationLabel = UILabel(frame: CGRect.zero)
        durationLabel.textAlignment = .right
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.text = "0:00"
        return durationLabel
    }()

    public lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()

    public lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.0
        return progressView
    }()
    
    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        playButton.constraint(equalTo: CGSize(width: 25, height: 25))
        playButton.addConstraints(left: messageContainerView.leftAnchor, centerY: messageContainerView.centerYAnchor, leftConstant: 5)
        activityIndicatorView.addConstraints(centerY: playButton.centerYAnchor, centerX: playButton.centerXAnchor)
        durationLabel.addConstraints(right: messageContainerView.rightAnchor, centerY: messageContainerView.centerYAnchor, rightConstant: 15)
        progressView.addConstraints(left: playButton.rightAnchor, right: durationLabel.leftAnchor, centerY: messageContainerView.centerYAnchor, leftConstant: 5, rightConstant: 5)
        
// UISlider:
        audioSeekingProgressBar.centerYAnchor.constraint(equalTo: self.messageContainerView.centerYAnchor).isActive = true
        audioSeekingProgressBar.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: 0).isActive = true
        audioSeekingProgressBar.leadingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: 30 ).isActive = true
        audioSeekingProgressBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        audioSeekingProgressBar.translatesAutoresizingMaskIntoConstraints = false
        audioSeekingProgressBar.layoutIfNeeded()
        
        
//    testSwitch.centerYAnchor.constraint(equalTo: self.messageContainerView.centerYAnchor).isActive = true
//    testSwitch.leadingAnchor.constraint(equalTo: self.messageContainerView.leadingAnchor, constant: 0).isActive = true
//    testSwitch.heightAnchor.constraint(equalToConstant: 35).isActive = true
//    testSwitch.widthAnchor.constraint(equalToConstant: 300).isActive = true
//    testSwitch.translatesAutoresizingMaskIntoConstraints = false
        
// Seeking View with Gesture :
        
//        progressContainerView.centerYAnchor.constraint(equalTo: self.progressView.centerYAnchor).isActive = true
//        progressContainerView.trailingAnchor.constraint(equalTo: self.progressView.trailingAnchor, constant: 0).isActive = true
//        progressContainerView.leadingAnchor.constraint(equalTo: self.progressView.leadingAnchor, constant: 0).isActive = true
//        progressContainerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        progressContainerView.translatesAutoresizingMaskIntoConstraints = false
//        progressContainerView.layoutIfNeeded()
//
//
//
//        seekingView.centerYAnchor.constraint(equalTo: self.progressContainerView.centerYAnchor).isActive = true
//        seekingView.leadingAnchor.constraint(equalTo: self.progressContainerView.leadingAnchor, constant: 0).isActive = true
//
//        seekingView.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        seekingView.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        seekingView.translatesAutoresizingMaskIntoConstraints = false
//
//        createDraggableSeekingView()
        

    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(playButton)
        messageContainerView.addSubview(activityIndicatorView)
        messageContainerView.addSubview(durationLabel)
        messageContainerView.addSubview(progressView)
        
        

// UISlider:
        self.addSubview(audioSeekingProgressBar)
        self.bringSubviewToFront(audioSeekingProgressBar)
        
        
// UISwitch:
//        messageContainerView.addSubview(testSwitch)
//        messageContainerView.bringSubviewToFront(testSwitch)
                
        
// Seeking View with Gesture :
//        messageContainerView.addSubview(progressContainerView)
//        progressContainerView.addSubview(seekingView)
//        progressContainerView.bringSubviewToFront(seekingView)
        
        setupConstraints()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        progressView.progress = 0
        playButton.isSelected = false
        activityIndicatorView.stopAnimating()
        playButton.isHidden = false
        durationLabel.text = "0:00"
//        audioSeekingProgressBar.value = 0
//        audioSeekingProgressBar.maximumValue = 0
//        audioSeekingProgressBar.minimumValue = 100.0
//        audioSeekingProgressBar.value = 50.0
    }

    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        // compute play button touch area, currently play button size is (25, 25) which is hardly touchable
        // add 10 px around current button frame and test the touch against this new frame
        let uiSliderTouchArea = CGRect(audioSeekingProgressBar.frame.origin.x - 10.0, audioSeekingProgressBar.frame.origin.y - 10, audioSeekingProgressBar.frame.size.width + 20, audioSeekingProgressBar.frame.size.height + 20)
        
        
        let progressContainerTouchArea = CGRect(progressContainerView.frame.origin.x - 10.0, progressContainerView.frame.origin.y - 10, progressContainerView.frame.size.width + 20, progressContainerView.frame.size.height + 20)
        
        
        
        let playButtonTouchArea = CGRect(playButton.frame.origin.x - 10.0, playButton.frame.origin.y - 10, playButton.frame.size.width + 20, playButton.frame.size.height + 20)
        let translateTouchLocation = convert(touchLocation, to: messageContainerView)
        if playButtonTouchArea.contains(translateTouchLocation) {
            delegate?.didTapPlayButton(in: self)
        }
        if progressContainerTouchArea.contains(translateTouchLocation) {
//            delegate?.didTapPlayButton(in: self)
        }
        if uiSliderTouchArea.contains(translateTouchLocation) {
            //            delegate?.didTapPlayButton(in: self)
        } else {
            super.handleTapGesture(gesture)
        }
    }

    
   
    
    
    // MARK: - Configure Cell

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }

        let playButtonLeftConstraint = messageContainerView.constraints.filter { $0.identifier == "left" }.first
        let durationLabelRightConstraint = messageContainerView.constraints.filter { $0.identifier == "right" }.first

        if !dataSource.isFromCurrentSender(message: message) {
            playButtonLeftConstraint?.constant = 12
            durationLabelRightConstraint?.constant = -8
        } else {
            playButtonLeftConstraint?.constant = 5
            durationLabelRightConstraint?.constant = -15
        }

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        let tintColor = displayDelegate.audioTintColor(for: message, at: indexPath, in: messagesCollectionView)
        playButton.imageView?.tintColor = tintColor
        durationLabel.textColor = tintColor
        progressView.tintColor = tintColor
        
        if case let .audio(audioItem) = message.kind {
            durationLabel.text = displayDelegate.audioProgressTextFormat(audioItem.duration, for: self, in: messagesCollectionView)
        }

        displayDelegate.configureAudioCell(self, message: message)
    }
}


extension AudioMessageCell {
    func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}



extension AudioMessageCell: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

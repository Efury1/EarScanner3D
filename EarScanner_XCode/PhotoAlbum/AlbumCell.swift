//
//  AlbumCell.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 19/9/21.
//

import UIKit
import EasyPeasy

class AlbumCell: UITableViewCell {
    
    static let id = "AlbumCell"
    
    lazy var photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var text: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var sendButton: UIButton = {
       let button = UIButton()
        let largeTitle = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.setImage(UIImage(systemName: "square.and.arrow.up.fill", withConfiguration: largeTitle), for: .normal)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setupView() {
        contentView.addSubview(photoView)
        contentView.addSubview(sendButton)
        contentView.addSubview(text)
        
        photoView.easy.layout(Top(), Left(), Right(), Height(200))
        text.easy.layout(Top(10).to(photoView, .bottom), Left())
        sendButton.easy.layout(Top(10).to(photoView, .bottom), Left(20), Right(20).to(text, .right), Bottom())
        
    }
    
}

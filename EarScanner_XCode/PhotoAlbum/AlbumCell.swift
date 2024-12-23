//
//  AlbumCell.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 19/9/21.
//

import UIKit
import EasyPeasy
import SwiftUI

class AlbumCell: UITableViewCell {
    
    static let id = "AlbumCell"
    
    lazy var photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var text: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var sendButton: UIButton = {
       let button = UIButton()
        let largeTitle = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.setImage(UIImage(systemName: "square.and.arrow.up.fill", withConfiguration: largeTitle), for: .normal)
        return button
    }()
    
    lazy var sendText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Send"
        return label
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
        
        //photoView.easy.layout(Top(), Left(), Right(), Height(50))
        text.easy.layout(Top(15), Left(10))
        sendButton.easy.layout(Right(20), Bottom())
        sendText.easy.layout(Top(), Left(), Right(20), Bottom())
    }
    
}

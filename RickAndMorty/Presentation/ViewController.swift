//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Ross Chapman on 9/29/20.
//  Copyright © 2020 Ross Chapman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var viewModel = CharactersViewModel()
    
    func showDetail(`for` character: CharacterViewModel) {
        let alert = UIAlertController(
            title: character.title,
            message: character.location,
            preferredStyle: .alert)
        alert.addAction(.init(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func updateViews() {
        self.charactersListView.tableView.reloadData()
    }
    
    var charactersListView: CharactersListView {
        return self.view as! CharactersListView
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.updateViews = self.updateViews
        
        self.charactersListView.viewModel = self.viewModel
        self.charactersListView.showDetail = self.showDetail(for:)
    }
    
    override func viewWillAppear(_ animate: Bool) {
        super.viewWillAppear(animate)
        
        self.viewModel.getCharacters()
    }
}

class CharactersListView: UIView {
    @IBOutlet var tableView: UITableView!
    
    var viewModel: CharactersViewModel!
    
    var showDetail: ((CharacterViewModel) -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
    }
    
    func configure(cell: UITableViewCell, character: CharacterViewModel) {
        cell.imageView?.image = nil
        cell.textLabel?.text = character.title
        cell.detailTextLabel?.text = character.subTitle
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        
        character.requestImage { (image, name) in
            guard name == character.name else { return }
            
            cell.imageView?.image = image
            cell.setNeedsLayout()
        }
    }
}

extension CharactersListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = self.viewModel.characters[indexPath.row]
        
        self.showDetail(character)
    }
}

extension CharactersListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Character", for: indexPath)
        let character = self.viewModel.characters[indexPath.row]
        self.configure(cell: cell, character: character)
        
        if indexPath.row == self.viewModel.characterCount - 1 {
            self.viewModel.getCharacters()
        }
        
        return cell
    }
}

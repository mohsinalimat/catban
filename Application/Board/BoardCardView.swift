import UIKit

class BoardCardView:BoardItemView {
    private(set) weak var label:UILabel!
    private(set) weak var dragGesture:UIPanGestureRecognizer!
    private(set) weak var longGesture:UILongPressGestureRecognizer!
    private weak var halo:UIView!
    
    override func makeOutlets() {
        let halo = UIView()
        halo.isUserInteractionEnabled = false
        halo.translatesAutoresizingMaskIntoConstraints = false
        halo.backgroundColor = .catBlue
        halo.layer.cornerRadius = 6
        halo.alpha = 0
        addSubview(halo)
        self.halo = halo
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Application.interface.text
        label.numberOfLines = 0
        addSubview(label)
        self.label = label
        
        let dragGesture = UIPanGestureRecognizer()
        addGestureRecognizer(dragGesture)
        self.dragGesture = dragGesture
        
        let longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 1
        addGestureRecognizer(longGesture)
        self.longGesture = longGesture
        
        halo.topAnchor.constraint(equalTo:topAnchor, constant:-10).isActive = true
        halo.leftAnchor.constraint(equalTo:leftAnchor, constant:-10).isActive = true
        halo.bottomAnchor.constraint(equalTo:bottomAnchor, constant:10).isActive = true
        halo.rightAnchor.constraint(equalTo:rightAnchor, constant:10).isActive = true
        
        label.topAnchor.constraint(equalTo:topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    override func showSelected() {
        label.textColor = .black
        halo.backgroundColor = .catBlue
        halo.alpha = 1
    }
    
    override func showDefault() {
        label.textColor = Application.interface.text
        halo.alpha = 0
    }
}

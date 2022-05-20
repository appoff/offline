import Archivable

extension Cloud where Output == Archive {
    public func add(map: Map, signature: Signature?) async {
        model.maps.remove { $0.id == map.id }
        model.maps.insert(.init(map: map, signature: signature), at: 0)
        await stream()
    }
    
    public func delete(map: Map) async {
        model.maps.remove { $0.id == map.id }
        await stream()
    }
    
    public func update(scheme: Settings.Scheme) async {
        guard scheme != model.settings.scheme else { return }
        model.settings.scheme = scheme
        await stream()
    }
    
    public func update(map: Settings.Map) async {
        guard map != model.settings.map else { return }
        model.settings.map = map
        await stream()
    }
    
    public func update(directions: Settings.Directions) async {
        guard directions != model.settings.directions else { return }
        model.settings.directions = directions
        await stream()
    }
    
    public func update(interest: Bool) async {
        guard interest != model.settings.interest else { return }
        model.settings.interest = interest
        await stream()
    }
    
    public func update(rotate: Bool) async {
        guard rotate != model.settings.rotate else { return }
        model.settings.rotate = rotate
        await stream()
    }
}

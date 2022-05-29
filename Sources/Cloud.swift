import Archivable

extension Cloud where Output == Archive {
    public func add(header: Header, schema: Schema?) async {
        model.projects.remove { $0.id == header.id }
        model.projects.insert(.init(header: header, schema: schema), at: 0)
        await stream()
    }
    
    public func delete(header: Header) async {
        model.projects.remove { $0.id == header.id }
        await stream()
    }
    
    public func offload(header: Header) async {
        guard let index = model.projects.firstIndex(where: { $0.id == header.id }) else { return }
        model.projects.remove(at: index)
        model.projects.insert(.init(header: header, schema: nil), at: index)
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

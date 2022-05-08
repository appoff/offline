import Archivable

extension Cloud where Output == Archive {
    public func update(scheme: Settings.Scheme) async {
        guard scheme != model.settings.scheme else { return }
        model.settings.scheme = scheme
        await stream()
    }
}

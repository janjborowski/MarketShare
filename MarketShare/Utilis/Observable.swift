final class Observable<T> {
    
    typealias Observer = (T) -> Void
    
    private var observers = [Observer]()
    private(set) var value: T
    
    init(value: T) {
        self.value = value
    }
    
    func update(value: T) {
        self.value = value
        observers.forEach { $0(value) }
    }
    
    func observe(observer: @escaping Observer) {
        observers.append(observer)
    }
    
    func observeNow(observer: @escaping Observer) {
        observe(observer: observer)
        observer(value)
    }
    
}

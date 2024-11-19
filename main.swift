import Foundation

// Criando com Thread
let newThread = Thread {
    for i in 1...5 {
        print("Executando na nova thread: \(i)")
    }
}

newThread.start()
for i in 1...5 {
    print("Executando na thread principal: \(i)")
}

// Criando com DispatchQueue
DispatchQueue.global().async {
    for i in 1...5 {
        print("Executando em background: \(i)")
    }
}

DispatchQueue.main.async {
    for i in 1...5 {
        print("Executando na thread principal: \(i)")
    }
}

// Compartilhamento de memória entre threads
var sharedCounter = 0 // Variável compartilhada entre as threads

DispatchQueue.concurrentPerform(iterations: 10) { index in
    for _ in 1...10 {
        sharedCounter += 1 // Acesso simultâneo ao recurso
    }
    print("Thread \(index) finalizou. Valor parcial: \(sharedCounter)")
}

// Pequeno atraso para garantir que todas as threads terminem
Thread.sleep(forTimeInterval: 1)
print("Valor final do contador: \(sharedCounter)")

// Sincronização entre threads
var counter = 0

// DispatchSemaphore
let semaphore = DispatchSemaphore(value: 1)

DispatchQueue.global().async {
    for _ in 1...5 {
        semaphore.wait() // Bloqueia o recurso
        counter += 1
        print("Incrementado: \(counter)")
        semaphore.signal() // Libera o recurso
    }
}

DispatchQueue.global().async {
    for _ in 1...5 {
        semaphore.wait()
        counter += 1
        print("Incrementado de outra thread: \(counter)")
        semaphore.signal()
    }
}

Thread.sleep(forTimeInterval: 1)
print("Valor final do contador: \(counter)")

// NSLock
counter = 0
let lock = NSLock() // Cria um lock

DispatchQueue.global().async {
    for _ in 1...5 {
        lock.lock() // Bloqueia o recurso
        counter += 1
        print("Thread 1 incrementou: \(counter)")
        lock.unlock() // Libera o recurso
    }
}

Thread.sleep(forTimeInterval: 1)
print("Valor final do contador: \(counter)")

//DispatchQueue.sync com Fila Serial
counter = 0
let syncQueue = DispatchQueue(label: "com.example.syncQueue") // Cria uma fila serial
DispatchQueue.global().async {
    for _ in 1...8 {
        syncQueue.sync {
            counter += 1
            print("Thread 1 incrementou: \(counter)")
        }
    }
}

Thread.sleep(forTimeInterval: 1)
print("Valor final do contador: \(counter)")




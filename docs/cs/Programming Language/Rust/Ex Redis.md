# Exercise: Build a Simple Redis

!!! Info

    来自 CodeCrafters 的 [Build your own Redis 项目]()

## TCP Servers in Rust

服务器端方法：

- `TcpListener::bind`：接受一个 `&str` 参数，其为链接的地址和端口，创建一个 TCP 服务器，绑定到指定地址和端口，返回一个 `TcpListener` 实例；
- `TcpListener::accept`：手动接受一个连接且阻塞等待，返回一个 `TcpStream` 实例；
- `TcpListener::incoming`：返回一个 `TcpStream` 实例的迭代器，相当于在循环里面一直 accept，用于处理传入连接；

客户端与数据传输方法：

- `TcpStream::connect`：接受一个 `&str` 参数，其为链接的地址和端口，连接到指定地址和端口，返回一个 `TcpStream` 实例；
- `TcpStream::read`：接受一个可变的 `&mut [u8]` 参数，返回一个 `Result<usize>`，从流中读取数据到缓冲区，返回读取的字节数；
- `TcpStream::write`：接受一个可变的 `&[u8]` 参数，返回一个 `Result<usize>`，将数据写入流，返回写入的字节数；
- `TcpStream::write_all`：接受一个可变的 `&[u8]` 参数，返回一个 `Result<()>`，将所有数据写入流，返回值指示写入是否成功；

## Redis


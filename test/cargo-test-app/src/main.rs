use std::io::Write;
use std::net::TcpListener;

fn main() {
    let listener = TcpListener::bind("0.0.0.0:8080").unwrap();
    println!("{}", listener.local_addr().unwrap());

    let mut response = String::new();
    response.push_str("HTTP/1.1 200 OK\n");
    let body = "Hello from rust TcpListener application.\n";
    response.push_str("Content-Length: ");
    let content_length = body.len().to_string();
    response.push_str(&content_length);
    response.push_str("\n\n");
    response.push_str(&body);
    let response = response.as_bytes();
    for stream in listener.incoming() {
        let mut stream = stream.unwrap();
        stream.write(response).unwrap();
        stream.flush().unwrap();
    }
}

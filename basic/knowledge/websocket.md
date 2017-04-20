# Websocket
The WebSocket Protocol enables two-way communication between a client running untrusted code in a controlled environment to a remote host that has opted-in to communications from that code.  
The protocol consists of an opening handshake followed by basic message framing, layered over TCP.  
The goal of this technology is to provide a mechanism for browser-based applications that need two-way communication with servers that does not rely on opening multiple HTTP connections.

The protocol has two parts: a handshake and the data transfer.
The handshake from the client looks as follows:

        GET /chat HTTP/1.1
        Host: server.example.com
        Upgrade: websocket
        Connection: Upgrade
        Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
        Origin: http://example.com
        Sec-WebSocket-Protocol: chat, superchat
        Sec-WebSocket-Version: 13

   The handshake from the server looks as follows:

        HTTP/1.1 101 Switching Protocols
        Upgrade: websocket
        Connection: Upgrade
        Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
        Sec-WebSocket-Protocol: chat
//101 Switching Protocols 服务器已经理解了客户端的请求，并将通过Upgrade消息头通知客户端采用不同的协议来完成这个请求。在发送完这个响应最后的空行后，服务器将会切换到在Upgrade消息头中定义的那些协议。只有在切换新的协议更有好处的时候才应该采取类似措施。例如，切换到新的HTTP版本（如HTTP/2）比旧版本更有优势，或者切换到一个实时且同步的协议（如WebSocket）以传送利用此类特性的资源。

Once the client and server have both sent their handshakes, and if the handshake was successful, then the data transfer part starts. This is a two-way communication channel where each side can, independently from the other, send data at will.
The WebSocket message is composed of one or more frames. A frame has an associated type.  Each frame belonging to the same message contains the same type of data.  

 Opening Handshake
 Closing Handshake


 The WebSocket Protocol is designed on the principle that there should be minimal framing (the only framing that exists is to make the protocol frame-based instead of stream-based and to support a distinction between Unicode text and binary frames). Basically it is intended to be as close to just exposing raw TCP to script as possible given the constraints of the Web.

 It's also designed in such a way that its servers can share a port with HTTP servers, by having its handshake be a valid HTTP Upgrade request.

 The WebSocket Protocol is an independent TCP-based protocol.  Its only relationship to HTTP is that its handshake is interpreted by HTTP servers as an Upgrade request.

 The client can request that the server use a specific subprotocol by including the |Sec-WebSocket-Protocol| field in its handshake.  If it is specified, the server needs to include the same field and one of the selected subprotocol values in its response for the connection to be established.


WebSocket URIs
ws-URI = "ws:" "//" host [ ":" port ] path [ "?" query ]
wss-URI = "wss:" "//" host [ ":" port ] path [ "?" query ]

Once a connection to the server has been established (including a connection via a proxy or over a TLS-encrypted tunnel), the client MUST send an opening handshake to the server.  The handshake consists of an HTTP Upgrade request, along with a list of required and optional header fields.

Once the client's opening handshake has been sent, the client MUST wait for a response from the server before sending any further data.

A data center might have a server that responds to WebSocket requests with an appropriate handshake and then passes the connection to another server to actually process the data frames.

When a client starts a WebSocket connection, it sends its part of the opening handshake.  The server must parse at least part of this handshake in order to obtain the necessary information to generate the server part of the handshake.

 Sending the Server's Opening Handshake

 In the WebSocket Protocol, data is transmitted using a sequence of frames.  A data frame MAY be transmitted by either the client or the server at any time after opening handshake completion and before that endpoint has sent a Close frame.

 The base framing protocol defines a frame type with an opcode, a payload length, and designated locations for "Extension data" and "Application data", which together define the "Payload data". Certain bits and opcodes are reserved for future expansion of the protocol.

Until 5.3  Client-to-Server Masking

Extensions provide a mechanism for implementations to opt-in to additional protocol features. 

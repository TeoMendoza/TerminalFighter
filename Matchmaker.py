from flask import Flask, request, jsonify
import socket
app = Flask(__name__)

host_queue = []

def get_lan_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"
    finally:
        s.close()
    return ip

@app.route('/look_for_host', methods=["GET", 'POST'])
def look_for_host():
    client_ip = request.remote_addr
    # If the host registers via localhost, swap it for the real LAN IP
    if client_ip in ("127.0.0.1", "::1"):
        client_ip = get_lan_ip()

    if host_queue:
        host_ip = host_queue.pop(0)
        return jsonify({"status": "Found host", "host_ip": host_ip})
    
    host_queue.append(client_ip)
    return jsonify({"status": "No hosts, added to queue"})

@app.route('/cancel_host', methods=['POST'])
def cancel_host():
    client_ip = request.remote_addr
    if client_ip in host_queue:
        host_queue.remove(client_ip)
        return jsonify({"status": "Host canceled"})
    return jsonify({"status": "Not hosting"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=12345, debug=True)
    #app.run(debug=True)

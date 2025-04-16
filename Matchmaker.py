from flask import Flask, request, jsonify

app = Flask(__name__)

host_queue = []

@app.route('/look_for_host', methods=['POST'])
def look_for_host():
    client_ip = request.remote_addr

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

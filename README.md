# IposiAgent - Local API Bridge for Iposi

IposiAgent is a lightweight, background proxy application built with Delphi. It serves as a local bridge for the web-based [Iposi API Management Tool](https://github.com/yushadev0/iposi), allowing it to securely communicate with your local development servers (localhost / 127.0.0.1) and internal networks.

Just like the main Iposi project, IposiAgent was built to solve a specific workflow problem without relying on bulky third-party solutions.

---

## Why IposiAgent?

Since Iposi is hosted as a web application in the cloud, it faces a fundamental limitation shared by all web-based API clients: browser security (CORS) and network isolation prevent it from accessing APIs running on your local machine.

Instead of forcing you to download a heavy desktop client, IposiAgent runs silently in the background of your OS. When the Iposi web interface detects that you are trying to reach a local endpoint (e.g., `http://localhost:5000`), it automatically routes the request through IposiAgent without requiring any manual configuration or toggle switches.

---

## How It Works

1. You run **IposiAgent** on your local machine. It sits quietly in the System Tray and listens on port `19090`.
2. You open the Iposi [web interface](https://hasup.net/iposoi) and send a request to a local API (e.g., `localhost` or `127.0.0.1`).
3. Iposi's smart routing mechanism intercepts this and forwards the request to IposiAgent.
4. IposiAgent acts as a proxy, executes the request against your local API, and seamlessly returns the formatted response, headers, and status codes back to the web interface.

---

## Features

* **Zero Configuration:** No manual toggles required in the UI. Iposi automatically detects local URLs and routes them to the agent.
* **Invisible Footprint:** Runs entirely in the background as a hidden VCL application. No annoying console windows.
* **System Tray Integration:** Manage the agent, check its connection status, or quick-launch the Iposi web app directly from the taskbar menu.
* **Heartbeat Detection:** The agent knows when Iposi is actively open and updates its status accordingly.
* **No DLL Hell:** Uses Delphi's native `TNetHTTPClient` for outbound requests, meaning it requires zero external SSL/TLS libraries (like OpenSSL) to function.

---

## Technology

* **Delphi (VCL)**
* **Indy (TIdHTTPServer):** For handling incoming proxy requests from the browser.
* **System.Net (TNetHTTPClient):** For executing the actual API calls seamlessly.

---

## Usage

1. Download and run the `IposiAgent.exe` executable.
2. An Iposi icon will appear in your System Tray (bottom right of your screen).
3. Open [Iposi](https://hasup.net/iposi) in your web browser.
4. Send an HTTP request to any local server (e.g., `http://localhost:8080/api/users`).
5. Iposi will automatically communicate with the agent and display the results.

To close the agent, simply right-click the System Tray icon and select **Quit**.

---

## Project Status

IposiAgent is an active sidecar project to the main Iposi application. It currently handles standard HTTP methods, headers, and bodies (Raw, JSON, Form-URL-Encoded) perfectly for local environments.

---

## Contributing

Bug reports, pull requests, and feature suggestions are welcome. 

---

## Licence

This project uses MIT License.

---

Developed by Yuşa Göverdik.
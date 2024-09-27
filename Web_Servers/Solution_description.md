# **Challenge Description.**
## Hosting a React app.
#### **Goal:** Configure environment using Vagrant and Nginx to host the React app from the given repository.
---
### Solution:

#### The process to be described is meant to walk the user through the process of deploying a React application (BMI Calculator) with Nginx web server.

#### **Assumptions:** 
- It is a static application.
- Application does not require backend server.

#### **Disclaimer:**
- No vagrant file is used in this exercise (it was not possible to install Vagrant in my M2 PC). Steps consider user has linux installed.

#### **Steps to follow:**
- Open your Terminal.

- Clone GitHub repository into your local machine.

    _git clone https://github.com/falconcr/react-demo_

- Access directory of the cloned application.
    _cd react-demo_

- Install dependencies. This will generate a folder named `build` that contains all static files, ready to be served by web server such as the Nginx server.

    _nom run build_

- Start by updating the installation packages.
    _sudo apt-get update_

- Second, install nginx.    
    _sudo apt-get install nginx_

- Third, get to the Nginx configuration directory.
    _cd /etc/nginx/sites-available_

- Fourth, create a new file to store server configuration.   
    _sudo nano react-demo_

- Fith, enter the configuration data.
```
server {
    listen 80;
    server_name localhost;  # add “localhost” for the application to run in your local IP address.

    root /route/to/your/project/react-demo/build;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```
- Save the changes: Ctrl + O
- Press: Enter
- Exit Nano editor: Ctrl + X

- Create a symbolic link at sites-enabled to enable your configuration.    
_sudo ln -s /etc/nginx/sites-available/react-demo /etc/nginx/sites-enabled/_

- Restart Nginx to apply changes
_sudo systemctl restart nginx_

- Go to a browser. Type: localhost. 
You should be able to see your React app.
---

#### [Verification image.](https://github.com/FreCalvo/CloudStation/blob/main/Web_Servers/React_app.png)

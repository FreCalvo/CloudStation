Challenge Description.

Hosting a React app.

Goal: Configure environment using Vagrant and Nginx to host the React app from the given repository.


Solution

The process to be described is meant to walk the user through the process of deploying a React application (BMI Calculator) with Nginx web server.

Assumptions: 
It is a static application.
Application does not require backend server.

Disclaimer: No vagrant file is used in this exercise (it was not possible to install Vagrant in my M2 PC). Steps consider user has linux installed.



Steps to follow.

Clone GitHub repository into your local machine.

git clone https://github.com/falconcr/react-demo


Access directory of the cloned application.
command: cd react-demo

Install dependencies. This will generate a folder named <build> that contains all static files, ready to be served by web server such as the Nginx server.
nom run build

Start updating the installation packages.
sudo apt-get update

Second, install nginx.
sudo apt-get install nginx

Third, get to the Nginx configuration directory.
cd /etc/nginx/sites-available

Fourth, create a new file to store server configuration.
sudo nano react-demo

Fith, enter the configuration data.
server {
    listen 80;
    server_name localhost;  # add “localhost” for the application to run in your local IP address.

    root /route/to/your/project/react-demo/build;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}


Save the changes: Ctrl + O
Press: Enter
Exit Nano editor: Ctrl + X

Create a symbolic link at sites-enabled to enable your configuration
command: sudo ln -s /etc/nginx/sites-available/react-demo /etc/nginx/sites-enabled/

Restart Nginx to apply changes
command: sudo systemctl restart nginx

Go to a browser. Type: localhost. 
You should see your React app.


Verification.
￼

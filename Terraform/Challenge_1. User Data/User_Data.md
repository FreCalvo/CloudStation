### **Challenge - User Data**

#### **Description**
1. Create a EC2 instance with Terraform.
2. Configure the user data to install and start NGINX automatically in the EC2 instance when launched.
3. Verify NGINX server is accessible through browser, using public IP address.
<br><br>
---

<br>

#### **Solution**
<br>

#### **- Configure AWS.**
a. Ensure AWS CLI is installed in your PC. Otherwise, download it from the link  AWS website.

b. Check AWS is installed.
```
aws --version
```
c. Get your Access Key ID and Secret Access Key.

d. Configure the AWS profile.
```
aws configure
```

```
aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]:
Default output format [None]:
```
e. Verify profile is all set.

```
aws sts get-caller-identity
```
This should show the account ID and associated profile.

<br>

#### **- Create AWS Resources.**
a. Initialize Terraform located in your project folder.
```
terraform init
```
b. Visualize the execution plan.
```
terraform plan
```
c. Run the plan.
```
terraform apply
```
Type "yes" when asked either you want to perform the actions.

d. Double-check in AWS the instance was created.

Instance state is `Running`.

<br>

#### **- Access Public IP.**
a. `terraform apply` will provide a public IP address. Open it in a browser to see the NGINX welcome page.

[public_ip_address](public_ip.png)
[nginx_welcome](nginx_welcome.png)

b. Finally, destroy the AWS resources created.
```
terraform destroy
```
Type "yes" when asked either you want to destroy all resources.

c. Double-check in AWS the instance was ended.
Instance state is `Terminated`.
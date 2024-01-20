def generate_ssh_command(pem_location, instance_user, instance_id):
    ssh_command = f'ssh -i "{pem_location}" {instance_user}@{instance_id}'
    return ssh_command

# Example usage:
pem_location = input("Enter PEM file location: ")
instance_user = input("Enter EC2 instance user name: ")
instance_id = input("Enter EC2 instance ID: ")

ssh_command = generate_ssh_command(pem_location, instance_user, instance_id)
print("Generated SSH Command:", ssh_command)

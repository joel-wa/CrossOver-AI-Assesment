import subprocess

def upload_to_ec2(pem_location, instance_user, local_file_path, ec2_instance_id, destination_path):
    scp_command = f'scp -i "{pem_location}" "{local_file_path}" {instance_user}@{ec2_instance_id}:{destination_path}'
    subprocess.run(scp_command, shell=True)

# Example usage:
pem_location = r"C:\Users\RanVic\Downloads\VSM_Flask_AI.pem"
instance_user = "ec2-user"
local_file_path = r"C:\Users\RanVic\OneDrive\Documents\GitHub\CrossOver-AI-Assesment\pythonFlask\code\flaskServer.py"
ec2_instance_id = "ec2-3-145-176-115.us-east-2.compute.amazonaws.com"
destination_path = "Desktop"

upload_to_ec2(pem_location, instance_user, local_file_path, ec2_instance_id, destination_path)
print("Document uploaded successfully!")

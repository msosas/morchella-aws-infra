def verify_node(node_id, aws_region='ap-southeast-2'):
    import boto3
    import re
    
    pattern = f'morchella-nodes-{ aws_region }-.*'
    client = boto3.Session().client('s3')
    response = client.list_buckets()

    for bucket in response["Buckets"]:
        if bool(re.match(pattern, bucket["Name"])):
            print(f'Bucket found: {bucket["Name"]}')
            bucket_name = bucket["Name"]
    try:
        response = client.get_object(
            Bucket=bucket_name,
            Key=f'{node_id}.json'
        )
        print(response)
        return response
    except:
        return None


def lambda_handler(event, context):
    import boto3
    from datetime import datetime
    import json

    client = boto3.Session().client('ssm')
    iam_role='AmazonEC2RunCommandRoleForManagedInstances'
    server_definition_tags = []

    print(f'EVENT: {event}')

    node_verification_result = verify_node(event['serial_number'])
    print(type(node_verification_result))
    if node_verification_result:
        if 'serial_number' in event.keys():
            server_definition = json.loads(node_verification_result['Body'].read())
            for key, value in server_definition.items():
                value = value.replace(',', ' ')
                server_definition_tags.append(
                    {
                        'Key': key.replace("_", " ").title(),
                        'Value': '-' if len(value) == 0 else ( value[:120] if len(value) > 120 else value )
                    }
                )
            default_tags = [
                {
                    'Key': 'Activation Date',
                    'Value': str(datetime.now())
                },
                {
                    'Key': 'Provisioned',
                    'Value': 'False'
                },
                {
                    'Key': 'Name',
                    'Value': server_definition['site_id']
                },
                {
                    'Key': 'Environment',
                    'Value': 'Production'
                },
                {
                    'Key': 'Terraform',
                    'Value': 'False'
                },
                {
                    'Key': 'Stack',
                    'Value': 'Provision'
                },
                {
                    'Key': 'Application',
                    'Value': 'Morchella'
                },
                {
                    'Key': 'Squad',
                    'Value': 'Infra'
                }
            ]
            full_tags = []
            for d in default_tags + server_definition_tags:
                # Check if a dictionary with the same name already exists in the merged list
                matching_dict = next((x for x in full_tags if x['Key'] == d['Key']), None)

                if matching_dict:
                    # If a matching dictionary is found, update its values with the values from the current dictionary
                    matching_dict.update(d)
                else:
                    # If no matching dictionary is found, append the current dictionary to the merged list
                    full_tags.append(d)
            response = client.create_activation(
                IamRole=iam_role,
                Tags=full_tags
            )
            response['node_metadata'] = server_definition
    else:
        err_msg = 'ERROR: This is not a valid serial number'
        response = {
            'statusCode': 400,
            'body': err_msg
        }
    
    print(f'RESPONSE: {response}')
    return response


if __name__ == '__main__': 
    # import boto3
    # import json
    # client = boto3.Session(profile_name='francium').client('lambda')
    # response = client.invoke(FunctionName='morchella-register-node')
    # response = json.loads(response['Payload'].read().decode('utf8'))
    # print(response)

    import json
    print((verify_node('VB00001'))['Body'].read().decode('utf8'))
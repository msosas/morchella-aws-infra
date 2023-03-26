def lambda_handler(event, context):
    import boto3
    
    print(event)
    client = boto3.Session().client('ssm')
    response = client.delete_activation(
        ActivationId=event['activation_id']
    )
    print(f'RESPONSE: {response}')
    return response

if __name__ == '__main__': 
    import boto3
    import json
    response = boto3.Session(profile_name='francium').client('lambda').invoke(FunctionName='morchella-delete-activation', Payload=json.dumps({ 'activation_id': '6c1799a4-d325-4dec-ac3b-09caeb0cd4e0' }) )
    print(response['Payload'].read().decode('utf8'))
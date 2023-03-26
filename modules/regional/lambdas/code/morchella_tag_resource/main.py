def lambda_handler(event, context):
    import boto3

    session = boto3.Session()
    client = session.client('ssm')
    tags = list()

    print(event)
    if 'detail' in event.keys():               
        if 'tags' in event['detail'].keys():
            for tag in event['detail']['tags']:
                if tag['Key'] == 'Instance Id':
                    resource_id = tag['Value']
                    print(f'ResourceID: {resource_id}')

            if not resource_id: 
                print('Instance ID not found in the event')
                return {
                    'statusCode': 404
                }
            tags=event['detail']['tags']
            print(f'TAGS: {tags}')
            response = client.add_tags_to_resource(
                ResourceType='ManagedInstance',
                ResourceId=resource_id,
                Tags=tags
            )
            print(f'RESPONSE: {response}')
            return response
        else:
            print('No tags found in the event')
            return {
                'statusCode': 404
            }

# if __name__ == '__main__': 
#     import boto3
#     import json
#     client = boto3.Session(profile_name='francium').client('lambda')

#     tags = {
#         'tags': [
#             # {
#             #     'Key': 'Serial',
#             #     'Value': 'PCX00001'
#             # },
#             {
#                 'Key': 'Instance_Id',
#                 'Value': 'mi-07da1a5d11204fde5'
#             },
#             {
#                 'Key': 'Node_Status',
#                 'Value': 'Provisioned'
#             }
#         ] 
#     }

#     response = client.invoke(FunctionName='morchella-tag-resource', Payload=json.dumps(tags))
#     print(response)
#     response = json.loads(response['Payload'].read().decode('utf8'))
#     print(response)
def lambda_handler(event, context):
    import boto3
    import re
    import json

    client = boto3.Session().client('resourcegroupstaggingapi')
    print(event)
    
    search_tags = [
        {
            "Key": "Provisioned",
            "Values": ["False"]
        }
    ]
    resources = client.get_resources(
        TagFilters=search_tags
    )
    for resource in resources['ResourceTagMappingList']:
        resource_id = re.search('mi-.*', resource['ResourceARN']).group()
        print(resource_id)
        new_status_tag = { 
            'tags': [ 
                { 
                    'Key': 'Provisioned',
                    'Value': 'True'
                },
                {
                    'Key': 'Instance Id',
                    'Value': resource_id 
                }
            ]
        }
        client = boto3.Session().client('lambda')
        response = client.invoke(FunctionName='morchella-tag-resource', Payload=json.dumps(
                {
                    'detail': new_status_tag
                }
            )
        )
        print(response['Payload'].read().decode('utf8'))
        print(f'RESPONSE: {response}')
        return response


# if __name__ == '__main__': 
#     import boto3
#     import json
#     client = boto3.Session(profile_name='francium').client('lambda')
#     response = client.invoke(FunctionName='morchella-update-node-status')
#     response = json.loads(response['Payload'].read().decode('utf8'))
#     print(response)
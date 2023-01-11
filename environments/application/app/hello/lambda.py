import json
import sys


def lambda_handler(event, context):
    print('hoge')
    print('fuga')
    print('piyo')
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

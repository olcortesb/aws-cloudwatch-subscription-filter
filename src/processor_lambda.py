import json
import boto3
import gzip
import base64
import uuid
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')

def handler(event, context):
    try:
        table_name = os.environ['DYNAMODB_TABLE']
        table = dynamodb.Table(table_name)
        
        print(f"Received event: {json.dumps(event)}")
        
        # CloudWatch Logs envía los datos en event['awslogs']['data']
        compressed_payload = base64.b64decode(event['awslogs']['data'])
        uncompressed_payload = gzip.decompress(compressed_payload)
        log_data = json.loads(uncompressed_payload)
        
        print(f"Log data: {json.dumps(log_data)}")
        
        # Procesar cada evento de log
        for log_event in log_data['logEvents']:
            message = log_event['message']
            
            # Buscar mensajes que contengan ✅ ORIGINAL_POST
            if '✅ ORIGINAL_POST:' in message:
                try:
                    # Extraer el JSON del POST original
                    json_start = message.find('{')
                    if json_start != -1:
                        original_post = json.loads(message[json_start:])
                        
                        # Guardar en DynamoDB
                        item = {
                            'id': str(uuid.uuid4()),
                            'original_post': original_post,
                            'timestamp': datetime.utcnow().isoformat(),
                            'log_timestamp': log_event['timestamp'],
                            'processed_at': datetime.utcnow().isoformat()
                        }
                        
                        table.put_item(Item=item)
                        print(f"Saved to DynamoDB: {item['id']}")
                        
                except json.JSONDecodeError as e:
                    print(f"Error parsing JSON from log: {str(e)}")
                except Exception as e:
                    print(f"Error saving to DynamoDB: {str(e)}")
        
        return {
            'statusCode': 200,
            'body': json.dumps('Successfully processed CloudWatch logs')
        }
        
    except Exception as e:
        print(f"Error processing CloudWatch logs: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
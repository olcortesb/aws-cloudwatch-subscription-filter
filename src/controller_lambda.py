import json
from datetime import datetime

def handler(event, context):
    try:
        # Parse del body del POST
        body = json.loads(event['body'])
        
        # Log del POST original para que sea capturado por el subscription filter
        if body.get('enable', False):
            print(f"✅ ORIGINAL_POST: {json.dumps(body)}")
            response_message = "POST logged successfully - subscription filter will process it"
        else:
            print(f"❌ POST received but enable=false: {json.dumps(body)}")
            response_message = "POST received but enable=false, not processed"
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': response_message,
                'received_data': body,
                'timestamp': datetime.utcnow().isoformat()
            })
        }
        
    except Exception as e:
        print(f"Error processing request: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': str(e),
                'timestamp': datetime.utcnow().isoformat()
            })
        }
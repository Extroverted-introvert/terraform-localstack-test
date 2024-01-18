import json


def handler(event, context):
    # Parse the JSON payload from the API Gateway
    payload = json.loads(event["body"])

    # Extract numbers from the payload
    number1 = payload.get("number1", 0)
    number2 = payload.get("number2", 0)

    # Compute the sum
    result = (number1 + number2) / 2

    # Prepare the response for API Gateway
    response = {"statusCode": 200, "body": json.dumps({"result": result})}

    return response

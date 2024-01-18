import json
import logging, sys

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)
# try:
#     logging.error(sys.path)
# except:
#     pass

# import numpy as np


def handler(event, context):
    # Parse the JSON payload from the API Gateway
    payload = json.loads(event["body"])

    # Extract numbers from the payload
    number1 = payload.get("number1", 0)
    number2 = payload.get("number2", 0)
    print(number1)
    # Compute the sum
    result = number1 + number2
    # Prepare the response for API Gateway
    response = {"statusCode": 200, "body": json.dumps({"result": result})}

    return response

import boto3
import logging
import base64

# Initialize the logger
logger = logging.getLogger()
logger.setLevel("INFO")

client = boto3.client('rekognition')

def base64_to_blob(base64_string):
    decode_bytes = base64.b64decode(base64_string)
    b = bytes(decode_bytes)
    return b 


def lambda_handler(event, context):
    """
    Main Lambda handler function
    Parameters:
        event: Dict containing the Lambda function event data
        context: Lambda runtime context
    Returns:
        Compare faces' response
    """
    try:
        base64_face1 = event['face1']
        base64_face2 = event['face2']
        if(base64_face1 is None or base64_face2 is None):
            return "Error: Imagen sin datos"
        blob_face1 = base64_to_blob(base64_face1)
        blob_face2 = base64_to_blob(base64_face2)
        response = client.compare_faces(
            SimilarityThreshold=90,
            SourceImage={
                "Bytes": blob_face1
            },
            TargetImage={
                "Bytes": blob_face2
            }
        )

        '''
        response = client.compare_faces(
            SimilarityThreshold=90,
            SourceImage={
                'S3Object': {
                    'Bucket': 'test-img-faces-01',
                    'Name': 'IMG_Cel01.jpg'
                }
            },
            TargetImage={
                'S3Object': {
                    'Bucket': 'test-img-faces-01',
                    'Name': 'IMG_Cred01.jpg'
                }
            }
        )
        '''
        return response

    except Exception as e:
        logger.error(f"Error processing order: {str(e)}")
        raise
 

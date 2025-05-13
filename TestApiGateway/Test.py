import boto3
import base64
import time
import json

class BotoClient:
    def __init__(self):
        self.client_ag = boto3.client("apigateway")
        self.api_resource_ids = self.get_resource_ids("api_gw_lambda_func")
        print(self.api_resource_ids)

    def get_api_resource_ids(self, api_gateway_id: str) -> dict:
        resource_ids = {}
        for resource in self.client_ag.get_resources(restApiId=api_gateway_id)["items"]:
            try:
                resource_ids[resource["pathPart"]] = resource["id"]
            except KeyError:
                print(KeyError)
                pass # Ignore resources with no pathPart
            return resource_ids

    def get_resource_ids(self, api_gateway_name: str) -> dict:
        api_gateways = self.client_ag.get_rest_apis()["items"]
        for api_gateway in api_gateways:
            if api_gateway["name"] == api_gateway_name:
                resource = self.get_api_resource_ids(api_gateway["id"])
                resource[api_gateway_name] = api_gateway["id"]
                return resource
        raise ValueError(f"{api_gateway_name} not found.")

    def send(self, http_method: str, payload: dict, api_gw_id: str, api_gw_resource_id: str):
        try:
            response = self.client_ag.test_invoke_method(
                restApiId = self.api_resource_ids[api_gw_id],
                resourceId = self.api_resource_ids[api_gw_resource_id],
                httpMethod=http_method,
                headers={"Content-Type": "application/json"},
                body=json.dumps(payload)
            )
            print(response)
        except Exception as e:
            print(e)

def send_request():
    api_gw_id = "api_gw_lambda_func"
    api_gw_resource_id = "face_compare"
    f = open('data.json') 
    payload = json.load(f) 
    client = BotoClient()
    #print(payload)
    client.send("POST", payload, api_gw_id, api_gw_resource_id)

send_request()

def get_base64_img(pathFile):
    with open(pathFile, "rb") as image_file:
        data = base64.b64encode(image_file.read())
    return data

#face1 = get_base64_img("IMG/1.jpg")
#face2 = get_base64_img("IMG/2.jpg")

#print(get_base64_img("IMG/2.jpg"))

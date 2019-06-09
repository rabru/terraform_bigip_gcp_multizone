{
  "class": "AS3",
  "action": "deploy",
  "persist": true,
  "declaration": {
    "class": "ADC",
    "schemaVersion": "3.5.0",
    "id": "LocationResponse:ddkvur342j",
    "label": "LocationResponse",
    "remark": "Simple HTTP application with iRule to respond with location",
    "LocationResponse": {
      "class": "Tenant",
      "ApplicationA": {
        "class": "Application",
        "template": "http",
        "serviceMain": {
          "class": "Service_HTTP",
          "iRules": ["LocationRespond"],
          "virtualAddresses": [
            "${vip}"
          ]
        },
        "LocationRespond": {
          "class": "iRule",
          "iRule": "when HTTP_REQUEST {\n   HTTP::respond 200 content {\n       <html>\n         <head>\n            <title>My location</title>\n         </head>\n         <body>\n            I am located at ${zone}<br>\n         </body>\n      </html>\n   }\n}"
        }
      }
    }
  }
}


{
    "schemaVersion": "1.0.0",
    "class": "Device",
    "label": "Basic onboarding",
    "Common": {
        "class": "Tenant",
        "hostname": "${local_host}",
        "myLicense": {
          "class": "License",
          "licenseType": "regKey",
          "regKey": "${local_sku}"
        },
        "dbvars": {
            "class": "DbVariables",
            "ui.advisory.enabled": true,
            "ui.advisory.color": "green",
            "ui.advisory.text": "/Common/hostname"
        },
        "myDns": {
            "class": "DNS",
            "nameServers": ${dns_server},
            "search": ${dns_search}
        },
        "myNtp": {
            "class": "NTP",
            "servers": ${ntp_server},
            "timezone": "${timezone}"
        },
        "myProvisioning": {
            "class": "Provision",
            "ltm": "nominal"
	}
    }
}

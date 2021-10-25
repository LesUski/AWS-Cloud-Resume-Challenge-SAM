SHELL:=/bin/bash

.PHONY: build
.SILENT: integration-test

build:
	sam build

deploy-infra:
	sam build && aws-vault exec sam-user --no-session -- sam deploy

deploy-site:
	aws-vault exec sam-user --no-session -- aws s3 sync ./website s3://myprofile.cloudofthings.net

invoke-put:
	sam build && aws-vault exec sam-user --no-session -- sam local invoke PutCountFunction

integration-test:
	FIRST=$$(curl -s "https://8zqfnxf6tf.execute-api.eu-north-1.amazonaws.com/Prod/get" | jq ".body| tonumber"); \
	curl -s "https://8zqfnxf6tf.execute-api.eu-north-1.amazonaws.com/Prod/put"; \
	SECOND=$$(curl -s "https://8zqfnxf6tf.execute-api.eu-north-1.amazonaws.com/Prod/get" | jq ".body| tonumber"); \
	echo "Comparing if first count ($$FIRST) is less than (<) second count ($$SECOND)"; \
	if [[ $$FIRST -le $$SECOND ]]; then echo "PASS"; else echo "FAIL";  fi

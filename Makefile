.PHONY: build

build:
	sam build

deploy-infra:
	sam build && aws-vault exec sam-user --no-session -- sam deploy

deploy-site:
	aws-vault exec sam-user --no-session -- aws s3 sync ./website s3://myprofile.cloudofthings.net

invoke-put:
	sam build && aws-vault exec sam-user --no-session -- sam local invoke PutCountFunction

integration-test:
	DOMAIN_NAME=$$(cat config.json | jq .DOMAIN_NAME -r); \
	FIRST=$$(curl -s "https://api.$$DOMAIN_NAME/get" | jq ".count| tonumber"); \
	curl -s "https://api.$$DOMAIN_NAME/put"; \
	SECOND=$$(curl -s "https://api.$$DOMAIN_NAME/get" | jq ".count| tonumber"); \
	echo "Comparing if first count ($$FIRST) is less than (<) second count ($$SECOND)"; \
	if [[ $$FIRST -le $$SECOND ]]; then echo "PASS"; else echo "FAIL";  fi

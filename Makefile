.PHONY: build

build:
	sam build

deploy-infra:
	sam build && aws-vault exec sam-user --no-session -- sam deploy

deploy-site:
	aws-vault exec sam-user --no-session -- aws s3 sync ./website s3://myprofile.cloudofthings.net

invoke-put:
	sam build && aws-vault exec sam-user --no-session -- sam local invoke PutCountFunction
[![ci](https://github.com/Balou9/cfn-check-failed-status/workflows/ci/badge.svg)](https://github.com/Balou9/cfn-check-failed-status/actions)

# cfn-check-failed-status

## wip

A Github action that checks the status of a aws cloudformation stack and deletes the stack if the previous deployment resolved in a failed status. It resolves the pain to manually delete the stack during the development process.

---
#### inputs

###### `stack-name`

**Required** The name of the stack to be status checked

#### outputs

###### `message`

`<stack-name> is in a nonfailed status. Stack will not be deleted.`  
status message non-failed stack status

`<stack-name>  is in CREATE_FAILED status. About to be deleted.`   
status message failed stack status

---

## usage

```yml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:  
    # - name: ...
    - name: check status of cloudformation stack prior to deployment
      id: checkstatus
      uses: ./
      with:
        stack-name: stackstack
```

#### example usage in deployment pipeline

```yml
name: cd

on: push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: clone the repo
        uses: actions/checkout@v2.5.0

      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v1.5.3
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      - name: validates cloudformation template
        run: |
          aws cloudformation validate-template \
            --template-body="./stack.yml"

      - name: check status of cloudformation stack prior to deployment
        id: checkstatus
        uses: ./
        with:
          stack-name: ${{ env.STACK_NAME }}

      - name: Get the stack status
        run: |
          echo "${{ steps.checkstatus.outputs.message }}"

      - name: configure the environment
        run: |
          echo "STACK_NAME=test-stack231" >> $GITHUB_ENV
#          echo ...

      - name: deploy cloudformation stack
        run: |
          aws cloudformation deploy \
            --template-file=./stack.yml \
            --stack-name=${{ env.STACK_NAME }} \
            --parameter-overrides \
          ...
```

## feat: cfn stack deletion on failed status

The following cloudformation stack status will resolve in stack deletion:

- CREATE_FAILED
- ROLLBACK_FAILED
- UPDATE_FAILED
- UPDATE_ROLLBACK_FAILED
- DELETE_FAILED

see: https://medium.com/nerd-for-tech/cloudformation-status-transition-ea402050c7aa

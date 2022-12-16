#!/bin/bash
STACK_NAME="$1"

stack_status_list=$(aws cloudformation describe-stack-events \
  --stack-name="$STACK_NAME" \
  | jq ".StackEvents[].ResourceStatus")

echo "RECENT STACK EVENTS:"

while IFS= read -r line; do
  if [[ "$line" == "CREATE_FAILED" ]] || [[ "$line" == "ROLLBACK_FAILED" ]] || [[ "$line" == "UPDATE_FAILED" ]] || [[ "$line" == "UPDATE_ROLLBACK_FAILED" ]] || [[ "$line" == "DELETE_FAILED" ]]
  then
    stack_status="$line"
    echo "### $line ###"
  else
    echo "$line"
  fi
done <<< "$stack_status_list"

if [[ -z "$stack_status" ]]
then
  output_msg="stack name...... $STACK_NAME"
  echo "$output_msg"
  echo "::set-output name=message::$output_msg"
else
  output_msg="$STACK_NAME" " is in "$stack_status" status. About to be deleted."
  echo "$output_msg"
  echo "::set-output name=message::$output_msg"
  aws cloudformation delete-stack --stack-name=$STACK_NAME
fi

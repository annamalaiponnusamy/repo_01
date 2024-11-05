day_of_week=`date +%A`

echo "Checking configuration for $day_of_week"
jq '.' variable.json > /dev/null
shell_enabled=`jq .Enabled variable.json`
shell_aws_role_arn=`jq .Inputs.AwsRoleArn variable.json | sed 's/"//g'`
shell_log_level=`jq .Inputs.LogLevel variable.json | sed 's/"//g'`
shell_up=`jq .Schedule.$day_of_week.Up variable.json | sed 's/"//g'`
shell_down=`jq .Schedule.$day_of_week.Down variable.json | sed 's/"//g'`
shell_configuration=`jq .Configuration variable.json | tr -d '[:space:]'`

unix_up=`date --date="$shell_up" +%s`
unix_down=`date --date="$shell_down" +%s`
time_now=`date +%s`

reverse=0

if [ $unix_down -lt $unix_up ]
then
	reverse=1
fi

if [ $reverse -eq 0 ]
then
	if [ $unix_up -lt $time_now -a $time_now -lt $unix_down ]
	then
		shell_direction="Up"
	else
		shell_direction="Down"
	fi
else
	if [ $unix_up -gt $time_now -a $time_now -gt $unix_down ]
	then
		shell_direction="Down"
	else
		shell_direction="Up"
	fi
fi

echo "Repository variable parsed correctly. Values from repository config"
printf "\tEnabled: $shell_enabled\n"
printf "\tAwsRoleArn: $shell_aws_role_arn\n"
printf "\tLogLevel: $shell_log_level\n"
printf "\tUp: $shell_up\n"
printf "\tDown: $shell_down\n"
printf "\tNow: `date '+%H:%M'`\n"
printf "\tDirection: $shell_direction\n"
printf "\tConfiguration: $shell_configuration\n"

echo "enabled=$shell_enabled" >> $GITHUB_OUTPUT
echo "awsRoleArn=$shell_aws_role_arn" >> $GITHUB_OUTPUT
echo "direction=$shell_direction" >> $GITHUB_OUTPUT
echo "logLevel=$shell_log_level" >> $GITHUB_OUTPUT
printf "configuration=$shell_configuration" >> $GITHUB_OUTPUT

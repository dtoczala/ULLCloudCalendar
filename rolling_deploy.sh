#############
# Colors    #
#############
green='\e[0;32m'
red='\e[0;31m'
label_color='\e[0;33m'
no_color='\e[0m'

#
# First we need to create a unique app name and route for our new deployment
#

# Used to create a public route within the space for accessing the deployed 
# application. The reserved CF_SPACE variable (configured in the deployer) is 
# used to unique the route name per space.
if [ "${CF_SPACE}" == "prod" ]; then
   PUBLIC_HOST=${CF_APP}
else
   PUBLIC_HOST="${CF_SPACE}-${CF_APP}"
fi

# Extract the selected build number from the reserved BUILD_SELECTOR variable.
SELECTED_BUILD=$(grep -Eo '[0-9]{1,100}' <<< "${BUILD_SELECTOR}")

# Compute a unique app name using the reserved CF_APP name (configured in the 
# deployer or from the manifest.yml file), the build number, and a 
# timestamp (allowing multiple deploys for the same build).
NEW_APP_NAME="${CF_APP}-$SELECTED_BUILD-$(date +%s)"

# Domain can be customized if needed.
DOMAIN=stage1.mybluemix.net
# Memory should match what you have in the manifest
MEMORY=256m
# Used to define a temporary route to test the newly deployed app
TEST_HOST=$NEW_APP_NAME

#
# Now we need to find all of the deployed apps in this space
#
# Remove the old temp file
rm -f apps.txt

# Log what you are doing
echo -e "${label_color}Find all existing deployments:${no_color}"

# Get a list of all of the deployed applications in this space
cf apps | { grep $PUBLIC_HOST || true; } | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" 
   &> apps.txt
cat apps.txt

# Store just the deployed application names
awk '{ print $1 }' apps.txt > app_names.txt
rm -f apps.txt

#
# Now we are going to deploy the application.
# To do this correctly, we'll need to deploy it without disturbing the existing
# application. 
#

# Log what you are doing
echo -e "${label_color}Pushing new deployment - ${green}$NEW_APP_NAME${no_color}"
cf push $NEW_APP_NAME -d $DOMAIN -n $TEST_HOST -m $MEMORY
DEPLOY_RESULT=$?

# Check the deployment result - see if it deployed OK
if [ $DEPLOY_RESULT -ne 0 ]; then
   echo -e "${red}Deployment of $NEW_APP_NAME failed!!"
   cf logs $NEW_APP_NAME --recent
   return $DEPLOY_RESULT
fi

echo -e "${label_color}APPS:${no_color}"
cf apps | grep ${CF_APP}

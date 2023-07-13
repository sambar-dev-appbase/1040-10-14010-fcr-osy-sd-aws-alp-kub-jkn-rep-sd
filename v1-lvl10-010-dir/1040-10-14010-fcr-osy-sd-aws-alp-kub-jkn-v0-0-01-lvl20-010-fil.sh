#!/bin/bash
year=`date +%Y`
month=`date +%m`
day=`date +%d`
tag='kube'
image_version=${year}.${month}.${day}-${BUILD_NUMBER}
echo "===================== Initiating build process via script ==============="
ecr_docker_image=635602896676.dkr.ecr.eu-west-2.amazonaws.com/1040-10-14010-fcr-osy-sd-aws-alp-kub-bas-img-rep-sd
container_name=1040-10-14010-fcr-osy-sd-aws-alp-kub-bas-img-rep-sd
aws_region=eu-west-2

pwd 
rm -rf .git
chmod 0777 -R *
############################
if sudo docker images | grep $container_name;
then
  sudo docker rmi $container_name;
fi
if sudo docker images | grep $ecr_docker_image;
then
  sudo docker rmi $ecr_docker_image;
fi
echo "################LOGIN TO DOCKER REGISTRY######################"
bash -c "aws ecr get-login --region eu-west-2  " > 1.sh
cat 1.sh
sudo bash 1.sh
rm -f 1.sh
################################
echo "################################# CREATE DOCKER BUILD #######################"
sudo docker build -t $container_name .
sudo docker tag $container_name $ecr_docker_image:$image_version
sudo docker tag  $ecr_docker_image:$image_version $ecr_docker_image:latest
################################
##bash -c "sudo aws ecr get-login --region $aws_region | source /dev/stdin"
sudo docker push $ecr_docker_image:$image_version
sudo docker push $ecr_docker_image:latest
###############################
echo "Cleaning up images from Jenkins server..."
sudo docker rmi $container_name;
sudo docker rmi $ecr_docker_image:$image_version
sudo docker rmi $ecr_docker_image:latest

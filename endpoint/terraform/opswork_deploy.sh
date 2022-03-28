
script "install_something" do
  interpreter "aws-cli"
  user "root"
  cwd "/tmp"
  code <<-EOH
    aws elasticbeanstalk create-application-version --application-name kibana --version-label 8.1.1 --source-bundle S3Bucket=my_app_ebs,S3Key=$ZIP
    aws elasticbeanstalk update-environment --environment-name dev --version-label 8.1.1
  EOH
end

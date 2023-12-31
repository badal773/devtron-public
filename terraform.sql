INSERT INTO plugin_metadata (id,name,description,type,icon,deleted,created_on,created_by,updated_on,updated_by)
VALUES (nextval('id_seq_plugin_metadata'),'Terraform Cli','The Terraform CLI, is integrated with Devtron, empowers users to effortlessly execute Terraform scripts, streamlining and enhancing the efficiency of infrastructure provisioning and management.','PRESET','https://raw.githubusercontent.com/badal773/devtron-public/main/file-type-terraform.svg',false,'now()',1,'now()',1);


INSERT INTO "plugin_pipeline_script" ("id", "script","type","deleted","created_on", "created_by", "updated_on", "updated_by")
VALUES (nextval('id_seq_plugin_pipeline_script'),E'
machine_type=$(uname -m)
if [ $machine_type == "x86_64" ]; then
    echo "Downloading binary for terraform"
    curl -LO https://releases.hashicorp.com/terraform/1.6.4/terraform_1.6.4_linux_amd64.zip
    unzip terraform_1.6.4_linux_amd64.zip
else
    echo "Downloading binary for terraform"
    curl -LO https://releases.hashicorp.com/terraform/1.6.4/terraform_1.6.4_linux_arm64.zip
    unzip terraform_1.6.4_linux_arm64.zip
fi
mv terraform /usr/bin/terraform

# RUNNING Terraform init 
if [ $RUN_TERRAFORM_INIT == "true" ]; then 
    echo "terraform -chdir=$PWD/$WORKINGDIR init"
    terraform -chdir=$PWD/$WORKINGDIR init 
    terraform -chdir=$PWD/$WORKINGDIR validate
fi
echo "======================================"
# exporting all the env variables 
echo "$ADDITIONALPARAMS" > devtron-custom-values.tfvars
export ARGS="${ARGS} -var-file devtron-custom-values.tfvars"

# RUNNING Terraform command 
echo "terraform -chdir=$PWD/$WORKINGDIR $ARGS"
terraform -chdir=$PWD/$WORKINGDIR $ARGS','SHELL','f','now()',1,'now()',1);

INSERT INTO "plugin_step" ("id", "plugin_id","name","description","index","step_type","script_id","deleted", "created_on", "created_by", "updated_on", "updated_by")
VALUES (nextval('id_seq_plugin_step'), (SELECT id FROM plugin_metadata WHERE name='Terraform Cli'),'Step 1','Step 1 - Terraform Cli','1','INLINE',(SELECT last_value FROM id_seq_plugin_pipeline_script),'f','now()', 1, 'now()', 1);

INSERT INTO plugin_step_variable (id,plugin_step_id,name,format,description,is_exposed,allow_empty_value,default_value,value,variable_type,value_type,previous_step_index,variable_step_index,variable_step_index_in_plugin,reference_variable_name,deleted,created_on,created_by,updated_on,updated_by) 
VALUES
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'HTTP_PROXY','STRING','HTTP proxy server for non-SSL requests','t','t',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1),
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'HTTPS_PROXY','STRING','HTTPS proxy server for SSL requests','t','t',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1),
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'NO_PROXY','STRING','no proxy - opt out of proxying HTTP/HTTPS requests','t','t',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1),
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'WORKINGDIR','STRING','Source directory','t','t',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1),
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'ARGS','STRING','The terraform cli commands to tun','t','t','--help',null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1),
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'RUN_TERRAFORM_INIT','BOOL','Terraform initialization command','t','t','true',null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1),
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'ADDITIONALPARAMS','STRING','Provide key value pairs that will be inject in terraform container','t','t',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1);




INSERT INTO plugin_stage_mapping (id,plugin_id,stage_type,created_on,created_by,updated_on,updated_by)
VALUES (nextval('id_seq_plugin_stage_mapping'),(SELECT id from plugin_metadata where name='Terraform Cli'), 0,'now()',1,'now()',1);

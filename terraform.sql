INSERT INTO plugin_metadata (id,name,description,type,icon,deleted,created_on,created_by,updated_on,updated_by)
VALUES (nextval('id_seq_plugin_metadata'),'Terraform Cli','The Terraform CLI, is integrated with Devtron, empowers users to effortlessly execute Terraform scripts, streamlining and enhancing the efficiency of infrastructure provisioning and management.','PRESET','null',false,'now()',1,'now()',1);

INSERT INTO plugin_step_variable (id,plugin_step_id,name,format,description,is_exposed,allow_empty_value,default_value,value,variable_type,value_type,previous_step_index,variable_step_index,variable_step_index_in_plugin,reference_variable_name,deleted,created_on,created_by,updated_on,updated_by) 
VALUES
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'ProvideImage','STRING','If you want to provide an image','t','t',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1),
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'SelectedOperation','STRING','Please choose the operation (validate, plan, apply, or destroy)','t','f',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1),
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'TfVarsPath','STRING','Please enter the path of the tf.vars (optional)','t','t',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1),
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'ExtraArgs','STRING','Specify additional arguments to include during Terraform apply or plan','t','t',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1);
(nextval('id_seq_plugin_step_variable'),(SELECT ps.id FROM plugin_metadata p inner JOIN plugin_step ps on ps.plugin_id=p.id WHERE p.name='Terraform Cli' and ps."index"=1 and ps.deleted=false),'TerraformOutput','STRING','To store the output of Terraform apply or plan command','t','t',null,null,'INPUT','NEW',null,1,null,null,'f','now()',1,'now()',1);


INSERT INTO "plugin_pipeline_script" ("id", "script","type","deleted","created_on", "created_by", "updated_on", "updated_by")
VALUES (nextval('id_seq_plugin_pipeline_script'),E'#!/bin/bash
DEFAULT_TF_IMAGE=docker.io/hashicorp/terraform:latest
if [-z  $ProvideImage ]; then 
    echo "Using $ProvideImage this image further"
    DEFAULT_TF_IMAGE=$ProvideImage
else 
    echo "Using the default Image --> $DEFAULT_TF_IMAGE"
fi
echo "Starting this operation $SelectedOperation"
#exporting all the env variables 
env > terraform_env_variables.env 
#RUNNING Terraform init 
docker run -it  -v $PWD:$PWD -w $PWD/ $DEFAULT_TF_IMAGE init

if [$SelectedOperation == "validate" ] ; then
#RUNNING Terraform validate
    docker run -it  -v $PWD:$PWD -w $PWD/ --env-file terraform_env_variables.env $DEFAULT_TF_IMAGE validate 

elif [$SelectedOperation == "plan" ] ; then
    docker run -it  -v $PWD:$PWD -w $PWD/ --env-file terraform_env_variables.env $DEFAULT_TF_IMAGE plan $ExtraArgs
elif [$SelectedOperation == "apply" ] ; then
    docker run -it  -v $PWD:$PWD -w $PWD/ --env-file terraform_env_variables.env $DEFAULT_TF_IMAGE apply -auto-approve  $ExtraArgs
elif [$SelectedOperation == "destroy" ] ; then
    docker run -it  -v $PWD:$PWD -w $PWD/ --env-file terraform_env_variables.env $DEFAULT_TF_IMAGE destroy -auto-approve $ExtraArgs
fi','SHELL','f','now()',1,'now()',1);

INSERT INTO "plugin_step" ("id", "plugin_id","name","description","index","step_type","script_id","deleted", "created_on", "created_by", "updated_on", "updated_by")
VALUES (nextval('id_seq_plugin_step'), (SELECT id FROM plugin_metadata WHERE name='Terraform Cli'),'Step 1','Step 1 - Terraform Cli','1','INLINE',(SELECT last_value FROM id_seq_plugin_pipeline_script),'f','now()', 1, 'now()', 1);


INSERT INTO plugin_stage_mapping (id,plugin_id,stage_type,created_on,created_by,updated_on,updated_by)
VALUES (nextval('id_seq_plugin_stage_mapping'),(SELECT id from plugin_metadata where name='Terraform Cli'), 0,'now()',1,'now()',1);

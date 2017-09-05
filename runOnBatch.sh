#!/bin/sh

#
# parameters to this come from the JobRunner implementation
# for the AWS install
#
# current arg is just job #
#
TEST_ROOT=$PWD
TASKLIB=$TEST_ROOT/src
INPUT_FILE_DIRECTORIES=$TEST_ROOT/data
JOB_DEFINITION_NAME="MutSigCV_1_2"
JOB_ID=gp_job_mutsigcv_1_2_$1
JOB_QUEUE=TedHighMemory
S3_ROOT=s3://moduleiotest
WORKING_DIR=$TEST_ROOT/job_32345
STDERR_FILENAME=stderr.mutsigcv.txt
STDOUT_FILENAME=stdout.mutsigcv.txt
GP_METADATA_DIR=$WORKING_DIR/meta
EXITCODE_FILENAME=$GP_METADATA_DIR/exitcode.txt

COMMAND_LINE="$TASKLIB/gp_MutSigCV $INPUT_FILE_DIRECTORIES/mutation_table.txt $INPUT_FILE_DIRECTORIES/LUSCedit.txt $INPUT_FILE_DIRECTORIES/gene.covariates.txt LUSCedit.txt"

#
# Copy the input files to S3 using the same path
#
aws s3 sync $INPUT_FILE_DIRECTORIES $S3_ROOT$INPUT_FILE_DIRECTORIES --profile genepattern
aws s3 sync $TASKLIB $S3_ROOT$TASKLIB --profile genepattern

#       --container-overrides memory=2000 \


mkdir -p $WORKING_DIR
mkdir -p $GP_METADATA_DIR
EXEC_SHELL=$GP_METADATA_DIR/exec.sh

echo "#!/bin/bash\n" > $EXEC_SHELL
echo $COMMAND_LINE >>$EXEC_SHELL
echo "\n " >>$EXEC_SHELL

chmod a+x $EXEC_SHELL
aws s3 sync $GP_METADATA_DIR $S3_ROOT$GP_METADATA_DIR --profile genepattern

REMOTE_COMMAND="runS3OnBatch.sh  $TASKLIB $INPUT_FILE_DIRECTORIES $S3_ROOT $WORKING_DIR $EXEC_SHELL"

aws batch submit-job \
      --job-name $JOB_ID \
      --job-queue $JOB_QUEUE \
      --container-overrides "memory=7900,environment=[{name=GP_METADATA_DIR,value=$GP_METADATA_DIR},{name=STDOUT_FILENAME,value=$STDOUT_FILENAME},{name=STDERR_FILENAME,value=$STDERR_FILENAME},{name=EXITCODE_FILENAME,value=$EXITCODE_FILENAME}]" \
      --job-definition $JOB_DEFINITION_NAME \
      --parameters taskLib=$TASKLIB,inputFileDirectory=$INPUT_FILE_DIRECTORIES,s3_root=$S3_ROOT,working_dir=$WORKING_DIR,exe1="$REMOTE_COMMAND"  \
      --profile genepattern

# may want to pipe the submit output through this to extract the job ID for checking status
# | python -c "import sys, json; print json.load(sys.stdin)['jobId']"




# wait for job completion TBD
#
#check status 
# aws batch describe-jobs --jobs 07f93b66-f6c0-47e5-8481-4a04722b7c91 --profile genepattern
#

#
# Copy the output of the job back to our local working dir from S3
#
#aws s3 sync $S3_ROOT$WORKING_DIR $WORKING_DIR --profile genepattern


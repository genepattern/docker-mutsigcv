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
S3_ROOT=s3://moduleiotest
WORKING_DIR=$TEST_ROOT/job_21111


COMMAND_LINE="$TASKLIB/gp_MutSigCV $INPUT_FILE_DIRECTORIES/mutation_table.txt $INPUT_FILE_DIRECTORIES/LUSCedit.txt $INPUT_FILE_DIRECTORIES/gene.covariates.txt LUSCedit.txt"


mkdir -p $WORKING_DIR
mkdir -p $WORKING_DIR/.gp_metadata
EXEC_SHELL=$WORKING_DIR/.gp_metadata/local_exec.sh

echo "#!/bin/bash\n" > $EXEC_SHELL
echo $COMMAND_LINE >>$EXEC_SHELL
echo "\n " >>$EXEC_SHELL

chmod a+x $EXEC_SHELL


REMOTE_COMMAND="runMatlab.sh $EXEC_SHELL"

echo REMOTE_COMMAND IS --$REMOTE_COMMAND --
echo DOCKER CALL IS --docker run -v $TASKLIB:$TASKLIB -v $INPUT_FILE_DIRECTORIES:$INPUT_FILE_DIRECTORIES -v $WORKING_DIR:$WORKING_DIR -w $WORKING_DIR genepattern/docker-mutsigcv $REMOTE_COMMAND--

docker run -v $TASKLIB:$TASKLIB -v $INPUT_FILE_DIRECTORIES:$INPUT_FILE_DIRECTORIES -v $WORKING_DIR:$WORKING_DIR -w $WORKING_DIR genepattern/docker-mutsigcv $REMOTE_COMMAND





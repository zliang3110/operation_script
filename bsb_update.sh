#! /bin/sh
#set -x
echo =============================部署增量包======================================
cd $HOME/diff/bsb
#svn up

cd $HOME/diff
exit_code=$?
if [ $exit_code -ne 0 ];then
 exit $exit_code
fi

ant bsb deploy 

echo =============================应用预编译=================================
cd $HOME/apps/bsb
rm -rf target_old
echo "=======================编译BSB==========================="
ant bsb clean build  -Dtarget=target_new
exit_code=$?
if [ $exit_code -ne 0 ];then
cd $HOME/apps/bsb
#rm -rf /home/ltts/apps/bsb/modules/*
#cd $HOME/apps/bsb/modules
#svn up
echo "==============编译BSB失败，modules代码已回滚=============="
 exit $exit_code
fi

#echo ==========================备份增量包===============================
#echo "备份增量包"
#cp /home/ltts/diff/bsb/*  /home/ltts/diff_bak/
#cd $HOME/diff/bsb
#svn rm *
#svn ci -m "commit 删除增量包"
       
#cd $HOME/diff
#exit_code=$?
#if [ $exit_code -ne 0 ];then
# exit $exit_code
#fi

#删除文件
#rm -rf  ~/diff/bsb/*
#exit_code=$?
#if [ $exit_code -ne 0 ];then
# exit $exit_code
#fi

echo ================================停止服务================================
appctl DEV_A00 stop
appctl DAY_A00 stop
appctl ops stop

echo ================================切换target================================
cd $HOME/apps/bsb
if [  -d  $HOME/apps/bsb/target_new ] ; then
  mv target  target_old
  mv target_new target
else
  echo 'no exit target_new '
fi 

echo ================================启动服务================================
appctl DEV_A00 start
exit_code=$?
if [ $exit_code -ne 0 ];then
 exit $exit_code
fi

appctl DAY_A00 start
exit_code=$?
if [ $exit_code -ne 0 ];then
 exit $exit_code
fi

appctl ops start
exit_code=$?
if [ $exit_code -ne 0 ];then
 exit $exit_code
fi

#echo ====================== `hostname` 提交SVN 开始 ======================
#cd $HOME/apps/bsb/modules
#exit_code=$?
#if [ $exit_code -ne 0 ];then
# exit $exit_code
#fi

#增加文件
#svn add ./ --force
#exit_code=$?
#if [ $exit_code -ne 0 ];then
# exit $exit_code
#fi

#从svn删除本地已删除的文件
#svn st | awk '{if ($1 == "!") {print $2}}' | xargs svn rm 
#svn ci -m "commit 升级应用"

#echo "提交备份增量包"
#cd $HOME/diff_bak
#svn add . --force
#svn ci -m "commit 备份增量"

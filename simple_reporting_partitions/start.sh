### 
### Does init only once
###
FLAG="/tmp/firstboot.done"
if [[ ! -f $FLAG ]]; then
    bash ./init.sh
    touch "$FLAG"
else
   echo "Init was done on previous runs. Skipping."
fi

###
### Cleans stuff if need be
###
rm -f tmp/pids/server.pid

###
### Runs Simple
###
bundle exec rails s -p 3000 -b '0.0.0.0'


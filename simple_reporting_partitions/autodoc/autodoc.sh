##
## downloads the dependencies
##
time mvn clean dependency:copy-dependencies

##
## Generates the documentation
##
time java -cp "./target/dependency/*" org.schemaspy.Main -t pgsql11 \
  -db simple-server_test \
  -schemas "public" \
  -u postgres \
  -p password \
  -host localhost \
  -norows \
  -rails \
  -o ./target/htmldoc 

##
## Makes a zip so sharing is easier
##
cd ./target/htmldoc/public && time zip -9 -r ../../db_documentation.zip * && cd -

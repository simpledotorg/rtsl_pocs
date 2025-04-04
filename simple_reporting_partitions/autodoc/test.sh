mvn clean dependency:copy-dependencies

java -cp "./target/dependency/*" org.schemaspy.Main -t pgsql11 \
  -db simple-server_test \
  -s public \
  -u postgres \
  -p password \
  -host localhost \
  -norows \
  -rails \
  -o ./target/htmldoc 

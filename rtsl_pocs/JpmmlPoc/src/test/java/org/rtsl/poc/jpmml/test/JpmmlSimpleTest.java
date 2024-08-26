package org.rtsl.poc.jpmml.test;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import org.jpmml.evaluator.Evaluator;
import org.jpmml.evaluator.LoadingModelEvaluatorBuilder;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class JpmmlSimpleTest {

    private static final Logger LOGGER = LoggerFactory.getLogger(JpmmlSimpleTest.class);

    @Test
    public void simpleTestAudit() throws Exception {

        LOGGER.info("Loading a file ");
        Evaluator evaluator = new LoadingModelEvaluatorBuilder()
                .load(new File("./src/test/resources/single_audit_dectree.xml"))
                .build();

        Map<String, Object> input = new HashMap<>();
        input.put("Age", "Private");
        input.put("Employment", 33);
        input.put("Education", "College");
        input.put("Marital", "Unmarried");
        input.put("Occupation", "Service");
        input.put("Income", 100000);
        input.put("Gender", "Female");
        input.put("Deductions", 1000);
        input.put("Hours", 50);

        LOGGER.info("Using input fields: {}", input);
        Map<String, ?> results = evaluator.evaluate(input);

        LOGGER.info("Results are: {}", results);

    }

    @Test
    public void simpleTestScore() throws Exception {

        LOGGER.info("Loading a file ");
        Evaluator evaluator = new LoadingModelEvaluatorBuilder()
                .load(new File("./src/test/resources/sample_score.pmml.xml"))
                .build();

        for (int i = 0; i < 100; i++) {
            Map<String, Object> input = new HashMap<>();
            input.put("param1", 50);
            input.put("param2", 33);
            input.put("finalscore", 33);

            LOGGER.info("Using input fields: {}", input);
            Map<String, ?> results = evaluator.evaluate(input);

            LOGGER.info("Results are: {}", results);
        }

    }

}

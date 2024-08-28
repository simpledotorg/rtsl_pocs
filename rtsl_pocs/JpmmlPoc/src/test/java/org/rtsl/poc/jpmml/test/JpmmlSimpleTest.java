package org.rtsl.poc.jpmml.test;

import java.io.FileInputStream;
import java.util.HashMap;
import java.util.Map;
import org.dmg.pmml.PMML;
import org.jpmml.evaluator.ModelEvaluator;
import org.jpmml.evaluator.ModelEvaluatorBuilder;
import org.jpmml.model.jackson.JacksonUtil;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class JpmmlSimpleTest {

    private static final Logger LOGGER = LoggerFactory.getLogger(JpmmlSimpleTest.class);

    @Test
    public void simpleTestAudit() throws Exception {

        String filePath = "./src/test/resources/single_audit_dectree.json";
        LOGGER.info("Loading file <{}>", filePath);
        PMML testPMML = JacksonUtil.readPMML(new FileInputStream(filePath));
        ModelEvaluator evaluator = new ModelEvaluatorBuilder(testPMML).build();

        LOGGER.info("Loading a file ");

        /*
        // PMML testPMML = JacksonUtil.readPMML(new FileInputStream("./src/test/resources/single_audit_dectree.xml"));
        LoadingModelEvaluatorBuilder evaluatorBuilder = new LoadingModelEvaluatorBuilder();
        evaluatorBuilder.setJAXBContext(MetroJAXBUtil.getContext());
        LOGGER.info("@@@@@@@" + evaluatorBuilder.getJAXBContext());

        Evaluator evaluator = evaluatorBuilder
                .load(new File("./src/test/resources/single_audit_dectree.xml"))
                .build();
        
        /**/
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
        String filePath = "./src/test/resources/sample_score.pmml.json";
        LOGGER.info("Loading file <{}>", filePath);
        PMML testPMML = JacksonUtil.readPMML(new FileInputStream(filePath));
        ModelEvaluator evaluator = new ModelEvaluatorBuilder(testPMML).build();

        /**
         * LoadingModelEvaluatorBuilder evaluatorBuilder = new
         * LoadingModelEvaluatorBuilder();
         * evaluatorBuilder.setJAXBContext(MetroJAXBUtil.getContext());
         * LOGGER.info("@@@@@@@" + evaluatorBuilder.getJAXBContext());
         *
         * Evaluator evaluator = evaluatorBuilder .load(new
         * File("./src/test/resources/sample_score.pmml.xml")) .build(); /*
         */
        int max = 1000;
        long totalNs = 0;
        for (int i = 0; i < max; i++) {
            long t1 = System.nanoTime();
            Map<String, Object> input = new HashMap<>();
            input.put("param1", 50);
            input.put("param2", 33);
            input.put("finalscore", 33);

            LOGGER.info("Using input fields: {}", input);
            Map<String, ?> results = evaluator.evaluate(input);
            long processTime = System.nanoTime() - t1;
            totalNs = totalNs + processTime;

            LOGGER.info("Results are obtained in <{}> ns. Result is: {}", processTime, results);
        }

        LOGGER.info("Average Process Time was <{}> nanoseconds", totalNs / max);
    }

}

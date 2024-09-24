package edu.ship.engr.shipsim.restfulcommunication.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import edu.ship.engr.shipsim.dataDTO.QuestionDTO;
import edu.ship.engr.shipsim.datatypes.QuestionsForTest;
import edu.ship.engr.shipsim.model.reports.GetAllQuestionsReport;
import edu.ship.engr.shipsim.testing.annotations.GameTest;
import edu.ship.engr.shipsim.testing.annotations.ResetModelFacade;
import edu.ship.engr.shipsim.testing.annotations.ResetPlayerManager;
import edu.ship.engr.shipsim.testing.annotations.ResetQuestManager;
import edu.ship.engr.shipsim.testing.annotations.ResetReportObserverConnector;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * @author Scott Bucher
 */
@GameTest("GameServer")
@ResetModelFacade
@ResetQuestManager
@ResetPlayerManager
@ResetReportObserverConnector
public class TestQuestionController
{

    @Test
    public void goodResponseQuestions()
            throws JsonProcessingException, JSONException
    {
        QuestionController mock = mock(QuestionController.class);

        QuestionDTO Question1 = QuestionsForTest.ONE.getQuestionDTO();
        QuestionDTO Question2 = QuestionsForTest.TWO.getQuestionDTO();
        when(mock.processAction(any(Runnable.class), eq(GetAllQuestionsReport.class))).thenReturn(
                new GetAllQuestionsReport(new ArrayList<>()
                    {{
                        add(Question1);
                        add(Question2);
                    }}
                ));

        when(mock.getAllQuestions()).thenCallRealMethod();

        ResponseEntity<Object> response = mock.getAllQuestions();
        assertEquals(HttpStatus.OK, response.getStatusCode());

        JSONObject last = new JSONObject((String) response.getBody());
        JSONArray records = (JSONArray) last.get("Questions");

        assertEquals(records.getJSONObject(0).getInt("id"), 1);
        assertEquals(records.getJSONObject(1).getInt("id"), 2);
    }
}


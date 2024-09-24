package edu.ship.engr.shipsim.restfulcommunication.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import edu.ship.engr.shipsim.dataDTO.PlayerWeeklyScoreDTO;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersScoreReport;
import edu.ship.engr.shipsim.restfulcommunication.representation.FetchObjectivesBody;
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

@GameTest("GameServer")
@ResetModelFacade
@ResetQuestManager
@ResetPlayerManager
@ResetReportObserverConnector
public class TestWeeklyPlayerScoreController
{

    @Test
    public void goodResponseWeeklyPlayerScore()
            throws JsonProcessingException, JSONException
    {
        WeeklyPlayerScoreController mock =
                mock(WeeklyPlayerScoreController.class);

        PlayerWeeklyScoreDTO player1 = new PlayerWeeklyScoreDTO(1, "bob", 5);
        PlayerWeeklyScoreDTO player2 = new PlayerWeeklyScoreDTO(2, "janice", 6);

        when(mock.processAction(any(Runnable.class), eq(
                GetAllPlayersScoreReport.class))).thenReturn(
                new GetAllPlayersScoreReport(new ArrayList<>()
                {{
                    add(player1);
                    add(player2);
                }}
                ));

        FetchObjectivesBody body = new FetchObjectivesBody(player1.getPlayerID());
        when(mock.getAllWeeklyPlayerScores(body)).thenCallRealMethod();

        ResponseEntity<Object> response = mock.getAllWeeklyPlayerScores(body);
        assertEquals(HttpStatus.OK, response.getStatusCode());

        JSONObject last = new JSONObject((String) response.getBody());
        JSONArray records = (JSONArray) last.get("weeklyPlayerScores");

        assertEquals(records.getJSONObject(0).getInt("playerID"), 1);
        assertEquals(records.getJSONObject(1).getInt("playerID"), 2);
        assertEquals(records.getJSONObject(0).getInt("weeklyScore"), 5);
        assertEquals(records.getJSONObject(1).getInt("weeklyScore"), 6);
    }
}



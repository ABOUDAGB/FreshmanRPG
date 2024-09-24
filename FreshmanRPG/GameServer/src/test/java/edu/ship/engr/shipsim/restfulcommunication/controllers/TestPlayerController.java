package edu.ship.engr.shipsim.restfulcommunication.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import edu.ship.engr.shipsim.dataDTO.PlayerDTO;
import edu.ship.engr.shipsim.dataDTO.PlayerWeeklyScoreDTO;
import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.model.IllegalQuestChangeException;
import edu.ship.engr.shipsim.model.NPC;
import edu.ship.engr.shipsim.model.Player;
import edu.ship.engr.shipsim.model.PlayerManager;
import edu.ship.engr.shipsim.model.reports.ChangePlayerReport;
import edu.ship.engr.shipsim.model.reports.CreatePlayerResponseReport;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersReport;
import edu.ship.engr.shipsim.model.reports.GetPlayerScoreReport;
import edu.ship.engr.shipsim.model.reports.UpdatePlayerInformationReport;
import edu.ship.engr.shipsim.restfulcommunication.representation.ChangePasswordInformation;
import edu.ship.engr.shipsim.restfulcommunication.representation.ChangePlayerInformation;
import edu.ship.engr.shipsim.restfulcommunication.representation.CreatePlayerInformation;
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
import java.util.Objects;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
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
public class TestPlayerController
{

    @Test
    public void goodResponseCreatePlayer()
    {
        PlayerController mock = mock(PlayerController.class);
        when(mock.processAction(any(Runnable.class), eq(CreatePlayerResponseReport.class))).thenReturn(
                new CreatePlayerResponseReport(true));
        when(mock.createPlayer(any(CreatePlayerInformation.class))).thenCallRealMethod();

        ResponseEntity<Object> response = mock.createPlayer(new CreatePlayerInformation("fred", "ow", 1, 2, 3));

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("{\"description\":\"Created\",\"success\":true}", Objects.requireNonNull(response.getBody()).toString());
    }

    @Test
    public void badResponseCreatePlayer()
    {
        PlayerController mock = mock(PlayerController.class);
        when(mock.processAction(any(Runnable.class), eq(CreatePlayerResponseReport.class))).thenReturn(
                new CreatePlayerResponseReport(false, "ERROR"));
        when(mock.createPlayer(any(CreatePlayerInformation.class))).thenCallRealMethod();

        ResponseEntity<Object> response = mock.createPlayer(new CreatePlayerInformation("fred", "ow", 1, 2, 3));
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals("{\"description\":\"ERROR\",\"success\":false}", Objects.requireNonNull(response.getBody()).toString());
    }

    @Test
    public void goodResponseGetAllPlayers()
            throws JsonProcessingException, JSONException
    {
        PlayerController mock = mock(PlayerController.class);

        PlayerDTO player1 = new PlayerDTO();
        player1.setPlayerID(1);
        PlayerDTO player2 = new PlayerDTO();
        player2.setPlayerID(2);

        when(mock.processAction(any(Runnable.class), eq(GetAllPlayersReport.class))).thenReturn(
                new GetAllPlayersReport(new ArrayList<>()
                {{
                    add(player1);
                    add(player2);
                }}
                ));

        when(mock.getAllPlayers()).thenCallRealMethod();

        ResponseEntity<Object> response = mock.getAllPlayers();
        assertEquals(HttpStatus.OK, response.getStatusCode());

        JSONObject last = new JSONObject((String) response.getBody());
        JSONArray records = (JSONArray) last.get("players");

        assertEquals(records.getJSONObject(0).getInt("playerID"), 1);
        assertEquals(records.getJSONObject(1).getInt("playerID"), 2);
    }

    @Test
    public void goodResponseChangePlayer()
    {
        PlayerController mock = mock(PlayerController.class);
        when(mock.processAction(any(Runnable.class), eq(
                ChangePlayerReport.class))).thenReturn(
                new ChangePlayerReport(true));
        when(mock.changePlayer(any(ChangePlayerInformation.class))).thenCallRealMethod();

        ResponseEntity<Object> response = mock.changePlayer(new ChangePlayerInformation("fred", "ow", 0));

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("{\"description\":\"Player Info have been Updated successfully\",\"success\":true}", Objects.requireNonNull(response.getBody()).toString());
    }

    @Test
    public void goodResponseGetPlayerScore()
            throws JsonProcessingException, JSONException
    {
        PlayerController mock =
                mock(PlayerController.class);

        PlayerWeeklyScoreDTO player1 = new PlayerWeeklyScoreDTO(1, "bob", 5);

        when(mock.processAction(any(Runnable.class), eq(
                GetPlayerScoreReport.class))).thenReturn(
                new GetPlayerScoreReport(player1.getWeeklyScore()));

        FetchObjectivesBody body = new FetchObjectivesBody(player1.getPlayerID());
        when(mock.getPlayerScoreThisWeek(body)).thenCallRealMethod();

        ResponseEntity<Object> response = mock.getPlayerScoreThisWeek(body);
        assertEquals(HttpStatus.OK, response.getStatusCode());

        JSONObject last = new JSONObject((String) response.getBody());

        int playerScore = last.getInt("playerScore");
        assertEquals(playerScore, 5);
    }

    @Test
    public void goodResponseGetPlayerInfo()
            throws DatabaseException, JsonProcessingException
    {
        PlayerController mock = mock(PlayerController.class);

        when(mock.getPlayerInfo(any(FetchObjectivesBody.class))).thenCallRealMethod();

        FetchObjectivesBody body = new FetchObjectivesBody(15);
        ResponseEntity<Object> response = mock.getPlayerInfo(body);


        assertEquals(HttpStatus.OK, response.getStatusCode());
        String expectedResponse = "{\"success\": true, \"clientPlayerQuestList\": " +
                "[], \"friendlist\": [], \"experiencePoints\": 13, \"doubloons\": 0, " +
                "\"level\": {\"description\":\"Serf\",\"levelUpPoints\":45,\"" +
                "levelUpMonth\":9,\"levelUpDayOfMonth\":30,\"deadlineDate\"" +
                ":[2024,9,30]}}";
        assertEquals(expectedResponse, Objects.requireNonNull(response.getBody()).toString());

    }

    @Test
    public void goodResponseChangePassword()
    {
        PlayerController mock = mock(PlayerController.class);
        when(mock.processAction(any(Runnable.class), eq(
                ChangePlayerReport.class))).thenReturn(
                new ChangePlayerReport(true));
        when(mock.changePassword(any(ChangePasswordInformation.class))).thenCallRealMethod();

        ResponseEntity<Object> response = mock.changePassword(new ChangePasswordInformation("fred", "pw"));

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("{\"description\":\"Player Info have been Updated successfully\",\"success\":true}", Objects.requireNonNull(response.getBody()).toString());
    }

}
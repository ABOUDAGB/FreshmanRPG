package edu.ship.engr.shipsim.restfulcommunication.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import edu.ship.engr.shipsim.communication.messages.HighScoreResponseMessage;
import edu.ship.engr.shipsim.communication.messages.InitializeThisClientsPlayerMessage;
import edu.ship.engr.shipsim.communication.messages.PlayerChangeAppearanceMessage;
import edu.ship.engr.shipsim.communication.packers.UpdatePlayerInformationMessagePacker;
import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.model.CommandChangePassword;
import edu.ship.engr.shipsim.model.CommandChangePlayer;
import edu.ship.engr.shipsim.model.CommandChangePlayerAppearance;
import edu.ship.engr.shipsim.model.CommandCreatePlayer;
import edu.ship.engr.shipsim.model.CommandGetAllPlayers;
import edu.ship.engr.shipsim.model.CommandGetAllPlayersScore;
import edu.ship.engr.shipsim.model.CommandGetPlayerScore;
import edu.ship.engr.shipsim.model.IllegalQuestChangeException;
import edu.ship.engr.shipsim.model.ModelFacade;
import edu.ship.engr.shipsim.model.Player;
import edu.ship.engr.shipsim.model.PlayerManager;
import edu.ship.engr.shipsim.model.ReportObserverConnector;
import edu.ship.engr.shipsim.model.reports.ChangePlayerReport;
import edu.ship.engr.shipsim.model.reports.CreatePlayerResponseReport;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersReport;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersScoreReport;
import edu.ship.engr.shipsim.model.reports.GetPlayerScoreReport;
import edu.ship.engr.shipsim.model.reports.PlayerConnectionReport;
import edu.ship.engr.shipsim.model.reports.PlayerQuestReport;
import edu.ship.engr.shipsim.model.reports.SendMessageReport;
import edu.ship.engr.shipsim.model.reports.UpdatePlayerInformationReport;
import edu.ship.engr.shipsim.restfulcommunication.representation.ChangePasswordInformation;
import edu.ship.engr.shipsim.restfulcommunication.representation.ChangePlayerInformation;
import edu.ship.engr.shipsim.restfulcommunication.representation.CreatePlayerInformation;
import edu.ship.engr.shipsim.restfulcommunication.representation.BasicResponse;
import edu.ship.engr.shipsim.restfulcommunication.representation.FetchObjectivesBody;
import edu.ship.engr.shipsim.restfulcommunication.representation.FetchObjectivesResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.sql.Date;

/**
 * @author Derek
 */
@RestController
public class PlayerController extends Controller
{
    @CrossOrigin // Required for web client support
    @PostMapping("/player/create")
    public ResponseEntity<Object> createPlayer(
            @RequestBody CreatePlayerInformation info)
    {
        CreatePlayerResponseReport report = processAction(() ->
        {
            CommandCreatePlayer command =
                    new CommandCreatePlayer(info.getPlayerName(),
                            info.getPassword(),
                            info.getCrew(), info.getMajor(),
                            info.getSection());
            ModelFacade.getSingleton().queueCommand(command);
        }, CreatePlayerResponseReport.class);

        if (report != null)
        {
            if (report.isSuccessful())
            {
                System.out.println("Success");
                return new ResponseEntity<>(new BasicResponse(true,"Created").toString(),
                        HttpStatus.OK);
            }
            else
            {
                System.out.println("FAIL; " + report.getDescription());
                return new ResponseEntity<>(
                        new BasicResponse(false, report.getDescription()).toString(),
                        HttpStatus.BAD_REQUEST);
            }
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @CrossOrigin // Required for web client support
    @GetMapping("/getAllPlayers")
    public ResponseEntity<Object> getAllPlayers() throws JsonProcessingException
    {
        GetAllPlayersReport report = processAction(() ->
        {
            CommandGetAllPlayers command =
                    new CommandGetAllPlayers();
            ModelFacade.getSingleton().queueCommand(command);
        }, GetAllPlayersReport.class);

        if (report != null)
        {
            ObjectMapper mapper = new ObjectMapper();
            String json = "{\"success\": true, \"players\": " + mapper.writeValueAsString(report.getPlayers()) + "}";
            return new ResponseEntity<>(json, HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @CrossOrigin // Required for web client support
    @PostMapping("/player/update/")
    public ResponseEntity<Object> changePlayer(
            @RequestBody ChangePlayerInformation info)
    {
        ChangePlayerReport report = processAction(() ->
        {
            CommandChangePlayer command =
                    new CommandChangePlayer(info.getPlayerName(),
                            info.getPassword(), info.getCrewID());
            ModelFacade.getSingleton().queueCommand(command);
        }, ChangePlayerReport.class);

        if (report != null)
        {
            if (report.isSuccessful())
            {
                System.out.println("Success");
                return new ResponseEntity<>(new BasicResponse(true,"Player Info have been Updated successfully").toString(),
                        HttpStatus.OK);
            }
            else
            {
                System.out.println("FAIL");
                return new ResponseEntity<>(
                        new BasicResponse(false, report.getDescription()).toString(),
                        HttpStatus.BAD_REQUEST);
            }
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @CrossOrigin // Required for web client support
    @GetMapping("/getPlayerScoreThisWeek")
    public ResponseEntity<Object> getPlayerScoreThisWeek(@RequestBody FetchObjectivesBody body) throws JsonProcessingException
    {
        GetPlayerScoreReport report = processAction(() ->
        {
            CommandGetPlayerScore command =
                    new CommandGetPlayerScore(body.getPlayerID());
            ModelFacade.getSingleton().queueCommand(command);
        }, GetPlayerScoreReport.class);

        if (report != null)
        {
            ObjectMapper mapper = new ObjectMapper();
            String json = "{\"success\": true, \"playerScore\": " + mapper.writeValueAsString(report.getPlayerScore()) + "}";
            return new ResponseEntity<>(json, HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @CrossOrigin // Required for web client support
    @PostMapping("/getPlayerInfo")
    public ResponseEntity<Object> getPlayerInfo(@RequestBody FetchObjectivesBody body)
            throws JsonProcessingException, DatabaseException
    {
        Player player = PlayerManager.getSingleton().addPlayer(body.getPlayerID());

        UpdatePlayerInformationReport report = new UpdatePlayerInformationReport(player);

        if (report != null)
        {
            System.out.println("Got a report: " + report.getClass().getSimpleName());
            System.out.println("playerID: " + ((SendMessageReport) report).getRelevantPlayerID());

            PlayerManager.getSingleton().removePlayer(body.getPlayerID());
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            String json = "{\"success\": true, \"clientPlayerQuestList\": " + mapper.writeValueAsString(report.getClientPlayerQuestList()) + ", " +
                    "\"friendlist\": " + mapper.writeValueAsString(report.getFriendsList()) + ", " +
                    "\"experiencePoints\": " + mapper.writeValueAsString(report.getExperiencePoints()) + ", " +
                    "\"doubloons\": " + mapper.writeValueAsString(report.getDoubloons()) + ", " +
                    "\"level\": " + mapper.writeValueAsString(report.getLevel())  +
                    "}";
            return new ResponseEntity<>(json, HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @CrossOrigin // Required for web client support
    @PostMapping("/player/change-password/")
    public ResponseEntity<Object> changePassword(
            @RequestBody ChangePasswordInformation info)
    {
        ChangePlayerReport report = processAction(() ->
        {
            CommandChangePassword command =
                    new CommandChangePassword(info.getPlayerName(),
                            info.getPassword());
            ModelFacade.getSingleton().queueCommand(command);
        }, ChangePlayerReport.class);

        if (report != null)
        {
            if (report.isSuccessful())
            {
                System.out.println("Success");
                return new ResponseEntity<>(new BasicResponse(true,"Player Info have been Updated successfully").toString(),
                        HttpStatus.OK);
            }
            else
            {
                System.out.println("FAIL");
                return new ResponseEntity<>(
                        new BasicResponse(false, report.getDescription()).toString(),
                        HttpStatus.BAD_REQUEST);
            }
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }


//    @CrossOrigin // Required for web client support
//    @PostMapping("/getAllPlayersScoreThisWeek")
//    public ResponseEntity<Object> getAllPlayerScoresThisWeek(@RequestBody FetchObjectivesBody body) throws JsonProcessingException
//    {
//        Date startDate = new Date(System.currentTimeMillis() - 604800000);
//        Date endDate = new Date(System.currentTimeMillis());
//
//        GetAllPlayersScoreReport report = processAction(() ->
//        {
//            CommandGetAllPlayersScore command =
//                    new CommandGetAllPlayersScore(startDate, endDate);
//            ModelFacade.getSingleton().queueCommand(command);
//        }, GetAllPlayersScoreReport.class);
//
//        if (report != null)
//        {
//            ObjectMapper mapper = new ObjectMapper();
//            String json = "{\"success\": true, \"WeeklyPlayerScores\": "
//                    + mapper.writeValueAsString(report.getPlayerWeeklyScoreDTOS()) + "}";
//            return new ResponseEntity<>(json, HttpStatus.OK);
//        }
//
//        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
//    }

}
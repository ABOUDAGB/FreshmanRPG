package edu.ship.engr.shipsim.restfulcommunication.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import edu.ship.engr.shipsim.model.CommandGetAllPlayersScore;
import edu.ship.engr.shipsim.model.CommandGetAllPlayersScoreWithinCrew;
import edu.ship.engr.shipsim.model.ModelFacade;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersScoreReport;
import edu.ship.engr.shipsim.model.reports.PlayerQuestReport;
import edu.ship.engr.shipsim.restfulcommunication.representation.FetchObjectivesBody;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;

@RestController
public class WeeklyPlayerScoreController extends Controller
{
    LocalDate start = LocalDate.now().with(TemporalAdjusters.previousOrSame(
            DayOfWeek.SUNDAY));
    LocalDate end = LocalDate.now();

    @CrossOrigin
    @PostMapping("/weeklyPlayerScores")
    public ResponseEntity<Object> getAllWeeklyPlayerScores(@RequestBody
                                                           FetchObjectivesBody fetchObjectivesBody) throws
            JsonProcessingException
    {
        GetAllPlayersScoreReport allPlayersScoreReport = processAction(() ->
        {
            CommandGetAllPlayersScore commandGetAllPlayersScore =
                    new CommandGetAllPlayersScore(start, end);
            ModelFacade.getSingleton().queueCommand(commandGetAllPlayersScore);
        }, GetAllPlayersScoreReport.class);

        GetAllPlayersScoreReport allPlayersScoreWithinCrewReport = processAction(() ->
        {
            CommandGetAllPlayersScoreWithinCrew commandGetAllPLayerScoresWithinCrew = new CommandGetAllPlayersScoreWithinCrew(
                    fetchObjectivesBody.getPlayerID(), start, end);
            ModelFacade.getSingleton().queueCommand(commandGetAllPLayerScoresWithinCrew);
        }, GetAllPlayersScoreReport.class);

        if (allPlayersScoreReport != null && allPlayersScoreWithinCrewReport != null)
        {
            //array list of dtos to json object

            System.out.println("Got a report: " + allPlayersScoreReport.getClass().getSimpleName());
            System.out.println(allPlayersScoreReport.getAllPlayersScoreReport().size() + " Player Scores");
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            String json = "{\"success\": true, \"weeklyPlayerScores\": " +
                    mapper.writeValueAsString(
                            allPlayersScoreReport.getPlayerWeeklyScoreDTOS()) +
                    ", \"weeklyPlayerScoresWithinCrew\": " + mapper.writeValueAsString(
                    allPlayersScoreWithinCrewReport.getPlayerWeeklyScoreDTOS()) + "}";
            return new ResponseEntity<>(json, HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}

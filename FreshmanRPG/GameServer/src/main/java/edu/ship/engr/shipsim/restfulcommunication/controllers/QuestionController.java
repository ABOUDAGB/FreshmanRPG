package edu.ship.engr.shipsim.restfulcommunication.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import edu.ship.engr.shipsim.model.CommandGetCrews;
import edu.ship.engr.shipsim.model.CommandGetQuestions;
import edu.ship.engr.shipsim.model.ModelFacade;
import edu.ship.engr.shipsim.model.reports.GetAllCrewsReport;
import edu.ship.engr.shipsim.model.reports.GetAllQuestionsReport;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author Scott Bucher
 */
@RestController
public class QuestionController extends Controller
{
    @CrossOrigin // Required for web client support
    @GetMapping("/questions")
    public ResponseEntity<Object> getAllQuestions() throws JsonProcessingException
    {
        GetAllQuestionsReport report = processAction(() ->
        {
            CommandGetQuestions command =
                    new CommandGetQuestions();
            ModelFacade.getSingleton().queueCommand(command);
        }, GetAllQuestionsReport.class);

        if (report != null)
        {
            //array list of dtos to json object
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            String json = "{\"success\": true, \"Questions\": " + mapper.writeValueAsString(report.getQuestions()) + "}";
            return new ResponseEntity<>(json, HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}

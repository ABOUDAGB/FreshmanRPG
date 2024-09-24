package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.dataDTO.CrewDTO;
import edu.ship.engr.shipsim.dataDTO.QuestionDTO;
import edu.ship.engr.shipsim.datasource.CrewTableDataGateway;
import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.QuestionDataGateway;
import edu.ship.engr.shipsim.model.reports.GetAllCrewsReport;
import edu.ship.engr.shipsim.model.reports.GetAllQuestionsReport;

import java.util.ArrayList;

public class CommandGetQuestions extends Command
{
    public CommandGetQuestions()
    {
    }
    @Override
    void execute()
    {

        try
        {
            ArrayList<QuestionDTO> questionDTOs = QuestionDataGateway.getAllQuestions();
            GetAllQuestionsReport questionReport = new GetAllQuestionsReport(questionDTOs);
            ReportObserverConnector.getSingleton().sendReport(questionReport);
        }
        catch (DatabaseException e)
        {
            throw new RuntimeException(e);
        }
    }
}

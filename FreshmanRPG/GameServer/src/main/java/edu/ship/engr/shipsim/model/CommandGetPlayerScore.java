package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.dataDTO.PlayerDTO;
import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.ObjectiveScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.datasource.PlayerTableDataGateway;
import edu.ship.engr.shipsim.datasource.QuestScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersReport;
import edu.ship.engr.shipsim.model.reports.GetPlayerScoreReport;

import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;

public class CommandGetPlayerScore extends Command
{
    private final int playerID;

    LocalDate startDate = LocalDate.now().with(
            TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
    LocalDate endDate = LocalDate.now();

    public CommandGetPlayerScore(int playerID)
    {
        this.playerID = playerID;
    }
    @Override
    void execute()
    {
        try
        {
            ObjectiveScoreDateViewTableDataGateway ObjectiveGateway = ObjectiveScoreDateViewTableDataGateway.getSingleton();
            QuestScoreDateViewTableDataGateway QuestGateway = QuestScoreDateViewTableDataGateway.getSingleton();


            int objectiveScore = ObjectiveGateway.getPlayerScoreByDate(playerID, startDate, endDate);
            int questScore = QuestGateway.getPlayerScoreByDate(playerID, startDate, endDate);
            GetPlayerScoreReport report = new GetPlayerScoreReport(objectiveScore + questScore);
            ReportObserverConnector.getSingleton().sendReport(report);
        }
        catch (DatabaseException e)
        {
            throw new RuntimeException(e);
        }
    }

}
package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.dataDTO.PlayerWeeklyScoreDTO;
import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.ObjectiveScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.datasource.QuestScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.model.reports.GetPlayerScoreReport;
import org.junit.jupiter.api.Test;

import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;

import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


public class CommandGetPlayerScoreTest
{
    @Test
    public void testGetPlayerScore() throws DatabaseException
    {
        ReportObserver obs = mock(ReportObserver.class);
        ReportObserverConnector.getSingleton()
                .registerObserver(obs, GetPlayerScoreReport.class);

        QuestScoreDateViewTableDataGateway questScore =
                QuestScoreDateViewTableDataGateway.getSingleton();
        QuestScoreDateViewTableDataGateway questScoreMock =
                mock(QuestScoreDateViewTableDataGateway.class);
        questScore.setSingleton(questScoreMock);

        ObjectiveScoreDateViewTableDataGateway objectiveScore =
                ObjectiveScoreDateViewTableDataGateway.getSingleton();
        ObjectiveScoreDateViewTableDataGateway objectiveScoreMock =
                mock(ObjectiveScoreDateViewTableDataGateway.class);
        objectiveScore.setSingleton(objectiveScoreMock);

        PlayerWeeklyScoreDTO player1obj = new PlayerWeeklyScoreDTO(1, "bob", 2);
        PlayerWeeklyScoreDTO player1quest =
                new PlayerWeeklyScoreDTO(1, "bob", 5);


        PlayerWeeklyScoreDTO player1after =
                new PlayerWeeklyScoreDTO(1, "bob", 7);


        ArrayList<Integer> playerScoresBefore = new ArrayList<>()
        {{
            add(player1obj.getWeeklyScore());
            add(player1quest.getWeeklyScore());
        }};


        LocalDate start = LocalDate.now().with(TemporalAdjusters.previousOrSame(
                DayOfWeek.SUNDAY));
        LocalDate end = LocalDate.now();

        //when(mockGateway.getAllPlayers()).thenReturn(players);

        when(questScoreMock.getPlayerScoreByDate(player1after.getPlayerID(),
                start, end)).thenReturn(
                player1quest.getWeeklyScore());

        when(objectiveScoreMock.getPlayerScoreByDate(player1after.getPlayerID(),
                start, end)).thenReturn(
                player1obj.getWeeklyScore());


        CommandGetPlayerScore cmd =
                new CommandGetPlayerScore(1);
        cmd.execute();

        verify(obs, times(1)).receiveReport(argThat(report ->
                {
                    GetPlayerScoreReport scoreReport =
                            new GetPlayerScoreReport(player1after.getWeeklyScore());
                    int playerScore = scoreReport.getPlayerScore();
                    return playerScore == 7;
                }
        ));
    }
}
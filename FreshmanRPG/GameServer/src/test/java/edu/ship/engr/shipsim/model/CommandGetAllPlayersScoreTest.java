package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.dataDTO.PlayerWeeklyScoreDTO;
import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.ObjectiveScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.datasource.QuestScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersReport;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersScoreReport;
import org.junit.jupiter.api.Test;

import java.sql.Array;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;

import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.runner.RunWith;


public class CommandGetAllPlayersScoreTest
{
    @Test
    public void testGetAllPlayersScores() throws DatabaseException
    {
        ReportObserver obs = mock(ReportObserver.class);
        ReportObserverConnector.getSingleton()
                .registerObserver(obs, GetAllPlayersScoreReport.class);

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

        PlayerWeeklyScoreDTO player2obj =
                new PlayerWeeklyScoreDTO(2, "janice", 3);
        PlayerWeeklyScoreDTO player2quest =
                new PlayerWeeklyScoreDTO(2, "janice", 6);

        PlayerWeeklyScoreDTO player1after =
                new PlayerWeeklyScoreDTO(1, "bob", 7);
        PlayerWeeklyScoreDTO player2after =
                new PlayerWeeklyScoreDTO(2, "janice", 9);

//        PlayerDTO player1 = new PlayerDTO();
//        player1.setPlayerID(1);
//        PlayerDTO player2 = new PlayerDTO();
//        player2.setPlayerID(2);

//        ArrayList<PlayerDTO> players = new ArrayList<>()
//        {{
//            add(player1);
//            add(player2);
//        }};

        ArrayList<PlayerWeeklyScoreDTO> playerScoresBefore = new ArrayList<>()
        {{
            add(player1obj);
            add(player1quest);
            add(player2quest);
            add(player2obj);
        }};

        ArrayList<PlayerWeeklyScoreDTO> playerScoresAfter = new ArrayList<>()
        {{
            add(player1after);
            add(player2after);
        }};

        LocalDate start = LocalDate.now().with(TemporalAdjusters.previousOrSame(
                DayOfWeek.SUNDAY));
        LocalDate end = LocalDate.now();

        //when(mockGateway.getAllPlayers()).thenReturn(players);

        when(questScoreMock.getWeeklyScores(start, end)).thenReturn(
                playerScoresBefore);

        when(objectiveScoreMock.getWeeklyScores(start, end)).thenReturn(
                playerScoresBefore);

        //mockStatic(ObjectiveScoreDateViewTableDataGateway.class);
        //when(ObjectiveScoreDateViewTableDataGateway.getWeeklyScores(start,
        // end)).thenReturn(playerScoresBefore);


        //CommandGetAllPlayers cmd = new CommandGetAllPlayers();
        // cmd.execute();

        CommandGetAllPlayersScore cmd =
                new CommandGetAllPlayersScore(start, end);
        cmd.execute();

        verify(obs, times(1)).receiveReport(argThat(report ->
                {
                    GetAllPlayersScoreReport scoreReport =
                            new GetAllPlayersScoreReport(playerScoresAfter);
                    ArrayList<PlayerWeeklyScoreDTO> playerDTOs =
                            scoreReport.getPlayerWeeklyScoreDTOS();

                    for (PlayerWeeklyScoreDTO playerDTO : playerDTOs)
                    {
                        if (playerDTO.getPlayerID() == 1 &&
                                playerDTO.getWeeklyScore() == 7)
                        {
                            //checks to see if combination was done
                            // correctly, with correct id
                        }
                        else if (playerDTO.getPlayerID() == 2 &&
                                playerDTO.getWeeklyScore() == 9)
                        {
                            //checks to see if combination was done
                            // correctly, with correct id
                        }
                        else
                        {
                            return false; //unexpected value
                        }
                    }

                    return true; // All players found with expected IDs and
                    // scores
                }
        ));

    }

}
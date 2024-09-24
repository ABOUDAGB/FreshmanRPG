package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.dataDTO.PlayerDTO;
import edu.ship.engr.shipsim.dataDTO.PlayerWeeklyScoreDTO;
import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.ObjectiveScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.datasource.QuestScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.datasource.QuestionDataGateway;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersScoreReport;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;

public class CommandGetAllPlayersScore extends Command
{
    LocalDate start;
    LocalDate end;

    public CommandGetAllPlayersScore(LocalDate start, LocalDate end)
    {
        this.start = start;
        this.end = end;
    }

    public static ArrayList<PlayerWeeklyScoreDTO> combineScores(
            ArrayList<PlayerWeeklyScoreDTO> list1,
            ArrayList<PlayerWeeklyScoreDTO> list2)
    {

        Map<Integer, PlayerWeeklyScoreDTO> combinedMap = new HashMap<>();

        // Combine scores from the first list
        for (PlayerWeeklyScoreDTO dto : list1)
        {
            int playerId = dto.getPlayerID();
            if (combinedMap.containsKey(playerId))
            {
                PlayerWeeklyScoreDTO combinedDto =
                        combinedMap.get(playerId);
                combinedDto.setWeeklyScore(combinedDto.getWeeklyScore() +
                        dto.getWeeklyScore());
            }
            else
            {
                combinedMap.put(playerId,
                        new PlayerWeeklyScoreDTO(dto.getPlayerID(),
                                dto.getPlayerName(), dto.getWeeklyScore()));
            }
        }

        // Combine scores from the second list
        for (PlayerWeeklyScoreDTO dto : list2)
        {
            int playerId = dto.getPlayerID();
            if (combinedMap.containsKey(playerId))
            {
                PlayerWeeklyScoreDTO combinedDto =
                        combinedMap.get(playerId);
                combinedDto.setWeeklyScore(combinedDto.getWeeklyScore() +
                        dto.getWeeklyScore());
            }
            else
            {
                combinedMap.put(playerId,
                        new PlayerWeeklyScoreDTO(dto.getPlayerID(),
                                dto.getPlayerName(), dto.getWeeklyScore()));
            }
        }

        // Convert map values to a list
        ArrayList<PlayerWeeklyScoreDTO> combinedList =
                new ArrayList<>(combinedMap.values());
        return combinedList;
    }

    @Override
    void execute()
    {
        try
        {
            //Date start = new Date(System.currentTimeMillis() - 604800000);
            // length of a week
            //Date end = new Date(System.currentTimeMillis());
            QuestScoreDateViewTableDataGateway QuestGate =
                    QuestScoreDateViewTableDataGateway.getSingleton();
            ArrayList<PlayerWeeklyScoreDTO> playerScoreDTOsQuests =
                    QuestGate.getWeeklyScores(start, end);
            ObjectiveScoreDateViewTableDataGateway objGate =
                    ObjectiveScoreDateViewTableDataGateway.getSingleton();
            ArrayList<PlayerWeeklyScoreDTO> playerScoreDTOsObjectives =
                    objGate.getWeeklyScores(start, end);

            ArrayList<PlayerWeeklyScoreDTO> combinedScores =
                    combineScores(playerScoreDTOsQuests,
                            playerScoreDTOsObjectives);

            // Sort the combinedScores ArrayList based on the weekly score in descending order
            combinedScores.sort(Comparator.comparingInt(PlayerWeeklyScoreDTO::getWeeklyScore).reversed());


            // Create a new ArrayList to hold the first 10 elements
            ArrayList<PlayerWeeklyScoreDTO> limitedScores = new ArrayList<>(combinedScores.subList(0, Math.min(combinedScores.size(), 10)));

            GetAllPlayersScoreReport scoresReport =
                    new GetAllPlayersScoreReport(limitedScores);
            ReportObserverConnector.getSingleton().sendReport(scoresReport);
        }
        catch (DatabaseException e)
        {
            throw new RuntimeException(e);
        }
    }
}

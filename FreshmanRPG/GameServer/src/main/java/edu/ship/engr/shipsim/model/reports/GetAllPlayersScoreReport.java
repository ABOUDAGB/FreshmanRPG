package edu.ship.engr.shipsim.model.reports;

import edu.ship.engr.shipsim.dataDTO.PlayerDTO;
import edu.ship.engr.shipsim.dataDTO.PlayerWeeklyScoreDTO;
import edu.ship.engr.shipsim.model.Report;
import lombok.Data;

import java.lang.reflect.Array;
import java.util.ArrayList;

@Data
public class GetAllPlayersScoreReport implements Report
{
    private final ArrayList<PlayerWeeklyScoreDTO> playerWeeklyScoreDTOS;

    public GetAllPlayersScoreReport(ArrayList<PlayerWeeklyScoreDTO> playerWeeklyScoreDTOS)
    {
        this.playerWeeklyScoreDTOS = playerWeeklyScoreDTOS;
    }

    public ArrayList<PlayerWeeklyScoreDTO> getAllPlayersScoreReport()
    {
        return playerWeeklyScoreDTOS;
    }
}

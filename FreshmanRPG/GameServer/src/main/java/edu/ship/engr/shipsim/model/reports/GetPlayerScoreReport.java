package edu.ship.engr.shipsim.model.reports;

import edu.ship.engr.shipsim.dataDTO.PlayerDTO;
import edu.ship.engr.shipsim.model.Report;
import lombok.Data;

import java.util.ArrayList;

@Data
public class GetPlayerScoreReport implements Report
{
    private final int playerScore;

    public GetPlayerScoreReport(int score)
    {
        this.playerScore = score;
    }
}
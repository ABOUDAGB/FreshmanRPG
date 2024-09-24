package edu.ship.engr.shipsim.dataDTO;

public class PlayerWeeklyScoreDTO
{
    private int playerID;
    private String playerName;
    private int weeklyScore;

    public int getPlayerID()
    {
        return playerID;
    }

    public void setPlayerID(int playerID)
    {
        this.playerID = playerID;
    }

    public String getPlayerName()
    {
        return playerName;
    }

    public void setPlayerName(String playerName)
    {
        this.playerName = playerName;
    }

    public int getWeeklyScore()
    {
        return weeklyScore;
    }


    public PlayerWeeklyScoreDTO(int playerID, String playerName,
                                int weeklyScore)
    {
        this.playerID = playerID;
        this.playerName = playerName;
        this.weeklyScore = weeklyScore;
    }

    public void setWeeklyScore(int weeklyScore)
    {
        this.weeklyScore = weeklyScore;
    }
}
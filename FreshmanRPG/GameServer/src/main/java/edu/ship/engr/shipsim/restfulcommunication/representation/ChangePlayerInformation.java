package edu.ship.engr.shipsim.restfulcommunication.representation;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

public class ChangePlayerInformation
{
    private final String playerName;
    private final String password;
    private final int crewID;
    public String getPlayerName()
    {
        return playerName;
    }

    public String getPassword()
    {
        return password;
    }

    public int getCrewID()
    {
        return crewID;
    }

    @JsonCreator
    public ChangePlayerInformation(@JsonProperty("playerName") String playerName, @JsonProperty("password") String password,
                                   @JsonProperty("crewID") int crewID)
    {
        this.playerName = playerName;
        this.password = password;
        this.crewID = crewID;
    }
}

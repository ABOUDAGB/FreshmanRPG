package edu.ship.engr.shipsim.restfulcommunication.representation;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * @author Mohamed
 */
public final class UserNameInformation
{
    private final String userName;

    @JsonCreator
    public UserNameInformation(@JsonProperty("userName") String userName)
    {
        this.userName = userName;
    }

    public String getUserName()
    {
        return userName;
    }
}


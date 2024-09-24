package edu.ship.engr.shipsim.restfulcommunication.representation;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

public final class GeneratedCodeInformation
{
    private final int code;
    private final String userName;

    @JsonCreator
    public GeneratedCodeInformation(@JsonProperty("code") int code,
                                    String userName)
    {
        this.code = code;
        this.userName = userName;
    }

    public int getCode()
    {
        return code;
    }
    public String getUserName()
    {
        return userName;
    }
}


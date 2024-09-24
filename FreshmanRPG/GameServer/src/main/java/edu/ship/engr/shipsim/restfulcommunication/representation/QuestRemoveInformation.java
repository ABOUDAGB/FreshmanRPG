package edu.ship.engr.shipsim.restfulcommunication.representation;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.text.ParseException;

public class QuestRemoveInformation
{
    private final int id;

    @JsonCreator
    public QuestRemoveInformation(@JsonProperty("id") int id)
            throws ParseException
    {
        this.id = id;
    }

    public int getId()
    {
        return id;
    }
}

package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.PlayerLoginRowDataGateway;
import edu.ship.engr.shipsim.model.reports.ChangePlayerReport;

/**
 * Command that takes a player's ID and the new
 * password and changes the password in the database.
 */
public class CommandChangePassword extends Command
{
    private final String playerName;
    private final String password;

    /**
     *
     * @param playerName the username of the player
     * @param password the new password overwriting old one
     */
    public CommandChangePassword(String playerName, String password)
    {
        this.playerName = playerName;
        this.password = password;
    }

    /**
     * Uses PlayerLoginRowDataGateway to set the new password
     * and then change the database
     */
    @Override
    void execute()
    {
        try
        {
            PlayerLoginRowDataGateway gw = new
                    PlayerLoginRowDataGateway(playerName);
            gw.setPassword(password);
            gw.persist();
        }
        catch (DatabaseException e)
        {
            e.printStackTrace();
        }
        ReportObserverConnector.getSingleton().sendReport(new ChangePlayerReport(true));
    }
}

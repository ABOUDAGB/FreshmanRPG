package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.PlayerLoginRowDataGateway;
import edu.ship.engr.shipsim.datasource.PlayerRowDataGateway;
import edu.ship.engr.shipsim.datatypes.Crew;
import edu.ship.engr.shipsim.model.reports.ChangePlayerReport;

/**
 * Command that takes a player's ID and the new
 * password and changes the password in the database.
 */
public class CommandChangePlayer extends Command
{
    private final String playerName;
    private final String password;
    private final int crewID;

    /**
     *
     * @param playerName the username of the player
     * @param password the new password overwriting old one
     */
    public CommandChangePlayer(String playerName, String password, int crewID)
    {
        this.playerName = playerName;
        this.password = password;
        this.crewID = crewID;
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

            String newAppearanceType = Crew.getCrewAppearanceTypeByID(crewID);

            PlayerRowDataGateway gw2 = new PlayerRowDataGateway(gw.getPlayerID());
            gw2.updateCrewID(crewID);

            if(newAppearanceType != null)
            {
                gw2.setAppearanceType(newAppearanceType);
            }

            gw2.persist();
        }
        catch (DatabaseException e)
        {
            e.printStackTrace();
        }
        ReportObserverConnector.getSingleton().sendReport(new ChangePlayerReport(true));
    }
}
package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.DuplicateNameException;
import edu.ship.engr.shipsim.datasource.PasswordResetRowDataGateway;
import edu.ship.engr.shipsim.model.reports.GetPlayerScoreReport;
import edu.ship.engr.shipsim.model.reports.GetResetPasswordCodeReport;

public class CommandGetResetPasswordCode extends Command
{
    private final int playerID;

    public CommandGetResetPasswordCode(int playerID)
    {
        this.playerID = playerID;
    }
    @Override
    public void execute() throws DuplicateNameException, DatabaseException
    {
        try
        {
            PasswordResetRowDataGateway gateway = new PasswordResetRowDataGateway(playerID);

            GetResetPasswordCodeReport report =
                    new GetResetPasswordCodeReport(gateway.getPasswordResetCode());
            ReportObserverConnector.getSingleton().sendReport(report);
        }
        catch (DatabaseException e)
        {
            //Couldn't get code
            e.printStackTrace();
        }
    }
}

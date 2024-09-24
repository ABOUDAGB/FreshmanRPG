package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.DuplicateNameException;
import edu.ship.engr.shipsim.datasource.PasswordResetRowDataGateway;
import edu.ship.engr.shipsim.model.reports.CreatePlayerResponseReport;
import edu.ship.engr.shipsim.model.reports.CreateResetPasswordCodeReport;

public class CommandCreateResetPasswordCode extends Command
{

    private final int playerID;
    private final int resetPasswordCode;

    public CommandCreateResetPasswordCode(int playerID, int resetPasswordCode)
    {
        this.playerID = playerID;
        this.resetPasswordCode = resetPasswordCode;
    }


    @Override
    public void execute() throws DuplicateNameException, DatabaseException
    {
        try
        {
            PasswordResetRowDataGateway gateway =
                    new PasswordResetRowDataGateway(playerID,
                            resetPasswordCode);
        }
        catch(DatabaseException e)
        {
            e.printStackTrace();
        }
        ReportObserverConnector.getSingleton()
                .sendReport(new CreateResetPasswordCodeReport(true));
    }
}

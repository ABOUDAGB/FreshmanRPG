package edu.ship.engr.shipsim.DatabaseBuilders;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.PasswordResetRowDataGateway;
import edu.ship.engr.shipsim.model.OptionsManager;

import java.sql.SQLException;

public class BuildTestPasswordReset
{
    private static void createResetPasswordTable() throws DatabaseException
    {
        PasswordResetRowDataGateway.createTable();
    }
    public static void main(String[] args) throws DatabaseException,
            SQLException
    {
        OptionsManager.getSingleton().setUsingTestDB(false);
        createResetPasswordTable();
        PasswordResetRowDataGateway.deleteExpiredRows();
    }
}

package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.PlayerLoginRowDataGateway;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

public class CommandChangePasswordTest
{
    @Test
    public void testChangePassword() throws DatabaseException
    {
        CommandChangePassword changePassword = new CommandChangePassword("John", "boop");
        changePassword.execute();

        PlayerLoginRowDataGateway afterGateway =
                new PlayerLoginRowDataGateway("John");
        assertTrue(afterGateway.checkPassword("boop"));

        CommandChangePlayer revertPassword = new CommandChangePlayer("John", "pw", 1);
        revertPassword.execute();
    }

}

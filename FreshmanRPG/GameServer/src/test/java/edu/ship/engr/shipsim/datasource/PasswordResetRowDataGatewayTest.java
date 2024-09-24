package edu.ship.engr.shipsim.datasource;

import edu.ship.engr.shipsim.testing.annotations.GameTest;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;

@GameTest("GameServer")
public class PasswordResetRowDataGatewayTest
{

    @Test
    public void CreateTable() throws DatabaseException
    {
        PasswordResetRowDataGateway.createTable();
    }
    @Test
    public void testCreateGateway() throws DatabaseException
    {
        PasswordResetRowDataGateway.createTable();
        PasswordResetRowDataGateway gateway =
                new PasswordResetRowDataGateway(1, 999999);
        assertEquals(gateway.getPlayerID(),1);
        assertEquals(gateway.getPasswordResetCode(), 999999);
        gateway.deleteCode();
    }

    @Test
    public void testGetResetCode() throws DatabaseException
    {
        PasswordResetRowDataGateway.createTable();
        PasswordResetRowDataGateway gateway =
                new PasswordResetRowDataGateway(1, 999999);
        PasswordResetRowDataGateway getter = new PasswordResetRowDataGateway(1);

        assertEquals(gateway.getPlayerID(), getter.getPlayerID());
        assertEquals(gateway.getPasswordResetCode(),
                getter.getPasswordResetCode());
        assertEquals(getter.getPasswordResetCode(), 999999);

        gateway.deleteCode();
    }
}

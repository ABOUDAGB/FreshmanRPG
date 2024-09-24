package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.PlayerLoginRowDataGateway;

import edu.ship.engr.shipsim.datasource.PlayerRowDataGateway;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

public class CommandChangePlayerTest
{
    @Test
    public void testChangePassword() throws DatabaseException
    {
        CommandChangePlayer changePassword = new CommandChangePlayer("John", "boop", 1);
        changePassword.execute();

        PlayerLoginRowDataGateway afterGateway =
                new PlayerLoginRowDataGateway("John");
        assertTrue(afterGateway.checkPassword("boop"));

        CommandChangePlayer revertPassword = new CommandChangePlayer("John", "pw", 1);
        revertPassword.execute();
    }

    @Test
    public void testChangeCrew() throws DatabaseException
    {
        PlayerRowDataGateway player = new PlayerRowDataGateway(1);
        assertEquals("Forty Percent", player.getCrew().getCrewName());

        //change player's crew to "Out Of Bounds"
        CommandChangePlayer changeCrew = new CommandChangePlayer("John", "boop", 2);
        changeCrew.execute();

        PlayerRowDataGateway player2 = new PlayerRowDataGateway(1);

        assertEquals(2, player2.getCrew().getID());
        assertEquals("Out Of Bounds", player2.getCrew().getCrewName());

        //change player's crew back to "Forty Percent"
        CommandChangePlayer revertCrew = new CommandChangePlayer("John", "boop", 1);
        revertCrew.execute();

        PlayerRowDataGateway player3 = new PlayerRowDataGateway(1);
        assertEquals("Forty Percent", player3.getCrew().getCrewName());

    }
}
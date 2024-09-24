package edu.ship.engr.shipsim.communication.messages;

import edu.ship.engr.shipsim.datatypes.PlayersForTest;
import edu.ship.engr.shipsim.testing.annotations.GameTest;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.Date;
import java.util.GregorianCalendar;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Tests time to level up deadline message
 *
 * @author Chris, Marty, and Evan
 */
@GameTest("GameShared")
public class TimeToLevelUpDeadlineTest
{

    /**
     * Tests of getters and setters
     */
    @Test
    public void testCreation()
    {
        LocalDate date = LocalDate.of(2016, 3, 4);
        TimeToLevelUpDeadlineMessage msg = new TimeToLevelUpDeadlineMessage(PlayersForTest.MARTY.getPlayerID(), false,
                LocalDate.of(2016, 3, 4), "freemerchant");
        assertEquals(18, msg.getRelevantPlayerID());
        assertEquals(date, msg.getTimeToDeadline());
        assertEquals("freemerchant", msg.getNextLevel());
    }

}

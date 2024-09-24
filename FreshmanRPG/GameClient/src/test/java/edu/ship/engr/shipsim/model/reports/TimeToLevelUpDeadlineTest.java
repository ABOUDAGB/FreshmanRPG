package edu.ship.engr.shipsim.model.reports;

import edu.ship.engr.shipsim.datatypes.PlayersForTest;
import edu.ship.engr.shipsim.testing.annotations.GameTest;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.Date;
import java.util.GregorianCalendar;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Tests time to level up deadline report
 *
 * @author Chris, Marty, and Evan
 */
@GameTest("GameClient")
public class TimeToLevelUpDeadlineTest
{

    /**
     * Tests of getters and setters
     */
    @Test
    public void testCreation()
    {
        LocalDate date = LocalDate.of(2016, 3, 4);
        ClientTimeToLevelUpDeadlineReport report = new ClientTimeToLevelUpDeadlineReport(PlayersForTest.MARTY.getPlayerID(), LocalDate.of(2016, 3, 4), "freemerchant");
        assertEquals(18, report.getPlayerID());
        assertEquals(date, report.getTimeToDeadline());
        assertEquals("freemerchant", report.getNextLevel());
    }


}

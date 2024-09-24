package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.DuplicateNameException;
import org.junit.jupiter.api.Test;


public class CommandSendMailTest
{
    @Test
    public void test() throws DuplicateNameException, DatabaseException
    {
        //Input your @ahip.edu username to hand test this command when running on the server
        Command command = new CommandSendMail("tp0227", 111111);
        command.execute();
    }
}

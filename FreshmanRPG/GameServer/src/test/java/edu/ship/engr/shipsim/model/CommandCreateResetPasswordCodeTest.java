package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.DuplicateNameException;
import edu.ship.engr.shipsim.datasource.PasswordResetRowDataGateway;
import edu.ship.engr.shipsim.model.reports.CreatePlayerResponseReport;
import edu.ship.engr.shipsim.model.reports.CreateResetPasswordCodeReport;
import edu.ship.engr.shipsim.model.reports.GetAllCrewsReport;
import edu.ship.engr.shipsim.model.reports.GetResetPasswordCodeReport;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

public class CommandCreateResetPasswordCodeTest
{
    @Test
    void testCreate() throws DuplicateNameException, DatabaseException
    {

        ReportObserver obs = mock(ReportObserver.class);
        ReportObserverConnector.getSingleton().registerObserver(obs,
                CreateResetPasswordCodeReport.class);

        CommandCreateResetPasswordCode command = new CommandCreateResetPasswordCode(1,111111);
        command.execute();
        PasswordResetRowDataGateway gateway = new PasswordResetRowDataGateway(1);
        gateway.deleteCode();

        verify(obs, times(1)).receiveReport(new CreateResetPasswordCodeReport(true));
    }
}

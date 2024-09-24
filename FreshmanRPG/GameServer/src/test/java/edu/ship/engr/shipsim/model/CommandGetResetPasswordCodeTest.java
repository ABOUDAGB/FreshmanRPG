package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.DuplicateNameException;
import edu.ship.engr.shipsim.datasource.ObjectiveRowDataGateway;
import edu.ship.engr.shipsim.datasource.ObjectiveTableDataGateway;
import edu.ship.engr.shipsim.datasource.PasswordResetRowDataGateway;
import edu.ship.engr.shipsim.datasource.PlayerLoginRowDataGateway;
import edu.ship.engr.shipsim.model.reports.GetAllCrewsReport;
import edu.ship.engr.shipsim.model.reports.GetAllPlayersScoreReport;
import edu.ship.engr.shipsim.model.reports.GetResetPasswordCodeReport;
import edu.ship.engr.shipsim.model.reports.ObjectiveDeletedReport;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import static nl.jqno.equalsverifier.internal.util.Assert.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

public class CommandGetResetPasswordCodeTest
{
    @Test
    public void testGetResetPasswordCommand()
            throws DatabaseException, DuplicateNameException
    {
        ReportObserver obs = mock(ReportObserver.class);
        ReportObserverConnector.getSingleton().registerObserver(obs,
                GetResetPasswordCodeReport.class);

        PasswordResetRowDataGateway gateway = new PasswordResetRowDataGateway(1, 999999);
        CommandGetResetPasswordCode command = new CommandGetResetPasswordCode(1);
        command.execute();

        gateway.deleteCode();

        verify(obs, times(1)).receiveReport(any(GetResetPasswordCodeReport.class));

    }
}

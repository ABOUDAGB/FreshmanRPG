package edu.ship.engr.shipsim.model.reports;

import edu.ship.engr.shipsim.model.Report;

public class GetResetPasswordCodeReport implements Report
{
    private final int resetPasswordCode;
    public GetResetPasswordCodeReport(int resetPasswordCode)
    {
        this.resetPasswordCode = resetPasswordCode;
    }


    public int getResetPasswordCode()
    {
        return resetPasswordCode;
    }
}

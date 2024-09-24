package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.DuplicateNameException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class CommandSendMail extends Command
{
    private final String playerName;
    private final int passwordResetCode;

    public CommandSendMail(String playerName, int passwordResetCode)
    {
        this.playerName = playerName;
        this.passwordResetCode = passwordResetCode;
    }

    @Override
    public void execute() throws DuplicateNameException, DatabaseException
    {
        try
        {
            /*
            Test this command using the CommandSendMailTest when on the rpg server. It will not work otherwise.
            Make sure to edit test with your username to send the email to yourself.
             */
            String command = "echo 'Your password reset code is: " + passwordResetCode + "' | mail -s \"Password Reset Code\" -a \"From: No-Reply@rpgserv.engr.ship.edu\" " + playerName + "@ship.edu";

            ProcessBuilder processBuilder = new ProcessBuilder(command);

            Process process = processBuilder.start();

            int exitCode = process.waitFor();
            System.out.println("Command exited with code: " + exitCode);

        }
        catch (IOException | InterruptedException e)
        {
            e.printStackTrace();
        }
    }
}

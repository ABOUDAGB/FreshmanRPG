package edu.ship.engr.shipsim.datasource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PasswordResetRowDataGateway
{
    private final int playerID;
    private final int passwordResetCode;
    private Connection connection;

    public PasswordResetRowDataGateway(int playerID, int passwordResetCode)
            throws DatabaseException
    {
        this.playerID = playerID;
        this.passwordResetCode = passwordResetCode;

        this.connection = DatabaseManager.getSingleton().getConnection();
        try(PreparedStatement stmt = connection.prepareStatement("INSERT INTO PasswordReset (playerID, passwordResetCode)\n" +
                "VALUES (?, ?)\n" +
                "ON DUPLICATE KEY UPDATE passwordResetCode = VALUES(passwordResetCode);\n"))
        {
            stmt.setInt(1, playerID);
            stmt.setInt(2, passwordResetCode);

            stmt.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new DatabaseException("Couldn't Create a Reset Code row with ID = " + playerID, e);
        }
    }

    public PasswordResetRowDataGateway(int playerID)
            throws DatabaseException
    {
        this.playerID = playerID;
        String getSql =
                "SELECT passwordResetCode FROM PasswordReset WHERE playerID =" +
                        " ?";

        this.connection = DatabaseManager.getSingleton().getConnection();
        try (PreparedStatement stmt = connection.prepareStatement(getSql))
        {
            stmt.setInt(1, playerID);
            try (ResultSet result = stmt.executeQuery())
            {
                result.next();
                this.passwordResetCode = result.getInt("passwordResetCode");
            }
        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Couldn't get a Reset Code row with ID = " + playerID, e);
        }
    }

    public static void createTable() throws DatabaseException
    {
        String dropSql = "DROP TABLE IF EXISTS PasswordReset";
        String createSql = "CREATE TABLE PasswordReset (" +
                "playerID INT PRIMARY KEY, " +
                "passwordResetCode INT, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
//                "FOREIGN KEY (playerID) REFERENCES Players(playerID) ON DELETE CASCADE)";


        Connection connection = DatabaseManager.getSingleton().getConnection();

        try (PreparedStatement stmt = connection.prepareStatement(dropSql))
        {
            stmt.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new DatabaseException("Unable to delete PasswordReset table", e);
        }

        try (PreparedStatement stmt = connection.prepareStatement(createSql))
        {
            stmt.execute();
        }
        catch (SQLException e)
        {
            throw new DatabaseException("Unable to create PasswordReset table", e);
        }
    }

    public static void deleteExpiredRows() throws DatabaseException
    {
        String dropSql = "DROP EVENT IF EXISTS DeleteExpiredRows";
        String createEventSql = "CREATE EVENT DeleteExpiredRows " +
                "ON SCHEDULE EVERY 1 MINUTE " +
                "DO " +
                "BEGIN " +
                "    DELETE FROM PasswordReset WHERE created_at < NOW() - INTERVAL 2 MINUTE; " +
                "END";


        Connection connection = DatabaseManager.getSingleton().getConnection();

        try (PreparedStatement stmt = connection.prepareStatement(dropSql))
        {
            stmt.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new DatabaseException("Unable to drop event", e);
        }

        try (PreparedStatement stmt = connection.prepareStatement(createEventSql))
        {
            stmt.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new DatabaseException("Unable to create event", e);
        }
    }



    public int getPlayerID()
    {
        return playerID;
    }

    public int getPasswordResetCode()
    {
        return passwordResetCode;
    }

    public void deleteCode() throws DatabaseException
    {
        this.connection = DatabaseManager.getSingleton().getConnection();

        try (PreparedStatement stmt = connection.prepareStatement("DELETE from PasswordReset where playerID = ?"))
        {
            stmt.setInt(1, playerID);
            stmt.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new DatabaseException("Unable to delete password reset row with id of: " + playerID, e);
        }
    }
}

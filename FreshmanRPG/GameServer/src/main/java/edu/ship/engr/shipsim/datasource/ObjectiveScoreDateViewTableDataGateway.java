package edu.ship.engr.shipsim.datasource;

import edu.ship.engr.shipsim.dataDTO.ObjectiveStateRecordDTO;
import edu.ship.engr.shipsim.dataDTO.PlayerWeeklyScoreDTO;
import edu.ship.engr.shipsim.datatypes.ObjectiveStateEnum;
import edu.ship.engr.shipsim.model.ObjectiveRecord;

import javax.xml.crypto.Data;
import java.sql.Connection;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;

public class ObjectiveScoreDateViewTableDataGateway
{

    private static ObjectiveScoreDateViewTableDataGateway singleton;

    private ObjectiveScoreDateViewTableDataGateway()
    {
        //do nothing, this just explicitly makes it private
    }

    public static void createView() throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();

        String dropSql = "DROP VIEW IF EXISTS ObjectiveScoreDate";
        String createSql =
                "Create VIEW ObjectiveScoreDate " +
                        "as SELECT c.playerID, c.playerName, d.crew, " +
                        "a.questID, a.objectiveID, a.experiencePointsGained, b.dateCompleted " +
                        "FROM Objectives a, ObjectiveStates b, PlayerLogins c, Players d " +
                        " " +
                        "WHERE a.objectiveID = b.objectiveID " +
                        "AND b.objectiveState = 2 " +
                        "AND a.questID = b.questID " +
                        "AND b.playerID = c.playerID " +
                        "AND b.playerID = d.playerID ";
        try (PreparedStatement stmt = connection.prepareStatement(dropSql))
        {
            stmt.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Unable to drop ObjectiveScoreDate view", e);
        }

        try (PreparedStatement stmt = connection.prepareStatement(createSql))
        {
            stmt.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Unable to create ObjectiveScoreDate view", e);
        }
    }

    public static ObjectiveScoreDateViewTableDataGateway getSingleton()
    {
        if (singleton == null)
        {
            singleton = new ObjectiveScoreDateViewTableDataGateway();
        }
        return singleton;
    }

    public int getPlayerScoreByDate(int playerID, LocalDate startDate,
                                           LocalDate endDate)
            throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM ObjectiveScoreDate WHERE (playerID = ? and " +
                        "dateCompleted >= ?) and dateCompleted <= ?"))
        {

            stmt.setInt(1, playerID);
            stmt.setDate(2, Date.valueOf(startDate));
            stmt.setDate(3, Date.valueOf(endDate));

            try (ResultSet result = stmt.executeQuery())
            {
                int weeklyScore = 0;
                while (result.next())
                {
                    weeklyScore = weeklyScore +
                            result.getInt("experiencePointsGained");
                }
                return weeklyScore;
            }
        }
        catch (SQLException e)
        {
            throw new RuntimeException(e);
        }
    }

    public ArrayList<PlayerWeeklyScoreDTO> getWeeklyScores(LocalDate start,
                                                                  LocalDate end)
            throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT DISTINCT playerID, playerName FROM ObjectiveScoreDate " +
                        " WHERE dateCompleted >= ? and dateCompleted <= ?"))
        {
            stmt.setDate(1, Date.valueOf(start));
            stmt.setDate(2, Date.valueOf(end));

            try (ResultSet queryResult = stmt.executeQuery())
            {
                ArrayList<PlayerWeeklyScoreDTO> results = new ArrayList<>();

                while (queryResult.next())
                {
                    int id = queryResult.getInt("playerID");
                    String playerName = queryResult.getString("playerName");

                    PlayerWeeklyScoreDTO weeklyScoreDTO =
                            new PlayerWeeklyScoreDTO(id,
                                    playerName,
                                    getPlayerScoreByDate(id, start, end));
                    results.add(weeklyScoreDTO);
                }
                return results;
            }
        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Couldn't find objective scores", e);
        }
    }

    public ArrayList<PlayerWeeklyScoreDTO> getWeeklyScoresByCrew(int playerID, LocalDate start,
                                                           LocalDate end)
            throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT DISTINCT playerID, playerName FROM ObjectiveScoreDate o " +
                        "WHERE o.crew = (SELECT crew FROM ObjectiveScoreDate WHERE playerID = ? LIMIT 1) " +
                        "AND dateCompleted >= ? and dateCompleted <= ? "))
        {
            stmt.setInt(1, playerID);
            stmt.setDate(2, Date.valueOf(start));
            stmt.setDate(3, Date.valueOf(end));

            try (ResultSet queryResult = stmt.executeQuery())
            {
                ArrayList<PlayerWeeklyScoreDTO> results = new ArrayList<>();

                while (queryResult.next())
                {
                    int id = queryResult.getInt("playerID");
                    String playerName = queryResult.getString("playerName");

                    PlayerWeeklyScoreDTO weeklyScoreDTO =
                            new PlayerWeeklyScoreDTO(id,
                                    playerName,
                                    getPlayerScoreByDate(id, start, end));
                    results.add(weeklyScoreDTO);
                }
                return results;
            }
        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Couldn't find objective scores", e);
        }
    }

    public void setSingleton(ObjectiveScoreDateViewTableDataGateway singleton)
    {
        this.singleton = singleton;
    }
}

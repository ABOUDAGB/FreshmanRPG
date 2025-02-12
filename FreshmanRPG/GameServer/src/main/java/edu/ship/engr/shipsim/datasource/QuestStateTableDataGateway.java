package edu.ship.engr.shipsim.datasource;

import edu.ship.engr.shipsim.dataDTO.QuestStateRecordDTO;
import edu.ship.engr.shipsim.datatypes.QuestStateEnum;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * The RDS implementation of the gateway
 *
 * @author Merlin
 */
public class QuestStateTableDataGateway
{
    private static QuestStateTableDataGateway singleton;

    /**
     * A private constructor only called by the getSingleton method
     */
    private QuestStateTableDataGateway()
    {
        //do nothing this just explicitly makes it private
    }

    public static QuestStateTableDataGateway getSingleton()
    {
        if (singleton == null)
        {
            singleton = new QuestStateTableDataGateway();
        }
        return singleton;
    }

    /**
     * Add a new row to the table
     *
     * @param playerID            the player
     * @param questID             the quest
     * @param state               the player's state in that quest
     * @param needingNotification true if the player should be notified about
     *                            this state
     * @throws DatabaseException if we can't talk to the RDS server
     */
    public void createRow(int playerID, int questID, QuestStateEnum state,
                          boolean needingNotification)
            throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();
        checkForDuplicateEntry(playerID, questID);
        try (PreparedStatement stmt = connection.prepareStatement(
                "Insert INTO QuestStates SET playerID = ?, questID = ?, " +
                        "questState = ?, needingNotification = ?"))
        {
            stmt.setInt(1, playerID);
            stmt.setInt(2, questID);
            stmt.setInt(3, state.getID());
            stmt.setBoolean(4, needingNotification);
            stmt.executeUpdate();

        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Couldn't create a quest state record for player with ID " +
                            playerID
                            + " and quest with ID " + questID, e);
        }
    }


    public void createDateRow(int playerID, int questID, QuestStateEnum state,
                              boolean needingNotification,
                              LocalDate dateCompleted)
            throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();
        checkForDuplicateEntry(playerID, questID);
        try (PreparedStatement stmt = connection.prepareStatement(
                "Insert INTO QuestStates SET playerID = ?, questID = ?, " +
                        "questState = ?, needingNotification = ?, " +
                        "dateCompleted = ?"))
        {
            stmt.setInt(1, playerID);
            stmt.setInt(2, questID);
            stmt.setInt(3, state.getID());
            stmt.setBoolean(4, needingNotification);
            stmt.setDate(5, Date.valueOf(dateCompleted));
            stmt.executeUpdate();

        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Couldn't create a quest state record for player with ID " +
                            playerID
                            + " and quest with ID " + questID, e);
        }
    }


    /**
     * Drop the table if it exists and re-create it empty
     *
     * @throws DatabaseException shouldn't
     */
    public void createTable() throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();

        try (PreparedStatement stmt = connection.prepareStatement(
                "DROP TABLE IF EXISTS QuestStates"))
        {
            stmt.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new DatabaseException("Unable to drop QuestStates table", e);
        }

        try (PreparedStatement stmt = connection.prepareStatement(
                "Create TABLE QuestStates (playerID INT NOT NULL, questID INT" +
                        " NOT NULL , questState INT NOT NULL, " +
                        "needingNotification BOOLEAN NOT NULL, dateCompleted " +
                        "DATE)"))
        {
            stmt.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new DatabaseException("Unable to create QuestStates table",
                    e);
        }
    }

    public ArrayList<QuestStateRecordDTO> getQuestStates(int playerID)
            throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM QuestStates WHERE playerID = ?"))
        {
            stmt.setInt(1, playerID);

            try (ResultSet result = stmt.executeQuery())
            {
                ArrayList<QuestStateRecordDTO> results = new ArrayList<>();
                while (result.next())
                {
                    if (result.getDate("dateCompleted") == null)
                    {
                        QuestStateRecordDTO rec =
                                new QuestStateRecordDTO(
                                        result.getInt("playerID"),
                                        result.getInt("questID"),
                                        convertToState(
                                                result.getInt("QuestState")),
                                        result.getBoolean(
                                                "needingNotification"),
                                        null);
                        results.add(rec);
                    }
                    else
                    {
                        QuestStateRecordDTO rec =
                                new QuestStateRecordDTO(
                                        result.getInt("playerID"),
                                        result.getInt("questID"),
                                        convertToState(
                                                result.getInt("QuestState")),
                                        result.getBoolean(
                                                "needingNotification"),
                                        result.getDate("dateCompleted")
                                                .toLocalDate());
                        results.add(rec);
                    }

                }
                return results;
            }
        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Couldn't find QuestStates record for player with " +
                            "playerID " +
                            playerID, e);
        }
    }

    /**
     * Returns a list of all quest
     *
     * @throws DatabaseException shouldn't
     */
    public ArrayList<QuestStateRecordDTO> retrieveAllQuestStates()
            throws DatabaseException
    {
        ArrayList<QuestStateRecordDTO> listOfQuestStates = new ArrayList<>();
        Connection connection = DatabaseManager.getSingleton().getConnection();
        try (PreparedStatement stmt = connection.prepareStatement(
                "select * from QuestStates");
             ResultSet rs = stmt.executeQuery())
        {
            HashMap<Integer, QuestStateEnum> recordMap = new HashMap<>();
            for (QuestStateEnum value : QuestStateEnum.values())
            {
                recordMap.put(value.getID(), value);
            }

            while (rs.next())
            {
                int playerID = rs.getInt("playerID");
                int questID = rs.getInt("questID");
                int questStateID = rs.getInt("questState");
                boolean needingNotification =
                        rs.getBoolean("needingNotification");
                LocalDate dateCompleted = null;
                if (rs.getDate("dateCompleted") != null)
                {
                    dateCompleted = rs.getDate("dateCompleted").toLocalDate();
                }

                QuestStateRecordDTO questStateRecord =
                        new QuestStateRecordDTO(playerID, questID,
                                recordMap.get(questStateID),
                                needingNotification,
                                dateCompleted);
                listOfQuestStates.add(questStateRecord);
            }
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        return listOfQuestStates;
    }

    public void updateState(int playerID, int questID, QuestStateEnum newState,
                            boolean needingNotification)
            throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();
        try (PreparedStatement stmt = connection.prepareStatement(
                "UPDATE QuestStates SET dateCompleted = ?, questState = ?, " +
                        "needingNotification = ? WHERE  playerID = ? and " +
                        "questID = ?"))
        {
            LocalDate date = LocalDate.now();

            if (newState == QuestStateEnum.COMPLETED ||
                    newState == QuestStateEnum.FULFILLED)
            {
                stmt.setDate(1, Date.valueOf(date));
            }
            else
            {
                stmt.setDate(1, null);
            }
            stmt.setInt(2, newState.getID());
            stmt.setBoolean(3, needingNotification);
            stmt.setInt(4, playerID);
            stmt.setInt(5, questID);
            int count = stmt.executeUpdate();
            if (count == 0)
            {
                this.createRow(playerID, questID, newState,
                        needingNotification);
                this.updateState(playerID, questID, newState,
                        needingNotification);
            }
        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Couldn't update a quest state record for player with ID " +
                            playerID
                            + " and quest with ID " + questID, e);
        }

    }

    private void checkForDuplicateEntry(int playerID, int questID)
            throws DatabaseException
    {
        Connection connection = DatabaseManager.getSingleton().getConnection();
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM QuestStates WHERE playerID = ? and questID = ?"))
        {
            stmt.setInt(1, playerID);
            stmt.setInt(2, questID);

            try (ResultSet result = stmt.executeQuery())
            {
                if (result.next())
                {
                    throw new DatabaseException(
                            "Duplicate quest state for player ID " + playerID +
                                    " and quest id " + questID);
                }
            }

        }
        catch (SQLException e)
        {
            throw new DatabaseException(
                    "Couldn't find quests for player ID " + playerID,
                    e);
        }
    }

    private QuestStateEnum convertToState(int int1)
    {
        return QuestStateEnum.values()[int1];
    }


}

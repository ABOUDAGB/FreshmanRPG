package edu.ship.engr.shipsim.DatabaseBuilders;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.ObjectiveScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.datasource.QuestScoreDateViewTableDataGateway;
import edu.ship.engr.shipsim.model.OptionsManager;

import java.sql.SQLException;

public class BuildDateViews
{
    private static void createObjectiveScoreDateView() throws DatabaseException
    {
        ObjectiveScoreDateViewTableDataGateway.createView();
    }

    private static void createQuestScoreDateView() throws DatabaseException
    {
        QuestScoreDateViewTableDataGateway.createView();
    }

    public static void main(String[] args) throws DatabaseException,
            SQLException
    {
        OptionsManager.getSingleton().setUsingTestDB(false);
        System.out.println("creating ObjectiveScoreDate view");
        createObjectiveScoreDateView();
        System.out.println("creating QuestScoreDate view");
        createQuestScoreDateView();
    }
}

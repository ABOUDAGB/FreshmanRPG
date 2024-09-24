package edu.ship.engr.shipsim.datasource;

import edu.ship.engr.shipsim.criteria.ObjectiveCompletionCriteria;
import edu.ship.engr.shipsim.dataDTO.PlayerDTO;
import edu.ship.engr.shipsim.dataDTO.PlayerWeeklyScoreDTO;
import edu.ship.engr.shipsim.dataENUM.ObjectiveCompletionType;
import edu.ship.engr.shipsim.datatypes.ObjectiveStateEnum;
import edu.ship.engr.shipsim.datatypes.ObjectiveStatesForTest;
import edu.ship.engr.shipsim.datatypes.ObjectivesForTest;
import org.junit.jupiter.api.Test;

import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

public class ObjectiveScoreDateViewTableDataGatewayTest
{

    @Test
    void createView() throws DatabaseException
    {
        ObjectiveScoreDateViewTableDataGateway.createView();
    }

    @Test
    void getWeeklyScore() throws DatabaseException
    {
        ObjectiveScoreDateViewTableDataGateway.createView();

        ObjectiveStateTableDataGateway state =
                ObjectiveStateTableDataGateway.getSingleton();

        ObjectivesForTest objectiveTest = ObjectivesForTest.OBJ_SCORE_Q112_O2;

        state.updateState(41, objectiveTest.getQuestID(),
                objectiveTest.getObjectiveID(), ObjectiveStateEnum.COMPLETED,
                false);

        ObjectiveScoreDateViewTableDataGateway gateway =
                ObjectiveScoreDateViewTableDataGateway.getSingleton();

        LocalDate start = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
        LocalDate end = LocalDate.now();

        int result =
                gateway.getPlayerScoreByDate(41,
                        start, end);

        assertEquals(3, result);

        state.updateState(41, objectiveTest.getQuestID(),
                objectiveTest.getObjectiveID(), ObjectiveStateEnum.TRIGGERED,
                false);

    }

    @Test
    void getWeeklyScoreMultipleObjectives() throws DatabaseException
    {
        ObjectiveScoreDateViewTableDataGateway.createView();

        ObjectiveStateTableDataGateway state =
                ObjectiveStateTableDataGateway.getSingleton();

        ObjectivesForTest objTest = ObjectivesForTest.OBJ_SCORE_Q112_O1;
        ObjectivesForTest objTest2 = ObjectivesForTest.OBJ_SCORE_Q112_O3;


        state.updateState(42, objTest.getQuestID(), objTest.getObjectiveID(),
                ObjectiveStateEnum.COMPLETED, false);
        state.updateState(42, objTest2.getQuestID(), objTest2.getObjectiveID(),
                ObjectiveStateEnum.COMPLETED, false);

        ObjectiveScoreDateViewTableDataGateway gateway =
                ObjectiveScoreDateViewTableDataGateway.getSingleton();

        LocalDate start = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
        LocalDate end = LocalDate.now();

        int result =
                gateway.getPlayerScoreByDate(42,
                        start, end);

        assertEquals(6, result);

        state.updateState(42, objTest.getQuestID(),
                objTest.getObjectiveID(), ObjectiveStateEnum.TRIGGERED, false);
        state.updateState(42, objTest2.getQuestID(), objTest2.getObjectiveID(),
                ObjectiveStateEnum.TRIGGERED, false);
    }


    @Test
    public void testWeeklyScores() throws DatabaseException
    {
        ObjectiveScoreDateViewTableDataGateway.createView();

        ObjectiveStateTableDataGateway state =
                ObjectiveStateTableDataGateway.getSingleton();

        ObjectivesForTest objTest = ObjectivesForTest.OBJ_SCORE_Q112_O1;
        ObjectivesForTest objTest2 = ObjectivesForTest.OBJ_SCORE_Q112_O2;
        ObjectivesForTest objTest3 = ObjectivesForTest.OBJ_SCORE_Q114_O2; //2


        state.updateState(43, objTest.getQuestID(), objTest.getObjectiveID(),
                ObjectiveStateEnum.COMPLETED, false);
        state.updateState(44, objTest2.getQuestID(), objTest2.getObjectiveID(),
                ObjectiveStateEnum.COMPLETED, false);
        state.updateState(45, objTest3.getQuestID(), objTest3.getObjectiveID(),
                ObjectiveStateEnum.COMPLETED, false);


        ObjectiveScoreDateViewTableDataGateway gateway =
                ObjectiveScoreDateViewTableDataGateway.getSingleton();

        LocalDate start = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
        LocalDate end = LocalDate.now();

        ArrayList<PlayerWeeklyScoreDTO> list =
                gateway.getWeeklyScores(start,
                        end);

        assertEquals(41, list.get(0).getPlayerID());
        assertEquals(1, list.get(0).getWeeklyScore());

        assertEquals(42, list.get(1).getPlayerID());
        assertEquals(2, list.get(1).getWeeklyScore());

        assertEquals(43, list.get(2).getPlayerID());
        assertEquals(4, list.get(2).getWeeklyScore());

        state.updateState(43, objTest.getQuestID(), objTest.getObjectiveID(),
                ObjectiveStateEnum.TRIGGERED, false);
        state.updateState(44, objTest2.getQuestID(), objTest2.getObjectiveID(),
                ObjectiveStateEnum.TRIGGERED, false);
        state.updateState(45, objTest3.getQuestID(), objTest3.getObjectiveID(),
                ObjectiveStateEnum.TRIGGERED, false);



    }

    @Test
    public void testWeeklyScoresByCrew() throws DatabaseException
    {
        ObjectiveScoreDateViewTableDataGateway.createView();

        ObjectiveStateTableDataGateway state =
                ObjectiveStateTableDataGateway.getSingleton();

        ObjectivesForTest objTest = ObjectivesForTest.OBJ_SCORE_Q112_O1; //1
        ObjectivesForTest objTest2 = ObjectivesForTest.OBJ_SCORE_Q113_O2; //2
        ObjectivesForTest objTest3 = ObjectivesForTest.OBJ_SCORE_Q114_O1; //1


        state.updateState(46, objTest.getQuestID(), objTest.getObjectiveID(),
                ObjectiveStateEnum.COMPLETED, false);
        state.updateState(47, objTest2.getQuestID(), objTest2.getObjectiveID(),
                ObjectiveStateEnum.COMPLETED, false);
        state.updateState(49, objTest3.getQuestID(), objTest3.getObjectiveID(),
                ObjectiveStateEnum.COMPLETED, false);

        ObjectiveScoreDateViewTableDataGateway gateway =
                ObjectiveScoreDateViewTableDataGateway.getSingleton();

        LocalDate start = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
        LocalDate end = LocalDate.now();

        ArrayList<PlayerWeeklyScoreDTO> list =
                gateway.getWeeklyScoresByCrew(46, start,
                        end);


        assertEquals(45, list.get(0).getPlayerID());
        assertEquals(1, list.get(0).getWeeklyScore());

        assertEquals(46, list.get(1).getPlayerID());
        assertEquals(3, list.get(1).getWeeklyScore());
        assertEquals(5, list.size());

        state.updateState(46, objTest.getQuestID(), objTest.getObjectiveID(),
                ObjectiveStateEnum.TRIGGERED, false);
        state.updateState(47, objTest2.getQuestID(), objTest2.getObjectiveID(),
                ObjectiveStateEnum.TRIGGERED, false);
        state.updateState(49, objTest3.getQuestID(), objTest3.getObjectiveID(),
                ObjectiveStateEnum.TRIGGERED, false);
    }

}
package edu.ship.engr.shipsim.datasource;

import edu.ship.engr.shipsim.criteria.GameLocationDTO;
import edu.ship.engr.shipsim.criteria.QuestCompletionActionParameter;
import edu.ship.engr.shipsim.dataDTO.PlayerWeeklyScoreDTO;
import edu.ship.engr.shipsim.dataENUM.ObjectiveCompletionType;
import edu.ship.engr.shipsim.dataENUM.QuestCompletionActionType;
import edu.ship.engr.shipsim.datatypes.ObjectiveStateEnum;
import edu.ship.engr.shipsim.datatypes.Position;
import edu.ship.engr.shipsim.datatypes.QuestStateEnum;
import edu.ship.engr.shipsim.datatypes.QuestsForTest;
import org.junit.jupiter.api.Test;

import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;

import static org.junit.jupiter.api.Assertions.*;

public class QuestScoreDateViewTableDataGatewayTest
{

    LocalDate start = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
    LocalDate end = LocalDate.now();

    @Test
    void createView() throws DatabaseException
    {
        QuestScoreDateViewTableDataGateway.createView();
    }

    @Test
    void getWeeklyScore() throws DatabaseException
    {
        QuestScoreDateViewTableDataGateway.createView();

        QuestStateTableDataGateway state =
                QuestStateTableDataGateway.getSingleton();


        QuestsForTest quest = QuestsForTest.QUEST_SCORE_DATE;

        state.updateState(41, quest.getQuestID(), QuestStateEnum.FULFILLED,
                false);


        QuestScoreDateViewTableDataGateway gateway = QuestScoreDateViewTableDataGateway.getSingleton();
        int result =
                gateway.getPlayerScoreByDate(41,
                        start, end);

        assertEquals(3, result);

        //This removes the row from the view
        state.updateState(41, quest.getQuestID(), QuestStateEnum.TRIGGERED,
                false);

    }

    @Test
    void getWeeklyScoreMultipleQuests() throws DatabaseException
    {
        QuestScoreDateViewTableDataGateway.createView();

        QuestStateTableDataGateway state =
                QuestStateTableDataGateway.getSingleton();


        QuestsForTest q1 = QuestsForTest.QUEST_SCORE_DATE;
        QuestsForTest q2 = QuestsForTest.QUEST_SCORE_DATE2;
        QuestsForTest q3 = QuestsForTest.QUEST_SCORE_DATE3;


        state.updateState(41, q1.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(41, q2.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(41, q3.getQuestID(), QuestStateEnum.FULFILLED, false);



        QuestScoreDateViewTableDataGateway gateway = QuestScoreDateViewTableDataGateway.getSingleton();
        int result =
                gateway.getPlayerScoreByDate(41,
                        start, end);

        assertEquals(12, result);

        //This removes the rows from the view
        state.updateState(41, q1.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(41, q2.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(41, q3.getQuestID(), QuestStateEnum.TRIGGERED, false);
    }


    @Test
    public void testWeeklyScores() throws DatabaseException
    {
        QuestScoreDateViewTableDataGateway.createView();

        QuestStateTableDataGateway state =
                QuestStateTableDataGateway.getSingleton();


        QuestsForTest q1 = QuestsForTest.QUEST_SCORE_DATE;  //3
        QuestsForTest q2 = QuestsForTest.QUEST_SCORE_DATE2; //4
        QuestsForTest q3 = QuestsForTest.QUEST_SCORE_DATE3; //5


        state.updateState(41, q1.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(41, q2.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(41, q3.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(42, q1.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(42, q2.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(43, q1.getQuestID(), QuestStateEnum.FULFILLED, false);


        QuestScoreDateViewTableDataGateway gateway = QuestScoreDateViewTableDataGateway.getSingleton();
        ArrayList<PlayerWeeklyScoreDTO> list =
                gateway.getWeeklyScores(start,
                        end);

        // Pleyers that are not 41, 42, 43 have previously completed quests
        assertEquals(44, list.get(0).getPlayerID());
        assertEquals(3, list.get(0).getWeeklyScore());

        assertEquals(45, list.get(1).getPlayerID());
        assertEquals(4, list.get(1).getWeeklyScore());

        assertEquals(46, list.get(2).getPlayerID());
        assertEquals(4, list.get(2).getWeeklyScore());

        assertEquals(47, list.get(3).getPlayerID());
        assertEquals(5, list.get(3).getWeeklyScore());

        assertEquals(48, list.get(4).getPlayerID());
        assertEquals(5, list.get(4).getWeeklyScore());

        assertEquals(49, list.get(5).getPlayerID());
        assertEquals(5, list.get(5).getWeeklyScore());

        assertEquals(41, list.get(6).getPlayerID());
        assertEquals(12, list.get(6).getWeeklyScore());

        assertEquals(42, list.get(7).getPlayerID());
        assertEquals(7, list.get(7).getWeeklyScore());

        assertEquals(43, list.get(8).getPlayerID());
        assertEquals(3, list.get(8).getWeeklyScore());

        //This removes the row from the view
        state.updateState(41, q1.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(41, q2.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(41, q3.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(42, q1.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(42, q2.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(43, q1.getQuestID(), QuestStateEnum.TRIGGERED, false);

    }


    @Test
    public void testWeeklyScoresByCrew() throws DatabaseException
    {
        QuestScoreDateViewTableDataGateway.createView();

        QuestStateTableDataGateway state =
                QuestStateTableDataGateway.getSingleton();


        QuestsForTest q1 = QuestsForTest.QUEST_SCORE_DATE;  //3
        QuestsForTest q2 = QuestsForTest.QUEST_SCORE_DATE2; //4
        QuestsForTest q3 = QuestsForTest.QUEST_SCORE_DATE3; //5

        state.updateState(41, q1.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(42, q1.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(42, q2.getQuestID(), QuestStateEnum.FULFILLED, false);
        state.updateState(46, q3.getQuestID(), QuestStateEnum.FULFILLED, false);



        QuestScoreDateViewTableDataGateway gateway = QuestScoreDateViewTableDataGateway.getSingleton();
        ArrayList<PlayerWeeklyScoreDTO> list =
                gateway.getWeeklyScoresByCrew(42, start,
                        end);

        // Pleyers that are not 41, 42, 43 have previously completed quests
        assertEquals(44, list.get(0).getPlayerID());
        assertEquals(3, list.get(0).getWeeklyScore());

        assertEquals(49, list.get(1).getPlayerID());
        assertEquals(5, list.get(1).getWeeklyScore());

        assertEquals(41, list.get(2).getPlayerID());
        assertEquals(3, list.get(2).getWeeklyScore());

        assertEquals(42, list.get(3).getPlayerID());
        assertEquals(7, list.get(3).getWeeklyScore());

        assertEquals(4, list.size());

        //This removes the row from the view
        state.updateState(41, q1.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(42, q1.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(42, q2.getQuestID(), QuestStateEnum.TRIGGERED, false);
        state.updateState(46, q3.getQuestID(), QuestStateEnum.TRIGGERED, false);


    }
}
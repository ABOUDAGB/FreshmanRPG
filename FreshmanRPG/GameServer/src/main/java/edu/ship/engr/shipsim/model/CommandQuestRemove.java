package edu.ship.engr.shipsim.model;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.model.reports.QuestRemoveReport;

public class CommandQuestRemove extends Command
{
    private final QuestRecord questRecord;

    public CommandQuestRemove(QuestRecord questRecord)
    {
        this.questRecord = questRecord;
    }

    @Override
    void execute()
    {
        try
        {
            boolean found = false;
            QuestMapper mapper;
            try
            {
                mapper = new QuestMapper(questRecord.getQuestID());
                found = true;
            }
            catch (DatabaseException ignored)
            {
                ignored.printStackTrace();
                mapper = null;
            }

            if (found)
            {
                // remove the quest from the database
                mapper.remove();
            }
        }
        catch (DatabaseException e)
        {
            // This should not happen because we create a new quest if it doesn't exist
            ReportObserverConnector.getSingleton().sendReport(
                    new QuestRemoveReport(false,
                            "Database Failed to Remove Quest."));
        }

        ReportObserverConnector.getSingleton()
                .sendReport(new QuestRemoveReport(true));
    }
}

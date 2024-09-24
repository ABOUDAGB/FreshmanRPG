package edu.ship.engr.shipsim.model.reports;

import edu.ship.engr.shipsim.dataDTO.QuestionDTO;
import edu.ship.engr.shipsim.model.Report;
import lombok.Data;

import java.util.ArrayList;

@Data
public class GetAllQuestionsReport implements Report
{
    private final ArrayList<QuestionDTO> questions;

    public GetAllQuestionsReport(ArrayList<QuestionDTO> questions)
    {
        this.questions = questions;
    }
}

package edu.ship.engr.shipsim.datatypes;

import edu.ship.engr.shipsim.dataDTO.QuestionDTO;
import lombok.Getter;

import java.time.LocalDate;

/**
 * Create test questions for the DB.
 *
 * @author gl9859
 */
@Getter
public enum QuestionsForTest
{
    /**
     *
     */

    ONE(1, "First question", "First answer", LocalDate.of(2014, 2, 11), LocalDate.of(9999, 3, 21)),

    /**
     *
     */
    TWO(2, "Second question", "Second answer", LocalDate.of(2014, 2, 11), LocalDate.of(9999, 2, 11)),

    /**
     *
     */
    MULTIPLE_CHOICE(3, "Would you like to pick A for correct answer?\nA. First Choice\nB. Second Choice\nC. Third Choice\nD. Fourth Choice\n", "A", LocalDate.of(2015, 2, 11), LocalDate.of(9999, 3, 28)),

    /**
     *
     */
    FOUR(4, "Third question", "Third answer", LocalDate.of(2014, 2, 11), LocalDate.of(9999, 2, 11)),

    /**
     * This question should never be seen in game
     */
    NOT_POSSIBLE(5, "YOU SHOULDN'T SEE ME, answer: 'tell someone'", "tell someone", LocalDate.of(9999, 2, 11), LocalDate.of(9999, 2, 11));

    private final String q;

    private final String a;

    private final int questionID;

    private final LocalDate startDate;

    private final LocalDate endDate;

    /**
     * Constructor
     *
     * @param questionID this question's unique ID
     * @param q          question
     * @param a          answer
     * @param startDate  first day the question is available
     * @param endDate    last day the question is available
     */
    QuestionsForTest(int questionID, String q, String a, LocalDate startDate, LocalDate endDate)
    {
        this.questionID = questionID;
        this.q = q;
        this.a = a;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public QuestionDTO getQuestionDTO()
    {
        return new QuestionDTO(questionID,q,a,startDate,endDate);
    }
}

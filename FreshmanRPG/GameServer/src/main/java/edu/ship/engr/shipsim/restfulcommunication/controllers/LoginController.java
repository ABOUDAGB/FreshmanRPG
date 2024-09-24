package edu.ship.engr.shipsim.restfulcommunication.controllers;

import edu.ship.engr.shipsim.datasource.DatabaseException;
import edu.ship.engr.shipsim.datasource.DuplicateNameException;
import edu.ship.engr.shipsim.datasource.LoggerManager;
import edu.ship.engr.shipsim.datasource.PasswordResetRowDataGateway;
import edu.ship.engr.shipsim.datasource.PlayerLoginRowDataGateway;
import edu.ship.engr.shipsim.model.CommandCreateResetPasswordCode;
import edu.ship.engr.shipsim.model.CommandGetResetPasswordCode;
import edu.ship.engr.shipsim.model.CommandRestfulLogin;
import edu.ship.engr.shipsim.model.CommandRestfulLogout;
import edu.ship.engr.shipsim.model.CommandSendMail;
import edu.ship.engr.shipsim.model.ModelFacade;
import edu.ship.engr.shipsim.model.Player;
import edu.ship.engr.shipsim.model.PlayerManager;
import edu.ship.engr.shipsim.model.PlayerNotFoundException;
import edu.ship.engr.shipsim.model.Report;
import edu.ship.engr.shipsim.model.reports.CreateResetPasswordCodeReport;
import edu.ship.engr.shipsim.model.reports.GetResetPasswordCodeReport;
import edu.ship.engr.shipsim.model.reports.RestfulLoginFailedReport;
import edu.ship.engr.shipsim.model.reports.RestfulLoginSuccessReport;
import edu.ship.engr.shipsim.model.reports.RestfulLogoutFailedReport;
import edu.ship.engr.shipsim.model.reports.RestfulLogoutSuccessReport;
import edu.ship.engr.shipsim.restfulcommunication.RestfulPlayerManager;
import edu.ship.engr.shipsim.restfulcommunication.RestfulServer;
import edu.ship.engr.shipsim.restfulcommunication.representation.BasicResponse;
import edu.ship.engr.shipsim.restfulcommunication.representation.GeneratedCodeInformation;
import edu.ship.engr.shipsim.restfulcommunication.representation.LoginInformation;
import edu.ship.engr.shipsim.restfulcommunication.representation.LoginResponse;
import edu.ship.engr.shipsim.restfulcommunication.representation.LogoutInformation;
import edu.ship.engr.shipsim.restfulcommunication.representation.UserNameInformation;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import static com.badlogic.gdx.math.MathUtils.random;

/**
 * @author Derek
 */
@RestController
public class LoginController extends Controller
{
    @PostMapping("/login")
    public ResponseEntity<Object> login(@RequestBody LoginInformation info)
    {
        // Temporary fix for autoclosing the connection
        try (RestfulServer.AutoClosingConnectionManager manager = RestfulServer.createConnectionToLoginServer())
        {
            LoggerManager.getSingleton().getLogger().info("[RestfulServer] Attempting login for user: \"" + info.getPlayerName() + "\"");

            Report report = processAction(() ->
            {
                CommandRestfulLogin command = new CommandRestfulLogin(info.getPlayerName(), info.getPassword());

                ModelFacade.getSingleton().queueCommand(command);
            }, RestfulLoginSuccessReport.class, RestfulLoginFailedReport.class);

            if (report != null)
            {
                return handleLoginReport(report);
            }

            LoggerManager.getSingleton().getLogger().info("[RestfulServer] Failed to receive report from LoginServer");

            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<Object> logout(@RequestBody LogoutInformation info)
    {
        Report report = processAction(() ->
        {
            CommandRestfulLogout command = new CommandRestfulLogout(info.getAuthKey());

            ModelFacade.getSingleton().queueCommand(command);
        }, RestfulLogoutSuccessReport.class, RestfulLogoutFailedReport.class);

        if (report != null)
        {
            return handleLogoutReport(report);
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @PostMapping("/login/generate-reset-code")
    @CrossOrigin
    public ResponseEntity<Object> generateResetPasswordCode(@RequestBody UserNameInformation body)
            throws PlayerNotFoundException, DuplicateNameException,
            DatabaseException
    {
        int playerId;

        int min = 100000;
        int max = 999999;
        int randomCode = random.nextInt(max - min + 1) + min;

        PlayerLoginRowDataGateway login =
                new PlayerLoginRowDataGateway(body.getUserName());

        playerId = login.getPlayerID();

        CreateResetPasswordCodeReport ResetPasswordReport = processAction(() ->
        {
            CommandCreateResetPasswordCode createCode = new CommandCreateResetPasswordCode(
                    playerId, randomCode);
            try
            {
                createCode.execute();
            }
            catch (DuplicateNameException | DatabaseException e)
            {
                throw new RuntimeException(e);
            }
        },CreateResetPasswordCodeReport.class);

        if (ResetPasswordReport != null)
        {
            if (ResetPasswordReport.isSuccessful())
            {
                //TODO want to send mail here, but it's currently not working.

                System.out.println("Success");
                return new ResponseEntity<>(new BasicResponse(true,
                        "Code successfully put into DB").toString(),
                        HttpStatus.OK);
            }
            else
            {
                System.out.println("FAIL; " + ResetPasswordReport.getDescription());
                return new ResponseEntity<>(
                        new BasicResponse(false,
                                ResetPasswordReport.getDescription()).toString(),
                        HttpStatus.BAD_REQUEST);
            }
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @PostMapping("/login/compare-codes")
    public ResponseEntity<Object> verifyResetPasswordCode(@RequestBody GeneratedCodeInformation body)
            throws DatabaseException
    {

        PlayerLoginRowDataGateway login = new PlayerLoginRowDataGateway(
                body.getUserName());

        int playerID = login.getPlayerID();

        GetResetPasswordCodeReport ResetPasswordReport = processAction(() ->
        {
            CommandGetResetPasswordCode getCode = new CommandGetResetPasswordCode(
                    playerID);
            try
            {
                getCode.execute();
            }
            catch (DuplicateNameException e)
            {
                throw new RuntimeException(e);
            }
            catch (DatabaseException e)
            {
                throw new RuntimeException(e);
            }
        }, GetResetPasswordCodeReport.class);

        if (ResetPasswordReport != null)
        {
            if (ResetPasswordReport.getResetPasswordCode() == body.getCode())
            {
                //System.out.println("Success");
                return new ResponseEntity<>(new BasicResponse(true,
                        "Inputted code equal to whats in DB").toString(),
                        HttpStatus.OK);
            }
            else
            {
                //System.out.println("FAIL; " + ResetPasswordReport.getDescription());
                return new ResponseEntity<>(
                        new BasicResponse(false,
                                "Inputted code not equal to whats in DB").toString(),
                        HttpStatus.BAD_REQUEST);
            }
        }
        else
        {
            return new ResponseEntity<>(
                    new BasicResponse(false,
                            "No code in DB for this user").toString(),
                    HttpStatus.BAD_REQUEST);
        }
        //return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }



    private ResponseEntity<Object> handleLogoutReport(Report report)
    {
        if (report.getClass().equals(RestfulLogoutSuccessReport.class))
        {
            return new ResponseEntity<>(HttpStatus.OK);
        }
        else if (report.getClass().equals(RestfulLogoutFailedReport.class))
        {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    private ResponseEntity<Object> handleLoginReport(Report report)
    {
        if (report.getClass().equals(RestfulLoginSuccessReport.class))
        {
            LoginResponse response = handleLoginSuccess(
                    (RestfulLoginSuccessReport) report);
            LoggerManager.getSingleton().getLogger().info(
                    "[RestfulServer] Login successful for userID: " +
                            ((RestfulLoginSuccessReport) report).getPlayerID());

            return new ResponseEntity<>(response.toString(), HttpStatus.OK);
        }
        else if (report.getClass().equals(RestfulLoginFailedReport.class))
        {
            LoginResponse response = new LoginResponse((RestfulLoginFailedReport)report);
            LoggerManager.getSingleton().getLogger().info(
                    "[RestfulServer] Login failed with this message: " +
                            ((RestfulLoginFailedReport) report).getMessage());

            return new ResponseEntity<>(response.toString(), HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }


    private LoginResponse handleLoginSuccess(RestfulLoginSuccessReport report)
    {
        Player player = PlayerManager.getSingleton().addPlayer(report.getPlayerID()); // Add the player to the player manager

        String authKey = RestfulPlayerManager.getSingleton().initializePlayer(player);

        return new LoginResponse(report.getPlayerID(), authKey);
    }
}

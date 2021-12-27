
package se.kth.iv1351.jdbcintro;

import java.util.ArrayList;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class BasicJdbc {

  private PreparedStatement getInstrumentStmt;
  private PreparedStatement getStudentRentingAmountStmt;
  private PreparedStatement rentInstrumentStmt;
  private PreparedStatement decreaseStorageInformationStmt;

  private PreparedStatement getHighestRentIDStmt;
  private PreparedStatement getRentedInstrumentsStmt;
  private PreparedStatement increaseStorageInformationStmt;
  private PreparedStatement deactivateRentalStmt;
  private PreparedStatement getOldestRentalStmt;

  private void findRentableInstruments(String type, ArrayList instrumentIDs) {
    try (Connection connection = createConnection()) {

      prepareStatements(connection);



      getInstrumentStmt.setString(1, type);
      listInstruments(instrumentIDs);

    } catch (SQLException | ClassNotFoundException exc) {
      exc.printStackTrace();
    }
  }

  private void rentInstrument(int studentId, int instrumentId) {
    try (Connection connection = createConnection()) {

      prepareStatements(connection);
      getStudentRentingAmountStmt.setInt(1, studentId);
      ResultSet numberOfRentedInstruments = getStudentRentingAmountStmt.executeQuery();

      boolean isNotEmpty = numberOfRentedInstruments.next();


        if (isNotEmpty) {
          int nrRentedInstruments = Integer.parseInt(numberOfRentedInstruments.getString(1));

          if (nrRentedInstruments >= 2) {
            System.out.println("To many rented instruments.");
          } else {
            executeRental(studentId, instrumentId);
          }
        } else {
          executeRental(studentId, instrumentId);
        }


    }
    catch (SQLException | ClassNotFoundException exc) {
      exc.printStackTrace();
    }
  }

  private void executeRental(int studentId, int instrumentId) throws SQLException {
    ResultSet highestID = getHighestRentIDStmt.executeQuery();
    highestID.next();
    int rentalID = highestID.getInt(1) + 1;
    rentInstrumentStmt.setInt(1, rentalID);
    rentInstrumentStmt.setInt(2, studentId);
    rentInstrumentStmt.setInt(3, instrumentId);
    rentInstrumentStmt.executeUpdate();

    decreaseStorageInformationStmt.setInt(1,instrumentId);
    decreaseStorageInformationStmt.setInt(2,instrumentId);
    decreaseStorageInformationStmt.executeUpdate();

    System.out.println("Instrument successfully rented");
  }

  private ArrayList findRentedInstruments(int studentId, String listType){

    try (Connection connection = createConnection()) {

      prepareStatements(connection);

      getRentedInstrumentsStmt.setInt(1, studentId);
      ResultSet rentedInstruments = getRentedInstrumentsStmt.executeQuery();
      ArrayList instrumentIDs;

      if(listType.equals("list")){
        instrumentIDs = listRentedInstruments(rentedInstruments);
      }
      else {
        instrumentIDs = getRentedInstruments(rentedInstruments);
      }

      if (instrumentIDs.size() == 0){
        System.out.println("No currently rented instruments");
      }
      return instrumentIDs;
    }
    catch (SQLException | ClassNotFoundException exc) {
    exc.printStackTrace();
    }

    return null;
  }

  private void terminateRental(int studentId, int chosenInstrument, ArrayList<Integer> instrumentIDs) {
    try (Connection connection = createConnection()) {

      if(instrumentIDs.size() > 0) {
        if (chosenInstrument <= instrumentIDs.size()) {

          prepareStatements(connection);

          int instrumentID = instrumentIDs.get(chosenInstrument - 1).intValue();

          getOldestRentalStmt.setInt(1, instrumentID);
          getOldestRentalStmt.setInt(2, studentId);
          ResultSet rentalIDresult = getOldestRentalStmt.executeQuery();
          rentalIDresult.next();
          int rentalId = rentalIDresult.getInt(1);

          increaseStorageInformationStmt.setInt(1, instrumentID);
          increaseStorageInformationStmt.setInt(2, instrumentID);
          increaseStorageInformationStmt.executeUpdate();

          deactivateRentalStmt.setInt(1, rentalId);
          deactivateRentalStmt.executeUpdate();

          System.out.println("Rental terminated");
        } else {
          System.out.println("The chosen instrument does not exist");
        }
      }
      else {
        System.out.println("No currently rented instruments");
      }


    }
    catch (SQLException | ClassNotFoundException exc) {
      exc.printStackTrace();
    }
  }

  private Connection createConnection() throws SQLException, ClassNotFoundException {
    Class.forName("org.postgresql.Driver");
    return DriverManager.getConnection("jdbc:postgresql://localhost:5432/best_music_school",
      "postgres", "password"); //Add your password to connect

  }



  private void listInstruments(ArrayList rentedInstrumentIDs) throws SQLException {

    ResultSet instruments = getInstrumentStmt.executeQuery();

    while (instruments.next()){
      if (!rentedInstrumentIDs.contains(instruments.getInt(1))) {
        System.out.println("Id: " + instruments.getString(1) + ", brand: " + instruments.getString(2) + ", price: " + instruments.getString(3));
      }
    }
  }

  private ArrayList listRentedInstruments(ResultSet rentedInstruments) throws SQLException {

    int i = 1;
    ArrayList<Integer> instrumentIDs = new ArrayList<>();
    while (rentedInstruments.next()){
      System.out.println("Instrument: " + i + ", type: " + rentedInstruments.getString(2) + ", brand: " + rentedInstruments.getString(3) + ", price: " + rentedInstruments.getString(4) + "kr/ month");
      instrumentIDs.add(rentedInstruments.getInt(1));
      i++;
    }
     return instrumentIDs;
  }

  private ArrayList getRentedInstruments(ResultSet rentedInstruments) throws SQLException {

    int i = 1;
    ArrayList<Integer> instrumentIDs = new ArrayList<>();
    while (rentedInstruments.next()){
      instrumentIDs.add(rentedInstruments.getInt(1));
      i++;
    }
    return instrumentIDs;
  }

  private void prepareStatements(Connection connection) throws SQLException {

    getInstrumentStmt = connection.prepareStatement("select id, brand, price from instrument where amount::int > 0 and type = ? order by id;");

    getStudentRentingAmountStmt = connection.prepareStatement("select count from (select student_id, count(*) from instrument_rental_information where active = 1::bit group by student_id) as f where student_id = ?");
    rentInstrumentStmt = connection.prepareStatement("insert into instrument_rental_information values (?, ?, ?, 1::bit);");
    decreaseStorageInformationStmt = connection.prepareStatement("update instrument set amount = (select amount from instrument where id = ?)::int - 1 where id = ?;");

    getRentedInstrumentsStmt = connection.prepareStatement("select i.id, type, brand, price from instrument_rental_information inner join instrument i on i.id = instrument_rental_information.instrument_id where student_id = ? and active = 1::bit ");
    increaseStorageInformationStmt = connection.prepareStatement("update instrument set amount = (select amount from instrument where id = ?)::int + 1 where id = ?");
    deactivateRentalStmt = connection.prepareStatement("update instrument_rental_information set active = 0::bit where id = ?;");
    getHighestRentIDStmt = connection.prepareStatement("select max(id) from instrument_rental_information;");
    getOldestRentalStmt = connection.prepareStatement("select min(id) from instrument_rental_information where instrument_id = ? and student_id = ? and active = 1::bit;");
  }

  public static void main(String[] args) {

    BasicJdbc dbCalls = new BasicJdbc();
    Scanner scanner = new Scanner(System.in);

    int action;
    String instrumentType;
    int instrumentChoice;
    ArrayList instrumentIDs;

    System.out.print("Insert studentID: ");
    int studentID = scanner.nextInt();
    scanner.nextLine();

    while (true){

      System.out.println("\nSelect action:");
      System.out.print("1: Find rentable instruments \n 2: Rent instrument \n 3: Terminate rental");
      action = scanner.nextInt();
      scanner.nextLine();

      switch (action){
        case(1) :
          instrumentIDs = dbCalls.findRentedInstruments(studentID, "find");
          System.out.println("What type of instrument are you looking for?");
          instrumentType = scanner.nextLine();

          dbCalls.findRentableInstruments(instrumentType, instrumentIDs);
          break;

        case(2) :

          instrumentIDs = dbCalls.findRentedInstruments(studentID, "find");
          System.out.println("What type of instrument are you looking for?");
          instrumentType = scanner.nextLine();

          dbCalls.findRentableInstruments(instrumentType, instrumentIDs);

          System.out.println("What instrument do you want to rent? Enter -1 to cancel");
          instrumentChoice = scanner.nextInt();
          scanner.nextLine();

          if (instrumentChoice != -1) {
            dbCalls.rentInstrument(studentID, instrumentChoice);
          }
          break;

        case(3) :
          instrumentIDs = dbCalls.findRentedInstruments(studentID, "list");
            System.out.println("Which instrument do you no longer want to rent? Enter -1 to cancel");
            instrumentChoice = scanner.nextInt();
            scanner.nextLine();

            if (instrumentChoice != -1) {
              dbCalls.terminateRental(studentID, instrumentChoice, instrumentIDs);
            }
          break;
      }
    }
  }
}

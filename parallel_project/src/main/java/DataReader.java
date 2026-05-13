import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;

// This class reads .xlsx files and returns a list of orders
public class DataReader {

    // Get all .xlsx files from the dataset folder
    public static File[] getFiles(String folderPath) {
        File folder = new File(folderPath);
        File[] files = folder.listFiles((dir, name) -> name.endsWith(".xlsx"));
        if (files == null || files.length == 0) {
            System.out.println("ERROR: No .xlsx files found in " + folderPath);
            return new File[0];
        }
        return files;
    }

    // Read one .xlsx file and return list of orders
    public static ArrayList<Order> readFile(File file) {
        ArrayList<Order> orders = new ArrayList<>();
        try {
            FileInputStream fis = new FileInputStream(file);
            Workbook workbook = new XSSFWorkbook(fis);
            Sheet sheet = workbook.getSheetAt(0);

            boolean firstRow = true;
            for (Row row : sheet) {
                if (firstRow) {
                    firstRow = false; // skip header row
                    continue;
                }
                try {
                    long orderId = (long) row.getCell(0).getNumericCellValue();
                    long customerId = (long) row.getCell(1).getNumericCellValue();
                    int restaurantId = (int) row.getCell(2).getNumericCellValue();
                    String city = row.getCell(3).getStringCellValue();
                    double amount = row.getCell(4).getNumericCellValue();
                    int deliveryTime = (int) row.getCell(5).getNumericCellValue();

                    orders.add(new Order(orderId, customerId, restaurantId, city, amount, deliveryTime));
                } catch (Exception e) {
                    // skip bad rows
                }
            }
            workbook.close();
            fis.close();
        } catch (Exception e) {
            System.out.println("Error reading: " + file.getName());
        }
        return orders;
    }
}

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Reads Talabat order data from .xlsx files using Apache POI.
 */
public class DataReader {

    /**
     * List all .xlsx files in the dataset directory.
     */
    public static File[] listXlsxFiles(String datasetDir) {
        File folder = new File(datasetDir);
        if (!folder.exists() || !folder.isDirectory()) {
            throw new IllegalArgumentException("Dataset folder not found: " + datasetDir);
        }
        File[] files = folder.listFiles((dir, name) -> name.toLowerCase().endsWith(".xlsx"));
        if (files == null || files.length == 0) {
            throw new IllegalStateException("No .xlsx files found in: " + datasetDir);
        }
        return files;
    }

    /**
     * Read a single .xlsx file and return all rows as Order objects.
     * Skips the header row.
     */
    public static List<Order> readFile(File file) {
        List<Order> orders = new ArrayList<>();
        try (FileInputStream fis = new FileInputStream(file);
             Workbook workbook = new XSSFWorkbook(fis)) {

            Sheet sheet = workbook.getSheetAt(0);
            boolean firstRow = true;

            for (Row row : sheet) {
                if (firstRow) {
                    firstRow = false;
                    continue; // skip header
                }
                try {
                    long orderId = (long) getNumeric(row.getCell(0));
                    long customerId = (long) getNumeric(row.getCell(1));
                    int restaurantId = (int) getNumeric(row.getCell(2));
                    String city = getString(row.getCell(3));
                    double amount = getNumeric(row.getCell(4));
                    int deliveryTime = (int) getNumeric(row.getCell(5));

                    orders.add(new Order(orderId, customerId, restaurantId,
                            city, amount, deliveryTime));
                } catch (Exception ignored) {
                    // skip malformed rows
                }
            }
        } catch (Exception e) {
            System.err.println("Error reading file " + file.getName() + ": " + e.getMessage());
        }
        return orders;
    }

    private static double getNumeric(Cell cell) {
        if (cell == null) return 0;
        if (cell.getCellType() == CellType.NUMERIC) return cell.getNumericCellValue();
        if (cell.getCellType() == CellType.STRING) {
            try { return Double.parseDouble(cell.getStringCellValue().trim()); }
            catch (Exception e) { return 0; }
        }
        return 0;
    }

    private static String getString(Cell cell) {
        if (cell == null) return "";
        if (cell.getCellType() == CellType.STRING) return cell.getStringCellValue().trim();
        if (cell.getCellType() == CellType.NUMERIC) return String.valueOf(cell.getNumericCellValue());
        return "";
    }
}

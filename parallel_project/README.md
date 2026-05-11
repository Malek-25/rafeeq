# Parallel Programming Project - Phase 2
## Talabat Orders Dataset Analysis

**Course:** Parallel Programming 1301421
**Semester:** Second Semester 2025/2026
**Instructors:** Dr. Mansour Alhelalat, Dr. Ayham Alomari, Engr. Nada Abdalfattah

---

## Project Structure

```
parallel_project/
├── src/main/java/
│   ├── Main.java                    # Entry point - runs all benchmarks
│   ├── DataReader.java              # Reads .xlsx files from dataset folder
│   ├── Order.java                   # Data model
│   ├── SequentialProcessor.java     # Simple + Complex sequential processing
│   ├── OuterThreadProcessor.java    # Parallel via extends Thread
│   ├── InnerThreadProcessor.java    # Parallel via lambda/inner runnable
│   └── PerformanceLogger.java       # Logs execution times to CSV
├── dataset/                          # Put your .xlsx files here
├── results/                          # Generated performance results
├── lib/                              # Apache POI jars for .xlsx reading
└── pom.xml                           # Maven config (easier dependency mgmt)
```

---

## Setup Instructions

### Option 1: Using Maven (Easiest)
```bash
cd parallel_project
mvn clean install
mvn exec:java -Dexec.mainClass="Main"
```

### Option 2: Manual JARs
1. Download Apache POI from https://poi.apache.org/download.html
2. Extract and copy these to `lib/` folder:
   - poi-5.2.5.jar
   - poi-ooxml-5.2.5.jar
   - poi-ooxml-lite-5.2.5.jar
   - commons-compress-1.26.0.jar
   - commons-io-2.15.1.jar
   - log4j-api-2.22.1.jar
   - xmlbeans-5.2.0.jar
3. Compile and run:
```bash
javac -cp "lib/*" -d out src/main/java/*.java
java -cp "out:lib/*" Main
```

---

## Dataset

Place all `.xlsx` files inside the `dataset/` folder.
Each file has columns: `order_id, customer_id, restaurant, city, amount, delivery_time`

---

## What This Project Does

1. **Sequential Processing (2 types):**
   - Simple: counts total records, finds max/min amounts, counts orders per city
   - Complex: computes weighted customer score = 0.4*amount + 0.3*(60-delivery_time) + 0.3*frequency

2. **Parallel Processing:**
   - **Outer Threading:** Uses `Thread` class - each thread processes a chunk of files
   - **Inner Threading:** Uses Lambda/Runnable inside a loop

3. **Thread Counts Tested:** 2, 4, 8, 16, 32, 64, 128

4. **Output:**
   - Console shows execution time for each run
   - `results/performance_results.csv` contains all benchmark data for your report

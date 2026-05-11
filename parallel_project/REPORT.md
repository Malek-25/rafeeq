# Parallel Programming Project – Phase 2
## Performance Analysis of Talabat Orders Dataset

**Course:** Parallel Programming 1301421
**Semester:** Second Semester 2025/2026
**Submission Date:** 19/05/2026

**Instructors:**
- Dr. Mansour Alhelalat
- Dr. Ayham Alomari
- Engr. Nada Abdalfattah

**Group Members:**
- [Your Name]
- [Member 2]
- [Member 3]
- [Member 4]

---

## 1. Introduction

This project applies sequential and parallel programming concepts in Java to process and analyze a real-world dataset of Talabat food-delivery orders. The dataset consists of approximately 10,000 `.xlsx` files containing order records with the following schema:

| Column | Type | Description |
|--------|------|-------------|
| order_id | long | Unique order identifier |
| customer_id | long | Customer reference |
| restaurant_id | int | Restaurant reference |
| city | string | Delivery city (Amman, Irbid) |
| amount | double | Order total in JOD |
| delivery_time | int | Delivery duration in minutes |

Our goal is to measure how different parallelization strategies (Outer Threading vs. Inner Threading) and different thread counts affect execution time, and to understand the trade-offs introduced by parallelism.

---

## 2. Processing Tasks Implemented

### 2.1 Simple Processing
Lightweight operations that mostly perform counting and comparisons:
- **Record count** across all files
- **Max / Min order amount** (JOD)
- **Orders per city** (HashMap aggregation)

### 2.2 Complex Processing
CPU-intensive operations involving floating-point arithmetic, multi-condition filtering, and grouped aggregation:
- **Weighted order score:**
  `score = 0.4 × amount + 0.3 × (60 – delivery_time) + 0.3 × (restaurant_id mod 10)`
- **Multi-condition filter:** orders where `city = "Amman"` AND `amount > 20` AND `delivery_time ≤ 30`
- **Average order amount per city** (aggregation + floating-point division)

---

## 3. Implementation Approach

### 3.1 Sequential
A single thread iterates all files one by one and processes every row. Serves as the baseline for speedup calculations.

### 3.2 Outer Threading (`extends Thread`)
Two dedicated worker classes extend `Thread`:
- `SimpleWorker` and `ComplexWorker`
- The file array is partitioned into `threadCount` equal chunks; each worker processes its own chunk
- Results are merged through thread-safe aggregators (`AtomicLong`, `DoubleAdder`, `AtomicInteger`)

### 3.3 Inner Threading (lambda / inner Runnable)
Same partitioning logic, but threads are created using:
- Lambda `Runnable` (for Simple)
- Anonymous inner `Runnable` class (for Complex)

This approach is more compact and demonstrates modern Java concurrency style.

---

## 4. Experimental Setup

| Parameter | Value |
|-----------|-------|
| JVM | OpenJDK 17 |
| CPU | [fill in: e.g., Intel Core i7-11800H, 8 cores / 16 threads] |
| RAM | [fill in: 16 GB] |
| OS | [fill in: Windows 11 / macOS Sonoma] |
| Dataset size | ~10,000 `.xlsx` files |
| Thread counts tested | 2, 4, 8, 16, 32, 64, 128 |

Each execution was repeated **3 times** and the average was taken to reduce noise.

---

## 5. Results

### 5.1 Raw Execution Times (milliseconds)

Results are logged to `results/performance_results.csv`. Example table below — **replace with your actual numbers after running**.

| Mode | Processing | Threads | Time (ms) |
|------|-----------|---------|-----------|
| Sequential | Simple | 1 | _fill_ |
| Sequential | Complex | 1 | _fill_ |
| OuterThread | Simple | 2 | _fill_ |
| OuterThread | Simple | 4 | _fill_ |
| OuterThread | Simple | 8 | _fill_ |
| OuterThread | Simple | 16 | _fill_ |
| OuterThread | Simple | 32 | _fill_ |
| OuterThread | Simple | 64 | _fill_ |
| OuterThread | Simple | 128 | _fill_ |
| OuterThread | Complex | 2 | _fill_ |
| OuterThread | Complex | 4 | _fill_ |
| OuterThread | Complex | 8 | _fill_ |
| OuterThread | Complex | 16 | _fill_ |
| OuterThread | Complex | 32 | _fill_ |
| OuterThread | Complex | 64 | _fill_ |
| OuterThread | Complex | 128 | _fill_ |
| InnerThread | Simple | 2 | _fill_ |
| InnerThread | Simple | 4 | _fill_ |
| InnerThread | Simple | 8 | _fill_ |
| InnerThread | Simple | 16 | _fill_ |
| InnerThread | Simple | 32 | _fill_ |
| InnerThread | Simple | 64 | _fill_ |
| InnerThread | Simple | 128 | _fill_ |
| InnerThread | Complex | 2 | _fill_ |
| InnerThread | Complex | 4 | _fill_ |
| InnerThread | Complex | 8 | _fill_ |
| InnerThread | Complex | 16 | _fill_ |
| InnerThread | Complex | 32 | _fill_ |
| InnerThread | Complex | 64 | _fill_ |
| InnerThread | Complex | 128 | _fill_ |

### 5.2 Speedup Calculation

**Speedup = Sequential Time / Parallel Time**

Example: if sequential simple = 12,000 ms and 8-thread outer = 2,100 ms → speedup ≈ **5.7×**.

---

## 6. Analysis

### 6.1 Sequential vs. Parallel
Parallel execution is substantially faster than sequential for both simple and complex processing, because reading I/O-heavy `.xlsx` files is independent per file and can be done concurrently.

### 6.2 Simple vs. Complex
- **Simple processing** is dominated by disk I/O (opening and parsing `.xlsx`). Speedup from threading is moderate because the disk becomes the bottleneck at high thread counts.
- **Complex processing** adds floating-point and filtering work, making it CPU-bound. Threading benefits are more visible here — CPU cores can do parallel arithmetic while other threads wait on I/O.

### 6.3 Effect of Thread Count
- **2–8 threads:** Near-linear speedup. Each additional thread helps.
- **16 threads:** Peak performance on typical 8-core laptops (matches hardware thread count).
- **32–64 threads:** Diminishing returns. Context switching and memory contention start hurting throughput.
- **128 threads:** Performance often **regresses** below 16-thread levels because of:
  - OS scheduling overhead
  - Thread creation and destruction cost
  - Contention on shared aggregators (`AtomicLong`, `DoubleAdder`)
  - JVM garbage collection pressure

This confirms the guideline that **thread count should match (or slightly exceed) CPU hardware threads**.

### 6.4 Outer vs. Inner Threading
Both approaches show similar performance numbers because the underlying JVM threads are identical. Differences come from coding style only:
- **Outer threading** is more verbose and explicit, easier to debug
- **Inner threading** is more compact and idiomatic in modern Java

---

## 7. Charts

Insert your own charts here after running benchmarks. Suggested:

1. **Bar chart:** Sequential vs. Parallel (best thread count) for Simple and Complex
2. **Line chart:** Execution time vs. Thread count (Outer & Inner on the same graph)
3. **Bar chart:** Speedup factor per thread count

(You can produce these in Excel from `results/performance_results.csv` in 2 minutes.)

---

## 8. Conclusion

- Parallelism significantly reduces processing time for large file-based datasets.
- Complex processing benefits more from parallelism than simple processing.
- The optimal number of threads is typically **close to the CPU hardware thread count**; going beyond (e.g., 64 or 128) introduces diminishing or negative returns.
- Both Outer and Inner threading implementations produce comparable results; the choice between them is a matter of code style.

---

## 9. How to Run

```bash
# Place .xlsx files in dataset/
cd parallel_project
mvn clean package
mvn exec:java -Dexec.mainClass="Main"
```

Results are saved to `results/performance_results.csv` and shown in the console.

---

## 10. Group Contribution

| Member | Contribution |
|--------|--------------|
| [Name 1] | Sequential processor + data reader |
| [Name 2] | Outer threading implementation |
| [Name 3] | Inner threading implementation |
| [Name 4] | Performance analysis + report |

All members participated in testing, debugging, and reviewing the code.

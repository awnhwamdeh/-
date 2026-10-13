import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# ==========================================
# بيانات daily_sales (من التمرين السابق)
# ==========================================

np.random.seed(42)

dates = pd.date_range(
    start='2023-01-01',
    end='2024-12-31',
    freq='D'
)

sales = (
    np.random.randint(500, 2000, size=len(dates))
    + np.where(pd.Series(dates).dt.month.isin([11, 12]), 800, 0)
)

daily_sales = pd.DataFrame({
    'date': dates,
    'sales': sales
})

daily_sales['date'] = pd.to_datetime(daily_sales['date'])
daily_sales = daily_sales.set_index('date')

# ==========================================
# تحميل بيانات flights
# ==========================================

flights = sns.load_dataset("flights")

# تحويلها لسلسلة زمنية شهرية
flights["date"] = pd.to_datetime(
    flights["year"].astype(str) + "-" +
    flights["month"].astype(str)
)

flights = flights.set_index("date")

# ==========================================
# الجزء 1 - Visualization
# ==========================================

# 1) رسم المبيعات اليومية
plt.figure(figsize=(12, 4))
plt.plot(daily_sales.index, daily_sales["sales"])
plt.show()

# 2) نسخة محسنة
plt.figure(figsize=(14, 5))
plt.plot(
    daily_sales.index,
    daily_sales["sales"],
    color="steelblue"
)

plt.title("Daily Sales (2023-2024)")
plt.xlabel("Date")
plt.ylabel("Sales")
plt.grid(True)
plt.show()

# 3) flights باستخدام Subplots

fig, axes = plt.subplots(
    2,
    1,
    figsize=(12, 8)
)

# الرسم الكامل
axes[0].plot(
    flights.index,
    flights["passengers"]
)

axes[0].set_title("Flights Dataset - Full History")
axes[0].set_ylabel("Passengers")
axes[0].grid(True)

# آخر 3 سنوات
last_3_years = flights.loc["1957":"1960"]

axes[1].plot(
    last_3_years.index,
    last_3_years["passengers"],
    color="red"
)

axes[1].set_title("Flights Dataset - Last 3 Years")
axes[1].set_xlabel("Date")
axes[1].set_ylabel("Passengers")
axes[1].grid(True)

plt.tight_layout()
plt.show()

# ==========================================
# الجزء 2 - Moving Averages
# ==========================================

# 1) متوسط متحرك 7 أيام

daily_sales["MA_7"] = (
    daily_sales["sales"]
    .rolling(window=7)
    .mean()
)

# 2) الرسم مع البيانات الأصلية

plt.figure(figsize=(14, 5))

plt.plot(
    daily_sales.index,
    daily_sales["sales"],
    alpha=0.4,
    label="Daily Sales"
)

plt.plot(
    daily_sales.index,
    daily_sales["MA_7"],
    color="red",
    linewidth=2,
    label="7-Day Moving Average"
)

plt.title("Daily Sales vs 7-Day

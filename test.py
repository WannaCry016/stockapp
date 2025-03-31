import requests
import json

API_KEY = "WDW38ORCRLKCIQOZ"  # Your Alpha Vantage API Key
STOCK_SYMBOL = "AAPL"  # Test with Apple stock

url = f"https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol={STOCK_SYMBOL}&apikey={API_KEY}"

response = requests.get(url)

try:
    data = response.json()
    
    # Check if API returned valid data
    if "Global Quote" in data and "05. price" in data["Global Quote"]:
        print("✅ API is working fine. Here is the stock data:")
        print(json.dumps(data, indent=4))
    elif "Note" in data:
        print("⚠️ You've hit the API limit! Here is the error message:")
        print(data["Note"])
    else:
        print("❌ Unexpected response. Here is the raw API output:")
        print(json.dumps(data, indent=4))

except json.JSONDecodeError:
    print("❌ Error: Unable to parse API response. API might be down.")

"GOOG": {
      "price": 2734.75,
      "change": 15.56,
      "percent_change": "+0.57%",
      "volume": "1,287,000",
      "prev_close": 2719.19,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "AMZN": {
      "price": 3468.23,
      "change": -20.45,
      "percent_change": "-0.58%",
      "volume": "3,650,500",
      "prev_close": 3488.68,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "MSFT": {
      "price": 294.25,
      "change": 5.43,
      "percent_change": "+1.87%",
      "volume": "18,234,678",
      "prev_close": 288.82,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "TSLA": {
      "price": 678.90,
      "change": -10.22,
      "percent_change": "-1.48%",
      "volume": "25,896,500",
      "prev_close": 689.12,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "NFLX": {
      "price": 582.17,
      "change": 7.83,
      "percent_change": "+1.36%",
      "volume": "2,134,290",
      "prev_close": 574.34,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "SPY": {
      "price": 413.97,
      "change": -4.56,
      "percent_change": "-1.09%",
      "volume": "12,500,450",
      "prev_close": 418.53,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "BA": {
      "price": 211.65,
      "change": -2.48,
      "percent_change": "-1.16%",
      "volume": "4,879,540",
      "prev_close": 214.13,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "NVDA": {
      "price": 195.22,
      "change": 3.15,
      "percent_change": "+1.64%",
      "volume": "11,256,780",
      "prev_close": 192.07,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "DIS": {
      "price": 170.12,
      "change": -1.02,
      "percent_change": "-0.60%",
      "volume": "7,134,810",
      "prev_close": 171.14,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
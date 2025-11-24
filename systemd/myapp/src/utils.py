from datetime import datetime, timezone, timedelta

DT_FORMAT = "%Y-%m-%d %H:%M:%S %Z"
UNIX_EPOCH = datetime.fromtimestamp(0, timezone.utc)

def cdt(tz_hr=8):
    """Current datatime
    @tz_hr: timezone hours relative to UTC (Default: +08:00)"""
    return datetime.now(tz=timezone(timedelta(hours=tz_hr)))

def format_db_str(dt_str):
    return f"00:{dt_str}" if len(dt_str) < 6 else dt_str

def calc_timedelta(start_time: str, end_time: str):
    st = datetime.strptime(format_db_str(start_time), "%H:%M:%S")
    et = datetime.strptime(format_db_str(end_time), "%H:%M:%S")
    if et < st:
        et = et + timedelta(days=1)
    return et - st

from google.oauth2 import service_account
from googleapiclient.discovery import build
import time

SERVICE_ACCOUNT_FILE = 'google_service_account.json'
SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly']

_cache = {}
_cache_expiry = {}

def get_sheet_responses(sheet_id, range_name):
    creds = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES)
    service = build('sheets', 'v4', credentials=creds)
    sheet = service.spreadsheets()
    result = sheet.values().get(spreadsheetId=sheet_id, range=range_name).execute()
    values = result.get('values', [])
    return values

def get_sheet_responses_cached(sheet_id, range_name):
    key = (sheet_id, range_name)
    now = time.time()
    if key in _cache and now < _cache_expiry[key]:
        return _cache[key]
    data = get_sheet_responses(sheet_id, range_name)
    _cache[key] = data
    _cache_expiry[key] = now + 600  # Cache for 10 minutes
    return data

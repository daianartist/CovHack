from google.oauth2 import service_account
from googleapiclient.discovery import build

SERVICE_ACCOUNT_FILE = 'google_service_account.json'
SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly']

# Replace with your actual Google Sheet ID and range
SHEET_ID = '1N-Ks8409nfcnIV4opMwwsDFXodVbz-b7NEZAj1Jr0gI'
RANGE_NAME = 'Ответы на форму (1)'  # or the actual name of your sheet/tab

def main():
    creds = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES)
    service = build('sheets', 'v4', credentials=creds)
    sheet = service.spreadsheets()
    result = sheet.values().get(spreadsheetId=SHEET_ID, range=RANGE_NAME).execute()
    values = result.get('values', [])
    print("Sheet values:")
    for row in values:
        print(row)

if __name__ == '__main__':
    main()

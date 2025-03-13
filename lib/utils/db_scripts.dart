final initialScript = <String>[
  '''
CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  first_name TEXT,
  last_name TEXT,
  mobile TEXT,
  email TEXT,
  status TEXT,
  role TEXT,
  profile TEXT,
  gender TEXT,
  username TEXT
);
  ''',
  '''
CREATE TABLE services(
  id INTEGER PRIMARY KEY,
  name TEXT,
  logo TEXT,
  description TEXT,
  provider TEXT,
  is_active REAL,
  category TEXT
);
  ''',
  '''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY,
        account_number TEXT,
        amount REAL,
        date TEXT,
        debit_account TEXT,
        narration TEXT,
        notification_status TEXT,
        payment_status TEXT,
        provider INTEGER,
        settlement_status TEXT,
        type TEXT,
        water_service_type TEXT,
        status TEXT,
        service TEXT,
        reference TEXT,
        providers_id INTEGER,
        credit_account TEXT,
        printed INTEGER DEFAULT 0,
        providers_name TEXT
      )
    '''
];

final migrationScript = <String>[
  // '''
// ALTER TABLE users ADD COLUMN gender TEXT;
  // ''',
  // '''
    // ALTER TABLE transactions ADD COLUMN printed INTEGER DEFAULT 0;
    // ''',
];

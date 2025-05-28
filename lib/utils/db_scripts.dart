final initialScript = <String>[
  '''
CREATE TABLE users(
  id TEXT PRIMARY KEY,
  name TEXT,
  phone TEXT,
  email TEXT,
  avatar TEXT,
  role TEXT,
  metaData TEXT
);
  ''',
];

final migrationScript = <String>[
  '''
ALTER TABLE users ADD COLUMN countryCode TEXT;
  ''',
    '''
ALTER TABLE users ADD COLUMN fullPhone TEXT;
  ''',
  // '''
    // ALTER TABLE transactions ADD COLUMN printed INTEGER DEFAULT 0;
    // ''',
];

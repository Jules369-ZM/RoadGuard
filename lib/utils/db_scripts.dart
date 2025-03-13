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
  // '''
// ALTER TABLE users ADD COLUMN gender TEXT;
  // ''',
  // '''
    // ALTER TABLE transactions ADD COLUMN printed INTEGER DEFAULT 0;
    // ''',
];

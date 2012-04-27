create keyspace CrowdSourced;
use CrowdSourced;

create column family Tweets with comparator = 'UTF8Type';

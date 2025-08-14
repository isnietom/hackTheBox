#!/bin/bash
awk -F'\t' '
BEGIN {
    print "Timeline of Login Sessions (UTC)";
    print "=================================";
    count = 0;
}
# Check if file is readable
FNR == 1 {
    if (system("test -r " FILENAME) != 0) {
        print "Error: Cannot read file " FILENAME;
        exit 1;
    }
}
# Store shutdown time
$1 == "RUN_LVL" && $5 == "shutdown" {
    shutdown = $10;
    last_time = $10;
}
# Store last timestamp as fallback
$10 ~ /^[0-9]{4}\/[0-9]{2}\/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$/ {
    last_time = $10;
}
# Store USER records
$1 == "USER" {
    key = $3; # line (e.g., pts/0)
    users[key] = $5; # user
    hosts[key] = $6; # host
    start[key] = $10; # timestamp
    pids[key] = $2; # pid
    count++;
}
# Store DEAD records
$1 == "DEAD" && $3 != "" {
    end[$3] = $10; # line -> end timestamp
}
END {
    if (count == 0) {
        print "No USER records found in the file.";
        exit 1;
    }
    print "User       | Line      | Start Time           | End Time             | Host";
    print "-----------|-----------|----------------------|----------------------|-----------------";
    for (key in users) {
        user = users[key];
        host = hosts[key];
        start_time = start[key];
        end_time = end[key] ? end[key] : (shutdown ? shutdown : last_time);
        if (!end_time) end_time = "ongoing";
        printf "%-10s | %-10s | %-20s | %-20s | %s\n", user, key, start_time, end_time, host;
    }
}' plain.txt
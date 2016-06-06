--Author: Harry Archibald
--Date: 26/05/2016
-- Create endpoint with  port of 7022
CREATE ENDPOINT AG_endpoint
    STATE=STARTED 
    AS TCP (LISTENER_PORT=7022) 
    FOR DATABASE_MIRRORING (ROLE=ALL)
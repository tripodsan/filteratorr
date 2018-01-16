filteratorr
===========

Web app to validate and test vault filters.

In action: [filteratorr.appspot.com](http://filteratorr.appspot.com)

Develop
-------

The actual web app code is in [filteratorr-war/src/main/webapp](filteratorr-war/src/main/webapp/).

### Run a local test server

    cd filteratorr-war
    mvn appengine:devserver
    
Then go to <http://localhost:8080>
    
Kill server with `CTRL+C`. Must be restarted every time a file has changed.

### Deploy to Google App engine

    cd filteratorr-war
    mvn appengine:update
    
If that fails with "Either the access code is invalid or the OAuth token is revoked.Details: invalid_grant", run

    rm ~/.appcfg_oauth2_tokens_java
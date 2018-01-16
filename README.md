<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

filteratorr
===========

Web app to validate and test vault filters.

In action: [filteratorr.appspot.com](https://filteratorr.appspot.com)

Develop
-------

The actual web app code is in [src/main/webapp](src/main/webapp/).

### Run a local test server

    mvn appengine:run
    
Then go to <http://localhost:8080>
    
Kill server with `CTRL+C`. Must be restarted every time a file has changed.

### Deploy to Google App engine

    mvn appengine:deploy
    
    
### Thanks

Special thanks to [@alexkli](https://github.com/alexkli). The project layout and build files were copied from his [versionatorr](https://github.com/alexkli/versionatorr).
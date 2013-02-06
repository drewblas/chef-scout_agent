# chef-scout

Installs the agent for [Scout](http://scoutapp.com), a hosted server monitoring service. This recipe:

* Installs the `scout` Ruby gem
* Configures the Cron job to run the monitoring agent

## Requirements

Debian or Ubuntu preferred.  Tested on Ubuntu 8.04 Server LTS, should work on others.

The agent requires a Scout account and the account's associated key. The key can be found in the account settings tab within the Scout UI or in the server setup instructions.

The key looks like:

    0mZ6BD9DR0qyZjaBLCPZZWkW3n2Wn7DV9xp5gQPs

## Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>[:scout][:key]</td>
      <td>Assigns this node to the account with the specified key.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:user]</td>
      <td>User to run the Scout agent under. Will be created if it does not exist.</td>
      <td><code>scout</code></td>
    </tr>
    <tr>
      <td>[:scout][:group]</td>
      <td>User group to run the Scout agent under. Will be created if it does not exist.</td>
      <td><code>scout</code></td>
    </tr>
    <tr>
      <td>[:scout][:name]</td>
      <td>Optional name to display for this node within the Scout UI.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:roles]</td>
      <td>An Array of roles for this node. Roles are defined through Scout's UI.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:scout_bin]</td>
      <td>The full path to the scout gem binary. Run `gem env` on the node to view the <code>EXECUTABLE DIRECTORY</code>.</td>
      <td><code>/usr/bin/scout</code></td>
    </tr>
    <tr>
      <td>[:scout][:version]</td>
      <td>Gem version to install.</td>
      <td><code>Latest Release</code></td>
    </tr>
    <tr>
      <td>[:scout][:public_key]</td>
      <td>If you use self-signed custom plugins, set this attribute to the public key value and it'll be installed on the node.</td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

## Questions?

Contact Scout (<support@scoutapp.com>) with any questions, suggestions, bugs, etc.

## Authors and License

Additions, Modifications, & Updates:

Author: Scout (<support@scoutapp.com>)
Copyright: 2013, Scout
https://github.com/scoutapp/chef-scout

Author: Drew Blas (<drew.blas@gmail.com>)
Copyright: 2012, Drew Blas
https://github.com/drewblas/chef-scout_agent

Originally:

Author: Seth Chisamore (<schisamo@gmail.com>)
Copyright: 2010, Seth Chisamore
https://github.com/schisamo/chef_cookbooks

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
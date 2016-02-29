# wiw-hhvm-cookbook

A wrapper around the hhvm community cookbook.

## Supported Platforms

- Ubuntu 14.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['wiw_hhvm']['install_fastcgi']</tt></td>
    <td>Boolean</td>
    <td>Install fastcgi modules</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['wiw_hhvm']['listen_socket']</tt></td>
    <td>Boolean</td>
    <td>Configure hhvm to listen on a socket rather than a tcp port</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['wiw_hhvm']['socket']</tt></td>
    <td>Boolean</td>
    <td>If configured to listen on a socket, this is the path of the socket.</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['wiw_hhvm']['user']</tt></td>
    <td>String</td>
    <td>User to run fastcgi under</td>
    <td><tt>www-data</tt></td>
  </tr>
  <tr>
    <td><tt>['wiw_hhvm']['group']</tt></td>
    <td>String</td>
    <td>Group to run fastcgi under</td>
    <td><tt>www-data</tt></td>
  </tr>
</table>

## Usage

## License and Authors

Author:: Brian Oldfield (<brian+wiw@oldfield.io>)

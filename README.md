[![Build Status](https://travis-ci.org/akatz/instance_manager.png?branch=master)](https://travis-ci.org/akatz/instance_manager)
[![CodeClimate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/akatz/instance_manager)

# InstanceManager

This gem is to facilitate easy management of the instances
running your infrastructure on the AWS platform

## Installation
```
gem build instance_manager.gemspec
gem install instance_manager --local
```
## Usage

This requires amazon api credentials.

Place them in a file called ~/.instance-manager like this:

```
:default:
  :aws_access_key_id: XXXXXXXXXXXXXXXXXXXX
  :aws_secret_access_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
#### Listing
1. List all (running) instances
`sk instances`
1. List all (running) instances in production
`sk instances -e prod`
1. List all (running) instances for backoffice
`sk instances -r back`
1. list all instances (including stopped)
`sk instances -a`

#### Searching
1. Search by amazon id
`sk search i-b4c98bcd`
1. Search by public ip
`sk search 107.22.112.78`
1. Search by private ip
`sk search 10.244.207.225`

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Added some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

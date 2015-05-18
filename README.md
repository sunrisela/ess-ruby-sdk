# Ess::Ruby::Sdk

Aliyun::ESS is a Ruby library for Aliyun's Elastic Scaling Service API (http://www.aliyun.com/product/ess).
Full documentation of the currently supported API can be found at http://www.aliyun.com/product/ess#resources.

## Installation

Add this line to your application's Gemfile:

    gem 'aliyun-ess'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aliyun-ess

## Usage

#### Getting started

To get started you need to require 'aliyun/ess':

    % irb -rubygems
    irb(main):001:0> require 'aliyun/ess'
    # => true

The Aliyun::ESS library ships with an interactive shell called <tt>ess</tt>. From within it, you have access to all the operations the library exposes from the command line.

    % ess
    >> Version

Before you can do anything, you must establish a connection using Base.establish_connection!.  A basic connection would look something like this:

    Aliyun::ESS::Base.establish_connection!(
      :access_key_id     => 'abc', 
      :secret_access_key => '123'
    )

The minimum connection options that you must specify are your access key id and your secret access key.

(If you don't already have your access keys, all you need to sign up for the ESS service is an account at Aliyun. You can sign up for ESS and get access keys by visiting http://aliyun.aliyun.com/ess.)

For convenience, if you set two special environment variables with the value of your access keys, the console will automatically create a default connection for you. For example:

    % cat .aliyun_access_keys
    export ACCESS_KEY_ID='abcdefghijklmnop'
    export SECRET_ACCESS_KEY='1234567891012345'

Then load it in your shell's rc file.

    % cat .zshrc
    if [[ -f "$HOME/.aliyun_access_keys" ]]; then
      source "$HOME/.aliyun_access_keys";
    fi

See more connection details at Aliyun::ESS::Connection::Management::ClassMethods.

#### Aliyun::ESS Basics

    group_collections = Aliyun::ESS::ScalingGroup.find
    scaling_group     = group_collections.items.first
    scaling_rule      = scaling_group.scaling_rules.first
    scaling_rule.execute

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

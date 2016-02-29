# Solution by wiw-boldfield
## Demo

This solution is comprised of wrappers around the following community cookbooks:

- `mysql`
- `hhvm`
- `nginx`

utilizing rolebooks to glue them together.  To test converge a standalone blog server
using kitchen, follow these simple steps (from the root of the project):

```bash
$ cd cookbooks/wiw-standalone-blog-rolebook/
$ bundle install
$ kitchen converge
```

The following ports will be forwarded from the host machine to the guest:

- (host) 8080 -> (guest) 80
- (host) 4430 -> (guest) 443

Once started, final installation of the wordpress blog will be waiting for you to [complete](https://localhost:4430)!

## Testing

ChefSpec tests have been written for the 'wiw-nginx`, `wiw-mysql` and `wiw-hhvm` cookbooks, and can be run
but executing `rake spec` from the root of each cookbook.  Additionally, foodcritic and rubocop style checkers
can be similarly run with `rake style`. In addition to the `wiw-standalone-blog-rolebook` cookbook, these three
wrapper cookbooks also have kitchen configurations to facilitate convirging vagrant nodes, but do not have
any integration tests written at this time.

#Starter Project
##Purpose
  * Assess your ability to take some general specs to a working demo
  * Gives us something to talk about
  * Shouldn't take more than 4 hours
  * Don't make it too complex

##Spec
###Need to have
  * Chef cookbook[s], structure as you see fit.
  * Implement a Linux, MySQL, HHVM, Nginx single host running some sort of blog software (take your pick)
  * Base OS should be ubuntu 14.04
  * Use Berkshelf for dependancy management, please no vendor drops (but version locks are good!)
  * Should leverage community cookbooks when it make sense.
  * Shoud be testable using Vagrant.
 
###Nice to have
  * Security hardening and user management.
  * Should converge both in chef-zero and chef-client modes.
  * Take care with secrets!
  * Funcitonal/Unit/Lint tests are cool.
  * Think in terms of re-usable components.
  * Bonus points for a rake/Thor file for common tasks.

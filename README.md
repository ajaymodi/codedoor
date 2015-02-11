CodeDoor
========

CodeDoor is a marketplace for freelance programmers to find work.  To qualify as a freelancer, you need at least one commit in a public repository with at least 25 stars.

The CodeDoor platform is open source (MIT and BSD license).  See the LICENSE file for more details.

---------------

CodeDoor was available at https://www.codedoor.com/, but has shut down.

---------------

CodeDoor is currently intended to run on Heroku.

Copy config/application.yml.sample to config/application.yml, and add the relevant keys to your sandbox.

The oAuth callback should be ROOT_URL/users/auth/github

Make sure you run db:seed.  If you do not want test data, run db:update_skills instead.

---------------

Purpose of website:

You can use CodeDoor either as a client or as a programmer.  As a client, you can hire freelance programmers.  As a programmer, you can find freelance work.

To use CodeDoor as a client, you can click the "Search" button.  You can choose to search by skill and hourly rate.  If you find a programmer that you are interested in contacting, you may contact him or her after logging in.  To create an account, you currently need to log in with your GitHub account.  If you agree to a contract with the programmer, you pay the programmer for time spent until the contract is ended.

To use CodeDoor as a programmer, you sign up with your GitHub account. In order to qualify as a freelancer on CodeDoor, you need at least one commit on a public GitHub repository with at 25 stars.  If you have contributed to a prominent open source project not GitHub, you can gain access by sending a support email to CodeDoor.  You set your hourly rate, and if a client is interested, you will get contacted. If you agree to a contract with the client, you will be paid by the client for time spent until the contract is ended.

---------------

Documentation:

CodeDoor uses Devise and Omniauth for authentiation.  For now, both clients and programmers have to log in with their GitHub account.

Everyone who logs is a User.  After checking the terms of service (User.checked_terms?), the user may create a Programmer instance or a Client instance.  A user may have both types of accounts.

When a user clicks on "Create Programmer Account", a programmer model is made.  This is because github repos are prefetched, and github repos are added via AJAX before the all of the info is added.

Some routes might ensure that the user has the proper prerequisites before visiting the page

* ensure_user_checked_terms
* client_required
* programmer_required
* client_or_programmer_required

If the user does not have the proper state, then a cookie is created with the path.  After the user checks the terms of service, creates a client account, or creates a programmer account, the user is redirected if a cookie is present.

A "job" is a conversation between a client and a programmer.  It may contain a running contract, where the client pays for time logged by the programmer.  A client and programmer can only have one active (not finished or disabled) job between them.


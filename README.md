## Sample Rails app implementing paywall with pricingpage.co

The base app

- regular scaffold for `User` and `Post`
- basic "login" is simulated by clicking on a user's `Login` link
- top nav will display email address of `current_user`
- click on `Posts` link to crud `current_user.posts`

Integration work (see [5e0afd9](https://github.com/develsadvocates/pricingpage_example_app/commit/5e0afd9ab38b63fa07e8a948cf6f5267a54698e9) for code changes)

- add `activeresource` gem
- save the generated ruby script from pricingpage.co as `config/initializers/pricingpage.rb` (could be any filename)
- add `if-else` to `PostsController#new` to render `signup` template if there is no subscribed customer found for `current_user.id`
- paste embed code from pricingpage.co as `signup` template
  - this will display pricing plan details & payment buttons

What happens when user chooses a plan

- user is brought to paypal.com to checkout
- if successful, user can revisit `PostsController#new` and the `if-else` condition will consider `current_user` as a "subscribed customer"
- otherwise, `if-else` condition will continue to render `signup` template whenever user tries to visit `PostsController#new`
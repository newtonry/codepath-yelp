## Yelp

This is a Yelp search app using the [Yelp API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: `<Number of hours spent>`

### Features

#### Required

- [ ] Search results page
   - [x] Table rows should be dynamic height according to the content height
   - [x] Custom cells should have the proper Auto Layout constraints
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [ ] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [ ] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [ ] You can use the default UISwitch for on/off states. Optional: implement a custom switch
   - [ ] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

#### Optional

- [ ] Search results page
   - [ ] Infinite scroll for restaurant results
   - [ ] Implement map view of restaurant results
- [ ] Filter page
   - [ ] Radius filter should expand as in the real Yelp app
   - [ ] Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.)
- [ ] Implement the restaurant detail page.

### Walkthrough

![Video Walkthrough](...)


### Basic Yelp client

This is a headless example of how to implement an OAuth 1.0a Yelp API client. The Yelp API provides an application token that allows applications to make unauthenticated requests to their search API.

### Next steps

- Check out `MainViewController.swift` to see how to use the `YelpClient`.
- Augment the search method in the `YelpClient` with whatever search parameters you want to support.

### Sample request

```
client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)

client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
    println(response)
}) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
    println(error)
}

```

### Sample response

```
businesses =     (
                {
            categories =             (
                                (
                    Thai,
                    thai
                )
            );
            "display_phone" = "+1-415-931-6917";
            id = "lers-ros-thai-san-francisco";
            "image_url" = "http://s3-media2.ak.yelpcdn.com/bphoto/IStxUNVdfuPR2ddDAIPk_A/ms.jpg";
            "is_claimed" = 1;
            "is_closed" = 0;
            location =             {
                address =                 (
                    "730 Larkin St"
                );
                city = "San Francisco";
                "country_code" = US;
                "cross_streets" = "Olive St & Ellis St";
                "display_address" =                 (
                    "730 Larkin St",
                    "(b/t Olive St & Ellis St)",
                    Tenderloin,
                    "San Francisco, CA 94109"
                );
                neighborhoods =                 (
                    Tenderloin
                );
                "postal_code" = 94109;
                "state_code" = CA;
            };
            "menu_date_updated" = 1387658025;
            "menu_provider" = "single_platform";
            "mobile_url" = "http://m.yelp.com/biz/lers-ros-thai-san-francisco";
            name = "Lers Ros Thai";
            phone = 4159316917;
            rating = 4;
            "rating_img_url" = "http://s3-media4.ak.yelpcdn.com/assets/2/www/img/c2f3dd9799a5/ico/stars/v1/stars_4.png";
            "rating_img_url_large" = "http://s3-media2.ak.yelpcdn.com/assets/2/www/img/ccf2b76faa2c/ico/stars/v1/stars_large_4.png";
            "rating_img_url_small" = "http://s3-media4.ak.yelpcdn.com/assets/2/www/img/f62a5be2f902/ico/stars/v1/stars_small_4.png";
            "review_count" = 1154;
            "snippet_image_url" = "http://s3-media4.ak.yelpcdn.com/photo/D40HpcJt-O6Ll654S_--6w/ms.jpg";
            "snippet_text" = "Fantastic pad-see-ew. Super rich, flavorful sauce and plenty of ginormous prawns, especially for a $12 price tag in San Francisco. I went through a pretty...";
            url = "http://www.yelp.com/biz/lers-ros-thai-san-francisco";
        }
    );
    region =     {
        center =         {
            latitude = "37.7703124";
            longitude = "-122.43647245575";
        };
        span =         {
            "latitude_delta" = "0.06424638000000016";
            "longitude_delta" = "0.07145348265001417";
        };
    };
    total = 760;
```


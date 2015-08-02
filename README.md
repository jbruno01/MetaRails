# Meta Rails


##Purpose

In order to better understand the inner workings of Rails, I recreated the basic code involved with Rails' key components: the router, the controller, sessions, and params.

----
## Controller

The controller takes a request and response. It renders content by pulling a stored template file and rendering the ERB it contains. It then appends this content to the response body and builds a session.

## Router

The router creates and stores individual routes based on a given pattern and http_method. Router#run finds a route based on the supplied req and calls run on the matching route.

##Session

The sessions controller stores any cookies sent up with the request. Getter and setter methods are also supplied.

##Params

The params controller is responsible for taking in a request and route_params and ultimately returning a single params hash. It handles deep nesting by first splitting the request into keys with URI::decode_www_form and then further parsing with the parse_key method.

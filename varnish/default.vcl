# default.vcl - Combined Varnish Configuration for WordPress
vcl 4.1;

# Backend Configuration for Production and Staging
backend production {
    .host = "production-server";
    .port = "80";
    .probe = {
        .url = "/";
        .interval = 5s;
        .timeout = 1s;
        .window = 5;
        .threshold = 3;
    }
}

backend staging {
    .host = "staging-server";
    .port = "80";
    .probe = {
        .url = "/";
        .interval = 5s;
        .timeout = 1s;
        .window = 5;
        .threshold = 3;
    }
}

# Varnish Configuration for WordPress
sub vcl_recv {
    # Remove cookies for static assets to improve caching
    if (req.url ~ "\.(css|js|jpg|jpeg|png|gif|ico|webp|svg|woff|woff2|ttf|eot)$") {
        unset req.http.Cookie;
    }

    # Pass admin and login URLs directly to backend
    if (req.url ~ "/wp-admin/" || req.url ~ "/wp-login.php") {
        return (pass);
    }

    # General caching for all other requests
    return (hash);
}

sub vcl_backend_response {
    # Cache static assets for a longer time
    if (bereq.url ~ "\.(css|js|jpg|jpeg|png|gif|ico|webp|svg|woff|woff2|ttf|eot)$") {
        set beresp.ttl = 30d;
    }

    # Set a short TTL for HTML documents to ensure they stay updated
    if (bereq.url ~ "\.html$" || bereq.url == "/") {
        set beresp.ttl = 1m;
    }
}

sub vcl_deliver {
    # Add headers to indicate Varnish cache status
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
    } else {
        set resp.http.X-Cache = "MISS";
    }
}

# Custom Error Handling
sub vcl_synth {
    if (resp.status == 404) {
        set resp.http.Content-Type = "text/html; charset=utf-8";
        synthetic("<html><body><h1>Page Not Found</h1><p>The page you requested could not be found.</p></body></html>");
        return (deliver);
    }

    if (resp.status == 503) {
        set resp.http.Content-Type = "text/html; charset=utf-8";
        synthetic("<html><body><h1>Service Unavailable</h1><p>Our servers are currently overloaded. Please try again later.</p></body></html>");
        return (deliver);
    }
}

**Mumble** is a VOIP application which allows users to talk to each other via
the same server. It uses a client-server architecture, and encrypts all
communication to ensure user privacy. **Murmur** is the server that Mumble
clients to connect to.

How to start it:

* configure letsencrypt (`/etc/letsencrypt/configs/<YOUR_URL>`)

```
# the domain we want to get the cert for;
# technically it's possible to have multiple of this lines, but it only worked
# with one domain for me, another one only got one cert, so I would recommend
# separate config files per domain.
domains = <YOUR_URL>

# increase key size
rsa-key-size = 4096

# the current closed beta (as of 2015-Nov-07) is using this server
server = https://acme-v01.api.letsencrypt.org/directory

# this address will receive renewal reminders
email = <YOUR_EMAIL>

# turn off the ncurses UI, we want this to be run as a cronjob
text = True

# authenticate by placing a file in the webroot (under .well-known/acme-challenge/)
# and then letting LE fetch it
authenticator = webroot
webroot-path = /var/www/mumble/
```

* configure nginx (`/etc/nginx/sites-available/mumble`)

```
server {
    listen 80 default_server;
    server_name <YOUR_URL>;

    location /.well-known/acme-challenge {
        root /var/www/mumble;
    }
}
```

* get a certificate

```
# certbot --config /etc/letsencrypt/configs/<YOUR_URL> certonly
```

* Install systemd services
```
# make install
```

### Logging in as SuperUser

If the environment variable `SUPERUSER_PASSWORD` is not defined when creating
the container, a password will be automatically generated. To view the password
for any container at any time, look at the container's logs.
As an example, to view the SuperUser password for an instance running in a container
named `mumble`:

```
$ docker logs mumble 2>&1 | grep SUPERUSER_PASSWORD
> SUPERUSER_PASSWORD: <value>
```

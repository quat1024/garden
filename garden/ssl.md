# SSL, nginx, certbot

Ok.

I installed certbot with `venv`/`pip`, this is way better than snap I think; [instructions are here](https://certbot.eff.org/instructions?ws=other&os=pip).

Additionally i'm not too comfortable with the magic auto-configuration certbot does. I want to know how it works!

There are two parts to an ACME challenge and response:

1. Certbot and let's encrypt cook up an ACME challenge. Certbot writes it to a file that is supposed to be reachable from `http://example.com/.well-known/acme-challenge/<something>`. Certbot then tells let's encrypt "i have an ACME challenge for you at this url"; let's encrypt looks for it at that location.
2. If let's encrypt can find the challenge and it's good, it gives certbot a new SSL certificate. The web server needs to install this new certificate.

We need:

* a place certbot can write acme challenges that the web server will serve from the appropriate path,
* to know where certbot writes the certificates, so the web server can use them,
* a way to restart the web server after it picks up a new certificate.

## Serving acme-challenge files

I did it with this kind of nginx directive:

```
server {
  # ...
  
  location /.well-known/acme-challenge {
  	root /opt/notes-certbot;
  }
}
```

This means a request to `example.com/.well-known/acme-challenge/foobar` is directed to the file `/opt/notes-certbot/.well-known/acme-challenge/foobar` on the filesystem.

The site is called `notes`, so i reserved a `notes-certbot` directory for certbot to spray its files into.

## Configuring certbot initially

[Man page is here](https://eff-certbot.readthedocs.io/en/stable/man/certbot.html). Many certbot commands are interactive, if you leave off an option it will ask you. Kinda friendly.

The command i used: `certbot certonly --webroot --webroot-path /opt/notes-certbot`.

* `--webroot` makes it use the webroot method (as opposed to magical auto-configuration of nginx or whatever)
* `--webroot-path` is the location certbot will spray its files in

You can pass `-d` for a comma-separated list of domains you want certs for, if you don't specify you will be asked interactively.

This will create a private and public key in `/etc/letsencrypt/live/<domain>/`.

You can pass `--test-cert` to order a certificate from the staging server which has relaxed ratelimits. Browsers will consider it to be self-signed and show an SSL error, but that just means it's working!

I noticed this in the certbot documentation:

> For historical reasons, the containing directories are created with permissions of `0700` meaning that certificates are accessible only to servers that run as the root user. **If you will never downgrade to an older version of Certbot**, then you can safely fix this using `chmod 0755 /etc/letsencrypt/{live,archive}`.

Very silly. Those directories didn't exist before I successfully exchanged my first key, I created them before chmodding them and things seem good.

## Telling nginx to use those keys

```
server {
	listen 80; # for non-https access
	listen 443 ssl;
	ssl_certificate     /etc/letsencrypt/live/notes.highlysuspect.agency/fullchain.pem;
	ssl_certiticate_key /etc/letsencrypt/live/notes.highlysuspect.agency/privkey.pem;
}
```

Cool. `systemctl restart nginx`.

See https://nginx.org/en/docs/http/configuring_https_servers.html .

It is a little picky; if you specify `listen <something> ssl` you must also specify `ssl_certificate(_key)`, and both halves of the key must exist and be readable by nginx. Kind of a chicken-and-egg game when it's first being set up.

## Key renewal

I did this with a systemd service (per [this blogpost](https://stevenwestmoreland.com/2017/11/renewing-certbot-certificates-using-a-systemd-timer.html) I found on google).

In `/etc/systemd/system/quat-certbot.service`:

```
[Service]
ExecStart=certbot renew --post-hook "systemctl restart nginx"
```

Adjacent to it, in `quat-certbot.timer`:

```
[Timer]
OnBootSec=300
OnUnitActiveSec=1w
RandomizedDelaySec=240s

[Install]
WantedBy=multi-user.target
```

Then `systemctl start` and `enable` the timer. Auto renews every week. Can check status with `systemctl status` and the usual suspects.

The `RandomizedDelaySec` i added is kind of moot since it's a timer and not a calendar-based cronjob... I should use a cron job. It's a [somewhat newer systemd feature](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html) that helps cut down the thundering herd of domain renewal requests lol

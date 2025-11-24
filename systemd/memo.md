# systemd

Locations:

* /etc/systemd/system
* /usr/lib/systemd/system

Unit File Man Pages:

```sh
man systemd.unit
man systemd.service
man systemd.exec
```

```sh
# list services
systemctl list-services
systemctl list-units --type=service

# list installed units, including not-loaded units
systemctl list-unit-files

# list only service units
systemctl list-units-files --type=service

# check service status
systemctl status <service_name.service>

# check all service status
systemctl --type=service

# start/stop/restart
systemctl start <service_name.service>
systemctl stop <service_name.service>
systemctl restart <service_name.service>

# reload systemd configurations, required after modify .service files, then `restart` services will take effect
systemctl daemon-reload <service_name.service>

# enabled/disabled on boot
systemctl enable <service_name.service>
systemctl disable <service_name.service>

# check whether enabled
systemctl is-enabled <service_name.service>

# check service file content
systemctl cat <service_name.service>

# edit service file, will create `service_name.service.d` sub folder to put override unit file
# if `--full` specified, the original unit file will be edited
systemctl edit <service_name.service>
```

# journalctl

* -f: follow
* -n: latest N lines
* --since/--until: ex: "2023-10-26 10:00:00" or "yesterday" or "1 hour ago"
* -p: log level, ex: err, warning

```sh
# check unit log
journalctl -u <service_name.service>
```

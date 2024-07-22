# NATS

* [veggiemonk/compose-nats](https://github.com/veggiemonk/compose-nats)
* [nats.py](https://github.com/nats-io/nats.py)

```sh
pip install nats-py[nkeys]
```

# NATS TLS

```sh
# init cluster
bash scripts/gencert.sh nats.tls.com
docker compose up -d
```

The `allow_non_tls: true` cluster setting seems not competible with the python sdk well.
The sdk doesn't respect `tls://` protocol and just use plain text for transmission.

Set `tls_handshake_first=True` can work with implicit TLS.

# Tools

```sh
# --- nats-cli
curl -sf https://binaries.nats.dev/nats-io/natscli/nats@latest | sh
# if go installed
go install github.com/nats-io/natscli/nats@latest

# --- nsc
curl -Lsf https://raw.githubusercontent.com/nats-io/nsc/main/install.sh | sh
# binary
https://github.com/nats-io/nsc/releases/download/v2.8.6/nsc-linux-amd64.zip
```


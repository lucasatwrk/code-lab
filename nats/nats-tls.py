import asyncio
import nats
from nats.errors import TimeoutError
import ssl
import pdb

async def main():
    ssl_ctx = ssl._create_unverified_context()
    nc = await nats.connect("tls://localhost:4222", tls=ssl_ctx, tls_handshake_first=True)
    # nc = await nats.connect("localhost")

    # Create JetStream context.
    js = nc.jetstream()

    # Persist messages on 'foo's subject.
    await js.add_stream(name="sample-stream", subjects=["foo"])

    msg_cnt = 3
    for i in range(0, msg_cnt):
        ack = await js.publish("foo", f"hello world: {i}".encode())
        print(ack)

    # Create pull based consumer on 'foo'.
    psub = await js.pull_subscribe("foo", "psub")

    # Fetch and ack messagess from consumer.
    for i in range(0, msg_cnt):
        msgs = await psub.fetch(1)
        for msg in msgs:
            print(msg)

    await nc.close()

if __name__ == '__main__':
    asyncio.run(main())
    # print(ssl.OPENSSL_VERSION)

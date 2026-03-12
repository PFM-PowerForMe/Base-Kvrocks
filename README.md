# Base-Kvrocks

需要 kvrocks 用户
```
RUN addgroup -g 1002 -S kvrocks && adduser -u 1002 -S kvrocks -G kvrocks
RUN mkdir /var/run/kvrocks && \
    chown -R kvrocks:kvrocks /var/run/kvrocks /var/lib/kvrocks

```

## [Redis Event Library](https://redis.io/topics/internals-rediseventlib)

===> creates and returns by

redisServer struct contain aeEventLoop and fd

Event Handler
Have `epoll` use `epoll` else
Have `kqueue` use `kqueue` else
use `select`

Event Loop Initialization
struct aeEventLoop
{
  aeFileEvent  array
  aeTimeEvent　list
  apidata      void*
}

use epoll explain
aeCreateEventLoop mallocs aeEventLoop
then mallocs aeApiState(
    epfd            epoll file descriptor ===> `epoll_create`
    epoll_event     epoll_event(Linux epoll Library)
)

sever.fd listening(default on port 6379) descriptor ==> `anet.c: anetTcpServer`

aeCreateTimeEvent add a timed event to aeTimeEvent List

aeCreateFileEvent use `epoll_ctl` adds w watch for EPOLLIN event on server.fd and associate it with epfd, add aeFileEvent to aeFileEvent array.

aeMain calls aeProcessEvents process pending time and file events.

aeProcessEvents use aeSearchNearestTimer looks for the nearest time event.

aeApiPoll does a `epoll_wait` and populate fired aeFileEvent array return the number of file events ready for operation.

client requested a connection the aeApiPool would have noticed it and do things.

ae.processTimeEvents iterates over list of time events

## Learn epoll
epoll − I/O event notification facility        https://man.cx/epoll(7)

epoll_create  https://man.cx/epoll_create(2)
epoll_ctl     https://man.cx/epoll_ctl
epoll_wait    https://man.cx/epoll_wait

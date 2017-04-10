The fact that the user can count on Redis not removing scripts is semantically useful in the context of pipelining.
If EVALSHA will return a NOSCRIPT error the command can not be reissued later otherwise the order of execution is violated.

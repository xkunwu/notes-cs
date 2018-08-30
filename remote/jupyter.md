### Working with Jupyter notebook on a remote  server ###

1. First, connect to the remote server if you haven’t already

```
ssh remote_server
```

1.5. Jupyter takes browser security very seriously, so in order to access a remote session from a local browser we need to set up a password associated with the remote Jupyter session. This is stored in jupyter_notebook_config.py which by default lives in ~/.jupyter. You can edit this manually, but the easiest option is to set the password by running Jupyter with the password argument:

```
jupyter-notebook password
```

This password will be used to access any Jupyter session running from this installation, so pick something sensible. You can set a new password at any time on the remote server in exactly the same way.

2. Launch a Jupyter session on the remote server.

```
jupyter-notebook --port=8888 --no-browser &
```

3. Now Jupyter is running on our remote server, we just need to create an ssh tunnel between a port on our machine and the port our Jupyter session is using on the remote server. On our local machine:

```
ssh -N -f -L 8888:localhost:8888 remote_server
```

- N tells ssh we won’t be running any remote processes using the connection. This is useful for situations like this where all we want to do is port forwarding.

- f runs ssh in the background, so we don’t need to keep a terminal session running just for the tunnel.

- L specifies that we’ll be forwarding a local port to a remote address and port. In this case, we’re forwarding port 8888 on our machine to port 9000 on the remote server. The name ‘localhost’ just means ‘this computer’. If you’re a Java programmer who lives for verbosity, you could equivalently pass -L localhost:8888:localhost:9000.

4. Fire up your favourite browser and type localhost:8888 into the address bar. This should bring up a Jupyter session and prompt you for a password. Enter the password you specified for Jupyter on the remote server.

5. To close the SSH tunnel on the local machine:

```
ps aux | grep localhost:8888
```

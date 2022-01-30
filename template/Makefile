SHELL:=/bin/bash

### local side
ssh-4017hp:
	ssh 4017hp

tunnel-4017hp-8080:
	ssh -L 8080:localhost:8080 xwu@4017hp

### server side:
start-jupyter:
	jupyter notebook --no-browser --port=8080
start-jupyter-web:
	jupyter notebook --port=8080
	
watch-nvidia:
	watch -n 1 -d nvidia-smi

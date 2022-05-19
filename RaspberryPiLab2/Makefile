floydwarshall: floydwarshall_main.c floydwarshall.s     # list of dependencies for make target. 
	gcc -g -mcpu=cortex-a53 -o floydwarshall floydwarshall_main.c floydwarshall.s 

floodfill: islandfill_main.c islandfill.s     # list of dependencies for make target. 
	gcc -mcpu=cortex-a53 -o islandfill islandfill_main.c islandfill.s

dfs: dfs_main.c dfs.s     # list of dependencies for make target. 
	gcc -mcpu=cortex-a53 -o dfs dfs_main.c dfs.s   # commands to run if any of the dependendies have changed

dfs-debug: dfs_main.c dfs.s    
	gcc -g -mcpu=cortex-a53 -o dfs dfs_main.c dfs.s

clean:
	rm dfs

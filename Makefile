CC=gcc
all: main-1 main-2 main-a main-so main-so2 main-dynamic-so

main-1: myAPI.c main.c myAPI.h
	$(CC) -o main-1 myAPI.c main.c
	@echo "main-1 done.  直接编译省略显示编译.o文件"
	@echo

main-2: main.c myAPI.o
	$(CC) -o main-2 myAPI.o main.c
	@echo "main-2 done.  显示编译.o文件"
	@echo

main-a: libmyAPI.a
	$(CC) -o main-a  main.c libmyAPI.a
	@echo "main-a done.  使用.a静态库文件 链接生成程序"
	@echo

main-so: libmyAPI.so
	$(CC) -o main-so main.c ./libmyAPI.so
	@echo "main-so done.  直接使用.so动态库文件(需要带路径,运行时直接使用此路径) 链接生成程序"
	@echo

main-so2: libmyAPI.so
	$(CC) -o main-so2 main.c -L. -lmyAPI
	@echo "main-so2 done.  让$(CC)自动在当前目录("."表示当前目录,或"./")查找.so动态库文件 链接生成程序"
	@echo "    但运行时默认到/usr/lib目录查找,,或运行前设置环境变量 LD_LIBRARY_PATH 为动态库的路径"## :export LD_LIBRARY_PATH=./  ./main-so2
	@echo


main-dynamic-so:libmyAPI.so
	$(CC) -o main-dynamic-so main_2.c -ldl
	@echo 需要加入-ldl，否则会提示dlopen找不到。
	@echo

myAPI.o: myAPI.c myAPI.h
	$(CC) -c myAPI.c
	@echo "myAPI.o done.  编译.o文件"
	@echo

libmyAPI.a: myAPI.o
	ar crv libmyAPI.a myAPI.o
	@echo "libmyAPI.a done.  编译.a静态库文件"
	@echo

libmyAPI.so:
	$(CC) -fPIC -c myAPI.c
	$(CC) -shared -o libmyAPI.so myAPI.o
	@echo "libmyAPI.so done.  编译.so动态库文件,需要 .o文件编译时加选项 -fPIC"
	@echo "    或者 直接编译动态库:"
	@echo "    $(CC) -shared -fPIC -o libmyAPI.so myAPI.c"
	@echo

#或者 直接编译动态库:
#libmyAPI.so:
#    $(CC) -shared -fPIC -o libmyAPI.so myAPI.c
#

clean:
	rm -f *.o *.a *.so main-*


#include<stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>
/*
int ADD(int a, int b);
int MINUS(int a, int b);
*/
#define SHARED_LIB_NAME "libmyAPI.so"

#define DECLARE_LIB_FUNC(x, sx) \
    do { \
        m_shared_lib_handle_t->x = (int (*)(int, int))dlsym(libHandle, sx); \
        if (m_shared_lib_handle_t->x == NULL) { \
            printf("Loading %s failed (%d:%s)", sx, errno, strerror(errno)); \
            goto exit; \
        } \
    } while(0)


typedef struct shared_lib_handle {
    void *_data;
    //void* ADD;
    //void* MINUS;
    int (*ADD)(int a, int b);
    int (*MINUS)(int a, int b);
} shared_lib_handle_t;

int main(){
    void *libHandle;
    shared_lib_handle_t* m_shared_lib_handle_t=NULL;
    libHandle = dlopen(SHARED_LIB_NAME, RTLD_NOW);
    if(libHandle == NULL) {
        printf("load OPTEECom API library failed (%d:%s)", errno, strerror(errno));
        goto exit;
    }
    
    m_shared_lib_handle_t = (shared_lib_handle_t*)malloc(sizeof(shared_lib_handle_t));
    if(m_shared_lib_handle_t == NULL){
        printf("malloc failed\n");
        goto exit;
    }
    
    
    
    DECLARE_LIB_FUNC(ADD, "ADD");
    DECLARE_LIB_FUNC(MINUS, "MINUS");
    
    printf("1 + 1 = %d\n",m_shared_lib_handle_t->ADD(1, 1));
    printf("1 - 1 = %d\n",m_shared_lib_handle_t->MINUS(1, 1));
    

exit:
    
    if(m_shared_lib_handle_t!=NULL){
        free(m_shared_lib_handle_t);
        m_shared_lib_handle_t = NULL;
    }
    
    
    if(libHandle != NULL) {
                dlclose(libHandle);
                libHandle = NULL;
            }
    
    return 0;

}

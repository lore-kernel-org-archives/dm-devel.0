From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: pthread_cancel and clone weirdness
Date: Sat, 16 Jul 2005 09:31:22 -0500
Message-ID: <20050716143122.GA11187@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

O.k. I finally figured out why pthread_cancel just wasn't working for me,
and it has something to do with the clone() call in multipathd. If you
fork child(), everything works correctly. If you clone it, pthread_cancel
dosn't work on PTHREAD_CANCEL_ASYNCHRONOUS type threads. This makes
no sense to me.  Is this supposed to happen??

Could people please try running the attached test program? When I use
clone() (WORKS_CORRECTLY set to 0) it hangs. When I use fork()
(WORKS_CORRECTLY set to 1) it does exactly what I expect.  This is happening
for me on RHEL4. I would be interested in knowing if it happens on other
distros.

Thanks
-Ben

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pthread_test.c"

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <sched.h>
#include <string.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

/* Compile with # gcc -o pthread_test -lpthread pthread_test.c */

/* uncomment this to make the program work on RHEL4. */
/* #define WORK_CORRECTLY 1 */

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void *thread_test(void *unused)
{
	pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);
	pthread_mutex_unlock(&mutex);
	pause();
	return NULL;
}	

int test(void *unused)
{
	void *status;
	int r;
	pthread_t thread;
	pthread_mutex_lock(&mutex);
	if ((r = pthread_create(&thread, NULL, thread_test, NULL)) != 0) {
		printf("pthread_create returned %d\n", r);
		exit(1);
	}
	pthread_mutex_lock(&mutex);
	printf("cancelling thread\n");
	r = pthread_cancel(thread);
	printf("pthread cancel returned : %s\n", strerror(r));
	printf("joining thread\n");
	r = pthread_join(thread, &status);
	printf("pthread_join returned : %s\n", strerror(r));
	if (status == PTHREAD_CANCELED)
		printf("child was canceled\n");
	else
		printf("child exit status is %u\n", (unsigned)status);
	return 0;
}

int main(void)
{
#if WORK_CORRECTLY
	int pid = fork();
	if (pid < 0){
		printf("fork failed\n");
		exit(1);
	}
	if (!pid) /* child */
		return test(NULL);
	
	/* parent */
	wait(NULL);
	return 0;
#else
	void *stack = (void *)malloc(16384);
	if (clone(test, stack + 16383, 0, NULL) < 0) {
		printf("clone failed\n");
		exit(1);
	}
	waitpid(0, NULL, __WCLONE);
	return 0;
#endif
}

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--LQksG6bCIzRHxTLp--

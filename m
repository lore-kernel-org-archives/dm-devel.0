From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 52/78] multipathd: Issue warning on CLI command
	timeout
Date: Mon, 16 Mar 2015 13:36:39 +0100
Message-ID: <1426509425-15978-53-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Some CLI commands like 'reconfigure' could take longer than the
socket timeout, causing the CLI to report 'timeout receiving packet'.
In these cases the multipath daemon should issue a warning with
the actual time spent in the CLI call to give the administator
some hints on the best socket timeout.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c   |  4 ++++
 multipathd/uxlsnr.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 394bec4..2d527df 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1522,6 +1522,8 @@ reconfigure (struct vectors * vecs)
 	struct config * old = conf;
 	int retval = 1;
 
+	running_state = DAEMON_CONFIGURE;
+
 	/*
 	 * free old map and path vectors ... they use old conf state
 	 */
@@ -1546,6 +1548,8 @@ reconfigure (struct vectors * vecs)
 		retval = 0;
 	}
 
+	running_state = DAEMON_RUNNING;
+
 	return retval;
 }
 
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 624d4eb..f20982f 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -20,6 +20,7 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <sys/poll.h>
+#include <sys/time.h>
 #include <signal.h>
 #include <checkers.h>
 #include <memory.h>
@@ -29,6 +30,7 @@
 #include <structs_vec.h>
 #include <uxsock.h>
 #include <defaults.h>
+#include <config.h>
 
 #include "main.h"
 #include "cli.h"
@@ -91,6 +93,24 @@ void free_polls (void)
 		FREE(polls);
 }
 
+void check_timeout(struct timeval start_time, char *inbuf,
+		   unsigned int timeout)
+{
+	struct timeval diff_time, end_time;
+
+	if (start_time.tv_sec && gettimeofday(&end_time, NULL) == 0) {
+		timersub(&end_time, &start_time, &diff_time);
+		unsigned long msecs;
+
+		msecs = diff_time.tv_sec * 1000 +
+			diff_time.tv_usec / 1000;
+		if (msecs > timeout)
+			condlog(2, "cli cmd '%s' timeout reached "
+				"after %lu.%06lu secs", inbuf,
+				diff_time.tv_sec, diff_time.tv_usec);
+	}
+}
+
 void uxsock_cleanup(void *arg)
 {
 	cli_exit();
@@ -105,15 +125,24 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 {
 	int ux_sock;
 	size_t len;
-	int rlen;
+	int rlen, timeout;
 	char *inbuf;
 	char *reply;
 	sigset_t mask;
 
 	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
 
-	if (ux_sock == -1)
-		exit(1);
+	if (ux_sock == -1) {
+		condlog(1, "could not create uxsock: %d", errno);
+		return NULL;
+	}
+
+	if (!conf) {
+		condlog(1, "configuration changed");
+		return NULL;
+	}
+
+	timeout = conf->uxsock_timeout;
 
 	pthread_cleanup_push(uxsock_cleanup, NULL);
 
@@ -125,6 +154,14 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 		struct client *c;
 		int i, poll_count;
 
+		/*
+		 * Store configuration timeout;
+		 * configuration might change during
+		 * the call to 'reconfigure'.
+		 */
+		if (conf)
+			timeout = conf->uxsock_timeout;
+
 		/* setup for a poll */
 		polls = REALLOC(polls, (1+num_clients) * sizeof(*polls));
 		polls[0].fd = ux_sock;
@@ -158,8 +195,13 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 			struct client *next = c->next;
 
 			if (polls[i].revents & POLLIN) {
+				struct timeval start_time;
+
+				if (gettimeofday(&start_time, NULL) != 0)
+					start_time.tv_sec = 0;
+
 				if (recv_packet(c->fd, &inbuf, &len,
-						DEFAULT_UXSOCK_TIMEOUT) != 0) {
+						timeout) != 0) {
 					dead_client(c);
 				} else {
 					inbuf[len - 1] = 0;
@@ -176,6 +218,8 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 						FREE(reply);
 						reply = NULL;
 					}
+					check_timeout(start_time, inbuf,
+						      timeout);
 					FREE(inbuf);
 				}
 			}
-- 
1.8.4.5

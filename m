From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 76/78] multipathd: timeout CLI commands when
	waiting for lock
Date: Mon, 16 Mar 2015 13:37:03 +0100
Message-ID: <1426509425-15978-77-git-send-email-hare@suse.de>
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

When a CLI command is waiting for the vector lock it might
timeout, but the command itself remains queued. This causes
some irritation as no other commands can be send until the
original command is processed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.h    |  2 ++
 libmultipath/configure.c |  7 ++++---
 libmultipath/dict.c      | 11 +++++++----
 libmultipath/lock.h      |  4 ++--
 multipathd/cli.c         | 26 ++++++++++++++++++++++----
 multipathd/cli.h         |  2 +-
 multipathd/main.c        | 12 ++++++++----
 multipathd/main.h        |  1 +
 multipathd/uxlsnr.c      | 16 +++-------------
 9 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 0183969..e512321 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -170,6 +170,8 @@ struct config {
 	vector elist_property;
 };
 
+extern int uxsock_timeout;
+
 struct config * conf;
 
 struct hwentry * find_hwe (vector hwtable, char * vendor, char * product, char *revision);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 24ad948..3a90950 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -701,7 +701,7 @@ deadmap (struct multipath * mpp)
 	return 1; /* dead */
 }
 
-int check_daemon(void)
+int check_daemon(int timeout)
 {
 	int fd;
 	char *reply;
@@ -714,7 +714,7 @@ int check_daemon(void)
 
 	if (send_packet(fd, "show daemon", 12) != 0)
 		goto out;
-	if (recv_packet(fd, &reply, &len, conf->uxsock_timeout) != 0)
+	if (recv_packet(fd, &reply, &len, timeout) != 0)
 		goto out;
 
 	if (strstr(reply, "shutdown"))
@@ -848,7 +848,8 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		if (r == DOMAP_DRY)
 			continue;
 
-		if (!conf->daemon && !conf->allow_queueing && !check_daemon()) {
+		if (!conf->daemon && !conf->allow_queueing &&
+		    !check_daemon(uxsock_timeout)) {
 			if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 			    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
 				condlog(3, "%s: multipathd not running, unset "
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 5c2da43..ff06a93 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1037,23 +1037,26 @@ declare_mp_snprint(delay_wait_checks, print_delay_checks)
 static int
 def_uxsock_timeout_handler(vector strvec)
 {
-	unsigned int uxsock_timeout;
+	unsigned int timeout;
 	char *buff;
 
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
 
-	if (sscanf(buff, "%u", &uxsock_timeout) == 1 &&
-	    uxsock_timeout > DEFAULT_UXSOCK_TIMEOUT)
-		conf->uxsock_timeout = uxsock_timeout;
+	if (sscanf(buff, "%u", &timeout) == 1 &&
+	    timeout > DEFAULT_UXSOCK_TIMEOUT)
+		conf->uxsock_timeout = timeout;
 	else
 		conf->uxsock_timeout = DEFAULT_UXSOCK_TIMEOUT;
 
 	free(buff);
+	uxsock_timeout = conf->uxsock_timeout;
 	return 0;
 }
 
+int uxsock_timeout = DEFAULT_UXSOCK_TIMEOUT;
+
 /*
  * blacklist block handlers
  */
diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 04ef78d..97af0f4 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -21,11 +21,11 @@ struct mutex_lock {
 	a.depth--; pthread_mutex_unlock(a.mutex)
 #define lock_cleanup_pop(a) \
 		fprintf(stderr, "%s:%s(%i) unlock %p depth: %d (%ld)\n", __FILE__, __FUNCTION__, __LINE__, a.mutex, a.depth, pthread_self()); \
-	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1)
 #else
 #define lock(a) a.depth++; pthread_mutex_lock(a.mutex)
 #define unlock(a) a.depth--; pthread_mutex_unlock(a.mutex)
-#define lock_cleanup_pop(a) pthread_cleanup_pop(1);
+#define lock_cleanup_pop(a) pthread_cleanup_pop(1)
 #endif
 
 void cleanup_lock (void * data);
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 2d3d02d..2c78ee4 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005 Christophe Varoqui
  */
+#include <sys/time.h>
 #include <pthread.h>
 #include <memory.h>
 #include <vector.h>
@@ -386,11 +387,13 @@ genhelp_handler (void)
 }
 
 int
-parse_cmd (char * cmd, char ** reply, int * len, void * data)
+parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 {
 	int r;
 	struct handler * h;
 	vector cmdvec = NULL;
+	struct timespec tmo;
+	struct timeval now;
 
 	r = get_cmdvec(cmd, &cmdvec);
 
@@ -412,12 +415,27 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data)
 	/*
 	 * execute handler
 	 */
+	if (gettimeofday(&now, NULL) == 0) {
+		tmo.tv_sec = now.tv_sec + timeout;
+		tmo.tv_nsec = now.tv_usec * 1000;
+	} else {
+		tmo.tv_sec = 0;
+	}
 	if (h->locked) {
 		struct vectors * vecs = (struct vectors *)data;
+
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		lock(vecs->lock);
-		pthread_testcancel();
-		r = h->fn(cmdvec, reply, len, data);
+		if (tmo.tv_sec) {
+			vecs->lock.depth++;
+			r = pthread_mutex_timedlock(vecs->lock.mutex, &tmo);
+		} else {
+			lock(vecs->lock);
+			r = 0;
+		}
+		if (r == 0) {
+			pthread_testcancel();
+			r = h->fn(cmdvec, reply, len, data);
+		}
 		lock_cleanup_pop(vecs->lock);
 	} else
 		r = h->fn(cmdvec, reply, len, data);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index b35a315..de62278 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -90,7 +90,7 @@ int alloc_handlers (void);
 int add_handler (unsigned long fp, int (*fn)(void *, char **, int *, void *));
 int set_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *));
 int set_unlocked_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *));
-int parse_cmd (char * cmd, char ** reply, int * len, void *);
+int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
 int load_keys (void);
 char * get_keyparam (vector v, unsigned long code);
 void free_keys (vector vec);
diff --git a/multipathd/main.c b/multipathd/main.c
index 77a1241..6c98686 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -807,10 +807,13 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 	*len = 0;
 	vecs = (struct vectors *)trigger_data;
 
-	r = parse_cmd(str, reply, len, vecs);
+	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
 
 	if (r > 0) {
-		*reply = STRDUP("fail\n");
+		if (r == ETIMEDOUT)
+			*reply = STRDUP("timeout\n");
+		else
+			*reply = STRDUP("fail\n");
 		*len = strlen(*reply) + 1;
 		r = 1;
 	}
@@ -917,6 +920,7 @@ uevqloop (void * ap)
 
 	return NULL;
 }
+
 static void *
 uxlsnrloop (void * ap)
 {
@@ -2102,7 +2106,7 @@ main (int argc, char *argv[])
 		case 'k':
 			if (load_config(DEFAULT_CONFIGFILE, udev_new()))
 				exit(1);
-			uxclnt(optarg, conf->uxsock_timeout);
+			uxclnt(optarg, uxsock_timeout + 100);
 			exit(0);
 		case 'B':
 			conf->bindings_read_only = 1;
@@ -2126,7 +2130,7 @@ main (int argc, char *argv[])
 			optind++;
 		}
 		c += snprintf(c, s + CMDSIZE - c, "\n");
-		uxclnt(s, conf->uxsock_timeout);
+		uxclnt(s, uxsock_timeout + 100);
 		exit(0);
 	}
 
diff --git a/multipathd/main.h b/multipathd/main.h
index 10378ef..1813633 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -15,6 +15,7 @@ struct prout_param_descriptor;
 struct prin_resp;
 
 extern pid_t daemon_pid;
+extern int uxsock_timeout;
 
 void exit_daemon(void);
 const char * daemon_status(void);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 61ba49a..698641b 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -125,7 +125,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 {
 	int ux_sock;
 	size_t len;
-	int rlen, timeout;
+	int rlen;
 	char *inbuf;
 	char *reply;
 	sigset_t mask;
@@ -142,8 +142,6 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		return NULL;
 	}
 
-	timeout = conf->uxsock_timeout;
-
 	pthread_cleanup_push(uxsock_cleanup, NULL);
 
 	polls = (struct pollfd *)MALLOC(0);
@@ -154,14 +152,6 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		struct client *c, *tmp;
 		int i, poll_count, num_clients;
 
-		/*
-		 * Store configuration timeout;
-		 * configuration might change during
-		 * the call to 'reconfigure'.
-		 */
-		if (conf)
-			timeout = conf->uxsock_timeout;
-
 		/* setup for a poll */
 		pthread_mutex_lock(&client_lock);
 		num_clients = 0;
@@ -221,7 +211,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 					start_time.tv_sec = 0;
 
 				if (recv_packet(c->fd, &inbuf, &len,
-						timeout) != 0) {
+						uxsock_timeout) != 0) {
 					dead_client(c);
 				} else {
 					inbuf[len - 1] = 0;
@@ -239,7 +229,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 						reply = NULL;
 					}
 					check_timeout(start_time, inbuf,
-						      timeout);
+						      uxsock_timeout);
 					FREE(inbuf);
 				}
 			}
-- 
1.8.4.5

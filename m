From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 57/57] Allow specific CLI commands to run unlocked
Date: Wed, 27 Apr 2016 13:10:58 +0200
Message-ID: <1461755458-29225-58-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When multipath is busy with checking paths or processing udev
events it'll take the vector lock, causing the CLI
to become unresponsive.
This patch allows certain CLI commands to not wait for the vector
lock, so that those commands will always succeed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/cli.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 multipathd/cli.h  |  4 +++-
 multipathd/main.c | 26 ++++++++++++--------------
 3 files changed, 59 insertions(+), 17 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 3c9cdbf..d991cd0 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -1,9 +1,13 @@
 /*
  * Copyright (c) 2005 Christophe Varoqui
  */
+#include <sys/time.h>
 #include <errno.h>
+#include <pthread.h>
 #include <memory.h>
 #include <vector.h>
+#include <structs.h>
+#include <structs_vec.h>
 #include <parser.h>
 #include <util.h>
 #include <version.h>
@@ -100,6 +104,19 @@ set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *))
 	if (!h)
 		return 1;
 	h->fn = fn;
+	h->locked = 1;
+	return 0;
+}
+
+int
+set_unlocked_handler_callback (unsigned long fp,int (*fn)(void *, char **, int *, void *))
+{
+	struct handler * h = find_handler(fp);
+
+	if (!h)
+		return 1;
+	h->fn = fn;
+	h->locked = 0;
 	return 0;
 }
 
@@ -430,11 +447,13 @@ genhelp_handler (const char *cmd, int error)
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
 
@@ -456,7 +475,30 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data)
 	/*
 	 * execute handler
 	 */
-	r = h->fn(cmdvec, reply, len, data);
+	if (gettimeofday(&now, NULL) == 0) {
+		tmo.tv_sec = now.tv_sec + timeout;
+		tmo.tv_nsec = now.tv_usec * 1000;
+	} else {
+		tmo.tv_sec = 0;
+	}
+	if (h->locked) {
+		struct vectors * vecs = (struct vectors *)data;
+
+		pthread_cleanup_push(cleanup_lock, &vecs->lock);
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
+		lock_cleanup_pop(vecs->lock);
+	} else
+		r = h->fn(cmdvec, reply, len, data);
 	free_keys(cmdvec);
 
 	return r;
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 2aa19d5..84ca40f 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -100,13 +100,15 @@ struct key {
 
 struct handler {
 	uint64_t fingerprint;
+	int locked;
 	int (*fn)(void *, char **, int *, void *);
 };
 
 int alloc_handlers (void);
 int add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *));
 int set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
-int parse_cmd (char * cmd, char ** reply, int * len, void *);
+int set_unlocked_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
+int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
 int load_keys (void);
 char * get_keyparam (vector v, uint64_t code);
 void free_keys (vector vec);
diff --git a/multipathd/main.c b/multipathd/main.c
index 132101f..dc788c5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -974,14 +974,13 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 	*len = 0;
 	vecs = (struct vectors *)trigger_data;
 
-	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-	lock(vecs->lock);
-	pthread_testcancel();
-
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
@@ -992,7 +991,6 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 	}
 	/* else if (r < 0) leave *reply alone */
 
-	lock_cleanup_pop(vecs->lock);
 	return r;
 }
 
@@ -1112,8 +1110,8 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
 	set_handler_callback(LIST+PATH, cli_list_path);
 	set_handler_callback(LIST+MAPS, cli_list_maps);
-	set_handler_callback(LIST+STATUS, cli_list_status);
-	set_handler_callback(LIST+DAEMON, cli_list_daemon);
+	set_unlocked_handler_callback(LIST+STATUS, cli_list_status);
+	set_unlocked_handler_callback(LIST+DAEMON, cli_list_daemon);
 	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
 	set_handler_callback(LIST+MAPS+STATS, cli_list_maps_stats);
 	set_handler_callback(LIST+MAPS+FMT, cli_list_maps_fmt);
@@ -1123,8 +1121,8 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
 	set_handler_callback(LIST+MAP+FMT, cli_list_map_fmt);
 	set_handler_callback(LIST+MAP+RAW+FMT, cli_list_map_fmt);
-	set_handler_callback(LIST+CONFIG, cli_list_config);
-	set_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
+	set_unlocked_handler_callback(LIST+CONFIG, cli_list_config);
+	set_unlocked_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
 	set_handler_callback(LIST+DEVICES, cli_list_devices);
 	set_handler_callback(LIST+WILDCARDS, cli_list_wildcards);
 	set_handler_callback(ADD+PATH, cli_add_path);
@@ -1132,7 +1130,7 @@ uxlsnrloop (void * ap)
 	set_handler_callback(ADD+MAP, cli_add_map);
 	set_handler_callback(DEL+MAP, cli_del_map);
 	set_handler_callback(SWITCH+MAP+GROUP, cli_switch_group);
-	set_handler_callback(RECONFIGURE, cli_reconfigure);
+	set_unlocked_handler_callback(RECONFIGURE, cli_reconfigure);
 	set_handler_callback(SUSPEND+MAP, cli_suspend);
 	set_handler_callback(RESUME+MAP, cli_resume);
 	set_handler_callback(RESIZE+MAP, cli_resize);
@@ -1144,8 +1142,8 @@ uxlsnrloop (void * ap)
 	set_handler_callback(RESTOREQ+MAP, cli_restore_queueing);
 	set_handler_callback(DISABLEQ+MAPS, cli_disable_all_queueing);
 	set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
-	set_handler_callback(QUIT, cli_quit);
-	set_handler_callback(SHUTDOWN, cli_shutdown);
+	set_unlocked_handler_callback(QUIT, cli_quit);
+	set_unlocked_handler_callback(SHUTDOWN, cli_shutdown);
 	set_handler_callback(GETPRSTATUS+MAP, cli_getprstatus);
 	set_handler_callback(SETPRSTATUS+MAP, cli_setprstatus);
 	set_handler_callback(UNSETPRSTATUS+MAP, cli_unsetprstatus);
-- 
2.6.6

From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 15/16] make multipathd disable
	queue_without_daemon by default
Date: Thu,  2 May 2013 16:46:36 -0500
Message-ID: <1367531197-8987-16-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Once multipathd stops, there is nothing to restore access to failed
paths. Any multipath devices with no active paths that are set to
queue_if_no_path will never stop queueing, even if they were supposed
to stop after a number of retries.  This can cause shutdown to hang.
So, this patch turns off queueing by default when multipathd is stopped.
It also adds two multipathd interactive commands "forcequeueing daemon"
and "restorequeueing daemon", which override and reset this behavior,
respectively.

Unfortunately this isn't a perfect solution.  Ideally, when restarting
multipathd, you would first call "forcequeueing daemon", no make sure
that any devices that are queueing without paths continue to do so while
you are restarting the daemon. However there is no way to do this in
systemd as there was in Upstart. There is a languishing RFE that I filed
for an ExecRestartPre option in systemd. But for most users, the only
time when they need to restart multipathd is when upgrading the package,
so forcing queueing can be dealt with there.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c               | 10 ++++------
 libmultipath/structs.h            |  2 +-
 multipathd/cli.c                  |  3 +++
 multipathd/cli.h                  |  2 ++
 multipathd/cli_handlers.c         | 18 ++++++++++++++++++
 multipathd/cli_handlers.h         |  2 ++
 multipathd/main.c                 |  2 ++
 multipathd/multipathd.init.redhat | 14 ++++++++++----
 8 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 5154cdd..14e7c57 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -438,14 +438,11 @@ def_queue_without_daemon(vector strvec)
 	if (!buff)
 		return 1;
 
-	if (!strncmp(buff, "off", 3) || !strncmp(buff, "no", 2) ||
-	    !strncmp(buff, "0", 1))
-		conf->queue_without_daemon = QUE_NO_DAEMON_OFF;
-	else if (!strncmp(buff, "on", 2) || !strncmp(buff, "yes", 3) ||
+	if (!strncmp(buff, "on", 2) || !strncmp(buff, "yes", 3) ||
 		 !strncmp(buff, "1", 1))
 		conf->queue_without_daemon = QUE_NO_DAEMON_ON;
 	else
-		conf->queue_without_daemon = QUE_NO_DAEMON_UNDEF;
+		conf->queue_without_daemon = QUE_NO_DAEMON_OFF;
 
 	free(buff);
 	return 0;
@@ -2649,8 +2646,9 @@ snprint_def_queue_without_daemon (char * buff, int len, void * data)
 	case QUE_NO_DAEMON_OFF:
 		return snprintf(buff, len, "\"no\"");
 	case QUE_NO_DAEMON_ON:
-	case QUE_NO_DAEMON_UNDEF:
 		return snprintf(buff, len, "\"yes\"");
+	case QUE_NO_DAEMON_FORCE:
+		return snprintf(buff, len, "\"forced\"");
 	}
 	return 0;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index b9ace36..59387d6 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -67,9 +67,9 @@ enum pgstates {
 };
 
 enum queue_without_daemon_states {
-	QUE_NO_DAEMON_UNDEF,
 	QUE_NO_DAEMON_OFF,
 	QUE_NO_DAEMON_ON,
+	QUE_NO_DAEMON_FORCE,
 };
 
 enum pgtimeouts {
diff --git a/multipathd/cli.c b/multipathd/cli.c
index d95cba0..2a5edfa 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -162,6 +162,7 @@ load_keys (void)
 	r += add_key(keys, "resize", RESIZE, 0);
 	r += add_key(keys, "reset", RESET, 0);
 	r += add_key(keys, "reload", RELOAD, 0);
+	r += add_key(keys, "forcequeueing", FORCEQ, 0);
 	r += add_key(keys, "disablequeueing", DISABLEQ, 0);
 	r += add_key(keys, "restorequeueing", RESTOREQ, 0);
 	r += add_key(keys, "paths", PATHS, 0);
@@ -459,6 +460,8 @@ cli_init (void) {
 	add_handler(GETPRSTATUS+MAP, NULL);
 	add_handler(SETPRSTATUS+MAP, NULL);
 	add_handler(UNSETPRSTATUS+MAP, NULL);
+	add_handler(FORCEQ+DAEMON, NULL);
+	add_handler(RESTOREQ+DAEMON, NULL);
 
 	return 0;
 }
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 6b288d4..09fdc68 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -10,6 +10,7 @@ enum {
 	__RESIZE,
 	__RESET,
 	__RELOAD,
+	__FORCEQ,
 	__DISABLEQ,
 	__RESTOREQ,
 	__PATHS,
@@ -45,6 +46,7 @@ enum {
 #define RESIZE		(1 << __RESIZE)
 #define RESET		(1 << __RESET)
 #define RELOAD		(1 << __RELOAD)
+#define FORCEQ		(1 << __FORCEQ)
 #define DISABLEQ	(1 << __DISABLEQ)
 #define RESTOREQ	(1 << __RESTOREQ)
 #define PATHS		(1 << __PATHS)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index a1e4bde..ac648ad 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -628,6 +628,24 @@ cli_resize(void *v, char **reply, int *len, void *data)
 }
 
 int
+cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data)
+{
+	condlog(2, "force queue_without_daemon (operator)");
+	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
+		conf->queue_without_daemon = QUE_NO_DAEMON_FORCE;
+	return 0;
+}
+
+int
+cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data)
+{
+	condlog(2, "restore queue_without_daemon (operator)");
+	if (conf->queue_without_daemon == QUE_NO_DAEMON_FORCE)
+		conf->queue_without_daemon = QUE_NO_DAEMON_OFF;
+	return 0;
+}
+
+int
 cli_restore_queueing(void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index c62a273..de51961 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -28,6 +28,8 @@ int cli_suspend(void * v, char ** reply, int * len, void * data);
 int cli_resume(void * v, char ** reply, int * len, void * data);
 int cli_reinstate(void * v, char ** reply, int * len, void * data);
 int cli_fail(void * v, char ** reply, int * len, void * data);
+int cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data);
+int cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data);
 int cli_quit(void * v, char ** reply, int * len, void * data);
 int cli_shutdown(void * v, char ** reply, int * len, void * data);
 int cli_reassign (void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index a8e4725..18c8293 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -898,6 +898,8 @@ uxlsnrloop (void * ap)
 	set_handler_callback(GETPRSTATUS+MAP, cli_getprstatus);
 	set_handler_callback(SETPRSTATUS+MAP, cli_setprstatus);
 	set_handler_callback(UNSETPRSTATUS+MAP, cli_unsetprstatus);
+	set_handler_callback(FORCEQ+DAEMON, cli_force_no_daemon_q);
+	set_handler_callback(RESTOREQ+DAEMON, cli_restore_no_daemon_q);
 
 	umask(077);
 	uxsock_listen(&uxsock_trigger, ap);
diff --git a/multipathd/multipathd.init.redhat b/multipathd/multipathd.init.redhat
index 15b5753..d46ef80 100644
--- a/multipathd/multipathd.init.redhat
+++ b/multipathd/multipathd.init.redhat
@@ -81,23 +81,28 @@ force_stop() {
 	echo
 }
 
-stop() {
+check_root() {
         root_dev=$(awk '{ if ($1 !~ /^[ \t]*#/ && $2 == "/") { print $1; }}' /etc/mtab)
 	dm_num=`dmsetup info -c --noheadings -o minor $root_dev 2> /dev/null`
 	if [ $? -eq 0 ]; then
 		root_dm_device="dm-$dm_num"
 		[ -d $syspath/$root_dm_device ] && teardown_slaves $syspath/$root_dm_device
 	fi
+}
 
-	force_stop
+force_queue_without_daemon() {
+	$DAEMON forcequeueing daemon
 }
 
 restart() {
-	stop
+	force_queue_without_daemon
+	check_root
+	force_stop
 	start
 }
 
 force_restart() {
+	force_queue_without_daemon
 	force_stop
 	start
 }
@@ -115,7 +120,8 @@ start)
 	start
 	;;
 stop)
-	stop
+	check_root
+	force_stop
 	;;
 force-stop)
 	force_stop
-- 
1.8.2

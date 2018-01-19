From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 07/16] multipathd: replace -n with
	!ignore_wwids
Date: Fri, 19 Jan 2018 01:29:07 +0100
Message-ID: <20180119002916.10323-8-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Ignore the -n option (ignore_new_devs), at use !ignore_wwids instead.
'-n' mean that multipathd should only create maps from WWIDs that
are listed in the WWIDs file. This is exactly the meaning of
"ignore_wwids = off". The difference is that the setting is now
made in the config file and honoured by multipath, too (unless
it's called with '-i').
---
 libmultipath/config.h | 1 -
 libmultipath/wwids.c  | 2 +-
 multipathd/main.c     | 7 +------
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index a20ac2aac296..7366974644bf 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -168,7 +168,6 @@ struct config {
 	int strict_timing;
 	int retrigger_tries;
 	int retrigger_delay;
-	int ignore_new_devs;
 	int delayed_reconfig;
 	int uev_wait_timeout;
 	int skip_kpartx;
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 828a3de5b5cb..655ccbe2c94a 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -278,7 +278,7 @@ should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 	struct config *conf;
 
 	conf = get_multipath_config();
-	ignore_new_devs = conf->ignore_new_devs;
+	ignore_new_devs = !conf->ignore_wwids;
 	if (!conf->find_multipaths && !ignore_new_devs) {
 		put_multipath_config(conf);
 		return 1;
diff --git a/multipathd/main.c b/multipathd/main.c
index 98ce16ee020b..6f612f6d3d2f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -107,7 +107,6 @@ int logsink;
 int uxsock_timeout;
 int verbosity;
 int bindings_read_only;
-int ignore_new_devs;
 enum daemon_status running_state = DAEMON_INIT;
 pid_t daemon_pid;
 pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
@@ -2131,8 +2130,6 @@ reconfigure (struct vectors * vecs)
 		conf->verbosity = verbosity;
 	if (bindings_read_only)
 		conf->bindings_read_only = bindings_read_only;
-	if (ignore_new_devs)
-		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
 
 	old = rcu_dereference(multipath_conf);
@@ -2357,8 +2354,6 @@ child (void * param)
 		conf->verbosity = verbosity;
 	if (bindings_read_only)
 		conf->bindings_read_only = bindings_read_only;
-	if (ignore_new_devs)
-		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
 	rcu_assign_pointer(multipath_conf, conf);
 	if (init_checkers(conf->multipath_dir)) {
@@ -2691,7 +2686,7 @@ main (int argc, char *argv[])
 			bindings_read_only = 1;
 			break;
 		case 'n':
-			ignore_new_devs = 1;
+			condlog(0, "WARNING: ignoring deprecated option -n, use 'ignore_wwids = no' instead");
 			break;
 		default:
 			fprintf(stderr, "Invalid argument '-%c'\n",
-- 
2.15.1

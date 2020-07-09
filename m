From: mwilck@suse.com
Subject: [PATCH 26/35] libmultipath:
	io_err_stat_handle_pathfail(): less error conditions
Date: Thu,  9 Jul 2020 12:16:11 +0200
Message-ID: <20200709101620.6786-27-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

io_err_stat_pathfail() returns an error if marginal path checking is
disabled, and on various other conditions which aren't runtime errors.
Fix that. Also, check the validity of parameters when the configuration
is read, and not on every call.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/defaults.h    |  2 ++
 libmultipath/io_err_stat.c | 25 ++++++++-----------------
 libmultipath/propsel.c     |  6 ++++++
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 01a501b..0574e8f 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -31,6 +31,8 @@
 #define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
 #define DEFAULT_DELAY_CHECKS	NU_NO
 #define DEFAULT_ERR_CHECKS	NU_NO
+/* half of minimum value for marginal_path_err_sample_time */
+#define IOTIMEOUT_SEC		60
 #define DEFAULT_UEVENT_STACKSIZE 256
 #define DEFAULT_RETRIGGER_DELAY	10
 #define DEFAULT_RETRIGGER_TRIES	3
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 1b9cd6c..58bc1dd 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -35,7 +35,6 @@
 #include "time-util.h"
 #include "io_err_stat.h"
 
-#define IOTIMEOUT_SEC			60
 #define TIMEOUT_NO_IO_NSEC		10000000 /*10ms = 10000000ns*/
 #define FLAKY_PATHFAIL_THRESHOLD	2
 #define CONCUR_NR_EVENT			32
@@ -301,30 +300,22 @@ int io_err_stat_handle_pathfail(struct path *path)
 	struct timespec curr_time;
 
 	if (uatomic_read(&io_err_thread_running) == 0)
-		return 1;
+		return 0;
 
 	if (path->io_err_disable_reinstate) {
 		io_err_stat_log(3, "%s: reinstate is already disabled",
 				path->dev);
-		return 1;
+		return 0;
 	}
 	if (path->io_err_pathfail_cnt < 0)
-		return 1;
+		return 0;
 
 	if (!path->mpp)
-		return 1;
-	if (path->mpp->marginal_path_double_failed_time <= 0 ||
-		path->mpp->marginal_path_err_sample_time <= 0 ||
-		path->mpp->marginal_path_err_recheck_gap_time <= 0 ||
-		path->mpp->marginal_path_err_rate_threshold < 0) {
-		io_err_stat_log(4, "%s: parameter not set", path->mpp->alias);
-		return 1;
-	}
-	if (path->mpp->marginal_path_err_sample_time < (2 * IOTIMEOUT_SEC)) {
-		io_err_stat_log(2, "%s: marginal_path_err_sample_time should not less than %d",
-				path->mpp->alias, 2 * IOTIMEOUT_SEC);
-		return 1;
-	}
+		return 0;
+
+	if (!marginal_path_check_enabled(path->mpp))
+		return 0;
+
 	/*
 	 * The test should only be started for paths that have failed
 	 * repeatedly in a certain time frame, so that we have reason
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d362beb..2233527 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -1066,6 +1066,12 @@ int select_marginal_path_err_sample_time(struct config *conf, struct multipath *
 	mp_set_conf(marginal_path_err_sample_time);
 	mp_set_default(marginal_path_err_sample_time, DEFAULT_ERR_CHECKS);
 out:
+	if (mp->marginal_path_err_sample_time > 0 &&
+	    mp->marginal_path_err_sample_time < 2 * IOTIMEOUT_SEC) {
+		condlog(2, "%s: configuration error: marginal_path_err_sample_time must be >= %d",
+			mp->alias, 2 * IOTIMEOUT_SEC);
+			mp->marginal_path_err_sample_time = 2 * IOTIMEOUT_SEC;
+	}
 	if (print_off_int_undef(buff, 12, mp->marginal_path_err_sample_time)
 	    != 0)
 		condlog(3, "%s: marginal_path_err_sample_time = %s %s",
-- 
2.26.2

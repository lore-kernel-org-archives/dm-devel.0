From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/42] Inconsistent string quoting
Date: Tue,  8 Jan 2013 14:53:57 +0100
Message-ID: <1357653259-62650-20-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

When printing the hardware table strings are quoted twice, and
even numerical values have single quotes. This patch removes
the double quotes and retains single quotes only for string
values.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/dict.c |   98 +++++++++++++++++++++++++-------------------------
 1 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ab9fdeb..6dae335 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1062,11 +1062,11 @@ hw_failback_handler(vector strvec)
 
 	buff = set_value(strvec);
 
-	if (strlen(buff) == 6 && !strcmp(buff, "manual"))
+	if (strlen(buff) == 6 && !strcmp(buff, "\"manual\""))
 		hwe->pgfailback = -FAILBACK_MANUAL;
-	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
+	else if (strlen(buff) == 9 && !strcmp(buff, "\"immediate\""))
 		hwe->pgfailback = -FAILBACK_IMMEDIATE;
-	else if (strlen(buff) == 10 && !strcmp(buff, "followover"))
+	else if (strlen(buff) == 10 && !strcmp(buff, "\"followover\""))
 		hwe->pgfailback = -FAILBACK_FOLLOWOVER;
 	else
 		hwe->pgfailback = atoi(buff);
@@ -1757,7 +1757,7 @@ snprint_mp_path_grouping_policy (char * buff, int len, void * data)
 		return 0;
 	get_pgpolicy_name(str, POLICY_NAME_SIZE, mpe->pgpolicy);
 
-	return snprintf(buff, len, "%s", str);
+	return snprintf(buff, len, "\"%s\"", str);
 }
 
 static int
@@ -1832,9 +1832,9 @@ snprint_mp_rr_weight (char * buff, int len, void * data)
 	if (!mpe->rr_weight)
 		return 0;
 	if (mpe->rr_weight == RR_WEIGHT_PRIO)
-		return snprintf(buff, len, "priorities");
+		return snprintf(buff, len, "\"priorities\"");
 	if (mpe->rr_weight == RR_WEIGHT_NONE)
-		return snprintf(buff, len, "uniform");
+		return snprintf(buff, len, "\"uniform\"");
 
 	return 0;
 }
@@ -1851,9 +1851,9 @@ snprint_mp_no_path_retry (char * buff, int len, void * data)
 	case NO_PATH_RETRY_UNDEF:
 		break;
 	case NO_PATH_RETRY_FAIL:
-		return snprintf(buff, len, "fail");
+		return snprintf(buff, len, "\"fail\"");
 	case NO_PATH_RETRY_QUEUE:
-		return snprintf(buff, len, "queue");
+		return snprintf(buff, len, "\"queue\"");
 	default:
 		return snprintf(buff, len, "%i",
 				mpe->no_path_retry);
@@ -1892,7 +1892,7 @@ snprint_mp_pg_timeout (char * buff, int len, void * data)
 	case PGTIMEOUT_UNDEF:
 		break;
 	case -PGTIMEOUT_NONE:
-		return snprintf(buff, len, "none");
+		return snprintf(buff, len, "\"none\"");
 	default:
 		return snprintf(buff, len, "%i", mpe->pg_timeout);
 	}
@@ -1910,7 +1910,7 @@ snprint_mp_features (char * buff, int len, void * data)
 	    !strcmp(mpe->features, conf->features))
 		return 0;
 
-	return snprintf(buff, len, "%s", mpe->features);
+	return snprintf(buff, len, "\"%s\"", mpe->features);
 }
 
 static int
@@ -1920,9 +1920,9 @@ snprint_mp_flush_on_last_del (char * buff, int len, void * data)
 
 	switch (mpe->flush_on_last_del) {
 	case FLUSH_DISABLED:
-		return snprintf(buff, len, "no");
+		return snprintf(buff, len, "\"no\"");
 	case FLUSH_ENABLED:
-		return snprintf(buff, len, "yes");
+		return snprintf(buff, len, "\"yes\"");
 	}
 	return 0;
 }
@@ -1935,7 +1935,7 @@ snprint_mp_prio(char * buff, int len, void * data)
 	if (!mpe->prio_name)
 		return 0;
 
-	return snprintf(buff, len, "%s", mpe->prio_name);
+	return snprintf(buff, len, "\"%s\"", mpe->prio_name);
 }
 
 static int
@@ -1946,7 +1946,7 @@ snprint_mp_prio_args(char * buff, int len, void * data)
 	if (!mpe->prio_args)
 		return 0;
 
-	return snprintf(buff, len, "%s", mpe->prio_args);
+	return snprintf(buff, len, "\"%s\"", mpe->prio_args);
 }
 
 static int
@@ -1978,7 +1978,7 @@ snprint_hw_fast_io_fail(char * buff, int len, void * data)
 	if (hwe->fast_io_fail == conf->fast_io_fail)
 		return 0;
 	if (hwe->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-		return snprintf(buff, len, "off");
+		return snprintf(buff, len, "\"off\"");
 	if (hwe->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
 		return snprintf(buff, len, "0");
 	return snprintf(buff, len, "%d", hwe->fast_io_fail);
@@ -1993,7 +1993,7 @@ snprint_hw_dev_loss(char * buff, int len, void * data)
 	if (hwe->dev_loss == conf->dev_loss)
 		return 0;
 	if (hwe->dev_loss >= MAX_DEV_LOSS_TMO)
-		return snprintf(buff, len, "infinity");
+		return snprintf(buff, len, "\"infinity\"");
 
 	return snprintf(buff, len, "%u", hwe->dev_loss);
 }
@@ -2061,7 +2061,7 @@ snprint_hw_prio (char * buff, int len, void * data)
 	if (!hwe->prio_name)
 		return 0;
 
-	return snprintf(buff, len, "%s", hwe->prio_name);
+	return snprintf(buff, len, "\"%s\"", hwe->prio_name);
 }
 
 static int
@@ -2131,7 +2131,7 @@ snprint_hw_path_grouping_policy (char * buff, int len, void * data)
 
 	get_pgpolicy_name(str, POLICY_NAME_SIZE, hwe->pgpolicy);
 
-	return snprintf(buff, len, "%s", str);
+	return snprintf(buff, len, "\"%s\"", str);
 }
 
 static int
@@ -2165,9 +2165,9 @@ snprint_hw_rr_weight (char * buff, int len, void * data)
 	if (!hwe->rr_weight)
 		return 0;
 	if (hwe->rr_weight == RR_WEIGHT_PRIO)
-		return snprintf(buff, len, "priorities");
+		return snprintf(buff, len, "\"priorities\"");
 	if (hwe->rr_weight == RR_WEIGHT_NONE)
-		return snprintf(buff, len, "uniform");
+		return snprintf(buff, len, "\"uniform\"");
 
 	return 0;
 }
@@ -2184,9 +2184,9 @@ snprint_hw_no_path_retry (char * buff, int len, void * data)
 	case NO_PATH_RETRY_UNDEF:
 		break;
 	case NO_PATH_RETRY_FAIL:
-		return snprintf(buff, len, "fail");
+		return snprintf(buff, len, "\"fail\"");
 	case NO_PATH_RETRY_QUEUE:
-		return snprintf(buff, len, "queue");
+		return snprintf(buff, len, "\"queue\"");
 	default:
 		return snprintf(buff, len, "%i",
 				hwe->no_path_retry);
@@ -2228,7 +2228,7 @@ snprint_hw_pg_timeout (char * buff, int len, void * data)
 	case PGTIMEOUT_UNDEF:
 		break;
 	case -PGTIMEOUT_NONE:
-		return snprintf(buff, len, "none");
+		return snprintf(buff, len, "\"none\"");
 	default:
 		return snprintf(buff, len, "%i", hwe->pg_timeout);
 	}
@@ -2242,9 +2242,9 @@ snprint_hw_flush_on_last_del (char * buff, int len, void * data)
 
 	switch (hwe->flush_on_last_del) {
 	case FLUSH_DISABLED:
-		return snprintf(buff, len, "no");
+		return snprintf(buff, len, "\"no\"");
 	case FLUSH_ENABLED:
-		return snprintf(buff, len, "yes");
+		return snprintf(buff, len, "\"yes\"");
 	}
 	return 0;
 }
@@ -2257,7 +2257,7 @@ snprint_hw_path_checker (char * buff, int len, void * data)
 	if (!hwe->checker_name)
 		return 0;
 
-	return snprintf(buff, len, "%s", hwe->checker_name);
+	return snprintf(buff, len, "\"%s\"", hwe->checker_name);
 }
 
 	static int
@@ -2285,7 +2285,7 @@ snprint_def_fast_io_fail(char * buff, int len, void * data)
 	if (conf->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
 		return 0;
 	if (conf->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-		return snprintf(buff, len, "off");
+		return snprintf(buff, len, "\"off\"");
 	if (conf->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
 		return snprintf(buff, len, "0");
 	return snprintf(buff, len, "%d", conf->fast_io_fail);
@@ -2297,7 +2297,7 @@ snprint_def_dev_loss(char * buff, int len, void * data)
 	if (!conf->dev_loss)
 		return 0;
 	if (conf->dev_loss >= MAX_DEV_LOSS_TMO)
-		return snprintf(buff, len, "infinity");
+		return snprintf(buff, len, "\"infinity\"");
 	return snprintf(buff, len, "%u", conf->dev_loss);
 }
 
@@ -2320,7 +2320,7 @@ snprint_reassign_maps (char * buff, int len, void * data)
 {
 	if (conf->reassign_maps == DEFAULT_REASSIGN_MAPS)
 		return 0;
-	return snprintf(buff, len, "%s",
+	return snprintf(buff, len, "\"%s\"",
 			conf->reassign_maps?"yes":"no");
 }
 
@@ -2353,7 +2353,7 @@ snprint_def_path_grouping_policy (char * buff, int len, void * data)
 
 	get_pgpolicy_name(str, POLICY_NAME_SIZE, pgpolicy);
 
-	return snprintf(buff, len, "%s", str);
+	return snprintf(buff, len, "\"%s\"", str);
 }
 
 static int
@@ -2369,9 +2369,9 @@ static int
 snprint_def_prio (char * buff, int len, void * data)
 {
 	if (!conf->prio_name)
-		return snprintf(buff, len, "%s", DEFAULT_PRIO);
+		return snprintf(buff, len, "\"%s\"", DEFAULT_PRIO);
 
-	return snprintf(buff, len, "%s", conf->prio_name);
+	return snprintf(buff, len, "\"%s\"", conf->prio_name);
 }
 
 static int
@@ -2396,9 +2396,9 @@ static int
 snprint_def_path_checker (char * buff, int len, void * data)
 {
 	if (!conf->checker_name)
-		return snprintf(buff, len, "%s", DEFAULT_CHECKER);
+		return snprintf(buff, len, "\"%s\"", DEFAULT_CHECKER);
 
-	return snprintf(buff, len, "%s", conf->checker_name);
+	return snprintf(buff, len, "\"%s\"", conf->checker_name);
 }
 
 static int
@@ -2412,11 +2412,11 @@ snprint_def_failback (char * buff, int len, void * data)
 	case  FAILBACK_UNDEF:
 		break;
 	case -FAILBACK_MANUAL:
-		return snprintf(buff, len, "manual");
+		return snprintf(buff, len, "\"manual\"");
 	case -FAILBACK_IMMEDIATE:
-		return snprintf(buff, len, "immediate");
+		return snprintf(buff, len, "\"immediate\"");
 	case -FAILBACK_FOLLOWOVER:
-		return snprintf(buff, len, "followover");
+		return snprintf(buff, len, "\"followover\"");
 	default:
 		return snprintf(buff, len, "%i", conf->pgfailback);
 	}
@@ -2478,9 +2478,9 @@ static int
 snprint_def_rr_weight (char * buff, int len, void * data)
 {
 	if (!conf->rr_weight || conf->rr_weight == RR_WEIGHT_NONE)
-		return snprintf(buff, len, "uniform");
+		return snprintf(buff, len, "\"uniform\"");
 	if (conf->rr_weight == RR_WEIGHT_PRIO)
-		return snprintf(buff, len, "priorities");
+		return snprintf(buff, len, "\"priorities\"");
 
 	return 0;
 }
@@ -2492,9 +2492,9 @@ snprint_def_no_path_retry (char * buff, int len, void * data)
 	case NO_PATH_RETRY_UNDEF:
 		break;
 	case NO_PATH_RETRY_FAIL:
-		return snprintf(buff, len, "fail");
+		return snprintf(buff, len, "\"fail\"");
 	case NO_PATH_RETRY_QUEUE:
-		return snprintf(buff, len, "queue");
+		return snprintf(buff, len, "\"queue\"");
 	default:
 		return snprintf(buff, len, "%i",
 				conf->no_path_retry);
@@ -2507,10 +2507,10 @@ snprint_def_queue_without_daemon (char * buff, int len, void * data)
 {
 	switch (conf->queue_without_daemon) {
 	case QUE_NO_DAEMON_OFF:
-		return snprintf(buff, len, "no");
+		return snprintf(buff, len, "\"no\"");
 	case QUE_NO_DAEMON_ON:
 	case QUE_NO_DAEMON_UNDEF:
-		return snprintf(buff, len, "yes");
+		return snprintf(buff, len, "\"yes\"");
 	}
 	return 0;
 }
@@ -2530,7 +2530,7 @@ snprint_def_pg_timeout (char * buff, int len, void * data)
 	switch (conf->pg_timeout) {
 	case PGTIMEOUT_UNDEF:
 	case -PGTIMEOUT_NONE:
-		return snprintf(buff, len, "none");
+		return snprintf(buff, len, "\"none\"");
 	default:
 		return snprintf(buff, len, "%i", conf->pg_timeout);
 	}
@@ -2543,10 +2543,10 @@ snprint_def_flush_on_last_del (char * buff, int len, void * data)
 	switch (conf->flush_on_last_del) {
 	case FLUSH_UNDEF:
 	case FLUSH_DISABLED:
-		return snprintf(buff, len, "no");
+		return snprintf(buff, len, "\"no\"");
 	case FLUSH_ENABLED:
 	case FLUSH_IN_PROGRESS:
-		return snprintf(buff, len, "yes");
+		return snprintf(buff, len, "\"yes\"");
 	}
 	return 0;
 }
@@ -2563,9 +2563,9 @@ static int
 snprint_def_user_friendly_names (char * buff, int len, void * data)
 {
 	if (conf->user_friendly_names  == USER_FRIENDLY_NAMES_ON)
-		return snprintf(buff, len, "yes");
+		return snprintf(buff, len, "\"yes\"");
 	else
-		return snprintf(buff, len, "no");
+		return snprintf(buff, len, "\"no\"");
 }
 
 static int
@@ -2581,7 +2581,7 @@ snprint_def_bindings_file (char * buff, int len, void * data)
 {
 	if (conf->bindings_file == NULL)
 		return 0;
-	return snprintf(buff, len, "%s", conf->bindings_file);
+	return snprintf(buff, len, "\"%s\"", conf->bindings_file);
 }
 
 static int
-- 
1.7.4.2

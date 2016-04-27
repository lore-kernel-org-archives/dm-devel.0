From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/57] multipathd: fixup queueing mode in 'show
	maps status'
Date: Wed, 27 Apr 2016 13:10:12 +0200
Message-ID: <1461755458-29225-12-git-send-email-hare@suse.de>
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

When manually disabling queueing via 'disablequeueing map $map'
the queueing status in 'show maps status' is not updated.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/print.c      | 6 ++++--
 multipathd/cli_handlers.c | 4 ++--
 multipathd/main.c         | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 76bda93..96a1680 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -174,12 +174,14 @@ snprint_queueing (char * buff, size_t len, struct multipath * mpp)
 	else if (mpp->no_path_retry == NO_PATH_RETRY_UNDEF)
 		return snprintf(buff, len, "-");
 	else if (mpp->no_path_retry > 0) {
-		if (mpp->retry_tick)
+		if (mpp->retry_tick > 0)
 			return snprintf(buff, len, "%i sec",
 					mpp->retry_tick);
-		else
+		else if (mpp->retry_tick == 0)
 			return snprintf(buff, len, "%i chk",
 					mpp->no_path_retry);
+		else
+			return snprintf(buff, len, "off");
 	}
 	return 0;
 }
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 168b872..886a5fd 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -807,7 +807,7 @@ cli_disable_queueing(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
-	mpp->retry_tick = 0;
+	mpp->retry_tick = -1;
 	dm_queue_if_no_path(mpp->alias, 0);
 	return 0;
 }
@@ -821,7 +821,7 @@ cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
 
 	condlog(2, "disable queueing (operator)");
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		mpp->retry_tick = 0;
+		mpp->retry_tick = -1;
 		dm_queue_if_no_path(mpp->alias, 0);
 	}
 	return 0;
diff --git a/multipathd/main.c b/multipathd/main.c
index 626f703..d9c0b8b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1200,7 +1200,7 @@ retry_count_tick(vector mpvec)
 	unsigned int i;
 
 	vector_foreach_slot (mpvec, mpp, i) {
-		if (mpp->retry_tick) {
+		if (mpp->retry_tick > 0) {
 			mpp->stat_total_queueing_time++;
 			condlog(4, "%s: Retrying.. No active path", mpp->alias);
 			if(--mpp->retry_tick == 0) {
-- 
2.6.6

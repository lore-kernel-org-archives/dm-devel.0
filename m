From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 5/7] Fix set_no_path_retry() regression
Date: Mon, 12 Feb 2018 21:42:12 -0600
Message-ID: <1518493334-18170-6-git-send-email-bmarzins@redhat.com>
References: <1518493334-18170-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518493334-18170-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

commit 0f850db7fceb6b2bf4968f3831efd250c17c6138 "multipathd: clean up
set_no_path_retry" has a bug in it. It made set_no_path_retry
never reset mpp->retry_ticks, even if the device was in recovery mode,
and there were valid paths. This meant that adding new paths didn't
remove a device from recovery mode, and queueing could get disabled,
even while there were valid paths. This patch fixes that.

This patch also fixes a bug in cli_restore_queueing() and
cli_restore_all_queueing(), where a device that had no_path_retry
set to "queue" would enter recovery mode (although queueing would
never actually get disabled).

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c |  5 +++--
 multipathd/cli_handlers.c  | 20 ++++++++++++--------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index fbab61f..0de2221 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -343,9 +343,10 @@ static void set_no_path_retry(struct multipath *mpp)
 			dm_queue_if_no_path(mpp->alias, 1);
 		break;
 	default:
-		if (mpp->nr_active > 0)
+		if (mpp->nr_active > 0) {
+			mpp->retry_tick = 0;
 			dm_queue_if_no_path(mpp->alias, 1);
-		else if (is_queueing && mpp->retry_tick == 0)
+		} else if (is_queueing && mpp->retry_tick == 0)
 			enter_recovery_mode(mpp);
 		break;
 	}
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 7f13bc9..80519b1 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -995,10 +995,12 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 			mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
 		dm_queue_if_no_path(mpp->alias, 1);
-		if (mpp->nr_active > 0)
-			mpp->retry_tick = 0;
-		else
-			enter_recovery_mode(mpp);
+		if (mpp->no_path_retry > 0) {
+			if (mpp->nr_active > 0)
+				mpp->retry_tick = 0;
+			else
+				enter_recovery_mode(mpp);
+		}
 	}
 	return 0;
 }
@@ -1019,10 +1021,12 @@ cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
 		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 		    mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
 			dm_queue_if_no_path(mpp->alias, 1);
-			if (mpp->nr_active > 0)
-				mpp->retry_tick = 0;
-			else
-				enter_recovery_mode(mpp);
+			if (mpp->no_path_retry > 0) {
+				if (mpp->nr_active > 0)
+					mpp->retry_tick = 0;
+				else
+					enter_recovery_mode(mpp);
+			}
 		}
 	}
 	return 0;
-- 
2.7.4

From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 4/4] cmirror: update resume method for
 interruption of presuspend
Date: Tue, 23 Feb 2010 13:45:14 -0500
Message-ID: <4B84223A.7030304@redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: k-ueda@ct.jp.nec.com, LVM2 development <lvm-devel@redhat.com>
List-Id: dm-devel.ids

Suspend procedure could be interrupted between presuspend and
postsuspend procedure. When it happens, all state changes done
by presuspend procedure needs to be canceled.

I proposed a kernel patch to use a resume handler for canceling
state changes and this patch fixes the cluster mirror.

Cluster mirror changes only one flag (log's recovery_halted) for
the DM_ULOG_PRESUSPEND request. Therefore, clog_resume function
needs to reset the log's recovery_halted flag if cluster mirror
received the DM_ULOG_RESUME request with the condition of log's
state is LOG_RESUMED and its recovery_halted is set.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 daemons/cmirrord/functions.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: LVM2-2.02.62-20100217/daemons/cmirrord/functions.c
===================================================================
--- LVM2-2.02.62-20100217.orig/daemons/cmirrord/functions.c
+++ LVM2-2.02.62-20100217/daemons/cmirrord/functions.c
@@ -721,6 +721,10 @@ static int clog_resume(struct dm_ulog_re
 	if (!lc)
 		return -EINVAL;
 
+	/* Check if the resume is called by interrupting suspend procedure */
+	if (lc->state == LOG_RESUMED && lc->recovery_halted)
+		goto cancel_presuspend;
+
 	switch (lc->resume_override) {
 	case 1000:
 		LOG_ERROR("[%s] Additional resume issued before suspend",
@@ -825,8 +829,10 @@ out:
 		   SHORT_UUID(lc->uuid), (unsigned long long)lc->sync_count);
 	lc->sync_search = 0;
 	lc->state = LOG_RESUMED;
+
+cancel_presuspend:
 	lc->recovery_halted = 0;
-	
+
 	return rq->error;
 }
 

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel

From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/42] Print log messages when updating tables
	failed
Date: Tue,  8 Jan 2013 14:54:04 +0100
Message-ID: <1357653259-62650-27-git-send-email-hare@suse.de>
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

Add some logging messages to identify the case of failure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/structs_vec.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 6d36d58..384afb7 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -246,11 +246,15 @@ update_multipath_table (struct multipath *mpp, vector pathvec)
 	if (!mpp)
 		return 1;
 
-	if (dm_get_map(mpp->alias, &mpp->size, params))
+	if (dm_get_map(mpp->alias, &mpp->size, params)) {
+		condlog(3, "%s: cannot get map", mpp->alias);
 		return 1;
+	}
 
-	if (disassemble_map(pathvec, params, mpp))
+	if (disassemble_map(pathvec, params, mpp)) {
+		condlog(3, "%s: cannot disassemble map", mpp->alias);
 		return 1;
+	}
 
 	return 0;
 }
@@ -263,11 +267,15 @@ update_multipath_status (struct multipath *mpp)
 	if (!mpp)
 		return 1;
 
-	if(dm_get_status(mpp->alias, status))
+	if (dm_get_status(mpp->alias, status)) {
+		condlog(3, "%s: cannot get status", mpp->alias);
 		return 1;
+	}
 
-	if (disassemble_status(status, mpp))
+	if (disassemble_status(status, mpp)) {
+		condlog(3, "%s: cannot disassemble status", mpp->alias);
 		return 1;
+	}
 
 	return 0;
 }
-- 
1.7.4.2

From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 11/11] libmultipath: don't [un]set
	queue_if_no_path after domap
Date: Thu, 22 Jun 2017 16:59:13 +0200
Message-ID: <20170622145913.23714-12-mwilck@suse.com>
References: <20170622145913.23714-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170622145913.23714-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

We set the queue_if_no_path feature in assemble_map() already,
no need to set it here again.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 03874f47..98589150 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1053,21 +1053,6 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 				remove_feature(&mpp->features,
 					       "queue_if_no_path");
 		}
-		else if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
-			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL) {
-				condlog(3, "%s: unset queue_if_no_path feature",
-					mpp->alias);
-				if (!dm_queue_if_no_path(mpp->alias, 0))
-					remove_feature(&mpp->features,
-						       "queue_if_no_path");
-			} else {
-				condlog(3, "%s: set queue_if_no_path feature",
-					mpp->alias);
-				if (!dm_queue_if_no_path(mpp->alias, 1))
-					add_feature(&mpp->features,
-						    "queue_if_no_path");
-			}
-		}
 
 		if (!is_daemon && mpp->action != ACT_NOTHING) {
 			conf = get_multipath_config();
-- 
2.13.1

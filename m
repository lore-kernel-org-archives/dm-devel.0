From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 05/11] libmultipath: assemble_map: fix
	queue_if_no_path logic
Date: Thu, 22 Jun 2017 16:59:07 +0200
Message-ID: <20170622145913.23714-6-mwilck@suse.com>
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

It is wrong to remove the queue_if_no_path feature if no_path_retry
is unset. Rather, in this case the feature should neither be added
nor removed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/dmparser.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index ba09dc72..1121c715 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -89,13 +89,12 @@ assemble_map (struct multipath * mp, char * params, int len)
 	 * We have to set 'queue_if_no_path' here even
 	 * to avoid path failures during map reload.
 	 */
-	if (mp->no_path_retry == NO_PATH_RETRY_UNDEF ||
-	    mp->no_path_retry == NO_PATH_RETRY_FAIL) {
+	if (mp->no_path_retry == NO_PATH_RETRY_FAIL) {
 		/* remove queue_if_no_path settings */
 		condlog(3, "%s: remove queue_if_no_path from '%s'",
 			mp->alias, mp->features);
 		remove_feature(&f, no_path_retry);
-	} else {
+	} else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF) {
 		add_feature(&f, no_path_retry);
 	}
 	if (mp->retain_hwhandler == RETAIN_HWHANDLER_ON)
-- 
2.13.1

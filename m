From: mwilck@suse.com
Subject: [PATCH 39/39] libmultipath: increase log level of
	limiting dev_loss_tmo
Date: Thu,  9 Jul 2020 12:19:52 +0200
Message-ID: <20200709101952.7285-5-mwilck@suse.com>
References: <20200709101952.7285-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101952.7285-1-mwilck@suse.com>
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

Users who aren't familar with the complex dependencies between
dev_loss_tmo, no_path_retry, and fast_io_fail may be confused
if their settings aren't applied. Print this log message at the
default level.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c00af7e..e26aae2 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -651,7 +651,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 		}
 	} else if (mpp->dev_loss > DEFAULT_DEV_LOSS_TMO &&
 		mpp->no_path_retry != NO_PATH_RETRY_QUEUE) {
-		condlog(3, "%s: limiting dev_loss_tmo to %d, since "
+		condlog(2, "%s: limiting dev_loss_tmo to %d, since "
 			"fast_io_fail is not set",
 			rport_id, DEFAULT_DEV_LOSS_TMO);
 		mpp->dev_loss = DEFAULT_DEV_LOSS_TMO;
-- 
2.26.2

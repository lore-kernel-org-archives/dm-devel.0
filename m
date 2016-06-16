From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 39/39] libmultipath/discovery.c: Fixup possible
	range overflow
Date: Thu, 16 Jun 2016 11:47:45 +0200
Message-ID: <1466070465-1021-40-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

When checking the maximum value for dev_loss_tmo we need to
use a larger type, otherwise the comparison will always be false.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 5d5441d..126a54f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -670,7 +670,7 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 	int dev_loss_tmo = mpp->dev_loss;
 
 	if (mpp->no_path_retry > 0) {
-		int no_path_retry_tmo = mpp->no_path_retry * conf->checkint;
+		uint64_t no_path_retry_tmo = mpp->no_path_retry * conf->checkint;
 
 		if (no_path_retry_tmo > MAX_DEV_LOSS_TMO)
 			no_path_retry_tmo = MAX_DEV_LOSS_TMO;
-- 
2.6.6

From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/12] libmultipath(coverity): fix int overflow
	in sysfs_set_scsi_tmo
Date: Tue,  8 Jan 2019 23:54:04 +0100
Message-ID: <20190108225409.15977-8-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3fd79a3..1748eeb 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -711,7 +711,7 @@ sysfs_set_scsi_tmo (struct multipath *mpp, int checkint)
 	int dev_loss_tmo = mpp->dev_loss;
 
 	if (mpp->no_path_retry > 0) {
-		uint64_t no_path_retry_tmo = mpp->no_path_retry * checkint;
+		uint64_t no_path_retry_tmo = (uint64_t)mpp->no_path_retry * checkint;
 
 		if (no_path_retry_tmo > MAX_DEV_LOSS_TMO)
 			no_path_retry_tmo = MAX_DEV_LOSS_TMO;
-- 
2.19.2

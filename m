From: mwilck@suse.com
Subject: [PATCH 37/39] libmultipath: improve logging for
	dev_loss_tmo override
Date: Thu,  9 Jul 2020 12:19:50 +0200
Message-ID: <20200709101952.7285-3-mwilck@suse.com>
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

Print a more meaningful warning message, and at higher level, if
the configured dev_loss_tmo can't be applied because it conflicts
with no_path_retry.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f7d6672..e2aea81 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -774,14 +774,15 @@ sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
 			no_path_retry_tmo = MAX_DEV_LOSS_TMO;
 		if (no_path_retry_tmo > dev_loss_tmo)
 			dev_loss_tmo = no_path_retry_tmo;
-		condlog(3, "%s: update dev_loss_tmo to %u",
-			mpp->alias, dev_loss_tmo);
 	} else if (mpp->no_path_retry == NO_PATH_RETRY_QUEUE) {
 		dev_loss_tmo = MAX_DEV_LOSS_TMO;
-		condlog(3, "%s: update dev_loss_tmo to %u",
-			mpp->alias, dev_loss_tmo);
 	}
-	mpp->dev_loss = dev_loss_tmo;
+	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET &&
+	    mpp->dev_loss != dev_loss_tmo) {
+		condlog(2, "%s: Using dev_loss_tmo=%u instead of %u because of no_path_retry setting",
+			mpp->alias, dev_loss_tmo, mpp->dev_loss);
+		mpp->dev_loss = dev_loss_tmo;
+	}
 	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET &&
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
 	    (unsigned int)mpp->fast_io_fail >= mpp->dev_loss) {
-- 
2.26.2

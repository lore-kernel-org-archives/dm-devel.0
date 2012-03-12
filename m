From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] Fix fast_io_fail capping
Date: Mon, 12 Mar 2012 20:56:52 +0900
Message-ID: <4F5DE484.2040307@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Hi Christophe,

fast_io_fail is only meaningful if it is smaller than dev_loss_tmo.
Setting dev_loss_tmo value to fast_io_fail ends up with -EINVAL.
If the fast_io_fail is not configured properly, turning it off
seems to be the right behavior.

MP_FAST_IO_FAIL_OFF is -1, defined in the following patch:
  [PATCH] Fix for setting '0' to fast_io_fail
  http://www.redhat.com/archives/dm-devel/2012-March/msg00047.html

-- 
Jun'ichi Nomura, NEC Corporation

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 16f786d..8009893 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -307,10 +307,10 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 			mpp->alias, dev_loss_tmo);
 	}
 	mpp->dev_loss = dev_loss_tmo;
-	if (mpp->fast_io_fail > (int)mpp->dev_loss) {
-		mpp->fast_io_fail = mpp->dev_loss;
-		condlog(3, "%s: update fast_io_fail to %d",
+	if (mpp->dev_loss && mpp->fast_io_fail >= (int)mpp->dev_loss) {
+		condlog(3, "%s: turning off fast_io_fail (%d is not smaller than dev_loss_tmo)",
 			mpp->alias, mpp->fast_io_fail);
+		mpp->fast_io_fail = MP_FAST_IO_FAIL_OFF;
 	}
 	if (!mpp->dev_loss && !mpp->fast_io_fail)
 		return 0;

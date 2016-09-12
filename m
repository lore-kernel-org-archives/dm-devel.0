From: Mike Gilbert <floppym@gentoo.org>
Subject: [PATCH] multipathd.service: ignore modprobe failures
Date: Mon, 12 Sep 2016 17:34:41 -0400
Message-ID: <20160912213441.8125-1-floppym@gentoo.org>
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
To: dm-devel@redhat.com
Cc: Mike Gilbert <floppym@gentoo.org>
List-Id: dm-devel.ids

---
 multipathd/multipathd.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index e3d6f91..d26577f 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -11,7 +11,7 @@ Conflicts=shutdown.target
 Type=notify
 NotifyAccess=main
 LimitCORE=infinity
-ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath
+ExecStartPre=-/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
 
-- 
2.10.0

From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: preload also scsi_dh_hp_sw
	before run multipathd
Date: Tue, 11 Oct 2016 14:55:15 +0200
Message-ID: <20161011125515.8523-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipathd/multipathd.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index e3d6f91..45aca35 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -11,7 +11,7 @@ Conflicts=shutdown.target
 Type=notify
 NotifyAccess=main
 LimitCORE=infinity
-ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath
+ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh_rdac dm-multipath
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
 
-- 
2.10.1

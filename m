From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 3/3] dm-delay: add cancel_presuspend function
Date: Tue, 19 Jan 2010 15:41:34 -0500
Message-ID: <4B5618FE.4020303@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

When suspend is interrupted after presuspend procedure, delay target
needs to be started because the target is not in the suspend status.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-delay.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.33-rc1-dm/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm-delay.c
+++ linux-2.6.33-rc1-dm/drivers/md/dm-delay.c
@@ -343,6 +343,7 @@ static struct target_type delay_target =
 	.dtr	     = delay_dtr,
 	.map	     = delay_map,
 	.presuspend  = delay_presuspend,
+	.cancel_presuspend  = delay_resume,
 	.resume	     = delay_resume,
 	.status	     = delay_status,
 	.iterate_devices = delay_iterate_devices,

-- 
Takahiro Yasui
Hitachi Computer Products (America), Inc.

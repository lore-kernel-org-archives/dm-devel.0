From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] make drivers/md/dm-snap.c:ksnapd static
Date: Fri, 17 Nov 2006 02:19:54 +0100
Message-ID: <20061117011954.GU31879@stusta.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch makes the needlessly global "ksnapd" static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.19-rc5-mm2/drivers/md/dm-snap.c.old	2006-11-16 23:22:56.000000000 +0100
+++ linux-2.6.19-rc5-mm2/drivers/md/dm-snap.c	2006-11-16 23:23:06.000000000 +0100
@@ -39,7 +39,7 @@
  */
 #define SNAPSHOT_PAGES 256
 
-struct workqueue_struct *ksnapd;
+static struct workqueue_struct *ksnapd;
 static void flush_queued_bios(void *data);
 
 struct pending_exception {

From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 10/21] [hwtable] Update S/390 DASD entry
Date: Mon, 21 May 2007 11:24:23 +0200
Message-ID: <20070521092423.83F0FD44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Current s390-tools contain a program 'dasdinfo', which should be used
instead of the older 'dasd_id' program from udev.
And we should be using 'queue_if_no_path', too.

Signed-off-by: Stefan Bader <bader@de.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index df6f5aa..9354a8e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -404,9 +404,9 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
 		.bl_product       = "S/390.*",
-		.getuid        = "/sbin/dasd_id /dev/%n",
+		.getuid        = "/sbin/dasdinfo -u -b %n",
 		.getprio       = NULL,
-		.features      = DEFAULT_FEATURES,
+		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = MULTIBUS,
-- 
1.4.3.4

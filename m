From: Dave Olien <dmo@osdl.org>
Subject: [PATCH] trivial fix to dm-emc.c
Date: Thu, 3 Mar 2005 13:56:21 -0800
Message-ID: <20050303215621.GA25051@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
Cc: agk@redhat.com
List-Id: dm-devel.ids



Here's a trivial fix to the emc hardware
handler module. The old code memset the hardware handler
structure to zero AFTER it had initialized the structure's
spinlock field to SPIN_LOCK_UNLOCKED.  The new patch moves the
memset into the hardware handler allocator.

The old code would probably only have a problem if someone
ran with spinlock debugging enabled, in which case SPIN_LOCK_UNLOCKED
contains the value SPINLOCK_MAGIC.

I have no emc hardware to test this change.  However it does compile.

Dave Olien


diff -ur linux-2.6.11-rc3-udm2-original/drivers/md/dm-emc.c linux-2.6.11-rc3-udm2-emc/drivers/md/dm-emc.c
--- linux-2.6.11-rc3-udm2-original/drivers/md/dm-emc.c	2005-03-03 13:40:55.000000000 -0800
+++ linux-2.6.11-rc3-udm2-emc/drivers/md/dm-emc.c	2005-03-03 13:44:38.000000000 -0800
@@ -227,6 +227,7 @@
 	struct emc_handler *h = kmalloc(sizeof(*h), GFP_KERNEL);
 
 	if (h) {
+		memset(h, 0, sizeof(*h));
 		h->lock = SPIN_LOCK_UNLOCKED;
 	}
 
@@ -263,8 +264,6 @@
 	if (!h)
 		return -ENOMEM;
 	
-	memset(h, 0, sizeof(*h));
-	
 	hwh->context = h;
 	
 	if ((h->short_trespass = short_trespass))

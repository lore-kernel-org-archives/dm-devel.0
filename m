From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH] dm-clone: replace spin_lock_irqsave with
	spin_lock_irq
Date: Mon, 7 Oct 2019 16:25:14 +0300
Message-ID: <00196cf3-e98e-e9ff-7494-e097182c80cf@arrikto.com>
References: <alpine.LRH.2.02.1910041015330.11863@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1910041015330.11863@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: Vangelis Koukis <vkoukis@arrikto.com>, dm-devel@redhat.com, Ilias Tsitsimpis <iliastsi@arrikto.com>
List-Id: dm-devel.ids

On 10/4/19 5:17 PM, Mikulas Patocka wrote:
> If we are in a place where it is known that interrupts are enabled,
> functions spin_lock_irq/spin_unlock_irq should be used instead of
> spin_lock_irqsave/spin_unlock_irqrestore.
> 
> spin_lock_irq and spin_unlock_irq are faster because the don't need to
> push and pop the flags register.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 

I reviewed the patch and it looks good. As a minor addition, I attach a
patch which updates the dm_clone_cond_set_range() comment.

Moreover, I will send a complementary patch converting a few more uses
of spin_lock_irqsave/spin_unlock_irqrestore to
spin_lock_irq/spin_unlock_irq.

Thanks,
Nikos


From 097517d594cc127d2f21ca976f1e7df304e1ed10 Mon Sep 17 00:00:00 2001
From: Nikos Tsironis <ntsironis@arrikto.com>
Date: Mon, 7 Oct 2019 14:07:19 +0300
Subject: [PATCH] dm clone: Fix dm_clone_cond_set_range() comment

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-clone-metadata.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-clone-metadata.h b/drivers/md/dm-clone-metadata.h
index 434bff08508b..9d3d29e6a838 100644
--- a/drivers/md/dm-clone-metadata.h
+++ b/drivers/md/dm-clone-metadata.h
@@ -44,7 +44,9 @@ int dm_clone_set_region_hydrated(struct dm_clone_metadata *cmd, unsigned long re
  * @start: Starting region number
  * @nr_regions: Number of regions in the range
  *
- * This function doesn't block, so it's safe to call it from interrupt context.
+ * This function doesn't block, but since it uses
+ * spin_lock_irq()/spin_unlock_irq() it's NOT safe to call it from any context
+ * where interrupts are disabled, e.g., from interrupt context.
  */
 int dm_clone_cond_set_range(struct dm_clone_metadata *cmd, unsigned long start,
 			    unsigned long nr_regions);
-- 
2.11.0

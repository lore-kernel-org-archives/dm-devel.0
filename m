From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [2.6.22-rc1-mm1 PATCH]
	dm-raid1-clear-region-outside-spinlock.patch
Date: Tue, 12 Jun 2007 13:56:38 -0500
Message-ID: <D4B3E83F-0F12-40A7-9B92-8153B38A5DB7@redhat.com>
References: <1179764750.13913.3.camel@hydrogen.msp.redhat.com>
	<20070612160809.GQ25091@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=UTF-8; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070612160809.GQ25091@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


On Jun 12, 2007, at 11:08 AM, Alasdair G Kergon wrote:

> Jon, please would you put together a more-detailed patch header  
> before I
> send this upstream?  I have already seen this analysis, but please
> include it with the patch so other people can review it too.
>
> It needs to mention:
>
>   1) all the code reordering in the patch
>   2) the fact clear_region() is no longer protected by the lock
>
> and why these changes are all OK.

Ok, I've updated the header a bit.

Let me know if it's clear enough,
  brassow

Upstream Status
===============
Original dm-devel post:
https://www.redhat.com/archives/dm-devel/2007-May/msg00077.html

Description
===========
 From drivers/md/dm-log.h:
         /*
          * Mark an area as clean or dirty.  These functions may
          * block, though for performance reasons blocking should
          * be extremely rare (eg, allocating another chunk of
          * memory for some reason).
          */
         void (*mark_region)(struct dirty_log *log, region_t region);
         void (*clear_region)(struct dirty_log *log, region_t region);

These function rarely block, but they could.  We need to
move the clear_region call in rh_update_states outside the
spin lock.

The bits being marked and cleared by the above functions are used
to update the on-disk log, but are never read directly.  We can
perform these operations outside the spinlock since the
bits are only changed within one thread:
         - mark_region in rh_inc
         - clear_region in rh_update_states
So, we grab the clean_regions list items via list_splice within
the spinlock and defer the clear_region until we iterate over
the list for deletion - similar to how the recovered_regions list
is already handled.  We then move the flush() call down to ensure
it encapsulates the changes which are done by the later calls to
clear_region.
Index: linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
@@ -378,10 +378,8 @@ static void rh_update_states(struct regi
                 list_splice(&rh->clean_regions, &clean);
                 INIT_LIST_HEAD(&rh->clean_regions);
-               list_for_each_entry (reg, &clean, list) {
-                       rh->log->type->clear_region(rh->log, reg->key);
+               list_for_each_entry (reg, &clean, list)
                         list_del(&reg->hash_list);
-               }
         }
         if (!list_empty(&rh->recovered_regions)) {
@@ -405,10 +403,12 @@ static void rh_update_states(struct regi
                 mempool_free(reg, rh->region_pool);
         }
-       rh->log->type->flush(rh->log);
-
-       list_for_each_entry_safe (reg, next, &clean, list)
+       list_for_each_entry_safe (reg, next, &clean, list) {
+               rh->log->type->clear_region(rh->log, reg->key);
                 mempool_free(reg, rh->region_pool);
+       }
+
+       rh->log->type->flush(rh->log);
}
static void rh_inc(struct region_hash *rh, region_t region)

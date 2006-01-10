From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [RFC] dm-raid1: not to add newly-allocated RH_CLEAN
	region to clean_regions
Date: Tue, 10 Jan 2006 18:11:40 -0500
Message-ID: <43C43F2C.6050704@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080908050709060306000709"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080908050709060306000709
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

I would like to know whether the attached patch is something
acceptable or not.

In dm-raid1.c, 'clean_regions' in region hash is a list used
to link regions which are clean AND no longer interested (freeable).
So I think it's safe not to add newly-allocated RH_CLEAN entry
to the list because someone who allocates it has interest
on the region.

In the current code, rh_alloc()/rh_find() is called from:
  - rh_inc(), which makes the state RH_DIRTY if it's RH_CLEAN
  - __rh_recovery_prepare(), which makes the state RH_RECOVERING
  - rh_delay(), which is called when the region is RH_RECOVERING

So none uses the newly allocated RH_CLEAN region as-is.
RH_DIRTY region is changed back to RH_CLEAN and then connected
to clean_regions when pending I/O completes.
RH_RECOVERING region is reclaimed when the recovery on the
region completes.

If this patch is acceptable, we can also merge RH_CLEAN and
RH_DIRTY into one state.

Comments are welcome.

Thanks,
Jun'ichi "Nick" Nomura

--------------080908050709060306000709
Content-Type: text/x-patch;
 name="dm-mirror-dont-add-clean.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-mirror-dont-add-clean.patch"

[RFC] dm-raid1: not to add newly-allocated RH_CLEAN region to clean_regions

The clean_regions list is used to maintain reclaimable hash entries.
If the region is known to be marked RH_DIRTY or RH_RECOVERING later,
it's not necessarily connected to clean_regions even if it's clean.

OTOH, region hash entries are allocated only when the region is going
to be written (RH_DIRTY) or recoverred (RH_RECOVERING).

So it's safe not to add RH_CLEAN region to clean_regions in __rh_alloc().
Not adding to clean_regions protects the region from potential race
condition that the hash entry is reclaimed by rh_update_states()
before use.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -urp linux.orig/drivers/md/dm-raid1.c linux/drivers/md/dm-raid1.c
--- linux.orig/drivers/md/dm-raid1.c	2005-12-26 05:25:04.000000000 -0500
+++ linux/drivers/md/dm-raid1.c	2006-01-06 11:47:03.000000000 -0500
@@ -255,11 +254,6 @@ static struct region *__rh_alloc(struct 
 
 	else {
 		__rh_insert(rh, nreg);
-		if (nreg->state == RH_CLEAN) {
-			spin_lock(&rh->region_lock);
-			list_add(&nreg->list, &rh->clean_regions);
-			spin_unlock(&rh->region_lock);
-		}
 		reg = nreg;
 	}
 	write_unlock_irq(&rh->hash_lock);

--------------080908050709060306000709
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080908050709060306000709--

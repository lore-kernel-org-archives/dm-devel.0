From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH v2] dm-switch: Remove unnecessary condition in
	conditional
Date: Thu, 29 Oct 2015 03:54:21 +0900
Message-ID: <1446058461-26298-1-git-send-email-kusumi.tomohiro@gmail.com>
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
To: snitzer@redhat.com, mpatocka@redhat.com
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

> 2015-10-28 8:03 GMT+09:00 Mikulas Patocka:
> On Wed, 28 Oct 2015, Tomohiro Kusumi wrote:
>
> > It's always (sctx->nr_regions == nr_regions) considering
> > the assignment right before this conditional, and this
> > function is only used by .ctr.
>
> The variable sctx->nr_regions has type unsigned long and the variable
> nr_regions has type sector_t.
>
> Thus the variables may be different when overflow happens.
>
> It could be changed to "if (nr_regions >= ULONG_MAX)".

Sorry about that.
Changed the conditional to "if (nr_regions >= ULONG_MAX)",
and brought the assignment of nr_regions after sector_div()
and the sanity check which looks more sane.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-switch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 50fca46..e1b6722 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -99,11 +99,11 @@ static int alloc_region_table(struct dm_target *ti, unsigned nr_paths)
 	if (sector_div(nr_regions, sctx->region_size))
 		nr_regions++;
 
-	sctx->nr_regions = nr_regions;
-	if (sctx->nr_regions != nr_regions || sctx->nr_regions >= ULONG_MAX) {
+	if (nr_regions >= ULONG_MAX) {
 		ti->error = "Region table too large";
 		return -EINVAL;
 	}
+	sctx->nr_regions = nr_regions;
 
 	nr_slots = nr_regions;
 	if (sector_div(nr_slots, sctx->region_entries_per_slot))
-- 
1.7.1

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-raid: stack limits instead of overwriting them.
Date: Thu, 24 Sep 2020 12:56:17 -0400
Message-ID: <20200924165616.GA14650@redhat.com>
References: <alpine.LRH.2.02.2009241225310.22728@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2009241225310.22728@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24 2020 at 12:26pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> This patch fixes a warning WARN_ON_ONCE(!q->limits.discard_granularity).
> The reason is that the function raid_io_hints overwrote
> limits->discard_granularity with zero. We need to properly stack the
> limits instead of overwriting them.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/md/dm-raid.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-raid.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-raid.c	2020-09-24 18:16:45.000000000 +0200
> +++ linux-2.6/drivers/md/dm-raid.c	2020-09-24 18:16:45.000000000 +0200
> @@ -3734,8 +3734,8 @@ static void raid_io_hints(struct dm_targ
>  	 * RAID0/4/5/6 don't and process large discard bios properly.
>  	 */
>  	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
> -		limits->discard_granularity = chunk_size_bytes;
> -		limits->max_discard_sectors = rs->md.chunk_sectors;
> +		limits->discard_granularity = max(limits->discard_granularity, chunk_size_bytes);
> +		limits->max_discard_sectors = min_not_zero(limits->max_discard_sectors, (unsigned)rs->md.chunk_sectors);
>  	}
>  }
>  

OK, but how is it that chunk_size_bytes is 0?  Oh, raid1 doesn't have a
chunksize does it!?

Relative to MD raid0 and raid10: they don't have dm-stripe like
optimization to handle large discards.  So stacking up larger discard
limits (that span multiple chunks) is a non-starter right?

Like dm-raid.c, raid10.c does explicitly set max_discard_sectors to
mddev->chunk_sectors.  But it (mistakenly IMHO) just accepts stackd up
discard_granularity.

Looking at raid1.c I see MD is just stacking up the limits without
modification.  Maybe dm-raid.c shouldn't be changing these limits at all
for raid1 (just use what was already stacked)?

WAIT... Could it be that raid_io_hints _really_ meant to special case
raid0 and raid10 -- due to their striping/splitting requirements!?
So, not raid1 but raid0?

E.g.:

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 56b723d012ac..6dca932d6f1d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3730,10 +3730,10 @@ static void raid_io_hints(struct dm_target *ti,
struct queue_limits *limits)
        blk_limits_io_opt(limits, chunk_size_bytes *
	mddev_data_stripes(rs));

        /*
-        * RAID1 and RAID10 personalities require bio splitting,
-        * RAID0/4/5/6 don't and process large discard bios properly.
+        * RAID0 and RAID10 personalities require bio splitting,
+        * RAID1/4/5/6 don't and process large discard bios properly.
         */
-       if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
+       if (rs_is_raid0(rs) || rs_is_raid10(rs)) {
                limits->discard_granularity = chunk_size_bytes;
                limits->max_discard_sectors = rs->md.chunk_sectors;
        }

Mike

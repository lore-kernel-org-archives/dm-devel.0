From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: dm-cache writethrough issue.
Date: Mon, 25 Mar 2013 09:36:54 -0700
Message-ID: <20130325163654.GF5357@blackbox.djwong.org>
References: <20130325102500.GA6340@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130325102500.GA6340@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 25, 2013 at 10:25:01AM +0000, Joe Thornber wrote:
> Alasdair,
> 
> Could you push this upstream ASAP please?
> 
> I'm not happy that we're now adding such a large structure to the per
> bio data, at the very least we should only do this if writethrough is
> enabled.  But I'll improve this later, for now correctness is the
> important thing.
> 
> - Joe

Makes my problems go away on my setup, so you can add:
Tested-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
> 
> 
> 
> Author: Joe Thornber <ejt@redhat.com>
> Date:   Mon Mar 25 10:10:58 2013 +0000
> 
>     [dm-cache] Writethrough mode wasn't resetting bio fields before reusing
>     
>     The writethrough mode reuses the same bio to write to both the origin
>     and cache device.  It was recording the bi_sector and restoring this,
>     but this was inadequate; lower level drivers can change all sorts of
>     bio fields.
>     
>     This patch adds a struct dm_bio_details field, and uses
>     dm_bio_record() and dm_bio_restore() to ensure the bio is restored
>     before reissuing to the cache device.
>     
>     Issue discovered by Darrick Wong.
> 
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index cf24a46..873f495 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -6,6 +6,7 @@
>  
>  #include "dm.h"
>  #include "dm-bio-prison.h"
> +#include "dm-bio-record.h"
>  #include "dm-cache-metadata.h"
>  
>  #include <linux/dm-io.h>
> @@ -205,6 +206,7 @@ struct per_bio_data {
>         struct cache *cache;
>         dm_cblock_t cblock;
>         bio_end_io_t *saved_bi_end_io;
> +       struct dm_bio_details bio_details;
>  };
>  
>  struct dm_cache_migration {
> @@ -642,6 +644,7 @@ static void writethrough_endio(struct bio *bio, int err)
>                 return;
>         }
>  
> +       dm_bio_restore(&pb->bio_details, bio);
>         remap_to_cache(pb->cache, bio, pb->cblock);
>  
>         /*
> @@ -665,6 +668,7 @@ static void remap_to_origin_then_cache(struct cache *cache, struct bio *bio,
>         pb->cache = cache;
>         pb->cblock = cblock;
>         pb->saved_bi_end_io = bio->bi_end_io;
> +       dm_bio_record(&pb->bio_details, bio);
>         bio->bi_end_io = writethrough_endio;
>  
>         remap_to_origin_clear_discard(pb->cache, bio, oblock);
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

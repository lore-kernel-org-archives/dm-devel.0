From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 7/17] bottom-layer barrier support (fwd)
Date: Mon, 27 Apr 2009 19:11:53 +0100
Message-ID: <20090427181153.GC23302@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 20, 2009 at 03:57:43AM -0400, Mikulas Patocka wrote:
> +static int __clone_and_map_empty_barrier(struct clone_info *ci)
> +{
> +	unsigned i, j, n;
> +	n = dm_table_get_num_targets(ci->map);
> +	for (i = 0; i < n; i++) {
> +		struct bio *clone;
> +		struct dm_target *ti = dm_table_get_target(ci->map, i);
> +		for (j = 0; j < ti->num_flush_requests; j++) {
> +			struct dm_target_io *tio = alloc_tio(ci->md);
> +			tio->io = ci->io;
> +			tio->ti = ti;
> +			memset(&tio->info, 0, sizeof(tio->info));
> +			tio->info.flush_request = j;
> +
> +			clone = bio_alloc_bioset(GFP_NOIO, 0, ci->md->bs);
> +			__bio_clone(clone, ci->bio);
> +			clone->bi_destructor = dm_bio_destructor;
> +
> +			__map_bio(ti, clone, tio);

I'm editing this one a bit, splitting that middle section out into a separate
function to improve readability.  (The compiler can optimise it back if it wants.)

Alasdair
-- 
agk@redhat.com

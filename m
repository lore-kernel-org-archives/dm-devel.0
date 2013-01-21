From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 4/8] [dm-bio-prison] Change the
	bio-prison	interface so the memory for the cells is passed in.
Date: Mon, 21 Jan 2013 23:32:45 +0000
Message-ID: <20130121233245.GF27093@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-5-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1355429956-22785-5-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 13, 2012 at 08:19:12PM +0000, Joe Thornber wrote:
> @@ -87,6 +79,20 @@ void dm_bio_prison_destroy(struct dm_bio_prison *prison)
>  }
>  EXPORT_SYMBOL_GPL(dm_bio_prison_destroy);
>  
> +struct dm_bio_prison_cell *
> +dm_bio_prison_alloc_cell(struct dm_bio_prison *prison, gfp_t gfp)

Let's keep that on one line.

> +int dm_bio_detain(struct dm_bio_prison *prison,
> +		  struct dm_cell_key *key,
> +		  struct bio *inmate,
> +		  struct dm_bio_prison_cell *memory,

The caller has already allocated 'memory' specifically to hold that struct.
Call it 'new_cell' perhaps?   'cell_prealloc' ?

> +		  struct dm_bio_prison_cell **ref)

cell_ref ?

> @@ -226,6 +226,53 @@ struct thin_c {
>  
>  /*----------------------------------------------------------------*/
>  
> +static int bio_detain(struct pool *pool, struct dm_cell_key *key, struct bio *bio,
> +		      struct dm_bio_prison_cell **result)
> +{
> +	int r;
> +	struct dm_bio_prison_cell *cell;
> +
> +	cell = dm_bio_prison_alloc_cell(pool->prison, GFP_NOIO);
> +	if (!cell)
> +		return -ENOMEM;

Redundant test?  The mempool allocation always succeeds (or blocks).

> +	r = dm_bio_detain(pool->prison, key, bio, cell, result);
> +
> +	if (r)
> +		/*
> +		 * We reused an old cell, or errored; we can get rid of

Can't have errored that I can see.

> +		 * the new one.
> +		 */
> +		dm_bio_prison_free_cell(pool->prison, cell);
> +
> +	return r;
> +}

Alasdair



--- a/dm-bio-prison.c	2013-01-14 19:32:36.000000000 +0000
+++ b/dm-bio-prison.c	2013-01-21 23:09:49.000000000 +0000
@@ -79,8 +79,7 @@
 }
 EXPORT_SYMBOL_GPL(dm_bio_prison_destroy);
 
-struct dm_bio_prison_cell *
-dm_bio_prison_alloc_cell(struct dm_bio_prison *prison, gfp_t gfp)
+struct dm_bio_prison_cell *dm_bio_prison_alloc_cell(struct dm_bio_prison *prison, gfp_t gfp)
 {
 	return mempool_alloc(prison->cell_pool, gfp);
 }
--- a/dm-thin.c	2013-01-18 15:00:00.000000000 +0000
+++ b/dm-thin.c	2013-01-21 23:09:48.000000000 +0000
@@ -250,16 +250,16 @@
 	int r;
 	struct dm_bio_prison_cell *cell;
 
+	/*
+	 * Allocate a cell from the prison's mempool.
+	 * This might block but it can't fail.
+	 */
 	cell = dm_bio_prison_alloc_cell(pool->prison, GFP_NOIO);
-	if (!cell)
-		return -ENOMEM;
 
 	r = dm_bio_detain(pool->prison, key, bio, cell, result);
-
 	if (r)
 		/*
-		 * We reused an old cell, or errored; we can get rid of
-		 * the new one.
+		 * We reused an old cell: get rid of the new one.
 		 */
 		dm_bio_prison_free_cell(pool->prison, cell);
 

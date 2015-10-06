From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block: flush queued bios when the process blocks
Date: Tue, 6 Oct 2015 16:26:06 -0400
Message-ID: <20151006202606.GB4158@redhat.com>
References: <5384AA79.4010206@kernel.dk>
 <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
 <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
 <5384CE82.90601@kernel.dk>
 <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
 <20151005205943.GB25762@redhat.com>
 <alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
 <20151006185016.GA31955@redhat.com>
 <20151006201637.GA4158@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151006201637.GA4158@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, kent.overstreet@gmail.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 06 2015 at  4:16P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> To give others context for why I'm caring about this issue again, this
> recent BZ against 4.3-rc served as a reminder that we _need_ a fix:
> https://bugzilla.redhat.com/show_bug.cgi?id=1267650
> 
> FYI, I cleaned up the plug-based approach a bit further, here is the
> incremental patch:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=f73d001ec692125308accbb5ca26f892f949c1b6
> 
> And here is a new version of the overall combined patch (sharing now
> before I transition to looking at alternatives, though my gut is the use
> of a plug in generic_make_request really wouldn't hurt us.. famous last
> words):
> 
>  block/bio.c            | 82 +++++++++++++-------------------------------------
>  block/blk-core.c       | 21 ++++++++-----
>  drivers/md/dm-bufio.c  |  2 +-
>  drivers/md/raid1.c     |  6 ++--
>  drivers/md/raid10.c    |  6 ++--
>  include/linux/blkdev.h | 11 +++++--
>  include/linux/sched.h  |  4 ---
>  7 files changed, 51 insertions(+), 81 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index ad3f276..3d03668 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -354,35 +354,31 @@ static void bio_alloc_rescue(struct work_struct *work)
>  	}
>  }
>  
> -static void punt_bios_to_rescuer(struct bio_set *bs)
> +/**
> + * blk_flush_bio_list
> + * @plug: the blk_plug that may have collected bios
> + *
> + * Pop bios queued on plug->bio_list and submit each of them to
> + * their rescue workqueue.
> + *
> + * If the bio doesn't have a bio_set, we use the default fs_bio_set.
> + * However, stacking drivers should use bio_set, so this shouldn't be
> + * an issue.
> + */
> +void blk_flush_bio_list(struct blk_plug *plug)
>  {
> -	struct bio_list punt, nopunt;
>  	struct bio *bio;
>  
> -	/*
> -	 * In order to guarantee forward progress we must punt only bios that
> -	 * were allocated from this bio_set; otherwise, if there was a bio on
> -	 * there for a stacking driver higher up in the stack, processing it
> -	 * could require allocating bios from this bio_set, and doing that from
> -	 * our own rescuer would be bad.
> -	 *
> -	 * Since bio lists are singly linked, pop them all instead of trying to
> -	 * remove from the middle of the list:
> -	 */
> -
> -	bio_list_init(&punt);
> -	bio_list_init(&nopunt);
> -
> -	while ((bio = bio_list_pop(current->bio_list)))
> -		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> -
> -	*current->bio_list = nopunt;
> -
> -	spin_lock(&bs->rescue_lock);
> -	bio_list_merge(&bs->rescue_list, &punt);
> -	spin_unlock(&bs->rescue_lock);
> +	while ((bio = bio_list_pop(&plug->bio_list))) {

Bleh, should be plug->bio_list.. obviously I didn't compile test this...

Here is the incremental I've folded in:

diff --git a/block/bio.c b/block/bio.c
index 3d03668..b868b9e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -369,7 +369,10 @@ void blk_flush_bio_list(struct blk_plug *plug)
 {
 	struct bio *bio;
 
-	while ((bio = bio_list_pop(&plug->bio_list))) {
+	if (!plug->bio_list)
+		return;
+
+	while ((bio = bio_list_pop(plug->bio_list))) {
 		struct bio_set *bs = bio->bi_pool;
 		if (!bs)
 			bs = fs_bio_set;

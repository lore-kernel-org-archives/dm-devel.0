From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/7] md: use block_device name vsprintf helper
Date: Tue, 14 Apr 2015 11:43:15 +0200
Message-ID: <20150414094315.GJ23327@quack.suse.cz>
References: <1428928300-9132-1-git-send-email-dmonakhov@openvz.org>
 <1428928300-9132-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428928300-9132-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon 13-04-15 16:31:38, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
...
> @@ -2610,7 +2597,6 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>  	struct bio *bio;
>  	struct r10conf *conf = mddev->private;
>  	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
> -	char b[BDEVNAME_SIZE];
>  	unsigned long do_sync;
>  	int max_sectors;
>  
> @@ -2623,7 +2609,6 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>  	 * frozen.
>  	 */
>  	bio = r10_bio->devs[slot].bio;
> -	bdevname(bio->bi_bdev, b);
>  	bio_put(bio);
>  	r10_bio->devs[slot].bio = NULL;
>  
> @@ -2639,9 +2624,9 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>  read_more:
>  	rdev = read_balance(conf, r10_bio, &max_sectors);
>  	if (rdev == NULL) {
> -		printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
> +		printk(KERN_ALERT "md/raid10:%s: %pg: unrecoverable I/O"
>  		       " read error for block %llu\n",
> -		       mdname(mddev), b,
> +		       mdname(mddev), bio->bi_bdev,
>  		       (unsigned long long)r10_bio->sector);
>  		raid_end_bio_io(r10_bio);
>  		return;
  So it seems to me that in the above, you'll reference bio->bi_bdev of an
already free bio since the code does bio_put() just after calling
bdevname()...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

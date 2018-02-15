From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] DM Regression in 4.16-rc1 - read() returns data when
 it shouldn't
Date: Thu, 15 Feb 2018 08:37:12 +0100
Message-ID: <1df6de2e-bfd3-84c4-cffb-83b6299c6d23@gmail.com>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
 <871shnqp9l.fsf@notabene.neil.brown.name> <20180214230526.GA25114@redhat.com>
 <87y3jvp13k.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87y3jvp13k.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 02/15/2018 01:07 AM, NeilBrown wrote:
> 
> And looking again at the code, it doesn't seem so bad.  I was worried
> about reassigning ci.io->orig_bio after calling
> __split_and_process_non_flush(), but the important thing is to set it
> before the last dec_pending() call, and the code gets that right.
> 
> I think I've found the problem though:
> 
> 			/* done with normal IO or empty flush */
> 			bio->bi_status = io_error;
> 
> When we have chained bios, there are multiple sources for error which
> need to be merged into bi_status:  all bios that were chained to this
> one, and this bio itself.
> 
> __bio_chain_endio uses:
> 
> 	if (!parent->bi_status)
> 		parent->bi_status = bio->bi_status;
> 
> so the new status won't over-ride the old status (unless there are
> races....), but dm doesn't do that - I guess it didn't have to worry
> about chains before.
> 
> So this:
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index d6de00f367ef..68136806d365 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -903,7 +903,8 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>  			queue_io(md, bio);
>  		} else {
>  			/* done with normal IO or empty flush */
> -			bio->bi_status = io_error;
> +			if (io_error)
> +				bio->bi_status = io_error;
>  			bio_endio(bio);
>  		}
>  	}
> 

Hi,

well, it indeed fixes the reported problem, thanks.
But I just tested the first (dm.c) change above.

The important part is also that if the error is hits bio later, it will produce
short read (and not fail of the whole operation), this can be easily tested if we switch
the error and the zero target in that reproducer
  //system("echo -e \'0 10000000 error\'\\\\n\'10000000 1000000 zero\' | dmsetup create test");
  system("echo -e \'0 10000000 zero\'\\\\n\'10000000 1000000 error\' | dmsetup create test");

So it seems your patch works.

I am not sure about this part though:

> should fix it.  And __bio_chain_endio should probably be
> 
> diff --git a/block/bio.c b/block/bio.c
> index e1708db48258..ad77140edc6f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -312,7 +312,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
>  {
>  	struct bio *parent = bio->bi_private;
>  
> -	if (!parent->bi_status)
> +	if (bio->bi_status)
>  		parent->bi_status = bio->bi_status;

Shouldn't it be
	if (!parent->bi_status && bio->bi_status)
  		parent->bi_status = bio->bi_status;
?

Maybe one rephrased question: what about priorities for errors (bio statuses)?

For example, part of a bio fails with EILSEQ (data integrity check error, BLK_STS_PROTECTION),
part with EIO (media error, BLK_STS_IOERR). What should be reported for parent bio?
(I would expect I always get EIO here because this is hard, uncorrectable error.)

Anyway, thanks for the fix!

Milan


>  	bio_put(bio);
>  	return parent;
> 
> to remove the chance that a race will hide a real error.
> 
> Milan: could you please check that the patch fixes the dm-crypt bug?
> I've confirmed that it fixes your test case.
> When you confirm, I'll send a proper patch.
> 
> I guess I should audit all code that assigns to ->bi_status and make
> sure nothing ever assigns 0 to it.
> 
> Thanks,
> NeilBrown
> 

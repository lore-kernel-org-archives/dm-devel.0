From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Fri, 30 Jan 2009 17:05:26 +0900
Message-ID: <4982B4C6.8050904@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>	<20090128154019.GB23158@agk.fab.redhat.com>	<49815863.8040806@ct.jp.nec.com>
	<20090129104147.GB9870@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090129104147.GB9870@pentland.suse.de>
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
Cc: Alasdair Kergon <agk@redhat.com>, mbroz@redhat.com
List-Id: dm-devel.ids

Hi Hannes,

Thank you for the comments and patches.
See my comments below.

On 01/29/2009 07:41 PM +0900, Hannes Reinecke wrote:
> On Thu, Jan 29, 2009 at 04:18:59PM +0900, Kiyoshi Ueda wrote:
>> Hi Alasdair,
>>
>> On 01/29/2009 12:40 AM +0900, Alasdair G Kergon wrote:
>>> On Fri, Oct 03, 2008 at 11:08:25AM -0400, Kiyoshi Ueda wrote:
>>>> This patch-set is the updated version of request-based dm-multipath.
>>>> The changes from the previous version (*) are to follow up the change
>>>> of the interface to export lld's busy state (PATCH 5).
>>> I've fixed them up to compile again, but haven't thoroughly checked for
>>> side-effects.
>> I found some problems below in my patches and now considering
>> how to fix them:
>>   o Unnecessary EIO is returned to application if it submits
>>     a bio during table swapping.
> Yes, I've noticed that. Problem is this:
> 
> --- linux-2.6.27.orig/drivers/md/dm.c
> +++ linux-2.6.27/drivers/md/dm.c
> @@ -1304,7 +1304,11 @@ static int dm_make_request(struct reques
>                 return 0;
>         }
>  
> -       if (unlikely(!md->map)) {
> +       /*
> +        * Submitting to a stopped queue with no map is okay;
> +        * might happen during reconfiguration.
> +        */
> +       if (unlikely(!md->map) && !blk_queue_stopped(q)) {
>                 bio_endio(bio, -EIO);
>                 return 0;
>         }
> 
> The make_request callback should never return EIO if there's any
> chance at all to get this request done.
 
Exactly this part has a race condition with table swapping.
Although you patch fixes the race condition, I think I need
more careful consideration here.
(e.g. Is it really OK to go bios through __make_request() with
      old queue restrictions during table swapping?)

I'll work on this problem after my vacation.


>>   o kernel panic occurs by frequent table swapping during heavy I/Os.
>>  
> That's probably fixed by this patch:
> 
> --- linux-2.6.27/drivers/md/dm.c.orig   2009-01-23 15:59:22.741461315 +0100
> +++ linux-2.6.27/drivers/md/dm.c        2009-01-26 09:03:02.787605723 +0100
> @@ -714,13 +714,14 @@ static void free_bio_clone(struct reques
>         struct dm_rq_target_io *tio = clone->end_io_data;
>         struct mapped_device *md = tio->md;
>         struct bio *bio;
> -       struct dm_clone_bio_info *info;
>  
>         while ((bio = clone->bio) != NULL) {
>                 clone->bio = bio->bi_next;
>  
> -               info = bio->bi_private;
> -               free_bio_info(md, info);
> +               if (bio->bi_private) {
> +                       struct dm_clone_bio_info *info = bio->bi_private;
> +                       free_bio_info(md, info);
> +               }
>  
>                 bio->bi_private = md->bs;
>                 bio_put(bio);
> 
> The info field is not necessarily filled here, so we have to check for it
> explicitly.
> 
> With these two patches request-based multipathing have survived all stress-tests
> so far. Except on mainframe (zfcp), but that's more a driver-related thing.

Hmm, it seems I'm hitting a different problem from the one you hit,
because I still see my problem even with your patch.
I need more investigation after my vacation.

Thanks,
Kiyoshi Ueda

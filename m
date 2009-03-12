From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Thu, 12 Mar 2009 17:58:35 +0900
Message-ID: <49B8CEBB.7070701@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>	<20090128154019.GB23158@agk.fab.redhat.com>	<49815863.8040806@ct.jp.nec.com>	<20090129104147.GB9870@pentland.suse.de>	<4982B4C6.8050904@ct.jp.nec.com>	<49B60444.2090008@ct.jp.nec.com>
	<49B613FE.3060501@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49B613FE.3060501@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

On 2009/03/10 16:17 +0900, Hannes Reinecke wrote:
>>>>>   o kernel panic occurs by frequent table swapping during heavy I/Os.
>>>>>  
>>>> That's probably fixed by this patch:
>>>>
>>>> --- linux-2.6.27/drivers/md/dm.c.orig   2009-01-23
>>>> 15:59:22.741461315 +0100
>>>> +++ linux-2.6.27/drivers/md/dm.c        2009-01-26
>>>> 09:03:02.787605723 +0100
>>>> @@ -714,13 +714,14 @@ static void free_bio_clone(struct reques
>>>>         struct dm_rq_target_io *tio = clone->end_io_data;
>>>>         struct mapped_device *md = tio->md;
>>>>         struct bio *bio;
>>>> -       struct dm_clone_bio_info *info;
>>>>  
>>>>         while ((bio = clone->bio) != NULL) {
>>>>                 clone->bio = bio->bi_next;
>>>>  
>>>> -               info = bio->bi_private;
>>>> -               free_bio_info(md, info);
>>>> +               if (bio->bi_private) {
>>>> +                       struct dm_clone_bio_info *info =
>>>> bio->bi_private;
>>>> +                       free_bio_info(md, info);
>>>> +               }
>>>>  
>>>>                 bio->bi_private = md->bs;
>>>>                 bio_put(bio);
>>>>
>>>> The info field is not necessarily filled here, so we have to check
>>>> for it
>>>> explicitly.
>>>>
>>>> With these two patches request-based multipathing have survived all
>>>> stress-tests
>>>> so far. Except on mainframe (zfcp), but that's more a driver-related
>>>> thing.
>>
>> Do you hit some problem without the patch above?
>> If so, that should be a programming bug and we need to fix it. 
>> Otherwise,
>> we should be leaking a memory (since all cloned bio should always have
>> the dm_clone_bio_info structure in ->bi_private).
>>
> Yes, I've found that one later on.
> The real problem was in clone_setup_bios(), which might end up calling an
> invalid end_io_data pointer. Patch is attached.

Nice catch!  Thank you for the patch.

> -static void free_bio_clone(struct request *clone)
> +static void free_bio_clone(struct request *clone, struct mapped_device *md)

I have changed the argument order to match with other free_* functions:
    free_bio_clone(struct mapped_device *md, struct request *clone)

Thanks,
Kiyoshi Ueda

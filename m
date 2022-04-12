Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD517C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 01:17:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-l1r7DPHLNOyW_5sEwdyT6A-1; Mon, 11 Apr 2022 21:17:37 -0400
X-MC-Unique: l1r7DPHLNOyW_5sEwdyT6A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B09A21C05AD2;
	Tue, 12 Apr 2022 01:17:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E820401DFB;
	Tue, 12 Apr 2022 01:17:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 280541940365;
	Tue, 12 Apr 2022 01:17:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 81E381947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 01:17:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5ED1E40D1D1; Tue, 12 Apr 2022 01:17:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AE25401473
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 01:17:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B523185A79C
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 01:17:34 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-zhUlnLsZO9ewQdiFxRTImA-1; Mon, 11 Apr 2022 21:17:32 -0400
X-MC-Unique: zhUlnLsZO9ewQdiFxRTImA-1
X-IronPort-AV: E=Sophos;i="5.90,252,1643644800"; d="scan'208";a="202534818"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 12 Apr 2022 09:17:29 +0800
IronPort-SDR: QQp1qt379m0qPbelC8EUollogoXnOapax9RCdj8gdrjn7h1qopgFZbrwRMU6QnVrMulj92VQcN
 eF3L05j4RQ9/Hw1jPMUPoeA+aDFGqKuhuLE2rSRpFHHusmwz/NnoVuNvqW0oHqGeqgSstVR3Dh
 6rfoL9MBvh13fE1Lv3aX6qThFH6EGFF1l8FkAkxzpgX2A4mgWE7kwsd1LKEXU5l+oYaCylZNtY
 mWo7RB3g5M8gnriKHwg4b9KNK5LRPyDed/2qVFtcCHEJyxeHJx6mDeeEWl76FYdyG/moyTCceV
 fwMDnK/7BVRfV3thclg0uAFE
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 17:47:59 -0700
IronPort-SDR: UexYrWwstDFevzGbvgrJyntfpBWjWfhAllteDBi/RH8p6RgnhahsbYx4gSk0p2a3VHHqGZSygx
 IarFEXW4Jwcow1lfM6iktFrl9qeOZUcVWtI6Q5CQE31+jpiZTCnXm338aIliyXtqTtiRTNNkMt
 PnDMj+QUzNQag5NuXcSBXbtkCOL243KvYM2S6YzTDgb5ZqBTBW7EkxZWuI2GtN7rgDKI8VQJxe
 SBsY50bf4GTqftn6iuH4aXluXKcYFf4fw48PIIMmDtFAu2L8d8IHxPGrstzUBQewprXxXF1hZQ
 xvI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 18:17:31 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kcnrp6RW5z1SHwl
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 18:17:30 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id uQHYZ-wo8FId for <dm-devel@redhat.com>;
 Mon, 11 Apr 2022 18:17:29 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kcnrn15hHz1Rvlx;
 Mon, 11 Apr 2022 18:17:28 -0700 (PDT)
Message-ID: <f1dbaa09-25b4-9703-f2ef-0c3c78bf1a76@opensource.wdc.com>
Date: Tue, 12 Apr 2022 10:17:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Ming Lei <ming.lei@redhat.com>
References: <95d8a8ed-27f8-0d88-a543-16910dca83e3@opensource.wdc.com>
 <YlN+plgvwZQdPBGj@T590>
 <7ccf1709-8aec-18c3-1d09-fe03b4a57017@opensource.wdc.com>
 <6b617a59-1591-8323-9de8-b39247eb328f@opensource.wdc.com>
 <YlPZ7vSZGMZBaRDv@T590>
 <54279bbe-6e8b-2c0a-90fc-825b89863b3f@opensource.wdc.com>
 <YlQ4na/HwBSm5C3U@T590>
 <869a7210-a0f0-4aae-3e90-cdfe30a72434@opensource.wdc.com>
 <YlTDJMxutPBszCg7@T590>
 <da55322d-bf3d-ade3-2f90-a361a8a402ba@opensource.wdc.com>
 <YlTPk9woQ29IXS+C@T590>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YlTPk9woQ29IXS+C@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 1/3] dm: don't grab target io reference in
 dm_zone_map_bio
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/12/22 10:02, Ming Lei wrote:
> On Tue, Apr 12, 2022 at 09:28:46AM +0900, Damien Le Moal wrote:
>> On 4/12/22 09:09, Ming Lei wrote:
>>> On Tue, Apr 12, 2022 at 08:33:04AM +0900, Damien Le Moal wrote:
>>>> On 4/11/22 23:18, Ming Lei wrote:
>>>>>>>> This fixes the issue:
>>>>>>>>
>>>>>>>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>>>>>>> index 3c5fad7c4ee6..3dd6735450c5 100644
>>>>>>>> --- a/drivers/md/dm.c
>>>>>>>> +++ b/drivers/md/dm.c
>>>>>>>> @@ -581,7 +581,7 @@ static struct dm_io *alloc_io(struct mapped_device
>>>>>>>> *md, struct bio *bio)
>>>>>>>>         io->status = 0;
>>>>>>>>         atomic_set(&io->io_count, 1);
>>>>>>>>         this_cpu_inc(*md->pending_io);
>>>>>>>> -       io->orig_bio = NULL;
>>>>>>>> +       io->orig_bio = bio;
>>>>>>>>         io->md = md;
>>>>>>>>         io->map_task = current;
>>>>>>>>         spin_lock_init(&io->lock);
>>>>>>>>
>>>>>>>> Otherwise, the dm-zone.c code sees a NULL orig_bio.
>>>>>>>> However, this change may be messing up the bio accounting. Need to check that.
>>>>>>>
>>>>>>> Looks it is one recent regression since:
>>>>>>>
>>>>>>> commit 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface")
>>>>>>
>>>>>> Yep, saw that. Problem is, I really do not understand that change setting
>>>>>> io->orig_bio *after* __map_bio() is called. It seems that the accounting
>>>>>> is done on each fragment of the orig_bio instead of once for the entire
>>>>>> BIO... So my "fix" above seems wrong. Apart from passing along orig_bio as
>>>>>> an argument to  __map_bio() from __split_and_process_bio(), I do not think
>>>>>> my change is correct. Thoughts ?
>>>>>
>>>>> Frankly speaking, both changing ->orig_bio after split and setting ->orig_bio
>>>>> after ->map() looks ugly & tricky, and the following change should avoid the
>>>>> issue, meantime simplify dm accounting a bit:
>>>>>
>>>>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>>>> index 3c5fad7c4ee6..f1fe83113608 100644
>>>>> --- a/drivers/md/dm.c
>>>>> +++ b/drivers/md/dm.c
>>>>> @@ -581,7 +581,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
>>>>>  	io->status = 0;
>>>>>  	atomic_set(&io->io_count, 1);
>>>>>  	this_cpu_inc(*md->pending_io);
>>>>> -	io->orig_bio = NULL;
>>>>> +	io->orig_bio = bio;
>>>>>  	io->md = md;
>>>>>  	io->map_task = current;
>>>>>  	spin_lock_init(&io->lock);
>>>>> @@ -1223,19 +1223,11 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
>>>>>  	 * Account io->origin_bio to DM dev on behalf of target
>>>>>  	 * that took ownership of IO with DM_MAPIO_SUBMITTED.
>>>>>  	 */
>>>>> -	if (io->map_task == current) {
>>>>> +	if (io->map_task == current)
>>>>>  		/* Still in target's map function */
>>>>>  		dm_io_set_flag(io, DM_IO_START_ACCT);
>>>>> -	} else {
>>>>> -		/*
>>>>> -		 * Called by another thread, managed by DM target,
>>>>> -		 * wait for dm_split_and_process_bio() to store
>>>>> -		 * io->orig_bio
>>>>> -		 */
>>>>> -		while (unlikely(!smp_load_acquire(&io->orig_bio)))
>>>>> -			msleep(1);
>>>>> +	else
>>>>
>>>> Curly brackets around the else here.
>>>>
>>>>>  		dm_start_io_acct(io, clone);
>>>>> -	}
>>>>>  
>>>>>  	__dm_submit_bio_remap(tgt_clone, disk_devt(io->md->disk),
>>>>>  			      tio->old_sector);
>>>>> @@ -1562,7 +1554,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>>>>>  				     struct dm_table *map, struct bio *bio)
>>>>>  {
>>>>>  	struct clone_info ci;
>>>>> -	struct bio *orig_bio = NULL;
>>>>> +	struct bio *new_bio = NULL;
>>>>>  	int error = 0;
>>>>>  
>>>>>  	init_clone_info(&ci, md, map, bio);
>>>>> @@ -1578,22 +1570,14 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>>>>>  	if (error || !ci.sector_count)
>>>>>  		goto out;
>>>>>  
>>>>> -	/*
>>>>> -	 * Remainder must be passed to submit_bio_noacct() so it gets handled
>>>>> -	 * *after* bios already submitted have been completely processed.
>>>>> -	 * We take a clone of the original to store in ci.io->orig_bio to be
>>>>> -	 * used by dm_end_io_acct() and for dm_io_complete() to use for
>>>>> -	 * completion handling.
>>>>> -	 */
>>>>
>>>> This comment should remain with some adjustment.
>>>
>>> Fine, just felt the approach is very straightforward.
>>>
>>>>
>>>>> -	orig_bio = bio_split(bio, bio_sectors(bio) - ci.sector_count,
>>>>> -			     GFP_NOIO, &md->queue->bio_split);
>>>>> -	bio_chain(orig_bio, bio);
>>>>> -	trace_block_split(orig_bio, bio->bi_iter.bi_sector);
>>>>> -	submit_bio_noacct(bio);
>>>>> +	new_bio = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
>>>>> +			&md->queue->bio_split);
>>>>
>>>> Why not keep using bio_split() ?
>>>
>>> With bio_split(), 'bio' actually tracks the remainder, and the returned
>>> 'orig_bio' tracks the part for current target io, so ->orig_bio has to
>>> be updated in this way.
>>>
>>> With bio_alloc_clone() and bio_trim(), ->orig_bio needn't to be
>>> changed, and assigning it in alloc_io() works perfectly.
>>
>> OK. Got it.
>>
>>>>> +	bio_trim(new_bio, bio_sectors(bio) - ci.sector_count, ci.sector_count);
>>>>> +	bio_trim(bio, 0, bio_sectors(bio) - ci.sector_count);
>>>>> +	bio_chain(new_bio, bio);
>>>>> +	trace_block_split(new_bio, new_bio->bi_iter.bi_sector);
>>>>> +	submit_bio_noacct(new_bio);
>>>>>  out:
>>>>> -	if (!orig_bio)
>>>>> -		orig_bio = bio;
>>>>> -	smp_store_release(&ci.io->orig_bio, orig_bio);
>>>>>  	if (dm_io_flagged(ci.io, DM_IO_START_ACCT))
>>>>>  		dm_start_io_acct(ci.io, NULL);
>>>>
>>>> I tested this and it works. Need to check the accounting though.
>>>> And I agree this is a lot cleaner :)
>>>
>>> BTW, the cloned bio for split is just for accounting purpose, if
>>> ->bi_iter.bi_sector & ->bi_iter.bi_size can be stored in 'struct dm_io',
>>> the cloned bio can be avoided, but code may become not readable as
>>> before.
>>
>> The BIO op would be needed too for remapping zone append to regular writes
>> when zone append emulation is enabled. That is actually why
>> dm_zone_map_bio() needs the original BIO, to have the unmodified BIO op
>> since the clone op may not be the same.
> 
> clone inherits the original bio's op. I meant to store the
> real bio from FS as ->orig_bio always in alloc_io(), and simply trim it in case
> of split & re-submission, meantime store orig_bio's ->bi_sector & ->size into
> 'dm_io' for account purpose. But it looks a bit complicated and messy.

Indeed.

> Wrt. dm zone, I'd suggest to double check anywhere orig bio is used,
> since only part of orig bio may be mapped in case of splitting, which is
> actually post-split.
> 
> If bio split won't happen for dm-zone, your patch is fine. But I guess
> it isn't true for dm-zone.

Zone append operations can never be split. That is checked before a user
bio reaches DM __map_bio()/dm_zone_map_bio(). So I think that there is no
issue with the clone+trim change since that will never be done for a zone
append operation.

In the case of emulated zone append, regular writes will still go through
the dm_zone_map_bio() function, and these writes may be split. But then
the orig_bio does not really matter in that case and the zone write
pointer tracking relies on the clone sector & size, not on the original BIO.

I will run more tests with this patch. But so far, this seems all OK.

>> So I think this fix+cleanup as is is good for now. Will you send a proper
>> patch ?
> 
> Not yet, the fix+cleanup patch actually breaks recent dm io polling, and I
> don't figure out one solution yet.

OK. Let me know if you need help testing.


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


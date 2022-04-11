Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF1DC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 23:33:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-TfMzlKXPMzyEmc5dD3LQSg-1; Mon, 11 Apr 2022 19:33:44 -0400
X-MC-Unique: TfMzlKXPMzyEmc5dD3LQSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73A3B8001EA;
	Mon, 11 Apr 2022 23:33:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1F60E2166B41;
	Mon, 11 Apr 2022 23:33:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B36351949762;
	Mon, 11 Apr 2022 23:33:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EEE11947BBF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 23:33:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BD69111D78B; Mon, 11 Apr 2022 23:33:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2779A111D78A
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 23:33:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 006BE1C068C0
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 23:33:26 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-AENQEqnIMXibadojJllFbg-2; Mon, 11 Apr 2022 19:33:24 -0400
X-MC-Unique: AENQEqnIMXibadojJllFbg-2
X-IronPort-AV: E=Sophos;i="5.90,252,1643644800"; d="scan'208";a="301852075"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 12 Apr 2022 07:33:07 +0800
IronPort-SDR: zzKlPZSzw3e4RWBLEJx2HFdDQ6dBp/l1SS0cLV+bbiGzIUneZj2JV3XqerxzyX+vTP2vOl6pIb
 lhetDPqejZ62XOv1/T8iSSEjXSzRSx38n9lkIZaicVkfJ6RsqizPReVBkT/NB2gS6iIdR6hjhr
 I4Zx0+aib2zC0XHBXdo49vyXerFg9/s6W/d/dnAvglCG3ldXLmtAnHHw8QqLfSdf64HRonaEdZ
 7waWwn3VxMRHpXsDaBS1OtXkc3IDT2J4LufX8dnoCisUEHFtYTYmnFEy0UN5kXRg8oaACiQ5HC
 y4L2oGlCuxa5gel/7y9hDMKQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 16:04:25 -0700
IronPort-SDR: 45a9uWnRDXDjOab5kVXzUsC4xLhM21yI0G9IfgLUH5/H2rIM4C+yxVD1o0jBgcXOB96cchy024
 iIIMCYJu2wP1VlYjxpUh8ur1S+QT6O2uRP6EoPtNMpI452ma7tiayTiT6NyqdIOqjWEp3NpMCI
 6tJyiHpjmty2p2S7JryzepC9mRnSeEGfM2oyZGSThvUY1vOPnEP/i6S+GDxVfzTWFH/T4Q5Bno
 uaPuS6c9QhXBZEBKXm09NrEthvqpRdQ+cSfh9NIOFizCZF35swj4JhYqtrZ2PmAThlFpCrMv2w
 cw0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 16:33:08 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KclXM5zRtz1SVnx
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 16:33:07 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id Od0V1GP-LqGH for <dm-devel@redhat.com>;
 Mon, 11 Apr 2022 16:33:07 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KclXL1nCyz1Rvlx;
 Mon, 11 Apr 2022 16:33:06 -0700 (PDT)
Message-ID: <869a7210-a0f0-4aae-3e90-cdfe30a72434@opensource.wdc.com>
Date: Tue, 12 Apr 2022 08:33:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Ming Lei <ming.lei@redhat.com>
References: <20220408171254.935171-1-ming.lei@redhat.com>
 <20220408171254.935171-2-ming.lei@redhat.com>
 <8b9078c2-7884-a5b5-5aa9-ad284b4068ef@opensource.wdc.com>
 <YlN4BC2qbGODxbVz@T590>
 <95d8a8ed-27f8-0d88-a543-16910dca83e3@opensource.wdc.com>
 <YlN+plgvwZQdPBGj@T590>
 <7ccf1709-8aec-18c3-1d09-fe03b4a57017@opensource.wdc.com>
 <6b617a59-1591-8323-9de8-b39247eb328f@opensource.wdc.com>
 <YlPZ7vSZGMZBaRDv@T590>
 <54279bbe-6e8b-2c0a-90fc-825b89863b3f@opensource.wdc.com>
 <YlQ4na/HwBSm5C3U@T590>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YlQ4na/HwBSm5C3U@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/22 23:18, Ming Lei wrote:
>>>> This fixes the issue:
>>>>
>>>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>>> index 3c5fad7c4ee6..3dd6735450c5 100644
>>>> --- a/drivers/md/dm.c
>>>> +++ b/drivers/md/dm.c
>>>> @@ -581,7 +581,7 @@ static struct dm_io *alloc_io(struct mapped_device
>>>> *md, struct bio *bio)
>>>>         io->status = 0;
>>>>         atomic_set(&io->io_count, 1);
>>>>         this_cpu_inc(*md->pending_io);
>>>> -       io->orig_bio = NULL;
>>>> +       io->orig_bio = bio;
>>>>         io->md = md;
>>>>         io->map_task = current;
>>>>         spin_lock_init(&io->lock);
>>>>
>>>> Otherwise, the dm-zone.c code sees a NULL orig_bio.
>>>> However, this change may be messing up the bio accounting. Need to check that.
>>>
>>> Looks it is one recent regression since:
>>>
>>> commit 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface")
>>
>> Yep, saw that. Problem is, I really do not understand that change setting
>> io->orig_bio *after* __map_bio() is called. It seems that the accounting
>> is done on each fragment of the orig_bio instead of once for the entire
>> BIO... So my "fix" above seems wrong. Apart from passing along orig_bio as
>> an argument to  __map_bio() from __split_and_process_bio(), I do not think
>> my change is correct. Thoughts ?
> 
> Frankly speaking, both changing ->orig_bio after split and setting ->orig_bio
> after ->map() looks ugly & tricky, and the following change should avoid the
> issue, meantime simplify dm accounting a bit:
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3c5fad7c4ee6..f1fe83113608 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -581,7 +581,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
>  	io->status = 0;
>  	atomic_set(&io->io_count, 1);
>  	this_cpu_inc(*md->pending_io);
> -	io->orig_bio = NULL;
> +	io->orig_bio = bio;
>  	io->md = md;
>  	io->map_task = current;
>  	spin_lock_init(&io->lock);
> @@ -1223,19 +1223,11 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
>  	 * Account io->origin_bio to DM dev on behalf of target
>  	 * that took ownership of IO with DM_MAPIO_SUBMITTED.
>  	 */
> -	if (io->map_task == current) {
> +	if (io->map_task == current)
>  		/* Still in target's map function */
>  		dm_io_set_flag(io, DM_IO_START_ACCT);
> -	} else {
> -		/*
> -		 * Called by another thread, managed by DM target,
> -		 * wait for dm_split_and_process_bio() to store
> -		 * io->orig_bio
> -		 */
> -		while (unlikely(!smp_load_acquire(&io->orig_bio)))
> -			msleep(1);
> +	else

Curly brackets around the else here.

>  		dm_start_io_acct(io, clone);
> -	}
>  
>  	__dm_submit_bio_remap(tgt_clone, disk_devt(io->md->disk),
>  			      tio->old_sector);
> @@ -1562,7 +1554,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>  				     struct dm_table *map, struct bio *bio)
>  {
>  	struct clone_info ci;
> -	struct bio *orig_bio = NULL;
> +	struct bio *new_bio = NULL;
>  	int error = 0;
>  
>  	init_clone_info(&ci, md, map, bio);
> @@ -1578,22 +1570,14 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>  	if (error || !ci.sector_count)
>  		goto out;
>  
> -	/*
> -	 * Remainder must be passed to submit_bio_noacct() so it gets handled
> -	 * *after* bios already submitted have been completely processed.
> -	 * We take a clone of the original to store in ci.io->orig_bio to be
> -	 * used by dm_end_io_acct() and for dm_io_complete() to use for
> -	 * completion handling.
> -	 */

This comment should remain with some adjustment.

> -	orig_bio = bio_split(bio, bio_sectors(bio) - ci.sector_count,
> -			     GFP_NOIO, &md->queue->bio_split);
> -	bio_chain(orig_bio, bio);
> -	trace_block_split(orig_bio, bio->bi_iter.bi_sector);
> -	submit_bio_noacct(bio);
> +	new_bio = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
> +			&md->queue->bio_split);

Why not keep using bio_split() ?

> +	bio_trim(new_bio, bio_sectors(bio) - ci.sector_count, ci.sector_count);
> +	bio_trim(bio, 0, bio_sectors(bio) - ci.sector_count);
> +	bio_chain(new_bio, bio);
> +	trace_block_split(new_bio, new_bio->bi_iter.bi_sector);
> +	submit_bio_noacct(new_bio);
>  out:
> -	if (!orig_bio)
> -		orig_bio = bio;
> -	smp_store_release(&ci.io->orig_bio, orig_bio);
>  	if (dm_io_flagged(ci.io, DM_IO_START_ACCT))
>  		dm_start_io_acct(ci.io, NULL);

I tested this and it works. Need to check the accounting though.
And I agree this is a lot cleaner :)

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F972C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 14:20:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7654F64DE2
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 14:20:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7654F64DE2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-fnBTv2RhOymbfXKXZJhopg-1; Thu, 11 Feb 2021 09:20:15 -0500
X-MC-Unique: fnBTv2RhOymbfXKXZJhopg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81166195D560;
	Thu, 11 Feb 2021 14:20:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED6A270959;
	Thu, 11 Feb 2021 14:20:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C8FFB4E58E;
	Thu, 11 Feb 2021 14:20:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BEK1qR008135 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 09:20:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2BB1AF8093; Thu, 11 Feb 2021 14:20:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25A0BF808E
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 14:19:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AB928032E5
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 14:19:58 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
	[209.85.218.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-6-g2J6FO-aN3-vhmI4rgtJMg-1; Thu, 11 Feb 2021 09:19:55 -0500
X-MC-Unique: g2J6FO-aN3-vhmI4rgtJMg-1
Received: by mail-ej1-f51.google.com with SMTP id sa23so10352150ejb.0
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 06:19:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=qpZf9jSrCDpGIvjj911kEoqcHgLHuVMeFFODajp0dW4=;
	b=f3rx0dpRvWZ8LErghhk2WSIm0A+oJCBkifchdHiNOfiMYoS5qUr+YGhtvq4X9q3JGy
	TIR7sB0ljkyCL/Pj0nbUnUMKheIr3tZHaKB1OXTrlhoihzjxciIynIVigHtZYXzDPMNj
	BiTsnshOTl4Fn16c2FaaTG8WGcM3icja4vcLtTverSFHxO3VRvC0uI8z5nMmE2KtLbrB
	MVsyC5LamHeO33fg0mJk4zd7ePCQR1fosiqqFGuvFqGh9HRK4YeG0cLMn58OtTG78SMH
	8Hzyv2bayXUBYTFu9P/+m6Z3I3qHOMY55i7LtiGy+jo5Il21hVZzw3lgM2L85qTlPRsx
	lNeA==
X-Gm-Message-State: AOAM531SWCV1dKJ9/8ffqyYaOlf/x/gzUsIZRy72gInjoKunGpVkFW0X
	eloC+WupUxo6UCOqQNGnN0CRuA==
X-Google-Smtp-Source: ABdhPJyFL2YkEw08E+DFuRrQL3QcMwPtnPaFrgXp3eo5j1mciVZYchcUBaZhUa8fYiwtGqCeIH/dYQ==
X-Received: by 2002:a17:906:cf89:: with SMTP id
	um9mr8780833ejb.189.1613053193851; 
	Thu, 11 Feb 2021 06:19:53 -0800 (PST)
Received: from [172.16.10.100] (193.92.71.108.dsl.dyn.forthnet.gr.
	[193.92.71.108])
	by smtp.gmail.com with ESMTPSA id g3sm4474419ejz.91.2021.02.11.06.19.52
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 11 Feb 2021 06:19:53 -0800 (PST)
To: Mike Snitzer <snitzer@redhat.com>
References: <20210122152556.24822-1-ntsironis@arrikto.com>
	<20210122152556.24822-5-ntsironis@arrikto.com>
	<20210210181205.GA7904@redhat.com> <20210210184842.GA6689@lobo>
From: Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <6dcd961a-23a8-2612-5040-c916089b8e39@arrikto.com>
Date: Thu, 11 Feb 2021 16:19:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210210184842.GA6689@lobo>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 4/4] dm era: Remove unreachable resize
 operation in pre-resume function
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 2/10/21 8:48 PM, Mike Snitzer wrote:
> On Wed, Feb 10 2021 at  1:12P -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Fri, Jan 22 2021 at 10:25am -0500,
>> Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>
>>> The device metadata are resized in era_ctr(), so the metadata resize
>>> operation in era_preresume() never runs.
>>>
>>> Also, note, that if the operation did ever run it would deadlock, since
>>> the worker has not been started at this point.
> 
> It wouldn't have deadlocked, it'd have queued the work (see wake_worker)
> 

Hi Mike,

The resize is performed as an RPC and in_worker1() ends up calling
perform_rpc(). perform_rpc() calls wake_worker() and then waits for the
RPC to complete: wait_for_completion(&rpc->complete). So, start_worker()
is not called until after the RPC has been completed.

But, you are right, it won't deadlock. I was confused by wake_worker:

   static void wake_worker(struct era *era)
   {
           if (!atomic_read(&era->suspended))
                   queue_work(era->wq, &era->worker);
   }

When we suspend the device we set era->suspended to 1, so I mistakenly
thought that the resize operation during preresume would deadlock,
because wake_worker wouldn't queue the work.

But, the resize is only triggered when loading a new table, which
creates a new target by calling era_ctr. There era->suspended is
indirectly initialized to 0, because of kzalloc.

So, wake_worker will indeed queue the work.

>>>
>>> Fixes: eec40579d84873 ("dm: add era target")
>>> Cc: stable@vger.kernel.org # v3.15+
>>> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
>>> ---
>>>   drivers/md/dm-era-target.c | 9 ---------
>>>   1 file changed, 9 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
>>> index 104fb110cd4e..c40e132e50cd 100644
>>> --- a/drivers/md/dm-era-target.c
>>> +++ b/drivers/md/dm-era-target.c
>>> @@ -1567,15 +1567,6 @@ static int era_preresume(struct dm_target *ti)
>>>   {
>>>   	int r;
>>>   	struct era *era = ti->private;
>>> -	dm_block_t new_size = calc_nr_blocks(era);
>>> -
>>> -	if (era->nr_blocks != new_size) {
>>> -		r = in_worker1(era, metadata_resize, &new_size);
>>> -		if (r)
>>> -			return r;
>>> -
>>> -		era->nr_blocks = new_size;
>>> -	}
>>>   
>>>   	start_worker(era);
>>>   
>>> -- 
>>> 2.11.0
>>>
>>
>> Resize shouldn't actually happen in the ctr.  The ctr loads a temporary
>> (inactive) table that will only become active upon resume.  That is why
>> resize should always be done in terms of resume.
>>

I kept the resize in the ctr to maintain the original behavior of
dm-era.

But, I had missed what you are describing here, which indeed makes sense
and it's the correct thing to do.

Thanks a lot for explaining it.

>> I'll look closer but ctr shouldn't do the actual resize, and the
>> start_worker() should be moved above the resize code you've removed
>> above.
> 
> Does this work for you?  If so I'll get it staged (like I've just
> staged all your other dm-era fixes for 5.12).
> 

The patch you attach won't work as is. We can't perform the resize in
the worker, because the worker might run other metadata operations,
e.g., it could start digestion, before resizing the metadata. These
operations will end up using the old size.

This can lead to errors:

1. Create a 1GiB dm-era device

    # dmsetup create eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"

2. Write to a block

    # dd if=/dev/zero of=/dev/mapper/eradev oflag=direct bs=4M count=1 seek=200

3. Suspend the device

    # dmsetup suspend eradev

4. Load a new table reducing the size of the device, so it doesn't
    include the block written at step (2)

    # dmsetup load eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"

5. Resume the device

    # dmsetup resume eradev

In dmesg we see the following:

    device-mapper: era: metadata_digest_transcribe_writeset: dm_array_set_value failed
    device-mapper: era: process_old_eras: digest step failed, stopping digestion

The reason is that the worker started the digestion of the archived
writeset using the old, larger size.

As a result, metadata_digest_transcribe_writeset tried to write beyond
the end of the era array.

Instead, we have to resize the metadata directly in era_preresume, and
not use the worker to do it.

I prepared a new patch doing that, which I will send with a new mail.

Nikos.

>   drivers/md/dm-era-target.c | 13 ++-----------
>   1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> index d0e75fd31c1e..ec198e9cdafb 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c
> @@ -1501,15 +1501,6 @@ static int era_ctr(struct dm_target *ti, unsigned argc, char **argv)
>   	}
>   	era->md = md;
>   
> -	era->nr_blocks = calc_nr_blocks(era);
> -
> -	r = metadata_resize(era->md, &era->nr_blocks);
> -	if (r) {
> -		ti->error = "couldn't resize metadata";
> -		era_destroy(era);
> -		return -ENOMEM;
> -	}
> -
>   	era->wq = alloc_ordered_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM);
>   	if (!era->wq) {
>   		ti->error = "could not create workqueue for metadata object";
> @@ -1583,6 +1574,8 @@ static int era_preresume(struct dm_target *ti)
>   	struct era *era = ti->private;
>   	dm_block_t new_size = calc_nr_blocks(era);
>   
> +	start_worker(era);
> +
>   	if (era->nr_blocks != new_size) {
>   		r = in_worker1(era, metadata_resize, &new_size);
>   		if (r)
> @@ -1591,8 +1584,6 @@ static int era_preresume(struct dm_target *ti)
>   		era->nr_blocks = new_size;
>   	}
>   
> -	start_worker(era);
> -
>   	r = in_worker0(era, metadata_era_rollover);
>   	if (r) {
>   		DMERR("%s: metadata_era_rollover failed", __func__);
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


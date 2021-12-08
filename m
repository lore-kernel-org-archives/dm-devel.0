Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B53C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  8 Dec 2021 20:10:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-0ilL7cDgM7eFkmnJ9jp9Dg-1; Wed, 08 Dec 2021 15:10:48 -0500
X-MC-Unique: 0ilL7cDgM7eFkmnJ9jp9Dg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 245461006AA9;
	Wed,  8 Dec 2021 20:10:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3150218369;
	Wed,  8 Dec 2021 20:10:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 983AB1809CB8;
	Wed,  8 Dec 2021 20:10:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B8KAbp5024496 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 8 Dec 2021 15:10:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D2656401471; Wed,  8 Dec 2021 20:10:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CEBB9401E21
	for <dm-devel@redhat.com>; Wed,  8 Dec 2021 20:10:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B142285A5AA
	for <dm-devel@redhat.com>; Wed,  8 Dec 2021 20:10:37 +0000 (UTC)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
	[209.85.221.54]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-94-0J4poJ72MzKBRty8kmOcaw-1; Wed, 08 Dec 2021 15:10:36 -0500
X-MC-Unique: 0J4poJ72MzKBRty8kmOcaw-1
Received: by mail-wr1-f54.google.com with SMTP id a9so6041327wrr.8
	for <dm-devel@redhat.com>; Wed, 08 Dec 2021 12:10:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=W2C8tovnq+LxMP7lEnuzA6dTdYMVQ3i1W+cFrUxPPxU=;
	b=RH6zWSdR3YuaiwF0Q3OP0o3Jg22qO1mKWTAmFtLA5R6DqJefrL2NT1LoN4Mo2PB7jn
	v+2VwyWfG7TDSI8r8zzwsSpbHv7+Hr2GMNxpsSLzuXUs9UUaFDQBZ8dCxw+VOwnD1AGP
	XBQhXurPNSD4b57UySl7fcG/KOPPKxM7vb6PGvOpamjlQ3nVIMtybvNviZQCvQeqFE4f
	CQLIvB+x8F0BstbnEvB/dqlye1lYcaRUzAmaRkPZXAAQt9Wt1ZfrdwrBXbEj5M7V2IyO
	93py3kSars8ZosmHXSBddK+PX+AcUuhev3S999Y96Abc4POSV29HEYyD9/lLKvh+xN1T
	JYkw==
X-Gm-Message-State: AOAM530eX0b4o0v2HSlSEylR+PmfrhLTVBgXnCIaDnKTsE/4v1uu9YrK
	MSIG13Yr6nyHlGkHwMijrBpXKm2kiXwPJA==
X-Google-Smtp-Source: ABdhPJz9mKQh2LlRFpwOlR0qzpUV3r/I2in1LsfMTcj7sHZDKr9GaOTxTPDNNTEEi3pn1uv6zjjEkw==
X-Received: by 2002:a5d:68c1:: with SMTP id p1mr933977wrw.585.1638994233983;
	Wed, 08 Dec 2021 12:10:33 -0800 (PST)
Received: from [172.16.10.100] (130.43.23.167.dsl.dyn.forthnet.gr.
	[130.43.23.167]) by smtp.gmail.com with ESMTPSA id
	a10sm6689827wmq.27.2021.12.08.12.10.32
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 08 Dec 2021 12:10:33 -0800 (PST)
To: Zdenek Kabelac <zkabelac@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
References: <1127b165-f886-e3cf-061d-141fa7fb7d97@arrikto.com>
	<5ccbac2c-8eb8-3e57-3cb3-8f85038d4e01@redhat.com>
	<1e508a1a-0ba4-0ef2-c660-0c522907ced0@arrikto.com>
	<7ff5dfca-bebb-4647-212d-3dd3aec678b9@redhat.com>
From: Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <d8624717-7371-2c98-3eb7-1fe1d9e80595@arrikto.com>
Date: Wed, 8 Dec 2021 22:10:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7ff5dfca-bebb-4647-212d-3dd3aec678b9@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] Deadlock when swapping a table with a dm-era target
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/3/21 6:00 PM, Zdenek Kabelac wrote:
> Dne 03. 12. 21 v 15:42 Nikos Tsironis napsal(a):
>> On 12/2/21 5:41 PM, Zdenek Kabelac wrote:
>>> Dne 01. 12. 21 v 18:07 Nikos Tsironis napsal(a):
>>>> Hello,
>>>>
>>>> Under certain conditions, swapping a table, that includes a dm-era
>>>> target, with a new table, causes a deadlock.
>>>>
>>>> This happens when a status (STATUSTYPE_INFO) or message IOCTL is blocked
>>>> in the suspended dm-era target.
>>>>
>>>> dm-era executes all metadata operations in a worker thread, which stops
>>>> processing requests when the target is suspended, and resumes again when
>>>> the target is resumed.
>>>>
>>>> So, running 'dmsetup status' or 'dmsetup message' for a suspended dm-era
>>>> device blocks, until the device is resumed.
>>>>
>> Hi Zdenek,
>>
>> Thanks for the feedback. There doesn't seem to be any documentation
>> mentioning that loading the new table should happen before suspend, so
>> thanks a lot for explaining it.
>>
>> Unfortunately, this isn't what causes the deadlock. The following
>> sequence, which loads the table before suspend, also results in a
>> deadlock:
>>
>> 1. Create device with dm-era target
>>
>>    # dmsetup create eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"
>>
>> 2. Load new table to device, e.g., to resize the device
>>
>>    # dmsetup load eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"
>>
>> 3. Suspend the device
>>
>>    # dmsetup suspend eradev
>>
>> 4. Retrieve the status of the device. This blocks for the reasons I
>>    explained in my previous email.
>>
>>    # dmsetup status eradev
> 
> 
> Hi
> 
> Querying 'status' while the device is suspend is the next issue you need to fix in your workflow.
> 

Hi,

These steps are not my exact workflow. It's just a series of steps to
easily reproduce the bug.

I am not the one retrieving the status of the suspended device. LVM is.
LVM, when running commands like 'lvs' and 'vgs', retrieves the status of
the devices on the system using the DM_TABLE_STATUS ioctl.

LVM indeed uses the DM_NOFLUSH_FLAG, but this doesn't make a difference
for dm-era, since it doesn't check for this flag.

So, for example, a user or a monitoring daemon running an LVM command,
like 'vgs', at the "wrong" time triggers the bug:

1. Create device with dm-era target

    # dmsetup create eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"

2. Load new table to device, e.g., to resize the device

    # dmsetup load eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"

3. Suspend the device

    # dmsetup suspend eradev

4. Someone, e.g., a user or a monitoring daemon, runs an LVM command at
    this point, e.g. 'vgs'.

5. 'vgs' tries to retrieve the status of the dm-era device using the
    DM_TABLE_STATUS ioctl, and blocks.

6. Resume the device: This deadlocks.

    # dmsetup resume eradev

So, I can't change something in my workflow to prevent the bug. It's a
race that happens when someone runs an LVM command at the "wrong" time.

I am aware that using an appropriate LVM 'global_filter' can prevent
this, but:

1. This is just a workaround, not a proper solution.
2. This is not always an option. Imagine someone running an LVM command
    in a container, for example. Or, we may not be allowed to change the
    LVM configuration of the host at all.

> Normally 'status' operation may need to flush queued IO operations to get accurate data.
> 
> So you should query states before you start to mess with tables.
> 
> If you want to get 'status' without flushing - use:   'dmsetup status --noflush'.
> 

I am aware of that, and of the '--noflush' flag.

But, note, that:

1. As I have already explained in my previous emails, the reason of the
    deadlock is not I/O related.
2. dm-era doesn't check for this flag, so using it doesn't make a
    difference.
3. Other targets, e.g., dm-thin and dm-cache, that check for this flag,
    also check _explicitly_ if the device is suspended, before committing
    their metadata to get accurate statistics. They don't just rely on
    the user to use the '--noflush' flag.

That said, fixing 'era_status()' to check for the 'noflush' flag and to
check if the device is suspended, could be a possible fix, which I have
already proposed in my first email.

Although, as I have already explained, it's not a simple matter of not
committing metadata when the 'noflush' flag is used, or the device is
suspended.

dm-era queues the status operation (as well as all operations that touch
the metadata) for execution by a worker thread, to avoid using locks for
accessing the metadata.

When the target is suspended this thread doesn't execute operations, so
the 'table_status()' call blocks, holding the SRCU read lock of the
device (md->io_barrier), until the target is resumed.

But, 'table_status()' _never_ unblocks if you resume the device with a
new table preloaded. Instead, the resume operation ('dm_swap_table()')
deadlocks waiting for 'table_status()' to drop the SRCU read lock.

This never happens, and the only way to recover is to reboot.

> 
>> 5. Resume the device. This deadlocks for the reasons I explained in my
>>    previous email.
>>
>>    # dmsetup resume eradev
>>
>> 6. The dmesg logs are the same as the ones I included in my previous
>>    email.
>>
>> I have explained the reasons for the deadlock in my previous email, but
>> I would be more than happy to discuss them more.
>>
> 
> There is no bug - if your only problem is 'stuck'  status while you have devices in suspended state.
> 

As I explained previously, my problem is not 'stuck' status while the
device is suspended.

The issue is that if the suspended dm-era device has a new table
preloaded, the 'stuck' status results in 'stuck' resume.

And the only way to recover is by rebooting.

> You should NOT be doing basically anything while being suspend!!
> 

The documentation of the writecache target
(https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/writecache.html)
states that the following is the proper sequence for removing the cache
device:

1. send the "flush_on_suspend" message
2. load an inactive table with a linear target that maps to the
    underlying device
3. suspend the device
4. ask for status and verify that there are no errors
5. resume the device, so that it will use the linear target
6. the cache device is now inactive and it can be deleted

The above sequence, except from step 1 that is not applicable to dm-era,
is exactly the sequence of steps that triggers the bug for dm-era.

These steps, if run for dm-era, cause a deadlock.

So, although I understand your point about not doing anything with a
suspended device, it seems that this sequence of steps is not wrong, and
it is actually recommended by the writecache documentation.

Still, as I mentioned, I am not explicitly running the 'status'
operation on the suspended dm-era device. It's a race with LVM, which
runs it implicitly when running commands such as 'vgs' or 'lvs'.

> i.e. imagine you suspend 'swap' device and while you are in suspened state kernel decides to swap memory pages - so you get instantly frozen here.
> 
> For this reason lvm2 while doing  'suspend/resume' sequance preallocates all memory in front of this operation - does very minimal set of operation between suspend/resume to minimize also latencies and so on.
> 
> Clearly if you suspend just some 'supportive'  disk of yours - you likely are no in danger of blocking your swap - but the 'status --noflush' logic still applies.
> 

I get what you are describing about a 'swap' device, and I agree
completely.

But, this is not what happens in the case of dm-era.

Regards,
Nikos.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


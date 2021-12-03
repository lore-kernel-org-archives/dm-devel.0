Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C69E2C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 14:45:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-fNWYo53wNlWuIpyMDXz-gg-1; Fri, 03 Dec 2021 09:45:12 -0500
X-MC-Unique: fNWYo53wNlWuIpyMDXz-gg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D654C80D680;
	Fri,  3 Dec 2021 14:45:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC5F84ABAD;
	Fri,  3 Dec 2021 14:45:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EB3551809CB8;
	Fri,  3 Dec 2021 14:44:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B3EghKh028549 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Dec 2021 09:42:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EC993401E3D; Fri,  3 Dec 2021 14:42:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E90CA401E3C
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 14:42:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D090D185A7BA
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 14:42:42 +0000 (UTC)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
	[209.85.221.42]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-604-Z-sHVetWPE-y-NL2owNXbA-1; Fri, 03 Dec 2021 09:42:41 -0500
X-MC-Unique: Z-sHVetWPE-y-NL2owNXbA-1
Received: by mail-wr1-f42.google.com with SMTP id q3so6185968wru.5
	for <dm-devel@redhat.com>; Fri, 03 Dec 2021 06:42:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=XPywC2L8l2Q9HOtQkaojwKig+azcHTnULwUr6FEeK0I=;
	b=PISZCYkm0GWgrYyistX7jegeMGDaiKMHTVjhgh+a9QCBgFikE40Ejhfb63H4gIU2Tf
	gqYMY0V4aMsH2tvBXNfij88kiX16dlcz5QxjX9EYi5EjU7LfXS7aYl2nPrukGl9OOsSL
	hLZgf2B7JAHLXaC2i+LPHd8b8IxXeAeWWzW17Hn18mFTcpnmThRDxCdr9LMfLdlj9gvN
	7bVpCFr5A243/VcKXqnhMRPklrfVSRWtP1y7cGk6ZXR+vjOK1pSzT+wr9QAcU911sJ4a
	9gFogxHvqNvB/qbQKp5IkASiQniOh46JcSDi9pF9BRMN6Gw7wPUtPKUJ3RTQo1qyUQEK
	RZag==
X-Gm-Message-State: AOAM5330XTxq3nbgGfv1X+SaAxTKpCZFJX/zNZzT2Rh6GEyT2/fMHTXl
	4KaeFrRT2Bog1NJS2Gkx8Yolx9H4+jLs5w==
X-Google-Smtp-Source: ABdhPJzvSug74bBnj+SbUxae1reA8wLeRGC2uq6I8gzRmEUnjc+CUMdOjs79Dv0sNqR/bTo+yS3ofg==
X-Received: by 2002:adf:82f7:: with SMTP id 110mr22422906wrc.111.1638542559269;
	Fri, 03 Dec 2021 06:42:39 -0800 (PST)
Received: from [172.16.10.100] (62.1.222.48.dsl.dyn.forthnet.gr. [62.1.222.48])
	by smtp.gmail.com with ESMTPSA id
	138sm5369148wma.17.2021.12.03.06.42.37
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 03 Dec 2021 06:42:38 -0800 (PST)
To: Zdenek Kabelac <zkabelac@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
References: <1127b165-f886-e3cf-061d-141fa7fb7d97@arrikto.com>
	<5ccbac2c-8eb8-3e57-3cb3-8f85038d4e01@redhat.com>
From: Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <1e508a1a-0ba4-0ef2-c660-0c522907ced0@arrikto.com>
Date: Fri, 3 Dec 2021 16:42:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5ccbac2c-8eb8-3e57-3cb3-8f85038d4e01@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/2/21 5:41 PM, Zdenek Kabelac wrote:
> Dne 01. 12. 21 v 18:07 Nikos Tsironis napsal(a):
>> Hello,
>>
>> Under certain conditions, swapping a table, that includes a dm-era
>> target, with a new table, causes a deadlock.
>>
>> This happens when a status (STATUSTYPE_INFO) or message IOCTL is blocked
>> in the suspended dm-era target.
>>
>> dm-era executes all metadata operations in a worker thread, which stops
>> processing requests when the target is suspended, and resumes again when
>> the target is resumed.
>>
>> So, running 'dmsetup status' or 'dmsetup message' for a suspended dm-era
>> device blocks, until the device is resumed.
>>
>> This seems to be a problem on its own.
>>
>> If we then load a new table to the device, while the aforementioned
>> dmsetup command is blocked in dm-era, and resume the device, we
>> deadlock.
>>
>> The problem is that the 'dmsetup status' and 'dmsetup message' commands
>> hold a reference to the live table, i.e., they hold an SRCU read lock on
>> md->io_barrier, while they are blocked.
>>
>> When the device is resumed, the old table is replaced with the new one
>> by dm_swap_table(), which ends up calling synchronize_srcu() on
>> md->io_barrier.
>>
>> Since the blocked dmsetup command is holding the SRCU read lock, and the
>> old table is never resumed, 'dmsetup resume' blocks too, and we have a
>> deadlock.
>>
>> Steps to reproduce:
>>
>> 1. Create device with dm-era target
>>
>>    # dmsetup create eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"
>>
>> 2. Suspend the device
>>
>>    # dmsetup suspend eradev
>>
>> 3. Load new table to device, e.g., to resize the device
>>
>>    # dmsetup load eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"
>>
> 
> Your sequence is faulty - you must always preload  new table before suspend.
> 
> Suspend&Resume should be absolutely minimal in its timing.
> 
> Also nothing should be allocating memory in suspend so that's why suspend has to be used after table line is fully loaded.
> 

Hi Zdenek,

Thanks for the feedback. There doesn't seem to be any documentation
mentioning that loading the new table should happen before suspend, so
thanks a lot for explaining it.

Unfortunately, this isn't what causes the deadlock. The following
sequence, which loads the table before suspend, also results in a
deadlock:

1. Create device with dm-era target

    # dmsetup create eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"

2. Load new table to device, e.g., to resize the device

    # dmsetup load eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"

3. Suspend the device

    # dmsetup suspend eradev

4. Retrieve the status of the device. This blocks for the reasons I
    explained in my previous email.

    # dmsetup status eradev

5. Resume the device. This deadlocks for the reasons I explained in my
    previous email.

    # dmsetup resume eradev

6. The dmesg logs are the same as the ones I included in my previous
    email.

I have explained the reasons for the deadlock in my previous email, but
I would be more than happy to discuss them more.

I would also like your feedback on the solutions I proposed there, so I
can work on a fix.

Thanks,
Nikos.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


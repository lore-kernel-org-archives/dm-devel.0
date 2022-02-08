Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05CC5C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 21:31:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-TSBBkbTROuWHXA-9sGKdBg-1; Tue, 08 Feb 2022 16:31:14 -0500
X-MC-Unique: TSBBkbTROuWHXA-9sGKdBg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12D5D189DF41;
	Tue,  8 Feb 2022 21:31:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBAEA6AB9F;
	Tue,  8 Feb 2022 21:31:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8BF5C4BB7C;
	Tue,  8 Feb 2022 21:31:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 218LUfY7003175 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Feb 2022 16:30:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6403E53DB; Tue,  8 Feb 2022 21:30:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F6DE53DA
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 21:30:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4982185A7A4
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 21:30:29 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
	[209.85.218.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-424-3oaojmE1OAGtVQw5uz5BwQ-1; Tue, 08 Feb 2022 16:30:28 -0500
X-MC-Unique: 3oaojmE1OAGtVQw5uz5BwQ-1
Received: by mail-ej1-f51.google.com with SMTP id k25so1478504ejp.5;
	Tue, 08 Feb 2022 13:30:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=t4B1ZX+gk3XXBYXo4MbrPRSmJlAdBTOlRsRMieGh2K8=;
	b=Q28tz4ejsCRpaV9S5R/w3L/aPd2vx0I7zF+0hR+jB4ghV59HMmLEhy74j9gy+boGPZ
	6DiN7yodm0fVcdvWZGG4ElPMdA1AbuYYrEyznRsqAXaorSKKz1HYaUweIinRQauQ4kW6
	SJaG5CeESeafkYdtwiGZxV4AGnqBqDkgFaRgQuHMkrStY6j1XzTbEwLl66wHL65uI8CI
	2dTyJXGQgffEibXDakYY2POz6cZovTG0XR9WGOYWc9/DuSj+/uJcwUIN6LFbQWHx51ar
	Qm8eeGMbJeokM47nmX5fUysqm/p8FQgs6Vim3zGqv3g5P41JzuA1UXb9uC0g85bhoEmD
	BsTA==
X-Gm-Message-State: AOAM531aKcx1mhSwNymrQq7ut6eKWcl158AtSkyU71ZT6xHZwe0r3GT9
	7JX2Z2uGT4rgzEmLggmv8fVN5UkVhghv5kZG
X-Google-Smtp-Source: ABdhPJwHeARc7by/J/2y8jpAavCM7Xoot4IEuguHV4aBlu/Zwgw0W5weDKU7wantNElR6fHUxZs97A==
X-Received: by 2002:a17:907:3d92:: with SMTP id
	he18mr5252979ejc.597.1644355826702; 
	Tue, 08 Feb 2022 13:30:26 -0800 (PST)
Received: from [192.168.0.99] ([83.148.32.207])
	by smtp.gmail.com with ESMTPSA id z4sm5266186ejd.39.2022.02.08.13.30.25
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 08 Feb 2022 13:30:26 -0800 (PST)
Message-ID: <fb00c57d-cf11-8632-bcdd-6b52826f212f@gmail.com>
Date: Tue, 8 Feb 2022 22:30:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Firefox/91.0 Thunderbird/91.4.0
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
	LVM general discussion and development <linux-lvm@redhat.com>,
	device-mapper development <dm-devel@redhat.com>
References: <YgK+Avj+VURDqo7j@itl-email>
	<9a14a7a5-a8a1-a4d6-f9fd-012d3c170f2a@gmail.com>
	<733f87f3-5ed9-b266-b951-4526f872bad1@invisiblethingslab.com>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <733f87f3-5ed9-b266-b951-4526f872bad1@invisiblethingslab.com>
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
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= <frederic.pierret@qubes-os.org>,
	=?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
	<marmarek@invisiblethingslab.com>
Subject: Re: [dm-devel] Thin pool performance when allocating lots of blocks
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dne 08. 02. 22 v 22:02 Demi Marie Obenour napsal(a):
> On 2/8/22 15:37, Zdenek Kabelac wrote:
>> Dne 08. 02. 22 v 20:00 Demi Marie Obenour napsal(a):
>>> Are thin volumes (which start as snapshots of a blank volume) efficient
>>> for building virtual machine images?  Given the nature of this workload
>>> (writing to lots of new, possibly-small files, then copying data from
>>> them to a huge disk image), I expect that this will cause sharing to be
>>> broken many, many times, and the kernel code that breaks sharing appears
>>> to be rather heavyweight.  Furthermore, since zeroing is enabled, this
>>> might cause substantial write amplification.  Turning zeroing off is not
>>> an option for security reasons.
>>>
>>> Is there a way to determine if breaking sharing is the cause of
>>> performance problems?  If it is, are there any better solutions?
>>
>> Hi
>>
>> Usually the smaller the thin chunks size is the smaller the problem gets.
>> With current released version of thin-provisioning minimal chunk size is
>> 64KiB. So you can't use smaller value to further reduce this impact.
>>
>> Note - even if you do a lot of tiny 4KiB writes  - only the 'first' such write
>> into 64K area breaks sharing all following writes to same location no longer
>> have this penalty (also zeroing with 64K is less impactful...)
>>
>> But it's clear thin-provisioning comes with some price - so if it's not good
>> enough from time constrains some other solutions might need to be explored.
>> (i.e. caching, better hw, splitting  FS into multiple partitions with
>> 'read-only sections,....)
> 
> Are the code paths that break sharing as heavyweight as I was worried
> about?  Would a hypothetical dm-thin2 that used dm-bio-prison-v2 be
> faster?
> 

Biggest problem is the size of chunks - the smaller chunk you could use,
the less amplification you get. On the other hand the amount of metadata 
handling is increasing. Then there is a lot about parallelization, locking and 
disk synchronization.

If you are more interested in this topic, dive into kernel code.
Also I'd suggest to make some good benchmarking.

Regards

Zdenek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


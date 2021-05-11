Return-Path: <SRS0=DHxF=KG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E64C433ED
	for <dm-devel@archiver.kernel.org>; Tue, 11 May 2021 17:07:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 203BA6134F
	for <dm-devel@archiver.kernel.org>; Tue, 11 May 2021 17:07:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 203BA6134F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620752834;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UXxxIHJ63u2AYzpXdPHXlQbr4kdee2MLetCkVoPv2eo=;
	b=NE6BYbU7Bj38jvwqdo3zrspu/uEGxNiagi21pQ1zZdZYNbaMNO3AdmVix9bgrXZavFD1qQ
	YByNHt+FS9yI/+7lY3JZQ+z8vxF/HEWW5zVYHKqD9T9F1C+pFfVU2WDruJMPWscfJP5qVg
	i47GxL8S1Zy3ZNcrUA/t5U0H82qeYYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-JFSZ48L-NM6QHxx9qmRL0A-1; Tue, 11 May 2021 13:07:11 -0400
X-MC-Unique: JFSZ48L-NM6QHxx9qmRL0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1FE8801817;
	Tue, 11 May 2021 17:07:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06A672CE01;
	Tue, 11 May 2021 17:07:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 30E591800BB4;
	Tue, 11 May 2021 17:07:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14BH71oi017512 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 May 2021 13:07:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1A871201668C; Tue, 11 May 2021 17:07:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 16A87202BFA3
	for <dm-devel@redhat.com>; Tue, 11 May 2021 17:06:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1E78182BBC7
	for <dm-devel@redhat.com>; Tue, 11 May 2021 17:06:58 +0000 (UTC)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-220-zhxQzrFVMlWfY7dQJwvZ1w-1; Tue, 11 May 2021 13:06:56 -0400
X-MC-Unique: zhxQzrFVMlWfY7dQJwvZ1w-1
Received: by mail-wm1-f70.google.com with SMTP id
	d199-20020a1c1dd00000b02901492c14476eso897717wmd.2
	for <dm-devel@redhat.com>; Tue, 11 May 2021 10:06:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Xv1bwZ4yKaP18uEl3wowujPp7XBxyILWzx9IYZd0YjI=;
	b=fV59UvEnoVEeC1QGohVQrPCgmEGuq5Kx3gndiXsEdvz2PpEGHLpVrIbNgSqoRN7cwm
	by6MDNHxVOVIjALetIM9iYJT5jKVz2iuyvcR7N4qChpfRu2psjC/tAWTtGWuQskwXAzq
	l5Z/a3epryY9UVzUbqxahz3cJj4AJsW+ybs8ty+L9gVbGBX8zUHguOnrkmXveqrKFMpk
	GoISKE8yoX9rfGYTw57Dj1TT142ndMiNTFj+f/vu+kvMs0QtVZEvu0lVkcyXXBA3MgKj
	Xq+v27Z5gG5pUeRmzJYzMQcR6t5u1A4E9dTDoi5XhnYdPrbdjGgYxL7ibrAuH+nvdEKh
	RZ6A==
X-Gm-Message-State: AOAM533wBeh9inqsXc95a48Qsa9rMCsgzvY3kN0IJ/kpWgvBlFfyP/By
	9efxlNfGbIzMsAnYTqlTcB1jjz7Ld1MXsnfYR9nFRBa/5rnNQsq2zmqk01uh4Fn8ZsMTEcgzWUB
	P7vtIuXH6bJfT8zOTrBuvynVeDUIQEIjCNC7JpcyYpfyOhEU8pWFQHqA6i3EUsNQ=
X-Received: by 2002:adf:d227:: with SMTP id k7mr40324860wrh.390.1620752815582; 
	Tue, 11 May 2021 10:06:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxV8p8Nn4QU+x2tz9nFeKr6hmq9GXgLqfJ24uaoCqEn+DT0dn+HfSsOpB3mbl7RXer1zd2RwQ==
X-Received: by 2002:adf:d227:: with SMTP id k7mr40324826wrh.390.1620752815302; 
	Tue, 11 May 2021 10:06:55 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	h9sm24395609wmb.35.2021.05.11.10.06.53
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 11 May 2021 10:06:54 -0700 (PDT)
To: Melvin Vermeeren <vermeeren@vermwa.re>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<10258776.4TuPVb8Keo@verm-r4e>
	<alpine.LRH.2.02.2105051642300.32187@file01.intranet.prod.int.rdu2.redhat.com>
	<1647312.vWrHn5Hxal@verm-r4e>
From: Milan Broz <mbroz@redhat.com>
Message-ID: <26d4e0b9-329b-710e-3b93-82246d633ccb@redhat.com>
Date: Tue, 11 May 2021 19:06:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1647312.vWrHn5Hxal@verm-r4e>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2] dm-integrity: if we have discard support,
 use it when recalculating
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 05/05/2021 23:47, Melvin Vermeeren wrote:
> Hi,
> 
> On Wednesday, 5 May 2021 22:45:09 CEST Mikulas Patocka wrote:
>> So, we can ask Milan to update the manpage.
> 
> Yes, that would be fine. However, "integrity recalculate" sounds like 
> recalculating integrity. The newly implemented logic is more of a "integrity 
> wipe" or "integrity reset".
> 
> What is problematic is that actual functionality from end user point of view 
> is now completely different depending on if you use --allow-discards or not. 
> Without discard you recalculate meta, with discard you reset/wipe meta.
> 
>> It will receive integrity protection for the newly written data.
>>
>> If you create an integrity device and make a filesystem on it, the newly
>> written data matters. The old data that were on the filesystem before
>> formatting it don't care and don't need to be protected.

This is not true. Imagine blkid that tries to read various superblocks on disk
and do decisions based on it (UUID links etc). These can be in "unused" sectors.

In the normal situation dm-integrity stops the read, because checksum is wrong.
Now it seems that it returns these random data. This is not integrity protection at all.

Maybe I am missing something, but I would say this is a wrong behavior and it should
be reverted. I think this should be not supported even with additional switch,
to me is it really against the principle of sector-level integrity protection.

Also, I added wiping to integritysetup because some tools (like mkfs) actually
needef to read unitialized data before creating metadata - so without previous wipe it failed.
(These are bugs in the tools, obviously: I plan to report these  unfortunately it never happened.
Dunno if it is still the case.)

Sorry for the late reply.

Milan


> 
> One of the current possible use cases with --no-wipe --data-device is that you 
> can use existing device holding data that has no integrity and add integrity 
> to it with detached metadata device in combination with recalculate.
> 
> Then recalculation can be used in a fashion similar to trust-on-first-use for 
> this specific disk without rewriting the data meaning also no temporary copy 
> is needed. This feature is something I have used a few times as adding 
> integrity in-place can be useful in certain situations especially when dealing 
> with large amounts of data.
> 
> 
> I am not against the new reset/wipe operation, it is certainly a useful thing 
> to have. This style of initialising metadata would be especially useful with 
> formatting devices supporting discard, as it could be used to avoid 
> unnecessary writes on main data by initialising metadata only (and perhaps 
> also issue discards to underlying device).
> 
> But I do think this should be a separate, new function in addition to existing 
> recalculation feature, to me they both seem useful in different use cases.
> 
> Thoughts on this?
> 
> Thanks,
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


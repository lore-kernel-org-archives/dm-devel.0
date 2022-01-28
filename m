Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5062FC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 17:47:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-9juPQ2S3OY26dWeQ1CxMiw-1; Fri, 28 Jan 2022 12:47:33 -0500
X-MC-Unique: 9juPQ2S3OY26dWeQ1CxMiw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 417C22F26;
	Fri, 28 Jan 2022 17:47:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBEF77D5B2;
	Fri, 28 Jan 2022 17:47:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 265844BB7C;
	Fri, 28 Jan 2022 17:47:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SHlPcE002585 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 12:47:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F3DE140885C2; Fri, 28 Jan 2022 17:47:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF4AF40885BF
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 17:47:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5EE72A5955E
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 17:47:24 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
	[209.85.218.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-333-SRuvK82YM-2D3R_oemx0pA-1; Fri, 28 Jan 2022 12:47:19 -0500
X-MC-Unique: SRuvK82YM-2D3R_oemx0pA-1
Received: by mail-ej1-f51.google.com with SMTP id a8so18361917ejc.8;
	Fri, 28 Jan 2022 09:47:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=ogNJP5EHoLlY/+pzq7MKSl45upWBBZ4YKt4mxMnYq0U=;
	b=MLkOpDdeDNWvht9kOpxKxdUpZMvPNlJs2rBucEJupGjsfzfhSbbiI0CApU+XLLhQlL
	OqvBN55bQ4DseaEvdQFU+NpNdiUY9/OUhBOL0fGSqE1RPvTnVpbNnAuNDbhyDBj42I9T
	xJFsIi9gE/tIVc70mCAo4DfGcjwSqF5nxuRxReWxLwhF33lAOe/HySgy+//Fep5WBqNv
	G8yHl/ar3YrKAOBMBae2psjoB6mBc9osR4oNyHVP6EH4aIu5y3kl4Wy40Xpd4QABO1UL
	Yoh03/R3UsJqFfFsGpVVa16dSL385laevvBRxXJdi7T4rvwUDDBqELzeEI4XZcF8bDJM
	LJFA==
X-Gm-Message-State: AOAM53314p3Q9FR6TunuHgcVfAskN3xywFWiFspcqlnwGRN/YneS4yoa
	M55EXDGDYNV+JOAbiYggV8sngf85NBSH7Dt2
X-Google-Smtp-Source: ABdhPJw9tAhAzrF+/5fMIovmUuxc/oT6iZSLHMfykDK0q9L8d8SLV4ddIzw/BxwFsxKaeGFQNqUe2A==
X-Received: by 2002:a17:907:7292:: with SMTP id
	dt18mr7557137ejc.305.1643392037099; 
	Fri, 28 Jan 2022 09:47:17 -0800 (PST)
Received: from [192.168.0.99] ([83.148.32.207])
	by smtp.gmail.com with ESMTPSA id
	z6sm10323231ejd.96.2022.01.28.09.47.16
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 28 Jan 2022 09:47:16 -0800 (PST)
Message-ID: <e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
Date: Fri, 28 Jan 2022 18:47:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Firefox/91.0 Thunderbird/91.4.0
To: Martin Wilck <mwilck@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>,
	David Teigland <teigland@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
	<a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>,
	Franck Bui <fbui@suse.de>, lvm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] udev: create symlinks and watch even in
	suspended state
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dne 28. 01. 22 v 17:02 Martin Wilck napsal(a):
> On Fri, 2022-01-28 at 16:57 +0100, Martin Wilck wrote:
>>
>> It's a race condition. It probably happens while multipathd is
>> reloading a map (*), suspending it during the table reload. The
>> device
>> will be resumed a few fractions of a second later (so yes, it's
>> "quick"), but then it's too late
> 
> More precisely: The suspend state itself may actually not last longer
> than a few ms. But once the symlink is bent to point to the wrong
> device, it will remain so, until the CHANGE event following the device
> resume is successfully processed by udev, which may happen
> substantially later. And it's that longer time span which matters for
> systemd's mount attempt (or LVM device activation, for that matter).
> 
>


This looks like you are trying to mask-out different synchronization bug.

Also it's worth to note - using symlinks is somewhat doomed on its own.

So you only solve a very minor subcase where you manage to 'hit' your race
just in a moment where you device is suspend and you actually 'scan' state of 
device.

But what happen - if device would happen to be already resumed ?
It looks like there is some race in udev rules processing - just somewhere else.

I think Peter could more enlighten the lvm2 logic - but it seems there is 
possibly missing similar logic on multipath side in the moment when devices 
are created ?

There should be no race when switching from ramdisk to rootfs.

Regards

Zdenek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


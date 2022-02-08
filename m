Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD74C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 20:37:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-FGBN2WQbPpmUHe2lhVwzbw-1; Tue, 08 Feb 2022 15:37:27 -0500
X-MC-Unique: FGBN2WQbPpmUHe2lhVwzbw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 600CD1091DA0;
	Tue,  8 Feb 2022 20:37:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 692D2E144;
	Tue,  8 Feb 2022 20:37:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE7031809CB8;
	Tue,  8 Feb 2022 20:37:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 218KbGVp030557 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Feb 2022 15:37:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B8EDBC080A9; Tue,  8 Feb 2022 20:37:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B50F1C07F5D
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 20:37:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B9E3802E5B
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 20:37:16 +0000 (UTC)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
	[209.85.208.48]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-329-0ZNn7fY0PXm3Iku3j7RZVw-1; Tue, 08 Feb 2022 15:37:13 -0500
X-MC-Unique: 0ZNn7fY0PXm3Iku3j7RZVw-1
Received: by mail-ed1-f48.google.com with SMTP id eg42so814137edb.7;
	Tue, 08 Feb 2022 12:37:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=tTVqdHz6utN6OoFKFhh+5Z+3IXoE9U96hd6oLCK9Q8g=;
	b=Vll4ZNwBZxJmKBmssTK6NaAvDtnOc5/+9GjPkltxN0hHig6sxoVphDpxda35IKX6Ii
	mGW/NpfRq3/cJT7/ted+251i1AhJpstoUpM2vAOnK//gS1e4WR12SRy1TPfygW8E3d9M
	irumJygES6mmMXscYJ6pXVUiVxV6iyR7fbSK/C/Eoyg2EZoWqGrpsHrcni/Q9tomlwnm
	mpI/uajvcgx3/GDr/XM1ci91SsJ9dQW815Qat1Rgu42c0EE7GRijq/FiwQEf8D2sJtRI
	vP6ALjoo/xG8RwpidzVm8katJuliYmVo2/f/g/GW6EdRarm4elCYfAzktDGeCJZ8CRhA
	t+vA==
X-Gm-Message-State: AOAM5300kWUKGQaoe0p4Sfv94A6JCXNv96WRwLrZfHtpK+hP5tLhR/6I
	bviCkoZg/l1jeQbzlT6pdfNru/6iEMVii9Bb
X-Google-Smtp-Source: ABdhPJxZiaODbkYiZ2asY2KY7boTGBqhjc8kTaOPG8gRR/AcZVrk2UOlXePFyUxcm+djbqkgA0VtoQ==
X-Received: by 2002:aa7:d815:: with SMTP id v21mr6232706edq.160.1644352630527; 
	Tue, 08 Feb 2022 12:37:10 -0800 (PST)
Received: from [192.168.0.99] ([83.148.32.207])
	by smtp.gmail.com with ESMTPSA id p1sm4565598edy.69.2022.02.08.12.37.09
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 08 Feb 2022 12:37:10 -0800 (PST)
Message-ID: <9a14a7a5-a8a1-a4d6-f9fd-012d3c170f2a@gmail.com>
Date: Tue, 8 Feb 2022 21:37:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Firefox/91.0 Thunderbird/91.4.0
To: LVM general discussion and development <linux-lvm@redhat.com>,
	Demi Marie Obenour <demi@invisiblethingslab.com>,
	device-mapper development <dm-devel@redhat.com>
References: <YgK+Avj+VURDqo7j@itl-email>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <YgK+Avj+VURDqo7j@itl-email>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dne 08. 02. 22 v 20:00 Demi Marie Obenour napsal(a):
> Are thin volumes (which start as snapshots of a blank volume) efficient
> for building virtual machine images?  Given the nature of this workload
> (writing to lots of new, possibly-small files, then copying data from
> them to a huge disk image), I expect that this will cause sharing to be
> broken many, many times, and the kernel code that breaks sharing appears
> to be rather heavyweight.  Furthermore, since zeroing is enabled, this
> might cause substantial write amplification.  Turning zeroing off is not
> an option for security reasons.
> 
> Is there a way to determine if breaking sharing is the cause of
> performance problems?  If it is, are there any better solutions?

Hi

Usually the smaller the thin chunks size is the smaller the problem gets.
With current released version of thin-provisioning minimal chunk size is 
64KiB. So you can't use smaller value to further reduce this impact.

Note - even if you do a lot of tiny 4KiB writes  - only the 'first' such write 
into 64K area breaks sharing all following writes to same location no longer 
have this penalty (also zeroing with 64K is less impactful...)

But it's clear thin-provisioning comes with some price - so if it's not good 
enough from time constrains some other solutions might need to be explored.
(i.e. caching, better hw, splitting  FS into multiple partitions with 
'read-only sections,....)

For analysis of device hot points you could check 'dmstats' tool for DM devices.

Regards

Zdenek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


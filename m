Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF5DC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jan 2022 13:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643636061;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pZ2wiBeqAeOiMOpWH86B0Zq7POIE1bZR4yn/uHd1XQA=;
	b=RHee9UCoXYMGpBHK4FGSfteZulU/RlGA+Pviwnqv0ENeX8GCVULFkfgDTL7oFfcLi6EW1U
	P4mhc/Naq756RWHi0My/kAbfG4Ev614thhUQKwYmD9lfvDIF727symvu19Ti+2S4kmiF0T
	Mpo+7qEmQp/JmLo4SoImjvT4d0VpO5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-yrv3WSDcPHKJ4JlM9c2apg-1; Mon, 31 Jan 2022 08:34:18 -0500
X-MC-Unique: yrv3WSDcPHKJ4JlM9c2apg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6899B51081;
	Mon, 31 Jan 2022 13:34:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17C0E6E20C;
	Mon, 31 Jan 2022 13:34:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 637A61809CBA;
	Mon, 31 Jan 2022 13:34:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20VDY11b031311 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 31 Jan 2022 08:34:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 97B731457F10; Mon, 31 Jan 2022 13:34:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 940911457F06
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 13:34:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B6CA1C04B61
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 13:34:01 +0000 (UTC)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
	[209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-460-0GYHVJs5N-CTmawJW1Q4dw-1; Mon, 31 Jan 2022 08:34:00 -0500
X-MC-Unique: 0GYHVJs5N-CTmawJW1Q4dw-1
Received: by mail-ej1-f70.google.com with SMTP id
	v2-20020a1709062f0200b006a5f725efc1so5001571eji.23
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 05:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=lmAqJXoRChcuoRl5kg7cE0FDHviec1Uj3NNVNauWVrY=;
	b=SLizlaja4GiGA/MmwFnkGdTjJlmJ6ZEILknyEaKlJO3fICna+eoHBmFOTY51C86w+B
	nx+fl34qENgyd2VrT5UeVry3Jeb6coSg90CcvvcObf86Usjrh+7+3OMRMrWoN/hqmylj
	0IrVO0B9tD4uBpGnkAYCHOrnGix1tVxEpwqfhXZh4zbe54mt01zMFuFuSzukxVh/MzXE
	rPo8V1Q6qcL+kkc76gkCg+Jhhg6urmtvy82koLhmWdbj5csIrZxxyyWJVBT72yJojMDu
	iTxKNv6K7+do81oouiIhP2dxDS9MNO62AHcsxBJngNqOcYro/Sd7f9EJKVM+MLiSXmeZ
	AWCA==
X-Gm-Message-State: AOAM532mTXL43D/m7YFHL5CqecPHHClLWDZ1j+lQRUO3QpVnrNcINbL4
	vhK/fg9nn+zXogogwgWH9OwgaGNs/SLJxjeudGNyXr/xLR2TPHCRx5EePPap3BlLK6/T8MUAiEY
	ma3dmqgy9F1+kq6s=
X-Received: by 2002:a17:906:5d09:: with SMTP id
	g9mr16735207ejt.510.1643636038860; 
	Mon, 31 Jan 2022 05:33:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxjTLOx9B0UmssFSJ5V1GQ7k9RscqHjFw8PkVtpd782zf/zPk0G1UnUzfNCU62IcGeu1/sELA==
X-Received: by 2002:a17:906:5d09:: with SMTP id
	g9mr16735195ejt.510.1643636038630; 
	Mon, 31 Jan 2022 05:33:58 -0800 (PST)
Received: from alatyr-rpi.brq.redhat.com (nat-pool-brq-t.redhat.com.
	[213.175.37.10]) by smtp.gmail.com with ESMTPSA id
	fy40sm13017144ejc.36.2022.01.31.05.33.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 31 Jan 2022 05:33:58 -0800 (PST)
Date: Mon, 31 Jan 2022 14:33:54 +0100
From: Peter Rajnoha <prajnoha@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20220131133354.vfomn5gdlgrhue4g@alatyr-rpi.brq.redhat.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
	<a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
	<e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
	<0a55dd1393df2c125f8cb443daaeb7d1b7162bcc.camel@suse.com>
	<aba2f6dd-f4cf-6af4-e2b6-965f5de06cd8@redhat.com>
	<92de9eff521e2702e364f7aa3cce6927d9d9c03c.camel@suse.com>
	<1b20e88f-2714-3c61-73a6-2f34f6a34edc@gmail.com>
	<712b54a06fa1b13f9ac92a00d7b121979c43d31c.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <712b54a06fa1b13f9ac92a00d7b121979c43d31c.camel@suse.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Franck Bui <fbui@suse.de>, lvm-devel@redhat.com, dm-devel@redhat.com,
	David Teigland <teigland@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Heming Zhao <heming.zhao@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat 29 Jan 2022 21:46, Martin Wilck wrote:
> On Sat, 2022-01-29 at 21:05 +0100, Zdenek Kabelac wrote:
> > Dne 29. 01. 22 v 0:21 Martin Wilck napsal(a):
> > 
> > > 
> > > AFAICS my patch eliminates the window for this error entirely.
> > 
> > 
> > Ok now I see that there is already skip for DM_SUSPENDED
> > and you patch likely only tries to preserve some existing state of
> > links.
> > 
> > I'll need to get in touch with Peter here.
> > 
> > I guess the idea behind was to avoid read of device that will be
> > resumed and 
> > will automatically get a new event - and suspened device itself
> > cannot change 
> 
> Thank you!
> 
> > - but that fact it's been loosing existing state was missed - I'm
> > wondering 
> > why this was not seen as problem before.
> 
> One reason is that we're now starting multipathd earlier. This has a
> lot of advantages, but it reveals problems that were hidden behind the
> "After=systemd-udev-settle.service" dependency of mulltipathd before.

Hi!

(just discussed this with Zdenek too)

The patch makes sense to me!

We added all the DM_UDEV_PRIMARY_SOURCE_FLAG and related for exactly
such cases where we need to take the existing values already scanned
in previous event, main use-case being the trigger at boot. We just
didn't cover the 13-dm-disk.rules with the same logic regarding the
suspended state to keep the symlinks - I didn't think it would cause
issues (because, usually, after suspend, we anticipate incoming
resume where the device is scanned again).

But yes, if temporarily losing the symlink causes issues, your patch
solves that (Zdenek will push that upstream).

(There's one more situation with checking the suspended state for the
pvscan we have in 69-dm-lvm...rules, but that's lvm-specific, we'll
patch that one...)

Thanks!

-- 
Peter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


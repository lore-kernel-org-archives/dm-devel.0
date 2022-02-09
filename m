Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E16AC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 08:18:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-UT6n2LP0PvC0goGbt1W8PA-1; Thu, 10 Feb 2022 03:18:51 -0500
X-MC-Unique: UT6n2LP0PvC0goGbt1W8PA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3E7E10247B5;
	Thu, 10 Feb 2022 08:18:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B84D05ED55;
	Thu, 10 Feb 2022 08:18:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8E1AC4A7CA;
	Thu, 10 Feb 2022 08:18:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 219E8Pib026897 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 09:08:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 668DE401E5F; Wed,  9 Feb 2022 14:08:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6330D401E5D
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 14:08:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AAFE800883
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 14:08:25 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
	[209.85.218.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-629-0eo22I9aNc-HsQ6nxP8kwQ-1; Wed, 09 Feb 2022 09:08:23 -0500
X-MC-Unique: 0eo22I9aNc-HsQ6nxP8kwQ-1
Received: by mail-ej1-f51.google.com with SMTP id fj5so4809821ejc.4
	for <dm-devel@redhat.com>; Wed, 09 Feb 2022 06:08:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=I5bx1qEtEg3EIzDv8AQCkahDWh6kYfXn3OFOgd1OTgg=;
	b=Kschm7RBLn9Pghb1p4FsYIO8Nu6iLrwX7V0laKKcE1aWxbK4NjEOWPuvbVDxu23YfX
	YoPh9aIbPbuBZI4tE8aY6abOlWK3mYxCYMavMTvv++uY3MKX26IlRwGyYygrC5uVow0v
	jvGCE4smsMkdyp0So4AB9LMJ6Hacdie5a87CoxRSkTeICvOH6EbZ2ITES38XoPc/hD5L
	S2dazy4wfCcH5SzW393xxPsgm9r7wtF4qVPezKOmb7qQWypkJCU5YuruTui+HRNcbU3F
	hrNP8IqKVeWBAxYWvIXjJgZ+qyyicyolvHN+94wZXErU9y/zZTJzPzXQRnBQHOX9KmCJ
	PuEg==
X-Gm-Message-State: AOAM531KLm4c3GPQlKm6PWizjKXTDzWG17zCTTvhDc95sx+k2cCJD1T/
	u9M3I82MQk2HLMV3+sNFUkzMR2u0UWnj5tq+DFHmXA==
X-Google-Smtp-Source: ABdhPJzLJN+qYozEzQz4G3pucxfA9BKQJ8B2bDBEeDHB5sIEzgJRDkQpP0iVNBhtpmdi/dHQfGoa28HPCL5HUVirJAw=
X-Received: by 2002:a17:907:1b1c:: with SMTP id
	mp28mr2137509ejc.624.1644415702501; 
	Wed, 09 Feb 2022 06:08:22 -0800 (PST)
MIME-Version: 1.0
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-4-hch@lst.de>
	<CAMGffE=GMYNsw+mDt1h-BDh3JXkdrP9v2AUF7z0xE7jkumM+RQ@mail.gmail.com>
	<20220209140448.GA20765@lst.de>
In-Reply-To: <20220209140448.GA20765@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 9 Feb 2022 15:08:11 +0100
Message-ID: <CAMGffEm5qivscB8r+koGL7-bVxUOPr6=wLH6-RfHqzp8u2+HMw@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
X-Mailman-Approved-At: Thu, 10 Feb 2022 03:18:24 -0500
Cc: axboe@kernel.dk, manoj@linux.ibm.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, philipp.reisner@linbit.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, haris.iqbal@ionos.com,
	ukrishn@linux.ibm.com, lars.ellenberg@linbit.com,
	drbd-dev@lists.linbit.com, mrochs@linux.ibm.com
Subject: Re: [dm-devel] [PATCH 3/7] rnbd: drop WRITE_SAME support
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 9, 2022 at 3:04 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Feb 09, 2022 at 11:16:13AM +0100, Jinpu Wang wrote:
> > Hi Christoph,
> >
> >
> > On Wed, Feb 9, 2022 at 9:28 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > REQ_OP_WRITE_SAME was only ever submitted by the legacy Linux zeroing
> > > code, which has switched to use REQ_OP_WRITE_ZEROES long before rnbd was
> > > even merged.
> >
> > Do you think if it makes sense to instead of removing
> > REQ_OP_WRITE_SAME, simply convert it to REQ_OP_WRITE_ZEROES?
>
> Well, they have different semantics, so you can't just "convert" it.
> But it might make sense to add REQ_OP_WRITE_ZEROES.
Thanks, we will add support for REQ_OP_WRITE_ZEROES later.

For this patch, I've run internal tests, works fine.

Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thanks!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


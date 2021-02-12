Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5969C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:39:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 80DCF64D9F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80DCF64D9F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1613576354;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=R8ivDsVKvvXqHcEc7HtwERX3WuFspmMq9Ylax1TJgjM=;
	b=Wu+jUSxUnJtjOvYvRUMcBc17lHjAlMHsp5bFWhZMk902ROr+3ji6SdFSv/T8M1D30djFkB
	XPLSd92Emwne4cUk6wWiCU6db5fsfNTfFWrzRzsK+4dtaKK0hpXEss8nk86YGuJPK8k3Ar
	chQ38bwTtxx+Opx9o26nRz4gseVGKaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-Ynf62IUfOD-_5v2PiaqCJg-1; Wed, 17 Feb 2021 10:39:12 -0500
X-MC-Unique: Ynf62IUfOD-_5v2PiaqCJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1FB0835E21;
	Wed, 17 Feb 2021 15:39:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A8A319C46;
	Wed, 17 Feb 2021 15:39:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1037C18095CC;
	Wed, 17 Feb 2021 15:39:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11CFjqwE028262 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Feb 2021 10:45:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E2F92026D14; Fri, 12 Feb 2021 15:45:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 178302026D16
	for <dm-devel@redhat.com>; Fri, 12 Feb 2021 15:45:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F4A2811760
	for <dm-devel@redhat.com>; Fri, 12 Feb 2021 15:45:49 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
	[209.85.216.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-513-EiJSWOWUODaOq-bAZgrXcA-1; Fri, 12 Feb 2021 10:45:45 -0500
X-MC-Unique: EiJSWOWUODaOq-bAZgrXcA-1
Received: by mail-pj1-f53.google.com with SMTP id z9so635532pjl.5;
	Fri, 12 Feb 2021 07:45:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=M8C1yZZgp4rNPfghNpxWN41GpCK1+InKLAelhxbvplw=;
	b=ojSi3IEpL9r8XIac1ubEpvXAM/p+XtqMfcfsFWPlq38RvIE+VlvO32DcP/QcuRhQHT
	T5CqB792vO1ZQS+xH7w+rhgmejfqKCNqTA9LKYhq6RGXbUgM0p3U3ArBJF641VpMJCjg
	V0w13xZOAfgo/G/BYtgQhm/9DawPEfuY7/bEP3WSi2SeQc264jjySA5gKO1zPe++DCgD
	k0wsSEZtWfjkZLfGP2dnjnaq8ojyYwVgtpds3A4z24pXQLJdJuj+CaXc3urssTwgL5eP
	kF5e1erguHkmg3gvt6R4sC4w5Nv7puvuUxx6g6dp8r7MrVsIYOQZM/O9s8EKPNrC+yO9
	QDOQ==
X-Gm-Message-State: AOAM530/cTaONW0+x9XuOVUhayQoL1Hc092DBURDCYN+WQGKB2BjQdce
	w7iuBFBadVPkL1krrcsKD2ynv8cvMMYfDM/wtr21iFKHgnODngXj
X-Google-Smtp-Source: ABdhPJyYCXBmQgiV5syIf5Cv8mFWKTwy1gjS5Yhyhg4Qi/jYzZasdmgfRgJp2ybsEGtlgybQDIghy8J0Yy2+jaKx2kI=
X-Received: by 2002:a17:90a:4e1:: with SMTP id g88mr3222886pjg.7.1613144743400;
	Fri, 12 Feb 2021 07:45:43 -0800 (PST)
MIME-Version: 1.0
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-13-hch@lst.de>
In-Reply-To: <20201116145809.410558-13-hch@lst.de>
From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 12 Feb 2021 10:45:32 -0500
Message-ID: <CAMM=eLfD0_Am3--X+PsKPTfc9qzejxpMNjYwEh=WtjSa-iSncg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: Justin Sanders <justin@coraid.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block <linux-block@vger.kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 12/78] dm: use set_capacity_and_notify
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 16, 2020 at 10:05 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Use set_capacity_and_notify to set the size of both the disk and block
> device.  This also gets the uevent notifications for the resize for free.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index c18fc25485186d..62ad44925e73ec 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1971,8 +1971,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>         if (size != dm_get_size(md))
>                 memset(&md->geometry, 0, sizeof(md->geometry));
>
> -       set_capacity(md->disk, size);
> -       bd_set_nr_sectors(md->bdev, size);
> +       set_capacity_and_notify(md->disk, size);
>
>         dm_table_event_callback(t, event_callback, md);
>

Not yet pinned down _why_ DM is calling set_capacity_and_notify() with
a size of 0 but, when running various DM regression tests, I'm seeing
a lot of noise like:

[  689.240037] dm-2: detected capacity change from 2097152 to 0

Is this pr_info really useful?  Should it be moved to below: if
(!capacity || !size) so that it only prints if a uevent is sent?

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


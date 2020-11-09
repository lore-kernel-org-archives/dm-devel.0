Return-Path: <SRS0=xkgx=EQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E20C5517A
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EF3702080A
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF3702080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-uW8IJ5XaPUGkfJee7c7Tnw-1; Tue, 10 Nov 2020 02:55:36 -0500
X-MC-Unique: uW8IJ5XaPUGkfJee7c7Tnw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9757B1007498;
	Tue, 10 Nov 2020 07:55:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77F0B19D7C;
	Tue, 10 Nov 2020 07:55:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4A43D180B65D;
	Tue, 10 Nov 2020 07:55:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A9DqGFL029082 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Nov 2020 08:52:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3848F6FA5A; Mon,  9 Nov 2020 13:52:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32BCE6FA59
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 13:52:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D62A1802704
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 13:52:13 +0000 (UTC)
Received: from mail-il1-f195.google.com (mail-il1-f195.google.com
	[209.85.166.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-450-VWupeJ0KMa6rD6B6fUA6dg-1; Mon, 09 Nov 2020 08:52:08 -0500
X-MC-Unique: VWupeJ0KMa6rD6B6fUA6dg-1
Received: by mail-il1-f195.google.com with SMTP id q1so8337723ilt.6;
	Mon, 09 Nov 2020 05:52:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=kU2Lz6FCVrZiuEoHabGbCYI8mZi4aQygf2Kr0fLfGG4=;
	b=DrZUBL4RpCZlr/4KmlifTEla9sJdbWCq/PpR0slLmDCTZmGLeiduXxApr3ksEnvw9s
	9c1tmipzE591NICKsFgOuqQWh4LjpY5IryfNdUyuCCKHoqMbx8mxZ0uxOnjpvs26IW35
	dS+JqLEUxFF/YLXhgZImCh25/JhMOs1gRHSOdwhrMXhgEOYKjo+k3zBiaP3hr9WjZ1ax
	7lJhEv2BilrXX1WXp88PIs+RgJzS2mC32pDHX7OSRQ+37Pqe9b7ze05FieNKqANKjeOn
	e/bJnbfWSYTqXdPtE3PLNTQrtT5AD9UXHkuOukUI3+u0EntpC+2eZR7qdQgnq2iIyvpn
	oQsg==
X-Gm-Message-State: AOAM531aOSmJisWlS3YdEOUbNcSgvfyZOyYiPWBv4MQYPa/DgMFy2x0S
	HeLC94bfOwVGK5bwFFS01kPecydBMPTVFIRebhg=
X-Google-Smtp-Source: ABdhPJyXm5ijaiShQDd7Xj0k0fsOvCm3U5j3JctcQpIY73kNN30YAUsNc9VfJ5DemzskInCCw4oOffcooZ/r5dSiKD8=
X-Received: by 2002:a05:6e02:c:: with SMTP id
	h12mr10623495ilr.177.1604929927708; 
	Mon, 09 Nov 2020 05:52:07 -0800 (PST)
MIME-Version: 1.0
References: <20201106190337.1973127-1-hch@lst.de>
	<20201106190337.1973127-18-hch@lst.de>
In-Reply-To: <20201106190337.1973127-18-hch@lst.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 9 Nov 2020 14:52:08 +0100
Message-ID: <CAOi1vP83cOt_FOFLXQmgBpDgmaq8o8OQcUYWOb97jzkgOw6r4A@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
X-Mailman-Approved-At: Tue, 10 Nov 2020 02:55:04 -0500
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
	Lars Ellenberg <drbd-dev@tron.linbit.com>,
	Ceph Development <ceph-devel@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 17/24] rbd: use set_capacity_and_notify
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 6, 2020 at 8:04 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Use set_capacity_and_notify to set the size of both the disk and block
> device.  This also gets the uevent notifications for the resize for free.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/rbd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index f84128abade319..b7a194ffda55b4 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4920,8 +4920,7 @@ static void rbd_dev_update_size(struct rbd_device *rbd_dev)
>             !test_bit(RBD_DEV_FLAG_REMOVING, &rbd_dev->flags)) {
>                 size = (sector_t)rbd_dev->mapping.size / SECTOR_SIZE;
>                 dout("setting size to %llu sectors", (unsigned long long)size);
> -               set_capacity(rbd_dev->disk, size);
> -               revalidate_disk_size(rbd_dev->disk, true);
> +               set_capacity_and_notify(rbd_dev->disk, size);
>         }
>  }
>
> --
> 2.28.0
>

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


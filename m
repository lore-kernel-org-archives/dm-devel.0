Return-Path: <SRS0=+j0W=FL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400A3C433FE
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 14:58:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB93923601
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 14:58:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB93923601
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-jsGX2WCcPz-agJKvhw2a6Q-1; Mon, 07 Dec 2020 09:58:05 -0500
X-MC-Unique: jsGX2WCcPz-agJKvhw2a6Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83BC3185E4A8;
	Mon,  7 Dec 2020 14:57:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D3FC5C1BB;
	Mon,  7 Dec 2020 14:57:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCF12180954D;
	Mon,  7 Dec 2020 14:57:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B7EvZTj019855 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Dec 2020 09:57:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 67E873322C; Mon,  7 Dec 2020 14:57:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 623C63322A
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 14:57:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 990B8800183
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 14:57:31 +0000 (UTC)
Received: from mail-il1-f195.google.com (mail-il1-f195.google.com
	[209.85.166.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-352-9Az44qnsNmKMDn87YJK4AQ-1; Mon, 07 Dec 2020 09:57:29 -0500
X-MC-Unique: 9Az44qnsNmKMDn87YJK4AQ-1
Received: by mail-il1-f195.google.com with SMTP id p5so12404991iln.8;
	Mon, 07 Dec 2020 06:57:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=BdzMWmghWMnmqJzPNphPqafzWOiOvEaXvaPDnRpTyig=;
	b=Uybp4TW9gTr4bd+ii2RFirgg8X66ccw4icyubN1EaJz3px32gIu93TGESJ0T/xawcA
	HJNtXTk8htKR/RAS9kLIZrMIv/yLgHXmBUHv0EZ6h9pRQbP5bpZX9k9nfh+eUKzDs9Bu
	jML0jT5uxOD018T+xaZpIZ/d7hLS9LphC3GGgTvHA+43U0coiF0J+RnOA2/QQdgRoXPj
	z+fuzkWfWMCvlJZiAOqfdDzO4UlEfF0UYV1mBXkK4dxcAbvJNXf+5uCKGMIwCtQl4ET6
	QEx22zI4iH55F+uzyxf/olsF3LIuaUbFY/x1QXJ/Hc9+XJLi0F7EFgyi8gZKaHUGmbuP
	gcEQ==
X-Gm-Message-State: AOAM530tGMsq7crBT5soYAUUkCijErua9AOunAZkBAUzudWW1DoTZEbT
	UDGREfRI4IncXzQMhtCowBFgLEt15/owiYN0sy0=
X-Google-Smtp-Source: ABdhPJzWgUFyUwn4oRQGFwhc7sjEZmk8MIUigwiYjc70guXN2OnSLrKLaIK50f+C57huiWudj+gdKgGdrTXAcHcP4D8=
X-Received: by 2002:a92:4c3:: with SMTP id 186mr21869621ile.177.1607353048343; 
	Mon, 07 Dec 2020 06:57:28 -0800 (PST)
MIME-Version: 1.0
References: <20201207131918.2252553-1-hch@lst.de>
	<20201207131918.2252553-6-hch@lst.de>
In-Reply-To: <20201207131918.2252553-6-hch@lst.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 7 Dec 2020 15:57:21 +0100
Message-ID: <CAOi1vP9q7iGLmDryWJ0Duk2uQODr5W=5RCt2GAAxKk+N_k9OOg@mail.gmail.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
	Mike Snitzer <snitzer@redhat.com>, Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 5/6] rbd: remove the ->set_read_only method
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Dec 7, 2020 at 2:21 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Now that the hardware read-only state can't be changed by the BLKROSET
> ioctl, the code in this method is not required anymore.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 19 -------------------
>  1 file changed, 19 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2ed79b09439a82..2c64ca15ca079f 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -692,29 +692,10 @@ static void rbd_release(struct gendisk *disk, fmode_t mode)
>         put_device(&rbd_dev->dev);
>  }
>
> -static int rbd_set_read_only(struct block_device *bdev, bool ro)
> -{
> -       struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
> -
> -       /*
> -        * Both images mapped read-only and snapshots can't be marked
> -        * read-write.
> -        */
> -       if (!ro) {
> -               if (rbd_is_ro(rbd_dev))
> -                       return -EROFS;
> -
> -               rbd_assert(!rbd_is_snap(rbd_dev));
> -       }
> -
> -       return 0;
> -}
> -
>  static const struct block_device_operations rbd_bd_ops = {
>         .owner                  = THIS_MODULE,
>         .open                   = rbd_open,
>         .release                = rbd_release,
> -       .set_read_only          = rbd_set_read_only,
>  };
>
>  /*
> --
> 2.29.2
>

If nothing can mess with read-only state after set_disk_ro(disk, true),
looks good.

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


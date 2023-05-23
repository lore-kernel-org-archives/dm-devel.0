Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D552BC7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 16:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684860581;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Vwk5g0Irt9e3ymhWws0d48K08wwBnXQFhIppaUVYJeQ=;
	b=ekGwnmt3poKlxUPwbi+MmKfDM0QaibdXDoA1j8obaOZtefHHVxj5FqjCzAjs4TotT6tPyO
	9g38iewnUDIweb5jvpelmsx5jvqpm1YCKuU/6RBgUNHNYHryoUXu+CqTR+9bUSTUCmZFyd
	7DFnhMuKd0xAvEU486bREK5O1pXaS7k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-KdObyn1DOQKHjhWev1_xfA-1; Tue, 23 May 2023 12:49:40 -0400
X-MC-Unique: KdObyn1DOQKHjhWev1_xfA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20108185A78F;
	Tue, 23 May 2023 16:49:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B428A145B965;
	Tue, 23 May 2023 16:49:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C84B19465B7;
	Tue, 23 May 2023 16:49:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17AA619465B6
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 16:49:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EF6E020296C6; Tue, 23 May 2023 16:49:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E8D1F200AD47
 for <dm-devel@redhat.com>; Tue, 23 May 2023 16:49:19 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (unknown [170.10.128.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CACD92A5955D
 for <dm-devel@redhat.com>; Tue, 23 May 2023 16:49:19 +0000 (UTC)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
 [209.85.222.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-qtBBG2DoPnqSepnbXgFN4g-1; Tue, 23 May 2023 12:49:18 -0400
X-MC-Unique: qtBBG2DoPnqSepnbXgFN4g-1
Received: by mail-qk1-f179.google.com with SMTP id
 af79cd13be357-75affe9d7feso10328685a.0
 for <dm-devel@redhat.com>; Tue, 23 May 2023 09:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684860557; x=1687452557;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=K3EMNNGlTZuYQJrvyvOENR+PpdBzLBVxLhbFOjcQtI8=;
 b=KIrcZ/L2kNGh4uYU0VNlcGZutDZSDbYs5o1/igeNAAygY10tP5HfF6cVSrkiLheH62
 FVg/GZ0vcrt5kXkCx2oOnsL5xxnbz8IZDE/axGZyzfA9XN3pn1PyfB+UguUJN8jiYRby
 q138g9uR8VY3vwn/DyJWzktEC6XbyTo0qBk3V8XJXLdgAG/wjYwYyPDPNm6/iXek7hGf
 yMBm5lsVDM/ux+zmjYZLM+6ZftDWeL44uD/AekM0rCg42P4XrjLpVfOcYGUZW0+7k30N
 pUavHUfTTvyasTmblQm1jRwsFurgKQK5RAmTRQpNHwq6Yd6sjzDjEekbg4cqP65QfPuB
 81hw==
X-Gm-Message-State: AC+VfDyPdaPXFMhMQc00IweHca4XQHHgk3e2i4AcHqj+T1zIL8E48o0g
 v3y1FT6rH/82XqcwtkKGaLy1+dE=
X-Google-Smtp-Source: ACHHUZ60MTd8uQA0xp9MNOc+NSCIw6YiYWa5gikMW79ezh2QPyW9HHZu/QE2R1r4T9c4z9ffo1j2pw==
X-Received: by 2002:a37:458b:0:b0:75b:23a0:de95 with SMTP id
 s133-20020a37458b000000b0075b23a0de95mr4318585qka.19.1684860557503; 
 Tue, 23 May 2023 09:49:17 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 m5-20020ae9e005000000b007578b6d060bsm2619050qkk.126.2023.05.23.09.49.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 09:49:17 -0700 (PDT)
Date: Tue, 23 May 2023 12:49:16 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZGzujNVLaQD2npwH@redhat.com>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-20-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230523074535.249802-20-hch@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 19/24] dm: remove dm_get_dev_t
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23 2023 at  3:45P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Open code dm_get_dev_t in the only remaining caller, and propagate the
> exact error code from lookup_bdev and early_lookup_bdev.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-table.c         | 20 ++++----------------
>  include/linux/device-mapper.h |  2 --
>  2 files changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 05aa16da43b0d5..e997f4322a9967 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -323,20 +323,6 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
>  	return 0;
>  }
>  
> -/*
> - * Convert the path to a device
> - */
> -dev_t dm_get_dev_t(const char *path)
> -{
> -	dev_t dev;
> -
> -	if (lookup_bdev(path, &dev) &&
> -	    early_lookup_bdev(path, &dev))
> -		return 0;
> -	return dev;
> -}
> -EXPORT_SYMBOL_GPL(dm_get_dev_t);
> -
>  /*
>   * Add a device to the list, or just increment the usage count if
>   * it's already present.
> @@ -359,8 +345,10 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  		if (MAJOR(dev) != major || MINOR(dev) != minor)
>  			return -EOVERFLOW;
>  	} else {
> -		dev = dm_get_dev_t(path);
> -		if (!dev)
> +		r = lookup_bdev(path, &dev);
> +		if (r)
> +			r = early_lookup_bdev(path, &dev);
> +		if (r)
>  			return -ENODEV;
>  	}
>  	if (dev == disk_devt(t->md->disk))

OK, but you aren't actually propagating the exact error code.  Did
you intend to change the return from -ENODEV to r?

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


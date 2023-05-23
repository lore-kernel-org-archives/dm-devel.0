Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC9BCC77B75
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684861155;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SmRA/2grfAtBTQittIbAZ6tPKDU5/hQ4zhQGtHvQJto=;
	b=bQ/Gtx1Kk69nRtCfkxm4uqBofO59qvsJfcMrwsjaj4cMPD3em+0puqYFG/GrzOaiyPV+3P
	9jCXxxEjV0qruWOflluuKNvD4mxwcnTwcL1efXnJHvLP5P0qTCkzUkPom7ZA38eFWiPKIJ
	LmSBQKLeFkVCl6EYMljcX/Ndq5CsrM8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-G8MmK1izOTawjWD-t637Kg-1; Tue, 23 May 2023 12:59:14 -0400
X-MC-Unique: G8MmK1izOTawjWD-t637Kg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98D9C3847087;
	Tue, 23 May 2023 16:59:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8723B40CFD00;
	Tue, 23 May 2023 16:59:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4703A19465A8;
	Tue, 23 May 2023 16:59:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E504619465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 16:59:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A53FC40D1B60; Tue, 23 May 2023 16:59:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D63840C6CCF
 for <dm-devel@redhat.com>; Tue, 23 May 2023 16:59:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 821573C0C887
 for <dm-devel@redhat.com>; Tue, 23 May 2023 16:59:05 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-DONjQWxaOtu_G775H27s-A-1; Tue, 23 May 2023 12:59:03 -0400
X-MC-Unique: DONjQWxaOtu_G775H27s-A-1
Received: by mail-qv1-f44.google.com with SMTP id
 6a1803df08f44-62382e86f81so32050926d6.2
 for <dm-devel@redhat.com>; Tue, 23 May 2023 09:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684861143; x=1687453143;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=iwRGjqJkSXRPJHHzQwuRJHCwrUdQwcyQ9byVzjawyEc=;
 b=PHC/rKWwsXrCCdalBJtQfqBzBakQsNXtWHQul09J3R3CIHlv6INOFXIVRlj5gIJd/U
 ZIjQvyweBSONKMzdHGj2VfnGSsS9A8RhnDEDXhw+FfiHB89zRbOo55AgzFuw0XAN7h9W
 rGoSftz4OpFfHwRwvKyBmc+12z78KKHVyY866Kph5pwA7jXnr03mLRQbhmLqXf9o4S8g
 YEaZHUROnvJKFXzz9sWd9M2ByxpNIJWGaCUGbedklnUw3J8nk2CRF9KuDCs8fyus75bC
 12QOISPcurirFVrO0vhYsv4O/bdTNWgX/eAsHCgP8ZED6dDY4HY2v3hH0+PMAXRSBr4r
 zU6A==
X-Gm-Message-State: AC+VfDweNs62noDdfCN1RjZFYwwCI0LjBe7m7O4u81Hl6g64aug3FZCC
 uVWEpj/MzDFVH7Ux9D/eWdSzcdE=
X-Google-Smtp-Source: ACHHUZ7KDQ2Jp5KWH/08+Nowc+ZerVbKYaqFsCmja4tNY6veUp3xnJBwfILDlwQLmRkuu4hWo14WpA==
X-Received: by 2002:ad4:5742:0:b0:621:64c7:235f with SMTP id
 q2-20020ad45742000000b0062164c7235fmr24446598qvx.27.1684861143301; 
 Tue, 23 May 2023 09:59:03 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 x19-20020ae9f813000000b00759333a57adsm2666246qkh.11.2023.05.23.09.59.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 09:59:02 -0700 (PDT)
Date: Tue, 23 May 2023 12:59:01 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZGzw1c60WJBTNclC@redhat.com>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-21-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230523074535.249802-21-hch@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 20/24] dm: only call early_lookup_bdev from
 early boot context
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23 2023 at  3:45P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> early_lookup_bdev is supposed to only be called from the early boot
> code, but dm_get_device calls it as a general fallback when lookup_bdev
> fails, which is problematic because early_lookup_bdev bypasses all normal
> path based permission checking, and might cause problems with certain
> container environments renaming devices.
> 
> Switch to only call early_lookup_bdev when dm is built-in and the system
> state in not running yet.  This means it is still available when tables
> are constructed by dm-init.c from the kernel command line, but not
> otherwise.
> 
> Note that this strictly speaking changes the kernel ABI as the PARTUUID=
> and PARTLABEL= style syntax is now not available during a running
> systems.  They never were intended for that, but this breaks things
> we'll have to figure out a way to make them available again.  But if
> avoidable in any way I'd rather avoid that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-table.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e997f4322a9967..c230241a76b374 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -326,8 +326,11 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
>  /*
>   * Add a device to the list, or just increment the usage count if
>   * it's already present.
> + *
> + * Note: the __ref annotation is because this function can call the __init
> + * marked early_lookup_bdev when called during early boot code from dm-init.c.
>   */
> -int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> +int __ref dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  		  struct dm_dev **result)
>  {
>  	int r;
> @@ -346,8 +349,10 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  			return -EOVERFLOW;
>  	} else {
>  		r = lookup_bdev(path, &dev);
> -		if (r)
> +#ifndef MODULE
> +		if (r && system_state < SYSTEM_RUNNING)
>  			r = early_lookup_bdev(path, &dev);
> +#endif
>  		if (r)
>  			return -ENODEV;
>  	}
> -- 
> 2.39.2
> 

I think/hope this will be fine:

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


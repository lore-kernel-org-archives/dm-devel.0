Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297B9C87FDC
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686120542;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mTQUL2/eg5hluX2AJW8xPox5lRZ0cL5Pv4M2b9/EGuM=;
	b=iBTWqDN80JVJXjucJimnP0eaC6QQv91BZv5iOc/XgdQOf9w1idhJOfAEinG18dn2jrras7
	NivXGu/SUpPO/GmoUyVj28kVW/Bzg6p/L7b0gr6cLN+LTmlUnblp63nwmJb0iT6vohBg8q
	VViGduisILpyZAa4wXqRS8hBKtaZ1Zs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-uiJ3ViGeNZ-n4v1cadf88g-1; Wed, 07 Jun 2023 02:48:58 -0400
X-MC-Unique: uiJ3ViGeNZ-n4v1cadf88g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3F4A1C06EC9;
	Wed,  7 Jun 2023 06:48:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E29F9C16044;
	Wed,  7 Jun 2023 06:48:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C0B719451E2;
	Wed,  7 Jun 2023 06:48:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A3C8919465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 22:52:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4651140E957; Tue,  6 Jun 2023 22:52:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC77F140E956
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 22:52:36 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7B9E2801A44
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 22:52:36 +0000 (UTC)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-oUNyAXXlOkuhRygFVwMhwQ-1; Tue, 06 Jun 2023 18:50:47 -0400
X-MC-Unique: oUNyAXXlOkuhRygFVwMhwQ-1
Received: by mail-wr1-f44.google.com with SMTP id
 ffacd0b85a97d-30ad458f085so14569f8f.0
 for <dm-devel@redhat.com>; Tue, 06 Jun 2023 15:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686091846; x=1688683846;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ZsgUvAUYrCnrR/1XiT9juxzkogVY5Vs72GapwMni78s=;
 b=Sh0K0Xg6fPQfVZTjNTW/KwOMiVpUD2FEKODugabAa+kKw7mEDVMNWtTDf+p8l+zAyN
 wgBhSGvUa0aWCzbmEl8gJSVu80409Z1kQhnLZt0YWQLfohV+dF0novkLz+aLDqV5vcWN
 Yw7peG+w5K4YAVHQKl8pDmnMfiInXcHe/WUPkib3dCB6yGBoPevr0cimxjDuDfFN/m+7
 /kmgbeT0+EehKl5weXlqAfsN/744Gluz45FxPaY8JC1TRCCv9BZc9pnTYTaiXG8fdrTE
 sVcfaQ5rGVmZOoUC+hZj0ABM1RFhvPcZyUt4nIwyl9G1g+Y4l22unh4sefxCgxmNBYTA
 3iJQ==
X-Gm-Message-State: AC+VfDwSQ+htYsKUC4THLwCp3o1rsWaxBQXcZSJB533BO0prUekQIiu2
 Mw3hn1rsMdxHx2KjHoFq/CZ40w==
X-Google-Smtp-Source: ACHHUZ6DIZ/PhyT9JV3FzdchvbYZ3qIwLNNEqf/pmfFBTRfAYv0aDDapWKAK27qD8k0ew1wS3jRAUg==
X-Received: by 2002:a5d:6b82:0:b0:30e:47e2:7eca with SMTP id
 n2-20020a5d6b82000000b0030e47e27ecamr4524731wrx.3.1686091845858; 
 Tue, 06 Jun 2023 15:50:45 -0700 (PDT)
Received: from equinox
 (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa.
 [2001:8b0:dfde:e1a0::2]) by smtp.gmail.com with ESMTPSA id
 l6-20020a5d4bc6000000b0030ae3a6be5bsm13760443wrt.78.2023.06.06.15.50.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Jun 2023 15:50:45 -0700 (PDT)
Date: Tue, 6 Jun 2023 23:50:43 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZH+4QyeJ2WCOaPGO@equinox>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230606073950.225178-3-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 07 Jun 2023 06:48:52 +0000
Subject: Re: [dm-devel] [PATCH 02/31] cdrom: remove the unused bdev argument
 to cdrom_open
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: philpotter.co.uk
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 06, 2023 at 09:39:21AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/cdrom/cdrom.c | 3 +--
>  drivers/cdrom/gdrom.c | 2 +-
>  drivers/scsi/sr.c     | 2 +-
>  include/linux/cdrom.h | 3 +--
>  4 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 416f723a2dbb33..e3eab319cb0474 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -1155,8 +1155,7 @@ int open_for_data(struct cdrom_device_info *cdi)
>   * is in their own interest: device control becomes a lot easier
>   * this way.
>   */
> -int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
> -	       fmode_t mode)
> +int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode)
>  {
>  	int ret;
>  
> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> index ceded5772aac6d..eaa2d5a90bc82f 100644
> --- a/drivers/cdrom/gdrom.c
> +++ b/drivers/cdrom/gdrom.c
> @@ -481,7 +481,7 @@ static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
>  	bdev_check_media_change(bdev);
>  
>  	mutex_lock(&gdrom_mutex);
> -	ret = cdrom_open(gd.cd_info, bdev, mode);
> +	ret = cdrom_open(gd.cd_info, mode);
>  	mutex_unlock(&gdrom_mutex);
>  	return ret;
>  }
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 12869e6d4ebda8..61b83880e395a4 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -498,7 +498,7 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
>  		sr_revalidate_disk(cd);
>  
>  	mutex_lock(&cd->lock);
> -	ret = cdrom_open(&cd->cdi, bdev, mode);
> +	ret = cdrom_open(&cd->cdi, mode);
>  	mutex_unlock(&cd->lock);
>  
>  	scsi_autopm_put_device(sdev);
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index 67caa909e3e615..cc5717cb0fa8a8 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -101,8 +101,7 @@ int cdrom_read_tocentry(struct cdrom_device_info *cdi,
>  		struct cdrom_tocentry *entry);
>  
>  /* the general block_device operations structure: */
> -extern int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
> -			fmode_t mode);
> +int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode);
>  extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
>  extern int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
>  		       fmode_t mode, unsigned int cmd, unsigned long arg);
> -- 
> 2.39.2
> 

Thanks for the patch, looks good to me.

Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

Regards,
Phil

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


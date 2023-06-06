Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B96DEC7EE43
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686120539;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vfyDZ8DEsZ5qC5lRNsozRkE7M/egi165TSy8x+9FRoA=;
	b=RGBRHNuQaLNyh80oE+5h2ITTMBPRV2CBPLant36eGWdMx70dKerFL0BZKWUk5nA0NDc3EW
	ZipOyfRCxl8saquGrP1AZWSRPNkrFGRGRmbuyp9DHRfIYM7lpiGcUGitOQW5+5DdW49FQX
	trjvV6vBh/n4dILVlyPk3PAjTleBWRI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-YHw6CVVSMA2FyzT0AtTbiw-1; Wed, 07 Jun 2023 02:48:58 -0400
X-MC-Unique: YHw6CVVSMA2FyzT0AtTbiw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A709B1C06937;
	Wed,  7 Jun 2023 06:48:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F90DC15612;
	Wed,  7 Jun 2023 06:48:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DC65C19451C8;
	Wed,  7 Jun 2023 06:48:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A93D419465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 22:54:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3AF7240336D; Tue,  6 Jun 2023 22:54:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32288477F61
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 22:54:17 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12319801224
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 22:54:17 +0000 (UTC)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-idGhw0kcNWqrELGUHxPXBg-1; Tue, 06 Jun 2023 18:54:15 -0400
X-MC-Unique: idGhw0kcNWqrELGUHxPXBg-1
Received: by mail-wr1-f54.google.com with SMTP id
 ffacd0b85a97d-30aebe2602fso5373704f8f.3
 for <dm-devel@redhat.com>; Tue, 06 Jun 2023 15:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686092054; x=1688684054;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=WXBt7JZzXPFqym4cCnJPiy0FfIw5Z8TRQSIrowmnJ2I=;
 b=MtSZUR1h4abeOc4TyEj3HzWhAQuQ0Sdt+CAYu1pgKkpe+CLbBbtPX8JzD2Q+K217Ps
 rC9hi4T8s40yuDF8gcWlknXkoy0Y6YdgZuT14FhR8+caFZ7myhB6R9HFLbm7HZlTXeuN
 qjblmY+zwynxDWMpB6+JQRomuhma/kIMMmT8ocwvY9CYSUxo6b/PgrpEuO5kIuJ8b5fp
 hO71Km+yIwuMCmT0cbp2TA+KJTENpBk7JGZau7dbG0FasXQa+G7Lxnd6IXcElxliJSOW
 B+d6n9sr/FNyGSaKOrIX1e95oLIXBiRYfi6CYwSkeTFD8YbgvrmiGDMAjNnvUO94tmY5
 +Png==
X-Gm-Message-State: AC+VfDyQ2wFH4JnoVfZsOkxRP21JQA+HBu8XkZMvo6Q1P6fya41IskrJ
 Rsarng0fKY29xQNo0pgngz9eoA==
X-Google-Smtp-Source: ACHHUZ5EAPVlS/dXZUIlff9U6cMvQ7qyxaaebNKkscChr1x36A65KZewdQ5EyNlkJSg7wU45zOpv+A==
X-Received: by 2002:a5d:458c:0:b0:309:4e85:897e with SMTP id
 p12-20020a5d458c000000b003094e85897emr2751249wrq.17.1686092054063; 
 Tue, 06 Jun 2023 15:54:14 -0700 (PDT)
Received: from equinox
 (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa.
 [2001:8b0:dfde:e1a0::2]) by smtp.gmail.com with ESMTPSA id
 y6-20020a5d4ac6000000b002c70ce264bfsm13877769wrs.76.2023.06.06.15.54.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Jun 2023 15:54:13 -0700 (PDT)
Date: Tue, 6 Jun 2023 23:54:11 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZH+5E5OUUBcE1URG@equinox>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230606073950.225178-4-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 07 Jun 2023 06:48:52 +0000
Subject: Re: [dm-devel] [PATCH 03/31] cdrom: remove the unused mode argument
 to cdrom_ioctl
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

On Tue, Jun 06, 2023 at 09:39:22AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/cdrom/cdrom.c | 2 +-
>  drivers/cdrom/gdrom.c | 2 +-
>  drivers/scsi/sr.c     | 2 +-
>  include/linux/cdrom.h | 4 ++--
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index e3eab319cb0474..245e5bbb05d41c 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -3336,7 +3336,7 @@ static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
>   * ATAPI / SCSI specific code now mainly resides in mmc_ioctl().
>   */
>  int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
> -		fmode_t mode, unsigned int cmd, unsigned long arg)
> +		unsigned int cmd, unsigned long arg)
>  {
>  	void __user *argp = (void __user *)arg;
>  	int ret;
> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> index eaa2d5a90bc82f..14922403983e9e 100644
> --- a/drivers/cdrom/gdrom.c
> +++ b/drivers/cdrom/gdrom.c
> @@ -505,7 +505,7 @@ static int gdrom_bdops_ioctl(struct block_device *bdev, fmode_t mode,
>  	int ret;
>  
>  	mutex_lock(&gdrom_mutex);
> -	ret = cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
> +	ret = cdrom_ioctl(gd.cd_info, bdev, cmd, arg);
>  	mutex_unlock(&gdrom_mutex);
>  
>  	return ret;
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 61b83880e395a4..444c7efc14cba7 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -539,7 +539,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>  	scsi_autopm_get_device(sdev);
>  
>  	if (cmd != CDROMCLOSETRAY && cmd != CDROMEJECT) {
> -		ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
> +		ret = cdrom_ioctl(&cd->cdi, bdev, cmd, arg);
>  		if (ret != -ENOSYS)
>  			goto put;
>  	}
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index cc5717cb0fa8a8..4aea8c82d16971 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -103,8 +103,8 @@ int cdrom_read_tocentry(struct cdrom_device_info *cdi,
>  /* the general block_device operations structure: */
>  int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode);
>  extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
> -extern int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
> -		       fmode_t mode, unsigned int cmd, unsigned long arg);
> +int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
> +		unsigned int cmd, unsigned long arg);
>  extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
>  				       unsigned int clearing);
>  
> -- 
> 2.39.2
> 

Thanks, looks good.

Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

Regards,
Phil

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


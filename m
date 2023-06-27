Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9DCEB64DC
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jun 2023 05:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687844494;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1dMN76XqNK40M3mFM6kCwvfwFC79otJZ6eRAcYQ1g2M=;
	b=Vfq0DrtjgCvB/On6WDL/R057V3aVgYudXJxn5WgNAzp9flOnUWTSwe/Q6pf+yd4I6+uDCN
	cbjyUVvzg+fLS+efwf8rGp4syg0Bas7VMUGuKRdUyJsf0+F5vy9ufHWUNmUwAB9+2IIQtj
	5lqClXU9dLKwlJ3yf5eJi4qNNzqZTjQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-D5eaZKNuNJ-4Leu2CTwQsQ-1; Tue, 27 Jun 2023 01:41:31 -0400
X-MC-Unique: D5eaZKNuNJ-4Leu2CTwQsQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93F741C06905;
	Tue, 27 Jun 2023 05:41:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B29A440BB4D;
	Tue, 27 Jun 2023 05:41:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D0BE1946587;
	Tue, 27 Jun 2023 05:41:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C82F1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Jun 2023 05:41:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D6F16C00049; Tue, 27 Jun 2023 05:41:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CEE6EC1ED97
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 05:41:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B061F185A7A5
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 05:41:24 +0000 (UTC)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-fPgwBEXfNayvtjtnn5YRSA-1; Tue, 27 Jun 2023 01:41:11 -0400
X-MC-Unique: fPgwBEXfNayvtjtnn5YRSA-1
Received: by mail-pl1-f178.google.com with SMTP id
 d9443c01a7336-1b4f9583404so34904735ad.2
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 22:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687844470; x=1690436470;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=eUHv1b8aqLsb4R7LditAal7kNTag6lxKqXAOQ2qujCU=;
 b=hcXJbpHuHfTxWX6rQkl7JBx9Wt24kSgfZV3Q4B+jS4bhZnXFsAQC4xKJKniF6zaEfc
 lkFlNLP0bPG9+bnHjsDlJ0s3c2VjdnNTQM4af8mffla9GMRRM7JuGbFJsCYAeGIZB76a
 o1IiAY7VKazJBYMitLN3vgxD8XAaHuO7V+XiSWtsfN0llT77nbGTnqd18oUGlTZg+yXL
 h3whbF+6HCkW7ca59+nX6q2TnEG2O38DG/Co9rsnUP/eT1hbJC8Lo291Qxghj9EP+QPW
 E7FCJWHS8YQsqhVtG9Snyautzt0ptVHLgg8zTAkPfFlK6hKezlC5u0zbQg2vZ5mV7SjZ
 +RmA==
X-Gm-Message-State: AC+VfDzocqg2vTc7GmWhDTi+mZB/2HfrCn8ZI8ugH94dyThBZno+LzEr
 sh9i4C23r5pVAgboiJk2G2w=
X-Google-Smtp-Source: ACHHUZ4Aj+CfQoLGg0YEyBUDipJUlv6nej6ije3P7CId9SMSoIBcFwHmOjcIwHyQMLpCclEzduuKWQ==
X-Received: by 2002:a17:902:f54b:b0:1b6:b805:5ae3 with SMTP id
 h11-20020a170902f54b00b001b6b8055ae3mr10571515plf.3.1687844469519; 
 Mon, 26 Jun 2023 22:41:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 n9-20020a1709026a8900b001b80d411e5bsm2144863plk.253.2023.06.26.22.41.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 26 Jun 2023 22:41:09 -0700 (PDT)
Date: Mon, 26 Jun 2023 22:41:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <fb21bb8b-958a-4238-aab8-c2720ac519ad@roeck-us.net>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-7-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230606073950.225178-7-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 06/31] cdrom: remove the unused mode argument
 to cdrom_release
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: roeck-us.net
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 06, 2023 at 09:39:25AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

$ git grep cdrom_release
Documentation/cdrom/cdrom-standard.rst:         cdrom_release,          /* release */
Documentation/cdrom/cdrom-standard.rst:the door, should be left over to the general routine *cdrom_release()*.
Documentation/cdrom/cdrom-standard.rst: void cdrom_release(struct inode *ip, struct file *fp)
                                                                           ^^^^^^^^^^^^^^^^^
drivers/cdrom/cdrom.c:void cdrom_release(struct cdrom_device_info *cdi)
drivers/cdrom/cdrom.c:  cd_dbg(CD_CLOSE, "entering cdrom_release\n");
drivers/cdrom/cdrom.c:EXPORT_SYMBOL(cdrom_release);
drivers/cdrom/gdrom.c:  cdrom_release(gd.cd_info, mode);
                                                ^^^^^^
drivers/scsi/sr.c:      cdrom_release(&cd->cdi);
include/linux/cdrom.h:void cdrom_release(struct cdrom_device_info *cdi);

$ git grep cdrom_open
Documentation/cdrom/cdrom-standard.rst:         cdrom_open,             /* open */
Documentation/cdrom/cdrom-standard.rst: int cdrom_open(struct inode * ip, struct file * fp)
Documentation/cdrom/cdrom-standard.rst:This function implements the reverse-logic of *cdrom_open()*, and then
drivers/cdrom/cdrom.c:static int cdrom_open_write(struct cdrom_device_info *cdi)
drivers/cdrom/cdrom.c:int cdrom_open(struct cdrom_device_info *cdi, blk_mode_t mode)
drivers/cdrom/cdrom.c:  cd_dbg(CD_OPEN, "entering cdrom_open\n");
drivers/cdrom/cdrom.c:                  if (cdrom_open_write(cdi))
drivers/cdrom/cdrom.c:EXPORT_SYMBOL(cdrom_open);
drivers/cdrom/gdrom.c:  ret = cdrom_open(gd.cd_info);
                                         ^^^^^^^^^^
drivers/scsi/sr.c:      ret = cdrom_open(&cd->cdi, mode);
include/linux/cdrom.h:int cdrom_open(struct cdrom_device_info *cdi, blk_mode_t mode);

>  drivers/cdrom/cdrom.c | 2 +-
>  drivers/cdrom/gdrom.c | 2 +-
>  drivers/scsi/sr.c     | 2 +-
>  include/linux/cdrom.h | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index adebac1bd210d9..998b03fe976e22 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -1250,7 +1250,7 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
>  	return 0;
>  }
>  
> -void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
> +void cdrom_release(struct cdrom_device_info *cdi)
>  {
>  	const struct cdrom_device_ops *cdo = cdi->ops;
>  
> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> index 14922403983e9e..a401dc4218a998 100644
> --- a/drivers/cdrom/gdrom.c
> +++ b/drivers/cdrom/gdrom.c
> @@ -481,7 +481,7 @@ static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
>  	bdev_check_media_change(bdev);
>  
>  	mutex_lock(&gdrom_mutex);
> -	ret = cdrom_open(gd.cd_info, mode);
> +	ret = cdrom_open(gd.cd_info);
>  	mutex_unlock(&gdrom_mutex);
>  	return ret;
>  }
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 444c7efc14cba7..6d33120ee5ba85 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -512,7 +512,7 @@ static void sr_block_release(struct gendisk *disk, fmode_t mode)
>  	struct scsi_cd *cd = scsi_cd(disk);
>  
>  	mutex_lock(&cd->lock);
> -	cdrom_release(&cd->cdi, mode);
> +	cdrom_release(&cd->cdi);
>  	mutex_unlock(&cd->lock);
>  
>  	scsi_device_put(cd->device);
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index 385e94732b2cf1..3f23d5239de254 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -102,7 +102,7 @@ int cdrom_read_tocentry(struct cdrom_device_info *cdi,
>  
>  /* the general block_device operations structure: */
>  int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode);
> -extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
> +void cdrom_release(struct cdrom_device_info *cdi);
>  int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
>  		unsigned int cmd, unsigned long arg);
>  extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
> -- 
> 2.39.2
> 
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51FBCC87FDE
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686120544;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P+OswAVs6iYYRBmb4LPyM9uuU4XJmGjACmfC1B/f2CI=;
	b=DjhFExxEDI5kG6Xf+DsJ9EQWi4yhvqR7sLlNp0y6xsHuvyuNGfPV8sQiBBAyesglgNVmnS
	O8Ofx2hrgPBMBWX+sM+qevDvjAhbqXMboHxaTyOZxIilTmZBLNIuHl06WLjPKh3pBKtRb9
	UuTUW7AT+D8nFMOPyD9EYkHz8uUSg1c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-8mtok2kpMZSaVs3EgYAp0w-1; Wed, 07 Jun 2023 02:49:00 -0400
X-MC-Unique: 8mtok2kpMZSaVs3EgYAp0w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ADDA8030D4;
	Wed,  7 Jun 2023 06:48:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47152477F61;
	Wed,  7 Jun 2023 06:48:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3475919452CA;
	Wed,  7 Jun 2023 06:48:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 999EE19465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 22:56:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D2BC477F61; Tue,  6 Jun 2023 22:56:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35956403367
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 22:56:42 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16DF385A5B5
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 22:56:42 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-zwRfC3ikMzKwA_V_uBMK3A-1; Tue, 06 Jun 2023 18:56:40 -0400
X-MC-Unique: zwRfC3ikMzKwA_V_uBMK3A-1
Received: by mail-wm1-f48.google.com with SMTP id
 5b1f17b1804b1-3f6d7abe9a4so57218765e9.2
 for <dm-devel@redhat.com>; Tue, 06 Jun 2023 15:56:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686092198; x=1688684198;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=dxnH2bKFZYPbzBbkbYN/M0Q5lBbTzYSqgYP+SCcXSJI=;
 b=hy+Ljhfl/qEDmih6uq9soiYznCZKef5fHnYzzVSO4sw5RT/oCEsr/0JBYeU/G5a7uL
 KFKGOUftc7CLYVMyuhSccjsJKLwd2HdtUk3l08UNhqSKNxTk08QHCFMROI3l9fMG9A+m
 tDmF2HNiq2i9eC06wo3LsAjd2xGB70rXS+x0ezcJa8tSszs3iFxQYvmTMXtQxokNR9dY
 0c6omjXu3KDAtg3yZxQ0A+wVsOquaCx/Z8XFCWkkkP9bSLeoQ4oLRgLw6m8e1xkt/4u2
 yW1xPVU4FimtuJYsRAgtZKHXOrgopk1rguNweSIkDyhgu3PDpJMynY49/8M7n3RPi3iz
 F78A==
X-Gm-Message-State: AC+VfDy+SqHJdgZnUx2qZbX2E3MHfL3ZenCfKA9N3WLkIIq24+yR+LpX
 rEF2tZNAo2V24uhYOR8fqBKo2Q==
X-Google-Smtp-Source: ACHHUZ5pQzUTLLtnHvgmo1ol8cE04EwQ5GBQgMMp4jQLTMwchBoXo98AWKbZj6A4D3QlrXQs6Z+F2A==
X-Received: by 2002:a5d:4711:0:b0:309:4e06:ff0b with SMTP id
 y17-20020a5d4711000000b003094e06ff0bmr2933775wrq.27.1686092198322; 
 Tue, 06 Jun 2023 15:56:38 -0700 (PDT)
Received: from equinox
 (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa.
 [2001:8b0:dfde:e1a0::2]) by smtp.gmail.com with ESMTPSA id
 o14-20020a5d62ce000000b0030af54c5f33sm13658638wrv.113.2023.06.06.15.56.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Jun 2023 15:56:37 -0700 (PDT)
Date: Tue, 6 Jun 2023 23:56:35 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZH+5oxuJzPnIlVxZ@equinox>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230606073950.225178-5-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 07 Jun 2023 06:48:52 +0000
Subject: Re: [dm-devel] [PATCH 04/31] cdrom: remove the unused
 cdrom_close_write release code
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
X-Mimecast-Originator: philpotter.co.uk
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 06, 2023 at 09:39:23AM +0200, Christoph Hellwig wrote:
> cdrom_close_write is empty, and the for_data flag it is keyed off is
> never set.  Remove all this clutter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/cdrom/cdrom.c | 15 ---------------
>  include/linux/cdrom.h |  1 -
>  2 files changed, 16 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 245e5bbb05d41c..08abf1ffede002 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -978,15 +978,6 @@ static void cdrom_dvd_rw_close_write(struct cdrom_device_info *cdi)
>  	cdi->media_written = 0;
>  }
>  
> -static int cdrom_close_write(struct cdrom_device_info *cdi)
> -{
> -#if 0
> -	return cdrom_flush_cache(cdi);
> -#else
> -	return 0;
> -#endif
> -}
> -
>  /* badly broken, I know. Is due for a fixup anytime. */
>  static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
>  {
> @@ -1282,12 +1273,6 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
>  	opened_for_data = !(cdi->options & CDO_USE_FFLAGS) ||
>  		!(mode & FMODE_NDELAY);
>  
> -	/*
> -	 * flush cache on last write release
> -	 */
> -	if (CDROM_CAN(CDC_RAM) && !cdi->use_count && cdi->for_data)
> -		cdrom_close_write(cdi);
> -
>  	cdo->release(cdi);
>  	if (cdi->use_count == 0) {      /* last process that closes dev*/
>  		if (opened_for_data &&
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index 4aea8c82d16971..0a5db0b0c958a1 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -61,7 +61,6 @@ struct cdrom_device_info {
>  	__u8 last_sense;
>  	__u8 media_written;		/* dirty flag, DVD+RW bookkeeping */
>  	unsigned short mmc3_profile;	/* current MMC3 profile */
> -	int for_data;
>  	int (*exit)(struct cdrom_device_info *);
>  	int mrw_mode_page;
>  	__s64 last_media_change_ms;
> -- 
> 2.39.2
> 

All good, many thanks.

Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

Regards,
Phil

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


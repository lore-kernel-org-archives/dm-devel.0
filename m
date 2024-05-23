Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF3D18643
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716482651; cv=none; b=eFi4rUUqbB1u+0nC9kXnLIWmL/SMRnJKsGORmk/bJeXwzVtWD8lGXCAbaDHADchfei9Zpm3azKJLfuIyA0p+SFtZrEWxNBK6LX3juoewzOMbJtNEM+WDR8JeqyQ9R9K4Z5QD1q85ESafSDa4zaWq08kTHv7pwa+rZ8tnvsgr7GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716482651; c=relaxed/simple;
	bh=tGsRzbgSJly0x2ZwKqWs+p+C8ACjpIBp/9ZZ46FSQ6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oL0yxQ3D7uAHmoCej169PR78HvZ/Oa3P3Y84s36+fqpA+cf7kmwNRC7dq3LmceRGEBS3UvGwYC/90hzYlfjO2tkVT7oNenQU/G6pYO2RbovmuwXbO+NNpUFM7AmNtT6ucG3y9lKjCOlfJRtIOUdy43fSAaxMIWY7v3mV908DJes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6a8d467aa23so30915906d6.2
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 09:44:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716482647; x=1717087447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4n1Ukufas5x3k9d6nSTwUuwLfPLiISfXH3RIGG5l5nE=;
        b=f4gn7e2SINkJRfqWvm7ZrmzM+eOSgGG9L3yvdtwZ2c6Hfh11ZM0UdClJv3dKaRxk42
         YAw42fdWOTegy/pVh1H0qVLAD9T2RdGit9o+CBEUzJJml4nMOCnpLYIFDypkT+oSmJEV
         6kz5irBqn0BX6IjC4tK4DjiqtyhadL0F2JQGKUlVU4H1anh+gfm2mrXma7UoMVGbLvGh
         Pnr6MLFVgnadY01kr+PMEKYSqYbNTl3L+gJ9h1bg/0NSSayiEkHXSNxpXr4LMraZTu9a
         ym3+Dvwj13lIxm3tr/btDPEMul77CelxTctqIefZxquxHaw90ya+FJ/4RUeU5kLymfAg
         JGqQ==
X-Gm-Message-State: AOJu0YyhxezaHP7Yd6AMgB9mHyod4NKNTcH2TdRWf1QS4B+tK2+vTv8i
	Vv+fgz+sV6F0YtjCEgYHhiCgMVzW27QpTA7V+w+Ha0idcMqVQ+QDND0hrYNB7Ok=
X-Google-Smtp-Source: AGHT+IHr55IGaupVGA4A50QwEIiHOoepMGyhXvb6sJOp9gNv1ZXbCprmekmZxfLOgwkl17ts7P22bw==
X-Received: by 2002:a05:6214:5988:b0:6ab:9945:9566 with SMTP id 6a1803df08f44-6ab99459af7mr11501966d6.11.1716482647125;
        Thu, 23 May 2024 09:44:07 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a35e6c34a1sm79019116d6.14.2024.05.23.09.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 09:44:06 -0700 (PDT)
Date: Thu, 23 May 2024 12:44:05 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: Re: dm: retain stacked max_sectors when setting queue_limits
Message-ID: <Zk9yVfZ8TEeEQJbw@kernel.org>
References: <20240522025117.75568-1-snitzer@kernel.org>
 <20240522142458.GB7502@lst.de>
 <Zk4h-6f2M0XmraJV@kernel.org>
 <20240523082731.GA3010@lst.de>
 <Zk9OyGTESlHXu6Wa@kernel.org>
 <20240523144938.GA30227@lst.de>
 <Zk9kRYgwhu49c8YY@kernel.org>
 <20240523155009.GB1783@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523155009.GB1783@lst.de>

On Thu, May 23, 2024 at 05:50:09PM +0200, Christoph Hellwig wrote:
> On Thu, May 23, 2024 at 11:44:05AM -0400, Mike Snitzer wrote:
> > a difference on larger IOs being formed (given it is virtual
> > scsi_debug devices).
> > 
> > In any case, we know I can reproduce with this scsi_debug-based mptest
> > test and Marco has verified my fix resolves the issue on his FC
> > multipath testbed.
> > 
> > But I've just floated a patch to elevate the fix to block core (based
> > on Ming's suggestion):
> > https://patchwork.kernel.org/project/dm-devel/patch/Zk9i7V2GRoHxBPRu@kernel.org/
> 
> I still think that is wrong.  Unfortunately I can't actually reproduce
> the issue locally, but I think we want sd to set the user_max_sectors
> and stack if you want to see the limits propagated, i.e. the combined
> patch below.   In the longer run I need to get SCSI out of messing
> with max_sectors directly, and the blk-mq stacking to stop looking
> at it vs just the hardware limits (or just drop the check).

This "works" but it doesn't safeguard blk_stack_limits() and
blk_validate_limits() from other drivers that weren't trained to
(ab)use max_user_sectors to get blk_validate_limits() to preserve the
underlying device's max_sectors.

But I suppose we can worry about any other similar issues if/when
reported.

Please send a proper patch to Jens so we can get this fixed for
6.10-rc1. Thanks.

Acked-by: Mike Snitzer <snitzer@kernel.org>

> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index a7fe8e90240a6e..7a672021daee6a 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -611,6 +611,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  	unsigned int top, bottom, alignment, ret = 0;
>  
>  	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
> +	t->max_user_sectors = min_not_zero(t->max_user_sectors,
> +			b->max_user_sectors);
>  	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
>  	t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);
>  	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 332eb9dac22d91..f6c822c9cbd2d3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3700,8 +3700,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	 */
>  	if (sdkp->first_scan ||
>  	    q->limits.max_sectors > q->limits.max_dev_sectors ||
> -	    q->limits.max_sectors > q->limits.max_hw_sectors)
> +	    q->limits.max_sectors > q->limits.max_hw_sectors) {
>  		q->limits.max_sectors = rw_max;
> +		q->limits.max_user_sectors = rw_max;
> +	}
>  
>  	sdkp->first_scan = 0;
>  
> 
> 

Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9278113475A
	for <dm-devel@lists.linux.dev>; Wed,  6 Mar 2024 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745946; cv=none; b=ZLPzuNJzHyLk1LkP3YQtoPdQYotSf7wyfou7gYmfqEVEunDjNTLeNcW0PbvzBWqTaD4O20LHb6ro81k71HrT9J3NeRqbPlqwtXzR9OOXeJKakdLtfQ8c9iQhP7Pskb7vDZ+XcYG+QRBXoRlWJzE963yYJYr5uQg4SwN63La6GHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745946; c=relaxed/simple;
	bh=8p2opZvkqwz13/KE3xtrCvYEBGR5Menz1ZsHlu33loo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jyZgMLXg0mWAS0a/qq1ymJ18Vdv2vAa/sNqNOrmPGq23xq0wDOPU1OjS5bJNxTbM2Qxdq4APRdRxj2lttOGPP7OPNgTlMmcneD8xzsLxTvr4+HDnh5pT0vBfFba4+fIEhTL0ULOCgJI3VxO5hn4q5N5KHSfAFCqUyamrzJKaXQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-21e6be74db4so728269fac.2
        for <dm-devel@lists.linux.dev>; Wed, 06 Mar 2024 09:25:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709745943; x=1710350743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lICbiutwJIIAg+5ET7ThLgtawqmnV2P0QQDIe0xrltM=;
        b=NNDqbmEcE0vzEBBxlkiYSaLtXqZYquGBpl9Me1fo03gfegV6VyoNwHqhqvauw/TFx1
         GT+fUC7jI+D9J1FhEaUHgvlHoq96buJkIBJIAVNp//OpNHziE3pdeDp3bgMVWHklgb0J
         DzcRYjuEHsHQjOd1tVlNQpeqCxNgutlsyPKyY3o5bEpgslPIBH41Ol3zOj2X7sq7aZUS
         uKV7vkhspVD6I8Rg9kEOD0rsQF4NCAbE1hvJ9b4m49WzYvPRh/ihs6kbR+/lZbURc9B9
         9cttAEGV6MnRKauqaBMjKPljV3p9IdzW7kKcuiJj5YRX1GYCDQA6G/cAMfwBdHtp/Rtj
         0QBw==
X-Forwarded-Encrypted: i=1; AJvYcCUo8xjlR2Dm62WPTpC/1nhCOsxPnHEvTWqpudB9iJUMNX17LUk2ukGdxO6y3WNJTt7T2SX1DrcUZ+NwiyYWJZXqJxMqlXBOR/A=
X-Gm-Message-State: AOJu0YyHNXinrl6eg/eoJt0pCmymQAy03xRQUVpK4IipjgI2DdMNZKqd
	yeaAmSvs+LAn/wwv2vii/3iglAmSPB4LLwWWyGqT7OuvLf+OJb0MTkB+lhlQ5g==
X-Google-Smtp-Source: AGHT+IEdsnL3H44CitlVgXc79s74rTtqtEN4ML5+/b1ZAmEVQMCdoGLTdYY8JEGFQDrqRWcv7J2kZw==
X-Received: by 2002:a05:6870:ac12:b0:221:42a1:9457 with SMTP id kw18-20020a056870ac1200b0022142a19457mr5265846oab.9.1709745943643;
        Wed, 06 Mar 2024 09:25:43 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id i8-20020a05620a0a0800b007883c9be0a9sm1108184qka.80.2024.03.06.09.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 09:25:43 -0800 (PST)
Date: Wed, 6 Mar 2024 12:25:42 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] dm-integrity: set max_integrity_segments in
 dm_integrity_io_hints
Message-ID: <ZeinFsPEsajU__Iv@redhat.com>
References: <20240306142739.237234-1-hch@lst.de>
 <20240306142739.237234-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306142739.237234-4-hch@lst.de>

On Wed, Mar 06 2024 at  9:27P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Set max_integrity_segments with the other queue limits instead
> of updating it later.  This also uncovered that the driver is trying
> to set the limit to UINT_MAX while max_integrity_segments is an
> unsigned short, so fix it up to use USHRT_MAX instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-integrity.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index c5f03aab455256..a2e5cfe84565ae 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -3419,6 +3419,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
>  		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
>  		limits->dma_alignment = limits->logical_block_size - 1;
>  	}
> +	limits->max_integrity_segments = USHRT_MAX;
>  }
>  
>  static void calculate_journal_section_size(struct dm_integrity_c *ic)
> @@ -3586,7 +3587,6 @@ static void dm_integrity_set(struct dm_target *ti, struct dm_integrity_c *ic)
>  	bi.interval_exp = ic->sb->log2_sectors_per_block + SECTOR_SHIFT;
>  
>  	blk_integrity_register(disk, &bi);
> -	blk_queue_max_integrity_segments(disk->queue, UINT_MAX);
>  }
>  
>  static void dm_integrity_free_page_list(struct page_list *pl)
> -- 
> 2.39.2
> 

I've picked this up for 6.9:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.9&id=f30e5ed1306be8a900b33317bc429dd3794d81a1

Thanks.

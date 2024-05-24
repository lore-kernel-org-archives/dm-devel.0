Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C0586644
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716563718; cv=none; b=FDLArfyFhcLS//WuBaAOP2WSYyL/hs0X0pIWyd0MPorI8xuX7TySgY1fYE+XklUH36dDwlJwN5FlUYq8o/y2asomlfJkvlXFhPbcicpntjEN5WEG0qccpRGqiBLuwffxTFx2IuMh/woyVnVxO9i5larpJTlesE0VBpyYTUiM9Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716563718; c=relaxed/simple;
	bh=PK3Chn1n3FDpFF68fBu0cdH/B8j8uiYUDFUCiWPnUeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gP8SIz6nDNoT+Wem9t7gEZEAku6SPUjy0AKQ0EYlM4jhRlQucdyb4gveNBZ8GxI7lNOoGCfb6shs2d5mAVqMUwML5CKYZ/toEpfjnWb8Afl+G4irBzQZsY5YgT978xogk0ZCevUKoaslIfzbqItUcgpTYn7clXlQAd8Y/oXujlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-79476195696so210779385a.0
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716563716; x=1717168516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EgUFXDx+j6+4OwhWjZuyPOUw01c6midm0HEOLKcMek4=;
        b=UB+sBWb/poWTQBbrVwok799EHjyyfkYKFiZN1mEhjosrLJA5qDZ5RpP9TUldZp23eM
         JfiRsyQIrzKodBvR8kADe0z4vLilXIIwAh3n+aOZNEJZCXrQTAm8Qyf/EQUJPm97Wvr1
         slCbtewnNmUJYAvIoKS4yVLoWq+3mRiTUbHGuIvl7o8dsknJaG0rqF23CxzOMShzEiP1
         3LVihVgjr4EWdckSyIhAb/UDVYuphZfihTbTr8BDzUzzILTmYtwJ0hF94HC4iHmcBw2i
         rhdTnIgLUX+itLFBgZ4KE9JcGFucWLwwQhbdEOgNST33WEI4sjjzenKNM3eyQD6K/MC8
         lM1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDVYflCrR7NJDLa5BZtQOMtov5XddIn0TxepJwgsnrAjQhWTE4QmOHSOgWEASn0lkLhIXTsatM0PO/9wj6D8XytN1Tqi0wgtc=
X-Gm-Message-State: AOJu0YznMQj8LIleuZatS5f6BYbwJn9f19ivUplnlBUSv7Z30PGhAmBO
	kTuOGmb9rFUq2bpUmZ95jFvL2zHjsI8xjGfixEAORHvJtMXXx0JLdbzAtCxdRlWb6G+Mbc5lo/P
	/wWjJWQ==
X-Google-Smtp-Source: AGHT+IFiVubC18li5AHbPeXFtwMRqBru7bkWoNPjM7qBG/0zYpgT5PRCYNQN18UMNDfIvaXKXw3cVg==
X-Received: by 2002:a05:620a:4310:b0:793:fdb:ca3 with SMTP id af79cd13be357-794ab1125b6mr304227185a.59.1716563715516;
        Fri, 24 May 2024 08:15:15 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-794abcdb0eesm71621285a.62.2024.05.24.08.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:15:15 -0700 (PDT)
Date: Fri, 24 May 2024 11:15:13 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 3/3] dm: make dm_set_zones_restrictions work on the queue
 limits
Message-ID: <ZlCvAZMBftEgovjJ@kernel.org>
References: <20240524142929.817565-1-hch@lst.de>
 <20240524142929.817565-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524142929.817565-4-hch@lst.de>

On Fri, May 24, 2024 at 04:29:11PM +0200, Christoph Hellwig wrote:
> Don't stuff the values directly into the queue without any
> synchronization, but instead delay applying the queue limits in
> the caller and let dm_set_zones_restrictions work on the limit
> structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-table.c | 16 +++++++++-------
>  drivers/md/dm-zone.c  | 11 ++++++-----
>  drivers/md/dm.h       |  3 ++-
>  3 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e291b78b307b13..6e4ee829005e92 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1981,10 +1981,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	if (!dm_table_supports_secure_erase(t))
>  		limits->max_secure_erase_sectors = 0;
>  
> -	r = queue_limits_set(q, limits);
> -	if (r)
> -		return r;
> -
>  	if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
>  		wc = true;
>  		if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_FUA)))
> @@ -2036,12 +2032,18 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	 * For a zoned target, setup the zones related queue attributes
>  	 * and resources necessary for zone append emulation if necessary.
>  	 */
> -	if (blk_queue_is_zoned(q)) {
> -		r = dm_set_zones_restrictions(t, q);
> -		if (r)
> +	if (limits->zoned) {
> +		r = dm_set_zones_restrictions(t, q, limits);
> +		if (r) {
> +			queue_limits_cancel_update(q);

Not aware of a preceding queue_limits_start_update().

Otherwise, rest of patch looks fine.

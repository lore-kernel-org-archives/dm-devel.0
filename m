Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1649D6BFCE
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 03:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749612539; cv=none; b=fgYxe6HXEzBibmx0bEsdV6mt7YIfqXjfOZ6dWsEFW64uOihtzKRkCsKXMebYMiIYupXC0mI+5qcYWYpoz8XvRXQ1Wo/CHXyyxlXgEVHnbcO10BUWdU2QasIR7khu1tWpNK2TIHj7s3FAP1J1IBmmZFktKc9aQf+J9yLBsKxrjsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749612539; c=relaxed/simple;
	bh=8FunIT8S3lGgocZCCALVWLaKG03mDmb+M3M6Cswb9Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYa5k5dfsCzFel3r2LpSHXIdZ37dv1Jd9avV2Sl6mfMqnyMgP3b4T4WzKvZ/dZWcNnYqzGefzmV+ESvG0KBThApP3a8KAdVljPWVRyaGaHqCRRCd2CMVWorBYc7vBsJYeL5qH8BSr5EKfIXEDr8juFfnvBNmU0+2FcqQEhCjTZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MXZukLmD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MXZukLmD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ef82hlU+7lHyJFhEAAueejXoix5Hr6rPcrAOJF7VcUM=; b=MXZukLmDd3o5F9FLg1P265YE58
	32UHV4Z/9smkenObklAS8Ej0twWvobzN36cbB2uP2W6A6u6QaeRKs89ypfm5ATdFaE4LgITQuBL/F
	FjHg5ICW00HfQRnS1MoSoOxnkUxRvMHa4AY27CtONMCqqbszoT4ddnZ+5lOTxGamDFD3zmfi6sIfD
	fGY/y8tn7O+M7zdTH9j79yFD8yPBir2WK6BFYxd9ArAYWu8QNsM+kalOi/LITcQh9FDCMsyjOYES5
	5wl6QnkKrHoWsmtAnRUox1EndkfneWjE5THkStGAfjUfEXwwEmaY4MSaQzNvdfjIaUOqgrP0R4xJp
	Sju1TGXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uPC93-00000008jpI-3TFM;
	Wed, 11 Jun 2025 03:28:57 +0000
Date: Tue, 10 Jun 2025 20:28:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] dm: Check for forbidden splitting of emulated zone
 append operations
Message-ID: <aEj3-S0aJWU5iEVg@infradead.org>
References: <20250611011340.92226-1-dlemoal@kernel.org>
 <20250611011340.92226-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611011340.92226-3-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 11, 2025 at 10:13:40AM +0900, Damien Le Moal wrote:
> @@ -1322,6 +1323,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
>  	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
>  	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
>  	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
> +	BUG_ON(bio_flagged(bio, BIO_EMULATES_ZONE_APPEND));
>  	BUG_ON(bio_sectors > *tio->len_ptr);
>  	BUG_ON(n_sectors > bio_sectors);

Shouldn't all these be WARN_ON_ONCE and error return instead?


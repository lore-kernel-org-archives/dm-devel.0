Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713F364D6
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 06:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732515083; cv=none; b=iBkoG1WX45pHeaFibZd5/X3xjBYA106huwnEWRQH7OdTgVmsJhTFbAFgO+q3YVyWoMrQtOyU6/dD6CWYrKjh1MXVUefovMFfsCJS47vTBj0fDsfz1IlBQLJFO3G/KhHcgxSArOyfzPW91+1rPo6l7xGjf2kYRjwyHNPqgtQCY0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732515083; c=relaxed/simple;
	bh=nRSl5fXKNqYlZjMRG0Mtuvnlq2GuvX8aXram9ZgrUUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkyFyjTKMhQwXzHeJjRf2BBPNPpJhI9u2PnJL57Drms4hZBdJq/y6oA+xeU8VhLHjXTQAMWcb1qYZ4Ensf8QhMsAZvbypN2XWmEf5FSkJCMdsupc1kIUkvhBIQdGalbsnEWs3VmbelAgz022Ap6TqGnNzHBjX2XQJTNdnVhxQ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w4N9zXhJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w4N9zXhJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lqfEwiii0RFf+iWBB395SxN+IJUaOUzZo6cMBeJONho=; b=w4N9zXhJmD0RjhjpD4gBhGfhLZ
	e33w4y6ulNgLThtv8i0K5ZU+XHBCdoVA1zk+BdkMLYDrKuxw5Q/bwNtTw9M3wy4qbesm6geyxvNwY
	35K8bUjvbbAYYHNsWLLhG5hhb92sxjZB1yitW8xU8p39BE3CRsqVYjWLcgDuNv2uqjo1DFHFxhMGX
	3/7KYS3QJ+jYUWrjpqTKfuSKG8jo5W06HjuSXXgwtzMq0c5+JyPsQ183IjndEtVwRIIJRibn/6PJc
	I9gyBDNhGiJju3EiYtzRbv6Ibu+0fl+C78aoJVo4zq9tQzdNgu0m9kjMlFvNVBlSCrH4kpy/MC9Jl
	KORjw79Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFSJd-000000079JY-1Jhg;
	Mon, 25 Nov 2024 06:11:21 +0000
Date: Sun, 24 Nov 2024 22:11:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	=?utf-8?B?6Z+m6b6Z5bmzKEdyb290KQ==?= <weilongping@oppo.com>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"ebiggers@google.com" <ebiggers@google.com>
Subject: Re: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
Message-ID: <Z0QVCemvU5_5REWB@infradead.org>
References: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
 <Z0QSqndKs1fyiOmJ@infradead.org>
 <b01f1929-f1bc-4ed6-ae57-dded68f23e26@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b01f1929-f1bc-4ed6-ae57-dded68f23e26@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 03:07:24PM +0900, Damien Le Moal wrote:
> 100% agree. But in this case, dm-crypt sees a single BIO which gets split when
> submitted to the underlying device. But the split issues the requests in
> reverse order, which breaks write ordering.

I'd like to see verification of this.  People who send these kinds of
odd old kernel reports tend to have weird patches applied to their tree
as well.

Without an upstream reproducer that actually shows issues I think
this can be safely ignored.


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E20258A;
	Thu, 10 Apr 2025 07:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744270575; cv=none; b=nGh6EVMoYliPcPOnBKdjkiO8G9o1HqA6+hT0BoahoJ/ysWtyus8V7m9E37KljbenGLqpkfzonbQ7xq5um/ffAjuUn4jEtFBynb24oxuRBvX2/ugrJwxMsh/plaHBJ4FMsUPO4+tNkJEnSV1Tg8Msg/LMuyH8rVVFjpJ6fiWlcio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744270575; c=relaxed/simple;
	bh=PkB9Sd7WAZ72HPghU2JQ8fpnzq1QgnUWnaKuvqxAyxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDogg8rEAoyC5v0CGQg9QzTw2HczY28kDTgvP6qC91ZLdoqYBlmTZhj0j7Kw3sYfter3wPZowxeG1ZwWFDGs+P+N7RVxEH/sZbbyxU8CDJLy/pxT42fvulQ5dG0B+kITl8ZYO9z7bt5OujPFc8pX6K8kn7H8ItcSv1/0ox22qTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CAeq1jw3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CAeq1jw3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QMKa6eYG5dZhaQEYKdrpNMNE122GZcpoMQ/GqSsxHIk=; b=CAeq1jw3gWUcnunQtWz00D+hix
	yqZdlzHunLGHUJLbyRL5clv4yfNNHLrMWcmqKvGIv3OUrzQ2kHYf62urnqH5u9/K5NIBMcjkBqwKJ
	i3oyAJlQolr4OFwMpS/gQSoW3gxuuqa9IBS88NywlLLbfYBIduD5Fqihcrbj12ivhAbbBRItNnnuQ
	zmQXE7IjVzhOGr8nsLWdIkbSefuIprbqLBFpjvo9gGK/6jlUrBeWkcKz1ObmAkKzgxXXEhmOazerS
	viWfIaz3uHK6ydhfkT8M6W48pvNvGOnCdfOmV14uEbxTphpfvUXKmPhjVmdHelje6NgKfnMJCjxNM
	8RKjUgPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2mSK-00000009aET-35os;
	Thu, 10 Apr 2025 07:36:12 +0000
Date: Thu, 10 Apr 2025 00:36:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: snitzer@kernel.org, mpatocka@redhat.com, axboe@kernel.dk,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	guoweichao@oppo.com, sfr@canb.auug.org.au
Subject: Re: [PATCH] block: Export __blk_flush_plug to modules
Message-ID: <Z_d07I1b71zQYS0M@infradead.org>
References: <20250410030903.3393536-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410030903.3393536-1-weilongping@oppo.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 10, 2025 at 11:09:04AM +0800, LongPing Wei wrote:
> Fix the compile error when dm-bufio is built as a module.
> 
> 1. dm-bufio module use blk_flush_plug();
> 2. blk_flush_plug is an inline function and it calls __blk_flush_plug.

Then don't call blk_flush_plug from dm-bufio, as drivers should not
micro-manage plug flushing.

Note that at least in current upstream and linux-next dm-bufio does
not actually call blk_flush_plug, so I'm not sure where your
report comes from.


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198CD382F09;
	Thu,  5 Mar 2026 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719971; cv=none; b=uKIBuyY3f7or0QLvrMw5zF9zW7ForXSUzXnKVOyvMxEhZshEJtaUByuyyndLD9G9k5/gcolChe+46uOYXSWyVQH9qvHvZG+K1zEoMR/liPLf7gWYz93tVC72l0bxmnO0Ke+7qZ/sj+RfWYE5Ch/8jn0nK8JcBqswWcG+y6T9wyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719971; c=relaxed/simple;
	bh=/ypjBRigD+SCCwYHLm8b2DgyPoeBnPa1nJ0ce3gNX7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZnfksudmbGuFFTRZIPEJZe8q5QDDghWHuQNq60A1X+e19bGd2ny3uLrQ719ZFDxQjNslktvgYTq2qzigLsrkpzzHcBnMAqkG1xXnLMg1XJIUV1FnNK2RBI70bBFQITtZsXvt4jLZmbBDOF9ADO/IUEd/FkW6gdvZN/p/RzibgAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EM5q36QG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EM5q36QG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IO6QMfBHH8sMK+gsIVCR4BlKaz4fOls25p0dmnSxTg0=; b=EM5q36QGse8Eo0rdRyuwEK0kug
	POFFSpf0FFYzOJTVE5uLbRO3DCfB160ZZqk4rXNER8kLMqP6pjdqRGQdu3Wv1bUUUnJLpRiAL9/HQ
	jgUBJGbLO5UZ4bZSerntEBKkY/QRv4PNEv07OkOuskyR2pRgnsJjo9LBHTLEqBL/FNGQHc6Nm1cC/
	nNV8/XRfxLaZQunjXq1DcQwxccMR0XQVDaXcaBuvmW4zOUzPW16fx3b9qiKQmFTNVoxv9bekfTegc
	XUwq7ye1qckYMF7lOie+IMOP3XtMbX/ahMAqSi5tuPvP/4OSsf9HoHYYQJxRdS2F7Oobc9Lbh0x05
	uVpsHBRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9RZ-00000001vWO-2ZpE;
	Thu, 05 Mar 2026 14:12:49 +0000
Date: Thu, 5 Mar 2026 06:12:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] block: consecutive blk_status_t error codes
Message-ID: <aamPYU19Qdh-6R8m@infradead.org>
References: <20260304190424.291743-1-agruenba@redhat.com>
 <20260304190424.291743-2-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304190424.291743-2-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 08:04:06PM +0100, Andreas Gruenbacher wrote:
> Since commit 9da3d1e912f3 ("block: Add core atomic write support"),
> there is a gap in the blk_status_t codes and block status code 18 is
> unused.  This causes blk_status_to_errno() and blk_status_to_str() to
> return incorrect values for that code.  Make the blk_status_t codes
> consecutive again to avoid that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


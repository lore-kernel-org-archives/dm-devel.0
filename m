Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093C61DF987
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 08:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744273797; cv=none; b=PJgg0CphE9/PJPkpAH70W/jHlrRTynL2wAQ1WMfeavBiz0/hk8P0cL+7twdCra+8v++4dJgLIqjyxV21KkFuoByoYjctNH8oTRrGPqR+iy9q/7FTSDaMuBgOtdnLI/cF88YWBBNtOlwPtmIdojsnaIq8ljhe+R11BC9EsHATZjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744273797; c=relaxed/simple;
	bh=sUCkTkml+mavOYWjQeUm/e+gVmf3mBlsyejuA6xFVm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZanN4W+Wsv4U/R4OUVhQureT/DRncNRdMarkOq1UyW2IDOjYjoSJ8ldmQv5pVBZFB7JFpQQMd3ymv/7VP55w95bpbIS2QFWqrA4e6/rSr8nEHr2FZHqzJyyKJQUBZNCEyWOWG7taWsqX43xHBQtDiYCJ01U4IqhMQLKGw+hKqig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s9pYB2nc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s9pYB2nc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SKs3Xz92IRG/I9Iglon0RYrCZgqkoRubUT1yInkYVM8=; b=s9pYB2ncZLDXqpOiZrYA14rvQD
	+uCnVc2qBZBwnYIhUXEJMn8lktZUv4mMCPN04ae00HOuWWhtRwHXc63z6xOFq57Db32oFZexxpX1C
	BwiuZTOgUALF4ppvXqDVfV7Y4fdeNXAgcLLnY9V+E3+0QwgECN0OBcthpB5+RQP8A+YYBg+rPIIpi
	je7uOdHpAkvZYi+1QWciMXq0OPwFqVHnGHC/qGW4HsgjCbVuL3DZAMxdgoRghUxuDuvN8wW7rGmdu
	YUVk1IvTOFyO38WM78EZp1aK6WY76xgDigegIUe6L9NLQhe4jn7MKG07bCn3551LH1yQTa6eiFU40
	7LQuszmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2nIJ-00000009kfg-2BWo;
	Thu, 10 Apr 2025 08:29:55 +0000
Date: Thu, 10 Apr 2025 01:29:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	guoweichao@oppo.com, ebiggers@kernel.org, bvanassche@acm.org
Subject: Re: [PATCH 1/2] dm-bufio: improve the performance of
 __dm_bufio_prefetch
Message-ID: <Z_eBg4v5wzs7F7Wp@infradead.org>
References: <20250402070934.2387587-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402070934.2387587-1-weilongping@oppo.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This commit message is extremtly sparse.  Not helped by the fact that
the series also misses a cover letter.

On Wed, Apr 02, 2025 at 03:09:34PM +0800, LongPing Wei wrote:
> 1. call blk_flush_plug when cache hit as the address of the subsequent
>  bio is no longer contiguous with the previous bio;

As you found out blk_flush_plug is not exported, and that for a good
reason.  This also completely fails to explain why you want to do
this and what the measured benefit is.

> 2. skip cond_resched when ioprio class is rt;

Same here.  Also these look compeltely unrelated and I have no idea
why they are in the same patch.


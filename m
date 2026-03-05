Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF8D382F09;
	Thu,  5 Mar 2026 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772720015; cv=none; b=gF9NsHZpNjdrPmC8tBlhkxNE1ivy+Ad3EfCP0/fqcwGX2Dy4pLBVbylRbz0oXXq5urTr+UeCVkpytum0TbXMli6/M+4EEA7JSPrLTA1NtHpkeW+ybKlj7r6POzIAP7gx4Y6VGQFAhj92Ptx5Ldwz/vuwK9+2Ih+YypWtWFAxPRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772720015; c=relaxed/simple;
	bh=VbRuujenCvLTP00jGZsikb0MM2gg1vqiQ3pM2WsNfE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KY2Ma2aOn7bNyEzyEQTKgY/Ks5Hy74QvCqsDftgpNFs+JHwz+GP+Hq7KvLvoC1OS27hd4jVD1CK6HsgYITCrF3fJGouKiexP+I2w0YjwypyP2vox7dKbOW5I+APGB9T1MkQSzYm1H0MweoiGqqKyjWyu8+l7vc+rX479SADKuc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JZFHlKMr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JZFHlKMr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TJHqUqNeTMnXyeDzlG2Ut7/dGbTr+YA33QxUyT5WrQw=; b=JZFHlKMrZ1roVh1G0oP4L2vexm
	FrZLBd0jy6czxnRKQ/Lp3Npu1Qkrd7nbareKkkH2li+1DxXvSs8mlSnt2tdCuiE4YnjL/3vgEJ6CJ
	m9GkA7a20axqbOCR/1dnVqK9zB5Z3dhfQkuoOK3kNxyT6XDzbneSodjsnP1MlYd/5Z2L9eUpBHMQJ
	pzhwzOFNoBtT+4onbzGRsbncLY5EMgD8EEesXVvOH3CyEFYYFOfMKFZKt4m86vEcMuEuh+INhV23+
	H/NL9mqTOZOo53eCjEvvM5LdzVOUt2x4shKhcQqbcqy4upmn6LNgg8Exm0P0vds/XCM8XadKBu7QI
	+e3ZJO5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9SH-00000001vXu-2o3v;
	Thu, 05 Mar 2026 14:13:33 +0000
Date: Thu, 5 Mar 2026 06:13:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] block: get rid of blk_status_to_{errno,str}
 inconsistency
Message-ID: <aamPjXeF0qHlhJZu@infradead.org>
References: <20260304190424.291743-1-agruenba@redhat.com>
 <20260304190424.291743-3-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304190424.291743-3-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 08:04:07PM +0100, Andreas Gruenbacher wrote:
> Change blk_status_to_str() to be consistent with blk_status_to_errno()
> and return "I/O" for undefined status codes.
> 
> With that, the fallback case in the blk_errors array can be removed with
> no change in behavior.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

While you're at it: blk_status_to_str is exported, but as no modular
users, can you also drop the export?


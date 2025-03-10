Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3144616D9C2;
	Mon, 10 Mar 2025 10:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741603347; cv=none; b=AHtrsQn98Z7zFqg+sjI0mZtJ3d62hDvVhStGlSIgBPkDlJeltRRBbFita2vR796rsEGIwA7FIrCE3pQ+mK6J6hTbCECJ6ue88F+5ueMhoNzIQ+Wwws7ytK9Wc9FCOp7Ldu/4TrU+/EWGkxRrlFp3DtC2y3iQlhVNs9f3maC0Zfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741603347; c=relaxed/simple;
	bh=BchiH3ks/Bb+a9/rT5xqXs4QG+DKMNtdKB33D7ZrnDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=adVr/7v2N40f4ABHU81oKQacCw6vQoraJlsN/kJLzbMTtvXFjQPUg70nZvB8CWLPwa4X36uI5kV8ZYpn2vmrSjdjY1xZkrPLu8deDkBCl4IfTFLvNCIcPEPZdTuPc4IeT9vmqXJ2oguE1xQ161OfoFp/eiYbaqJ/fvY9J08FUYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kll8VgK7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kll8VgK7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=BchiH3ks/Bb+a9/rT5xqXs4QG+DKMNtdKB33D7ZrnDE=; b=kll8VgK7x71s7MRcsXZaZljJ+d
	CZmyUA4t9opO/YG6CSrjVYn/PDWzBn0UCVrvG/B7gsNpbxizd/6e6LxFKha8AdunpZchZaxv2CU6e
	clMZLChAMVQ0Kg9RVDeojpBdencE/P/cV1vv7JbuUpxnIkIuY2qDUFZ3+KXvVyvAvQHC0f5m3Wass
	9VChsgreKUfJY7zvzTAaWAjX0MgWXs7CPEpPm9NAkIxUOESl7+8+5O7Z8qFM4edKjia+aYW9A68n+
	3VBfCA7Yqr+JkMzkeMMFbMKNdOxVBLZxWFrxwn7hD2D2G42uSsxpPtYHneh85rofjNu0h+TdtxoiI
	nh7fgzsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1traaQ-00000002Hm0-3Vjm;
	Mon, 10 Mar 2025 10:42:18 +0000
Date: Mon, 10 Mar 2025 03:42:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] block: make sure ->nr_integrity_segments is cloned in
 blk_rq_prep_clone
Message-ID: <Z87CCuYFgA71JvXV@infradead.org>
References: <20250310091610.2010623-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310091610.2010623-1-ming.lei@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 10, 2025 at 05:16:10PM +0800, Ming Lei wrote:
> Make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone(),
> otherwise zero ->nr_integrity_segments will be observed in
> sg_alloc_table_chained(), in which BUG() is hit.

Maybe reword this to:

... otherwise requests cloned by device-mapper multipath will not
have the prope nr_integrity_segments values set?

The fact that sg_alloc_table_chained BUG⁽)s is just a symptom of that.

> Cc: stable@vger.kernel.org

... and replace this with a proper Fixes tag?


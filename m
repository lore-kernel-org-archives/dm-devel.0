Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A0324E01B;
	Wed, 12 Mar 2025 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741789215; cv=none; b=q5QJo3QyFpYN+WdAMy2mlDszJyfpRlx5sEXh+hjFLQSiM1zKutM88veLkLy/O/6d6lXL0nc328Ia4iCZ5srCMSSQS7D8Hbskj6XF5l46x9fTD4w8tvHwg3xcHG4plrtFDebTj72xcGCcSCYcCgZBE45XJrWl80jUBz41YlLSx84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741789215; c=relaxed/simple;
	bh=FVgwkNvdBVna1lZKEuoxhUiMfcQJE7r/RVcXktgflO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXPTyF0BP1k7TxNJy+HJSlzOeZuS4dmESXPuzDS9vcS4+hwM1c28AZ2tRqH8yU+N42xbzZozEaXD+tZWcpTfm9rhHbpqrP0B0Lds9b9iwesUtqoQyCMP6DOgPOFv51yeAn0pKAbSnlQGsXn4ciL00nD3KEmYvS8dv/5mBvUNbwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iYn2cEi0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iYn2cEi0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qKvB2nlT3iUgjzyDXuqxiMFS1Em8INDMpJfZqPHhHac=; b=iYn2cEi0fHqMF9jO945+0Payis
	ebcZe3lInCyVQtA+Cpk69+kFkR76CPVVG5sWIB1AaJj7JPcZb82CbVScbWZQz0xP73IhCe/l9eS0B
	gw+nctm7DFDdVykaTKLxCQU2xGZEu40w/fgZhIPiMVIPTwZj0VJxv7wWCvpAzQ3bkzq879siKtCTH
	r/i1iXP++jhEEGCpf8DzQQBJZKbggvFv+hEm6bF7qKoD9UlmsZtH9o3A4JAW2KZKjgU63y36D1SpG
	xM7V2kRkanFltPH0HfXyyZd6M+giV8yS0UnMLuPsaMlTzI7uGypDhKznDG5LNMBGK9RPcDgeg+wJ3
	ZMFdBEEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tsMwN-00000008ffL-2u45;
	Wed, 12 Mar 2025 14:20:11 +0000
Date: Wed, 12 Mar 2025 07:20:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z9GYGyjJcXLvtDfv@infradead.org>
References: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com>
 <Z8W1q6OYKIgnfauA@infradead.org>
 <b3caee06-c798-420e-f39f-f500b3ea68ca@redhat.com>
 <Z8XlvU0o3C5hAAaM@infradead.org>
 <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>
 <Z8cE_4KSKHe5-J3e@infradead.org>
 <2pwjcvwkfasiwq5cum63ytgurs6wqzhlh6r25amofjz74ykybi@ru2qpz7ug6eb>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2pwjcvwkfasiwq5cum63ytgurs6wqzhlh6r25amofjz74ykybi@ru2qpz7ug6eb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 12, 2025 at 09:26:55AM -0400, Kent Overstreet wrote:
> We might be able to provide an API to _request_ a stable mapping to a
> file - with proper synchronization, of course.

We already have that with the pNFS layouts.

> I don't recall anyone ever trying that, it'd replace all the weird
> IF_SWAPFILE() hacks and be a safe way to do these kinds of performance
> optimizations.

IS_SWAPFILE isn't going way, as can't allow other writers to it.
Also asides from the that the layouts are fairly complex.

The right way ahead for swap is to literally just treat it as a slightly
special case of direct I/o that is allowed to IS_SWAPFILE files.  We
can safely do writeback to file backed folios under memory pressure,
so we can also go through the normal file system path.

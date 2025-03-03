Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2291586347;
	Mon,  3 Mar 2025 13:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741010351; cv=none; b=evP3rrl3txelBZJPWYtynXHqlKPUfDFC3k1hSddNetnkFuuNgNLxK5tDB4AjnXe/xQn1B10CDJJTqB7riowzkTDKON0QzI/FTg/rDzc+B2g/lH84vjRJWZNwOJhj1QW6w8CZFf88OIdL2awDXXdI+6Fa+PbsrNzXFb4CTaj0IA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741010351; c=relaxed/simple;
	bh=8iKfJkNQrU4crLkC75d2xewvQHA+lVj1LfcNV3Q+XIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eD+LhLpchrVhNGW8Qtd1OSMLLS9MvkeUfNobzoflqE+XguCKoU4+htew8Z2wZ8QRTe7UAVrhYBLnbPGmRH/5HvBybMDWgBrMlStZjsB2bV1d3/9zFncl/YDIbkUCNisZE+rJ3LRb2nSQ/ZgVHA810aSN+3pGzB1Acos2ayWRm6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fTqYSiNS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fTqYSiNS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5X+YN9HLo1PBpCJ901n+jjHLjaif9nWTt/biwkwt76U=; b=fTqYSiNSmMk2YG+r8O4GzNLhuB
	9H9FWaSaNv1LsPRcu1LwFwsPDjwA5ehyrqudIITIMFkFFOUVCyVOD67s3ABL6bgTg3AT2TWlL0OGi
	wkNUrbTzWuB//MbnzFfLJSNmmN0C6kVnk8eYXLq+ZfMvZU61TwtFQnjtunqRNLe7v40HclhZ7GC7h
	aJLzkNqXTlwM0J+RfeHYeTXH13EKxnSVcjhDUm0FNCrcqZXmeGqzGLmG5L7R2QfWaYLPdIbD6QmXG
	BR/mSW6chXIkW83p86HvI8cJTkrYigTLjY74qX82nleGzgivl3q56fwwWUAZUCx7NYo7Hfl5hBCvy
	A/q8fS2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tp6K3-000000010Ky-3ArC;
	Mon, 03 Mar 2025 13:59:07 +0000
Date: Mon, 3 Mar 2025 05:59:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z8W1q6OYKIgnfauA@infradead.org>
References: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 03, 2025 at 11:24:27AM +0100, Mikulas Patocka wrote:
> This is the dm-loop target - a replacement for the regular loop driver 
> with better performance. The dm-loop target builds a map of the file in 
> the constructor and it just remaps bios according to this map.

Using ->bmap is broken and a no-go for new code.  If you have any real
performance issues with the loop driver document and report them so that
they can be fixed instead of working around them by duplicating the code
(and in this case making the new code completely broken).

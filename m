Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AC74C6D;
	Mon,  7 Oct 2024 05:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728279945; cv=none; b=U4EyLd36yM+UD38VzoETFy/da5O+0pvyX4IzRa9vFV+pZn5oKYeiOH2VnfKz1dxahd7IrDV4vitksrr5RuRSE65ebLaancTZmIKKBBCl7E3JwcUthz7G7RwiYtKIYN9dihwBQNvBObk4j6BZjf+ijOfJ8xNxRQmBLh3C75FpBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728279945; c=relaxed/simple;
	bh=DlFO+5QF5k964e/6HjPexeYDAC/i5H9us6gjnHB4eIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sn8QPSEOlOk37p7jg2182CqYQ513bR+fJW0CnsbLDzpZMLwxFiTqM87UzK1KRWUmIxuRUnoYkLJ6XDpmA3LoNLVDebCG+GasBm7tY+3o1YoCuDDAixbJNNNoLW9LyYBj0mLbiIxZMWqyDzcNB2mTLowuhC6gQo+pkPU4W29RK6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t3S1sRkw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t3S1sRkw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+xdYGj0pjecCgJTrRUDpLZIli0yKHN0arUvojV1amAA=; b=t3S1sRkwa0zoxLxxYQFtWyV3u5
	c/y9uzxRJkr57onmvYZMqFCfeGs36bAS7Ps7DHJbm+WIInbAWT47KLIILiKXX+v61tB7Q1OxNogQ/
	pY6/D2InltKv/8WSwxFSa/3MvZUA4Fv+/u20hIxbPX3RN+7LsbWf75xjQScPnRks58WbnSp8oP2pm
	TJqwF5PcWysj9tpQRzTBxWGG92LtKfI3BibDN99OXjXZwK0IYwLAzgeTlq2UAyaKFv1zMFCpmrUSe
	yzv0VYM+oTGh3NKhO3fymbWX2dg+S+HcNiHlNKji3XpVxsaDbHaVhQrGbCDSJU2gFNAPGfZAB+djd
	YMgyxywg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sxgYu-00000001KjM-3fHp;
	Mon, 07 Oct 2024 05:45:40 +0000
Date: Sun, 6 Oct 2024 22:45:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>
Subject: Re: [RFC PATCH] dm-inlinecrypt: add target for inline block device
 encryption
Message-ID: <ZwN1hDK34h0du5qp@infradead.org>
References: <20241004004152.8845-1-ebiggers@kernel.org>
 <Zv-Ap9E2r1bRT2Wm@infradead.org>
 <20241004184819.GA86456@google.com>
 <f335366a-3752-4272-8592-fe1ed9f43aee@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f335366a-3752-4272-8592-fe1ed9f43aee@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 04, 2024 at 09:21:47PM +0200, Milan Broz wrote:
> There was another discussion recently. I also discussed this with Mikulas
> as DM maintainer, and we agreed this is the best way.
> 
> Extending dm-crypt is possible, but the dm-crypt threat model should not allow
> pushing plaintext down the level.

As should any other stackable crypto driver, so that's not an argument
per se.  Allowing to bypass encryption in a lower layer is simply
broken, no matter what you call the target.

> (I am currently investigating several issues with Opal hw encryption that just
> cannot happen with sw dm-crypt. We opened can of worms supporting it in LUKS. :)
> 
> Actually, I like the inline encryption logic (and the sw fallback), just I would
> prefer we clearly separate the code here (and dm-crypt is already complicated enough).

Now code complexity is an absolute valid argument. I think it should be
weighted very carefully vs a confusing user interface that requires the
user to know if there is hardware acceleration or not.

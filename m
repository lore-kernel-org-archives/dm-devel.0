Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776305;
	b=yETnhNpfzg7aX0bR306Xj8Zdg966Wvr6lawCFcrk2eG8OT+BrE1Hwdj3yFVAOFRG49Yd
	 VMsfO2WS9TSnO5hJBN1DfoM80+ad+4tzINFF580BOH6/fbfZB9TWTQ+avu8RrWJREmL3U
	 SUwOKl7Ue5OuNKXRmNOnTBe1HOIlu05oqo7iWvZAsLVbji0DRdXfif8rjT/nezZorUGnM
	 bLPX81iQGRZrl0JDEWGAzNiWQ+s7O/5r7bMfu/alAE8L8aTVS9GTMCy7tErswacrUh/sz
	 xiJrww824AjnuKDZX6taxC8COrAy9MO/9w0J//TVtu3Vn/IYbtR+AgYdcr/gOSRumDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776305;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=U6e1StiwuLXl1ElZ7KjtJ0ynOkK+aUdGjyiu7hHBZW+hSnR4OLPftM62ISsA70PEehMt
	 9DIDmM0LBikdMOvrBjKEB0JX0lN4P0Svi5ZMU6uZE3GYXXa7xUApqBzaYPeHGFJQNC3nO
	 5lx4XO/Rrdq9JXXSbd/WqLz/aV5qtaXz1qaNzrvYnqwrEd7qJGBhPRERD0FnA6gKy/CwB
	 3h7o4gsNDKbYIS3qRYrot4WrkPEBndhP9jKymN+MHSMUW0EfryosDqns79Z7khgf+vBi5
	 8ia3YiLO0RljFnvHTVoQduAbutkscqUzqfUYQg61DIfOCr9fIXmA6rOYP5+1tBXLV5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1reA5Rc5;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA1F606A326;
	Wed,  4 Nov 2026 07:11:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FA1F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1reA5Rc5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1reA5Rc5kEU1THZUFLOfosbTv2
	9VB5BAjHnxOh9M/LQDOLkXUWGTPzJhvAZ87WoRYhiFnXYk4Q5858Tn4W4GNdQXgRy6785XBLhVplF
	HiZtcDU0eSa2R9+VgIzdTRyOO1mgBRderNwPNSZItsXzfHvKkBav9WTflRD+5c498Cn0Hyx+w0ddV
	8DrEQB+8KDkj/1UhQabeQtGHHQo7eshzoHbhGYV2x+I+2OwREnOlxIpYcNucuYrUSpoEGiguLsT9I
	ZtPmMtHb4bsm2zY0iv/5v8Hlk9I4oUMTMHoDT1PU7Ic2pUGyLiPFX4PMC1kHwiHPykLvBH1RjMrxP
	oq7V6OBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOV9m-00000004TXi-2TiN;
	Wed, 04 Nov 2026 07:11:38 +0000
Date: Tue, 3 Nov 2026 23:11:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: axboe@kernel.dk, hch@infradead.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	mtsai@redhat.com, sashiko-bot@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] block: fix discard alignment for non-power-of-two
 granularities
Message-ID: <auraqpkUiHmTgoli@infradead.org>
References: <20261103185909.71843-1-dennylin0707@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103185909.71843-1-dennylin0707@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


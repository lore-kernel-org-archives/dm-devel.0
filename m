Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188285;
	b=mEWUel4vXS1ixahm0ECWP16IMJb8G+k4yXdaio+wWCmn2zMqR2DTYNPvfV8UyQeguG7r
	 JGNxZhfJlDmVzJuo2V+fQlFWHesamwlkJUgz8mXIttbEekdkaMixtln3Ykb7qrXoE0/TR
	 /xPviygdyyoW8SKzFCe95L56ILMrhiLoQyTXp0TTxXgNlrhZSd78msUMz3xbqZZaNqL2I
	 yo8USz+hjrEDsgqYCNv5RXXHD/dX/eBepQ5crfuz8LYYknRB0eRxSQgZdzV5+Kef2OYdv
	 jQChuLEU8SBv5vXZaCkDo7lHYzqooJ5pS5jyhnGC45UjTlV9StVEZQvJBaeYhVvYUng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188285;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=SpN6lK+ZTM45pGVSTME2zCdRIELg0pbhb5h4WrRIpEg=;
	b=iNleJAfjqKeR3GSTO5eG58B5wRRf3gbZrSRxQrw+50K7K92sV3Th5ldJPpX+4yYW21+Z
	 rAj8XBe/wchp17e0NVD3kKyeFQp6Ec9LVe2+Vp+Kcy4pMFR7FGOq8gCJ771A5dc9QlVmD
	 TP8v59CHQH5WMULR5xltrbPCnhobZ+ZglAKJj6qZl+6Tcij9TxXHQdqP78lkWgoXpai8R
	 ZIXoguTOQcH04UCBaWhNr8iEyhfo0zFCVWik+3binKOaXj7ssgnC1Rxl+T97HaIy1Ls9Z
	 rc36Nfxb/oLk/yYAUOUB9cSPsLEPqsQMUorSJwyNT55t8EjX5Jkg8IlMf4PuHvtpAzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=iorlInwk;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED238606A332;
	Fri, 20 Nov 2026 15:24:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED238606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=iorlInwk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SpN6lK+ZTM45pGVSTME2zCdRIELg0pbhb5h4WrRIpEg=; b=iorlInwkb1vVdxSQUJWI8rObEf
	Ndm24D0wj3iOgCbxGhLNDv0UhmZ0k3TR3GaSETaVftmOoWdF8Lk9jmFiBL62gi5lVkdAEky2GPV6Z
	/Fy5TKiPWVAEKmIw1LcCVet25gmmNgYHpn/hMSlg4EnVJo9feCsuFequkW73wlVZ2BytPFFh68169
	vZt92pJ0z9heE9BzyQTNTKy5x0i4SZ341OY8swk59WyXzQEOijE8vG8UIOtyfW4fQDeW1UoY3HOMO
	w1MW5iDx6rbTXqG3C1m/e/uoBLvotouQKC+H20rvk8X5pM5qI7n959RF3zzXjbp+5ChYo2e4jpReJ
	j5pSWsIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUQTi-0000000FP26-1OUk;
	Fri, 20 Nov 2026 15:24:42 +0000
Date: Fri, 20 Nov 2026 07:24:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: tongzhiwei <tongzhiwei@cmss.chinamobile.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com
Subject: Re: [PATCH] block: fix divide by zero in
 queue_limit_discard_alignment()
Message-ID: <awBmOrGl2dlMEd-q@infradead.org>
References: <20261120103040.610-1-tongzhiwei@cmss.chinamobile.com>
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
In-Reply-To: <20261120103040.610-1-tongzhiwei@cmss.chinamobile.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 20, 2026 at 06:30:13PM +0800, tongzhiwei wrote:
> Commit e924da7d6622 ("block: Drop granularity check in
> queue_limit_discard_alignment()") removed the check for a sub-sector
> discard granularity on the assumption that lim->discard_granularity
> is always at least SECTOR_SIZE.
> 
> That assumption does not hold for every queue: a backing device can
> report a non-zero discard granularity smaller than 512 bytes.  When
> blk_stack_limits() stacks such limits, only the non-zero granularity
> is checked, and queue_limit_discard_alignment() shifts the value down
> to zero and divides by it:

Well, then let's fix the setup time to reject this.  Because a discard
granularity less than a sector by definition makes no sense whatsoever.


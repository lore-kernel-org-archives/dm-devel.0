Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1FB139579;
	Tue,  4 Feb 2025 05:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738648521; cv=none; b=shxaTcxSNSWzxfebtrlFAdtWyl6x9dChTgm7JRbeUB0VhjeULnWcYmJRrmXrp4q4YacEWgEOfbYHAFs5Bnct1nrHHgpGcED5/jqGgjWMtFeCcUCBSWEzUTZ7/M++0cbcDPAjgPddsN/RZfkOyYLit66EiXr/eedz8tZP8Hy3nSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738648521; c=relaxed/simple;
	bh=algTlgUBpIj1L7Eyxv+KxeDUCTwu2wH2vJsJMTAMjxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIsaCYju5BN+DAESQLuR2L67WF6jzsHxy5K0lKM4gkA7b5YxMsaT9wjVAuonN1bMgoGirHzqmEdtzKCUDrsNC05hGGH/v0DJhCtjFfBP8V+SMrd7jYPuXqgLqnvaEH53jbMGGKVuLHt+ijXh8vEEjX+epUs96Uy9+7uzGiqdjfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0lu97MR0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0lu97MR0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3RtQilQjm8VtuiHINZ17CRgyyuCDuHiy/+nyEganVB0=; b=0lu97MR0idtE75HbOPjybF+Sne
	v0seLo3DB9dwWtG7juev/uym0czHu69VtznF8QNvtx3627bP6/m0ItiAHHqc7noRrzT62hc0xofD1
	+yhRaA095LAczkDPy07Uxflox8LYBEog3leahjvmEQLwVp0JASFTvrCK/bSl6lqeeYqYmCmVfmq4n
	n6i+FxlMzfbtb4sIBzw5CCRr19V8hqpzfQ2z2pEcyhekEwH4YwDXD+A2XoqXRvbpxZr7xJRVVLcNf
	bzOL2qhpnDR/TWuZy1MnnQEj53gbfVV+DWS2CnhUvobG3pCCjr48CCOB2rCUF8w5eaQ9sACbMFJf4
	XGCYdw7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfBu2-0000000HJKy-43uH;
	Tue, 04 Feb 2025 05:55:18 +0000
Date: Mon, 3 Feb 2025 21:55:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
Message-ID: <Z6GrxgX3PVlRD4cJ@infradead.org>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
 <Z5CMPdUFNj0SvzpE@infradead.org>
 <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 03, 2025 at 02:38:25PM +0100, Mikulas Patocka wrote:
> > Not really.  I mean it's always smart to not do tiny unaligned I/O
> > unless you have to.  So we're not just going to cap an exported value
> > to a magic number because of something.
> 
> The purpose of this patch is to avoid doing I/O not aligned on 4k 
> boundary.
> 
> The 512-byte value that some SSDs report is just lie.

That's very strong words.  NVMe until fairly recently had no way
to report this value at all, so defaulting to the LBA is not a lie.
Similarly we ignore the device characteristics page is supposed to
be skipped for usb attached SCSI device as it is buggy much more often
than not.

You still haven't mentioned what consumer of the value is affect that
you care about, but it probably needs to be taught that
opt_io == logical_block_size means that no opt_io size is provided at
all.

> Some USB-SATA bridges report optimal I/O size 33553920 bytes (that is 
> 512*65535).

Well, that's clearly bogus and we'll need a tweak.  That being said
I was pretty sure we wouldn't even read that value for USB attachments.


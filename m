Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC4E1E5B91;
	Tue, 13 May 2025 06:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116862; cv=none; b=ZmOE2LVGP1PEsHxHNFOG0QBZGlfCV3fCllbK/takk+RlmK2N0o5bh+TbLXfDslx+wvWtakWGGOrjttFMCs53kOciMUgiMqhmLESUT8R1gbZc4d+k745OQhVnOfmc4/OXvwv4tuiDe94SWyuF20R8t02RupDFxXN6DQCmeR7sDoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116862; c=relaxed/simple;
	bh=JIVfMbtGsG5F3YlFUUQ2mVBIytr449CcZ3k7TgCts04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aps6Cn4JrescOS011jdD0WOT6ygbGpfDnXYyiUUunzpHZVaxibDTha/ENk1IkygXzz2+5iB9I0vwpGYgH6fniRSmwWN/ZjlgfB8DobiT5ZyhKmxnX20562C6uGC+RWAwMiGdJik8pmaq+Db8Le1aPe/alGfFrfqW7JM4kgnmh+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zprRRUzh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zprRRUzh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=exyNQMmNEAeSwUCzxr3Ri8MZBjKaYzQ/rLDEz8LLY3E=; b=zprRRUzhfuhIh1fWql+kQihzyi
	R7O8WsDYt9a/ry2+Tu0ryfv++riVF6vZJdJ3+SnMPdwxwx28ZaO11V2lIeLIgZtuS5EJkUgug58kK
	haOUPKThYwsTMtlJAtDmNX8l9y8h4M4IXkulq5CW1gzkWFloAF+cD184qdXxGQHBUQKe789m3K+1E
	LWPL4nVtNlJjFGP0S3J331ElbOY3v9AAzRjb4mUadgoulId+Ul/k2/58YDj/zXSeNpryIx/2/1bxM
	RIdNSuq5OG4XJs7NnZmycZi1EmlMhFsAnTpJ5fjm5hi9JACI2AGG3o9yqY5F0QsrfNVFLeaDT9APt
	h+ODaoUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEiuC-0000000BTut-2y1q;
	Tue, 13 May 2025 06:14:20 +0000
Date: Mon, 12 May 2025 23:14:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>,
	Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev,
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	bmarzins@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCLjPLCztuXhgpnA@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <aCLe5UT2kfzI96TQ@infradead.org>
 <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 13, 2025 at 08:09:45AM +0200, Hannes Reinecke wrote:
> On 5/13/25 07:55, Christoph Hellwig wrote:
> > On Mon, May 12, 2025 at 05:18:43PM +0200, Kevin Wolf wrote:
> > > Yes, it's a bit unfortunate, but we have to work with what we have. QEMU
> > > doesn't even necessarily know that it's dealing with a multipath device,
> > > so it just has to blindly try the ioctl and see if it works.
> > 
> > Why is qemu even using SG_IO to start with?
> > 
> To be able to forward SCSI commands.

Why?


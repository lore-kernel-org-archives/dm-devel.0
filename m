Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE9F53E32;
	Mon, 29 Jan 2024 08:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706516790; cv=none; b=lyD+WlxPeB6IJrGn1VBQS/l0v1wp53mmYDf/MT7Ka+dOpARuQew4hfMiYUrqyPQGmKu1M5OveBCJNfhRRSjRFp44BtbUh0DGpPbJ5FM1oC6lUvWwL+NMgPgLvIQ9nZCAaVUi5xo7FZc5OxV03bNvmo/Uzl/8xRQ2zZLeYrzWUf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706516790; c=relaxed/simple;
	bh=3PR8Y8m3tugXwkqNMqV/kiMMLnyu4yH9Jpk2m83Y71U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U3K8VQOAvDPrrEYIZ86EM5R1rLabB4iyP5H/1ivjNNV2X5NazCXD9CThKgOyn9ykdl1G/GWuCju7FLmnt1hlQebXp4XEb7811bxTBiLgGYNJTyaDNP24xBSo6VGLfSO+y9f64oKtPIGyiLgh88D/B7iR6OgQq3Vc+f9ZkXoVfXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fTfrYi/4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fTfrYi/4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PEMJ6pLy+aMTn3PQXV89uVlWkRqf0t6m9okigCBbbrc=; b=fTfrYi/4YtfsjbGCHm0iVK7CV5
	XZpCGqDcn5gY4O7II5GrXuaJTZ/iXga82fm+TiykLzRLKBas0v2u/nLS4YfxyrGw6p61WJni/kl8N
	ctxDsvsmZO7V7LohAcgdjvjXOVo2EKAbKYzgUd5yfemC3oeWs8rgzDR6b5MVFA6q3hHPwUQyai6Pm
	B8VyDDTqcHn6SVvCHxcU8Wz8fqiZl2m/72P8jKwco/PAvaGd+8J94pupYf9I13k7zz3Ke1UAC1/24
	fuXG4bYVIym3dqm9U240lg7uP7Yg+VO8PCkRTEFPSSuwyX1IqtqZr8EtPqXjPpbMDP76oDdqxA269
	pK6+zVtg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUMyK-0000000BlbR-2RmV;
	Mon, 29 Jan 2024 08:26:28 +0000
Date: Mon, 29 Jan 2024 00:26:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Mike Snitzer <msnitzer@redhat.com>,
	Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org
Subject: request based dm-multipath, was Re: [PATCH] softirq: fix memory
 corruption when freeing tasklet_struct
Message-ID: <ZbdhNEkEfqWsE1yy@infradead.org>
References: <82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com>
 <CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com>
 <586ca4dd-f191-9ada-1bc3-e5672f17f7c@redhat.com>
 <5e2b5f23-94f0-4bf0-80a6-48380c7dc730@kernel.org>
 <d390d7ee-f142-44d3-822a-87949e14608b@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d390d7ee-f142-44d3-822a-87949e14608b@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 26, 2024 at 07:56:39AM +0100, Hannes Reinecke wrote:
> DM-multipath schedules based on request (if you use the request-based
> interface) or bios (if you use the bio-based interface).
> Any merge decision is typically done by the block layer when combining bios
> into requests; and you can only merge bios if the bvecs are adjacent.
> So if you use bio-based multipathing you will spread sequential bios
> across all paths, leaving the block layer unable to merge requests.

While I think the current code would do that, there is nothing inherent
in the interface forcing it to do that.  The blk_plug allows drivers
to attach callbacks to batch up plugged bios, and the md raid code makes
use of that to get larger I/O, which is rather essential for partity
RAID.

> Another thing is timeouts; bios don't do timeouts, so a bio can run
> for an arbitrary time with no chance of interrupting it.
> Requests do have a timeout, and will be aborted from the driver when
> the timeout is hit.
> Seeing that 99% of all I/O issues I've seen _are_ timeouts it becomes
> a crucial feature if you want dm-multipath to control failover time.

This does not matter - a timeout bio will return an error to the
submitter even on a request based driver unless the timeout handler
fixed it up.  And there is nothing preventing a bio based driver from
having it's own timeout.  We had quite a few in the past.  But dm-rq
doesn't even set a timeout, so for the current situation this is
100% irrelevant.

So while I'm not sure if using the existing bio based mpath code with
plugging would be enough to suite all users of dm-multipath, I'd
really love to see someone actually trying it.  Removing the request
based path would significantly simplify dm, and also remove a fair
amount of hacks from the block layer.

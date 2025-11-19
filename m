Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687DA537E9
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 07:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763539087; cv=none; b=rBuEWKTlHJNhvp+SP2/K9qWzFiPlkMmxbRKV5noOgyERzBUMp5AOaP4Vf06o3Am6535qEhe0lbQyZYTprLlCmnmZpfm1gNfxuySB3VvWSKNthlx1dtwO5q6mBLS0yEX+yc3JvyTSKoXTFn2HFiv4ycP4fG1EGNBdntRU0ii73yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763539087; c=relaxed/simple;
	bh=ourgBo/ceXjTrvEgL3aRaw/TM8Fffy+aaFrlBtQa5iA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TI8eldvis4MJQ84oR9cBG0XQhnicVFwu9PBw84p3PN1uNAMVXsHVeaRqQRoVUy1VA8aJFvVvHMztUvz5/bfG2q/4wVW3ZcAQ1Ed7w6NbZ4rtTwllBLDpx8BzEgCudiI7gnrT65Q5BdQJjqRg8dyoXbbBStc0VHMM5yBjoPI9HXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 91FA868AFE; Wed, 19 Nov 2025 08:58:00 +0100 (CET)
Date: Wed, 19 Nov 2025 08:58:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: add a flag to allow underordered zoned writes
Message-ID: <20251119075800.GA23083@lst.de>
References: <20251118070321.2367097-1-hch@lst.de> <f385de59-5bef-4ddf-b363-edf76f88d855@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f385de59-5bef-4ddf-b363-edf76f88d855@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 18, 2025 at 10:10:33PM -0800, Bart Van Assche wrote:
> Is the following deadlock inherent to this approach?
> - Several bios are present on zwplug->bio_list and these bios cannot be
>   submitted because their starting offset is past the write pointer.
> - No new bios can be allocated because all memory is in use.
> - A deadlock occurs because none of the queued bios can be submitted
>   and no new bio can be allocated.

This can if the number of in-flight bios is larger than bio mempool
reserve.  Which is real, but we also have this in various other
submitters that hold bios to submit in a list.  This suggests it is
mostly theoretical, but I'd still love to address it for all these
cases.

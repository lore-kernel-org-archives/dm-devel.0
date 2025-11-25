Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A2128DF07
	for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 06:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764052545; cv=none; b=l2z+8G12jIaiiQ7uZElHoWeanmM/dgPmyoaez57x3x/tXyXnEoqEm9yTTfUgU2Iwppdaz4AVt51aT857HmGAzzjItwWElnCX4QP7BpTUghBqSNPQ5AA0zbz9zydfArJN1JEe91PO2m8fDbQjoVCs15eDPFig2zTT30pGZMRKYpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764052545; c=relaxed/simple;
	bh=dvG8d5PlRHjYc2MJyrWeEGTqD5XH89RmhP35EfLk/Rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXcFyC971x0ljXwyNB08BeVupOAdj/nNOGVoasp89ml2dZP4zrFTRCKMz5u6LYpRz9FPIPeGb7NELGFl9x+12TKfUqkukCHLG0lW5bvY8giMIRnqKvwcEy3F/vEwQes+lErgYGzD+b3JFDQv/k9mfOf7tnZq45ylYO327kg9DyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CFA2D68BFE; Tue, 25 Nov 2025 07:35:40 +0100 (CET)
Date: Tue, 25 Nov 2025 07:35:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	snitzer@kernel.org, axboe@kernel.dk, ebiggers@kernel.org
Subject: Re: [PATCHv2 1/3] block: remove stacking default dma_alignment
Message-ID: <20251125063540.GA14873@lst.de>
References: <20251124170903.3931792-1-kbusch@meta.com> <20251124170903.3931792-2-kbusch@meta.com> <20251124171230.GA29490@lst.de> <aSUZP6yP8mvi-q7v@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSUZP6yP8mvi-q7v@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 24, 2025 at 07:49:35PM -0700, Keith Busch wrote:
> On Mon, Nov 24, 2025 at 06:12:30PM +0100, Christoph Hellwig wrote:
> > On Mon, Nov 24, 2025 at 09:09:01AM -0800, Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > The dma_alignment becomes 511 anyway if the caller doesn't explicitly
> > > set it. But setting this default prevents the stacked device from
> > > requesting a lower value even if it can handle lower alignments.
> > 
> > Given how much trouble we had with drivers doing software processing
> > and unaligned buffers I'd feel more comfortable keeping this default
> > limitation.  Drivers that want to relax it can still trivially do
> > that right after calling blk_set_stacking_limits.
> 
> That should have the same result, but it's totally fine with me if you
> prefer the caller overwrite the default instead.

I think it's much safer if we require the opt-in.

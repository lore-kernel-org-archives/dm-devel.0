Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E171BBBE5;
	Tue, 25 Nov 2025 02:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764038977; cv=none; b=bdUFNAI906qKVt2Eo+0caZmt9PA12jlpPIXuehzvAZ3Snh/oHb2O+7R4h5jzjJtW4B+J+oWWloBpulK74wXFifIBnHNPxxNBPxQo9sMvA5zhuNETRvkyNb4tDoE96hFK6bo0gEiEL/1wSPXg+db12l+YIlCW9VBSZObp1utoxJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764038977; c=relaxed/simple;
	bh=6gQjztsDDlh8n/eTljRDdlDWD5jAcdxxhM0F5+hbMUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6gW9Zo5P6jF7CIrnW0jTvrmWn2eT72PZSuOzQpc4KJexos4pqHz7PyuS76V/cmjuFwvUOxYvmRZ81y5O+I8X/lWbQBBk9c6RJbFCNrpdaEBKVVHcpJr5lZDCtx29ze9z7a8RgypNj6DltA2BLidkBhyZ3/FUMWVUGtFFVRajFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O60DemiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O60DemiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB22FC4CEFB;
	Tue, 25 Nov 2025 02:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764038977;
	bh=6gQjztsDDlh8n/eTljRDdlDWD5jAcdxxhM0F5+hbMUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O60DemiNA5KuF1BgeDQzAvVVBaj+pyx9Kg8vxWVP8gVszGkzdj6AnTEtIZSp7Q4r8
	 hCX9AB55IF6+0tkPPYq0Vkg5rAAweSqFyMHh7y/4n39Qf/AXahyQzhgpKqmN9qWlLB
	 ocV8J0wcBiz3EuvCt1QW0uRMpVsuIzbjBGCTpB/xf5xeFVEvU0eVUzDmKRPnWS46MT
	 P94e/PZGyr+s7po/ovXM4mwBanFJ6O64V6eHMrR2CeIK/VgjguAoXZUyqepu6y1x10
	 2iQ4QrH8G5790i2Lp8U/vRxpmSwQJEKGthtvnknz8VhuC/+ykgAaS9gU63uonAGtVT
	 T2DfM34cA/0/g==
Date: Mon, 24 Nov 2025 19:49:35 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, snitzer@kernel.org, axboe@kernel.dk,
	ebiggers@kernel.org
Subject: Re: [PATCHv2 1/3] block: remove stacking default dma_alignment
Message-ID: <aSUZP6yP8mvi-q7v@kbusch-mbp>
References: <20251124170903.3931792-1-kbusch@meta.com>
 <20251124170903.3931792-2-kbusch@meta.com>
 <20251124171230.GA29490@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124171230.GA29490@lst.de>

On Mon, Nov 24, 2025 at 06:12:30PM +0100, Christoph Hellwig wrote:
> On Mon, Nov 24, 2025 at 09:09:01AM -0800, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > The dma_alignment becomes 511 anyway if the caller doesn't explicitly
> > set it. But setting this default prevents the stacked device from
> > requesting a lower value even if it can handle lower alignments.
> 
> Given how much trouble we had with drivers doing software processing
> and unaligned buffers I'd feel more comfortable keeping this default
> limitation.  Drivers that want to relax it can still trivially do
> that right after calling blk_set_stacking_limits.

That should have the same result, but it's totally fine with me if you
prefer the caller overwrite the default instead.

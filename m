Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7BC12F374
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712671090; cv=none; b=luN6otkmGvRnUbo1HG5KEnZkO7HTVB9b3HmGXQtBvvagkMVMow6A0DJiz1YgPhrwME3qUgrWe5vUrx4MlV5Vkj9dfUGfRzZoftz2RYFEOE3UbwL7MSvSmGCbhQocUPTbih3YA3eCAJTx9OGM29gO1vwCjlvXkFdSjq+SbCKIkAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712671090; c=relaxed/simple;
	bh=aup9EyGiaZCY4USFtmk2XO8IJxXlwPpNJ7u1cRpu9U4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asNv3XXIQuAzhLBMfLuKvEYyCGL7BFKm1mun1x217JYGkq8409XuHsvxwxIHOYNWxRFt9R1AoQSUX1R8CkRbhohSjj3a3ezCR3m268H+yR6V3dUoIqMDB63bX8myorrgdup29TnIe8MFXyQE6LzrSmqq5O91+n0nQmWyHVsbqhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B03C068B05; Tue,  9 Apr 2024 15:57:58 +0200 (CEST)
Date: Tue, 9 Apr 2024 15:57:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, janpieter.sollie@edpnet.be,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] block: allow device to have both virt_boundary_mask
 and max segment size
Message-ID: <20240409135758.GA20668@lst.de>
References: <20240407131931.4055231-1-ming.lei@redhat.com> <20240408055542.GA15653@lst.de> <ZhOekuZdwlwNSiZV@fedora> <20240408084739.GA26968@lst.de> <ZhO9UrfK4EulTkLo@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhO9UrfK4EulTkLo@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 08, 2024 at 05:48:02PM +0800, Ming Lei wrote:
> The limit is from commit 09324d32d2a0 ("block: force an unlimited segment
> size on queues with a virt boundary") which claims to fix f6970f83ef79
> ("block: don't check if adjacent bvecs in one bio can be mergeable").
> 
> However commit f6970f83ef79 only covers merge code which isn't used by
> bio driver at all, so not sure pre-6.9-rc is broken for stacking driver.

We can stack rq drivers as well.

> Also commit 09324d32d2a0 mentioned that it did not cause problem,
> actually 64K default segment size limits always exists even though the
> device doesn't provide one, so looks there isn't report as 'real bugs',
> or maybe I miss something?

The problem is when the segment size does not align to the boundary
mask as you'll now start feeding malformed segments/entris to the
device.


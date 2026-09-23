Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC9C3D0BE7
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 04:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139316; cv=none; b=ALsup8VbvR9Qo/kUdtUe10To38Qp+ekoXy7qgmpIUPZVWZQny0mRFnq4JcsX5w/2eJzAy/AwXWgAq39HBXvDKMWbs+ICruEH1gpY2IPCd0nCx2NphJEKpvqcvycfte6MGDX9zaVzF9KE1DrUNgmB2srSXA8MvRazDcPRBKSoe6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139316; c=relaxed/simple;
	bh=Qs19OWKtYjUAEmVURvXm80xgS1L3ZM2WRz5g0LPu/o0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAEhSi1JlPXtEQDzkJbXbeCdvn0z6mgbkSjxbst9tCpP5n+W9jhLEzEhyfd5q8ZLtBu4vEjxvgda2Ua6TtchVYq/b5OaZ4DyxENS1UqXiiy2AJDLEgeyWd5ksXI6ygd28gop5D+VA+I79kLc/6YEduGGhlhIiQCyMFocY6fJhgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B955768BFE; Wed, 23 Sep 2026 06:55:05 +0200 (CEST)
Date: Wed, 23 Sep 2026 06:55:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v6 06/13] nvme-pci: implement dma-buf backed requests
Message-ID: <20260923045505.GB26231@lst.de>
References: <cover.1789997898.git.asml.silence@gmail.com> <e80c3b1e0de004eaca6c51a2a86115ac9ed36381.1789997898.git.asml.silence@gmail.com> <20260922132016.GA30684@lst.de> <d39a6dd7-cb5a-43d6-8dcb-16eb9fc95b4d@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d39a6dd7-cb5a-43d6-8dcb-16eb9fc95b4d@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 22, 2026 at 02:37:08PM +0100, Pavel Begunkov wrote:
>> Sashiko had a few comments, which I think are correct - if we use
>> dma_map_sg to map the data, we need to use the sync_sg APIs to
>> transfer ownership.  That only matters on non-coherent architectures
>> with MMU, but we need to get it right.
>
> I've seen that and fixed everything locally that should be fixed,
> apart from the sync. I wonder what we can do about that? I can
> somehow replace it with the sg variant for now, but sync'ing the
> entire possibly multi-GB mapping for, let's say, a 512B I/O, sounds
> not wise.

If we'd want to fix this for real we'd need to add an offset to the
sync by sg methods.  Or move away from scatterlists in dma-buf, given
that they are a horrible API.  All of these are bigger projects,
though.  So for now I think you'd want to do the sync all, and have
the people who run high-performance io_uring code on non-coherent
platforms suffer.

> And I can think of another place that does mix sync_single
> with sgs.

Which one?


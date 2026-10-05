Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5653842F708
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 09:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191415; cv=none; b=jUYEifFURLb6EyduCGNf3D0Aj09kWhO1+2Y/FjAXXNGUSkxo807WiAySvy2WXe5OklIMhNYvNES80zN2vVBZ3TmUvufN2Sm6++NtyHsCyobY7xlklo6IeMSeq8Z1LHoq8o9WQxOJAxU9x5ZZygBJoplHuw3d1CF2126bAcV/EQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191415; c=relaxed/simple;
	bh=hNmAJf53nuCegwa5Bo6KwYtz5NCdOGq2JIipG/i7568=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqzPJtmTUdwG1Lrov6+b4kC3Wg6D4Q3nAAZcAtJg0cyLZ1iLfQOn6OujskawFnd+1rkxrkMXlSbO0xUInjWRl1LRDTihG5u6Q/45X+9fFZgZQqdbzD34sh397OvFvvt5v67lWxl3WjpPovblREdVxiyC6FmbK1c0Eh0kv/ajN2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8EEDC68BFE; Mon,  5 Oct 2026 11:10:08 +0200 (CEST)
Date: Mon, 5 Oct 2026 11:10:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sumit Semwal <sumit.semwal@linaro.org>,
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
Subject: Re: [PATCH v7 02/13] iov_iter: add iterator type for dmabuf maps
Message-ID: <20261005091008.GA10727@lst.de>
References: <cover.1790602223.git.asml.silence@gmail.com> <74a9d65f5c4f9acce5f57ad5921a9fadc6eda712.1790602223.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74a9d65f5c4f9acce5f57ad5921a9fadc6eda712.1790602223.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 02:32:18PM +0100, Pavel Begunkov wrote:
> Introduce a new iterator type for dmabuf maps. The map in an opaque
> object with internals and format specific to the subsystem / driver, and
> only it can use that subsystem / driver for issuing IO. The task of the
> middle layers is to pass the map / iterator further down, maybe doing
> basic splitting and length checking. The iterator can only be used by
> operations of the file the associated map was created for.
> 
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

FYI, I think the Sashiko complaint about iterate_and_advance2
is correct here.  We don't really hit that in the series, but leaving
iov_iter methods partially implemented and fall through to others
seems dangerous.  At minimum that needs a WARN_ON to catch that case.


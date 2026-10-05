Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F488432E80
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 09:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191477; cv=none; b=dmZg2PJHILuWjzdReFTFRPA6CSa8rOndMI4SD2WjtPscJbJAwKUZ+e8t4kfIF404jvoVsgpG3KkIkL3vqOkhFUKpwKd3sewCMLuj10KArmkiIQ2mz8zRdePYKRwHxqI6IdXGIEIa6nkRVQcNOgnnSHCIcmwH2BaY6pACKpDVrWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191477; c=relaxed/simple;
	bh=GPIZUU+3LzlHpt8dWN7uSDKYHB5h2wSJfQNyM6QkLWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BvJR0A52kVsQ4In5JRqFayUKn7hdq++ywo3DhZqLhAZsXzyYR+6CKkACmPc2JQTgWerRF0qiZD+kRD+/4Qn0/+zLVvIUoB9Ur76yw1BWJFPSMgSjVZwWjJEeRW27mdcdVMWy6w6zUw/BSS9DU4Ywlzp5Ua+1+f9C/Pw8H2RQKos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BD5A468C4E; Mon,  5 Oct 2026 11:11:11 +0200 (CEST)
Date: Mon, 5 Oct 2026 11:11:11 +0200
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
Subject: Re: [PATCH v7 05/13] block: add dma-buf support for raw bdev
Message-ID: <20261005091111.GB10727@lst.de>
References: <cover.1790602223.git.asml.silence@gmail.com> <a6b81e65b1f09b6ed1f71f294e5a94896ea1ead7.1790602223.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b81e65b1f09b6ed1f71f294e5a94896ea1ead7.1790602223.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 02:32:21PM +0100, Pavel Begunkov wrote:
> Add a simple proxy implementation of init_dma_buf_io_ctx() forwarding
> the call to a new struct block_device_operations operation. Also reject
> dma-buf backed iterators for buffered IO.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> [pavel: reject dma-buf without O_DIRECT]
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

The Sashiko report about the errno on fallback here looks real,
and is probably easily fixed by setting a proper errno.


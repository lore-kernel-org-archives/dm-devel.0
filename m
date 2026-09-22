Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA91560ACF
	for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 13:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083224; cv=none; b=iTS4nh6I5SF2UybCeT/uQUx3QOO4Yce9tUp4L24aOjJI7TZvLcifyKwh7Wx9cASxwGo+wup+Hff1ZQY88HxeT0ZCcGPQoTC+y/Lx4tGe/vNc+I/VvZohA8VgBBQnvkRebWoBCLVBWKyR8dzeK67JxJsmuX/zNY+OQFN1nFHfWnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083224; c=relaxed/simple;
	bh=Fv5UtnMOkrV4L6o2J600jZ+PSpEfTT3W1fpr7JrMPT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFUXrtkZPZq/q5WqBLKKhUw2hp6TfGASIWn/bMXAXbyFhXTuxxpS3L6yZmvIyGaLv3r0l+VOf33UG/BjakVZxg4P3YPbSq4bMWzbDGV79yVqquT8gS6EUQvICCnA5ldWL61sO/7vRokb2xNXCpsrw2Ht0iSnUGJ/SgVizwk8Wko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8030168C7B; Tue, 22 Sep 2026 15:20:17 +0200 (CEST)
Date: Tue, 22 Sep 2026 15:20:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
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
Subject: Re: [PATCH v6 06/13] nvme-pci: implement dma-buf backed requests
Message-ID: <20260922132016.GA30684@lst.de>
References: <cover.1789997898.git.asml.silence@gmail.com> <e80c3b1e0de004eaca6c51a2a86115ac9ed36381.1789997898.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e80c3b1e0de004eaca6c51a2a86115ac9ed36381.1789997898.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 21, 2026 at 02:38:50PM +0100, Pavel Begunkov wrote:
> Enable BIO_DMABUF_MAP backed requests. On registration we map the

This is now REQ_DMABUF.

Sashiko had a few comments, which I think are correct - if we use
dma_map_sg to map the data, we need to use the sync_sg APIs to
transfer ownership.  That only matters on non-coherent architectures
with MMU, but we need to get it right.

And the reset deadlock also looks plausible.


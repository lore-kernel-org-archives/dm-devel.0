Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0EB42E400
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 09:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191762; cv=none; b=EA/d3J/Ir0/bg/hEwLMxhfCs3dnEe8yVrhgi7qoHp2iHyiOjeATaM/Q+1s8Qa2RcyjAyxZ8OZ1fEq+ByQqrDwLkn94R+DGUZ1zVGguNjuzcarbRNY0O63mhdm6Q0AZkYEsmgC1oF9I/pjv+PmEIs5BumlZmWTgRVFUHDI1JnizE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191762; c=relaxed/simple;
	bh=iO6107BwP04RCUeP8uOkQU3mxjck8WGhVhoHrPM9h3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELd2lp//h/1CWmpR85tnQ7DYFOIeex0fEeThy7dEp5Sg1vahBCSzzLRy8rLs8FwpV7TXyfLruLvj7CjTHAidyndz45+y1v3fLUNDbfO7u3NHFeAaBKR2fBgVu5VTRIDCmXXsxcO0xn8B1affqNLYaUVpz7YppwPk7NtcMei6Vso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9D82768BFE; Mon,  5 Oct 2026 11:15:54 +0200 (CEST)
Date: Mon, 5 Oct 2026 11:15:54 +0200
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
Subject: Re: [PATCH v7 06/13] nvme-pci: implement dma-buf backed requests
Message-ID: <20261005091554.GD10727@lst.de>
References: <cover.1790602223.git.asml.silence@gmail.com> <e99dd5221c71cbf9aafb5737468d814cb83b9174.1790602223.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e99dd5221c71cbf9aafb5737468d814cb83b9174.1790602223.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 02:32:22PM +0100, Pavel Begunkov wrote:
> +static void nvme_dmabuf_map_sync_for_cpu(struct nvme_dev *nvme_dev,
> +		struct request *req)
> +{
> +	struct device *dev = nvme_dev->dev;
> +	enum dma_data_direction dma_dir;
> +	struct bio *bio = req->bio;
> +	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
> +
> +	dma_dir = rq_data_dir(req) == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	dma_sync_sgtable_for_cpu(dev, map->sgt, dma_dir);

This can use rq_dma_dir in the argument.  Same for the other DMA API
calls.

Btw, given how larger the dmabuf code is now, have you considered
splitting it into a new nvme-pci-dmabuf.c file?

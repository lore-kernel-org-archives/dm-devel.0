Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545FA134A8
	for <dm-devel@lists.linux.dev>; Sat,  1 Jun 2024 06:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717222725; cv=none; b=U4KI88cS1w3a8CZH341xjtILURSWQ6JCy+ybC8oJPrFuLS+y+6bnzsZKFUA7RfAdaYzgaL0N+A9iVy9DofRPkU1MdER/Fr8Fp20G1JOPrnVkXYJ3SZkqQWV+rJOt13G7xo6r2KSzU4seNv24W9lSvUzmfCU8ABxnQF42vdKb2kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717222725; c=relaxed/simple;
	bh=rrBjQRF40NCxkbGV+C8UNlmDmwTUguMTPm33YC2RW1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljb0dpvDVOP+v7sDJVPccwqy3w94asuHR9MxL+RDXaJZ0/NtYf2wOm8KloZj1iuBYAmnBo8Nq1xZ+y/UWThX6vq+4RgYV/rFW0+UCOLWJYn4gdgUjei0EuunBbPg5kybue4sp1+Ux9gVYSHgdZ9VRZJ43f3fsjr1gJWMAyVYhRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C5AF668D17; Sat,  1 Jun 2024 08:18:39 +0200 (CEST)
Date: Sat, 1 Jun 2024 08:18:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	martin.petersen@oracle.com, bvanassche@acm.org, david@fromorbit.com,
	hare@suse.de, damien.lemoal@opensource.wdc.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, nitheshshetty@gmail.com,
	gost.dev@samsung.com, Vincent Fu <vincent.fu@samsung.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v20 04/12] block: add emulation for copy
Message-ID: <20240601061839.GA6221@lst.de>
References: <20240520102033.9361-1-nj.shetty@samsung.com> <CGME20240520102906epcas5p15b5a0b3c8edd0bf3073030a792a328bb@epcas5p1.samsung.com> <20240520102033.9361-5-nj.shetty@samsung.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520102033.9361-5-nj.shetty@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 20, 2024 at 03:50:17PM +0530, Nitesh Shetty wrote:
> For the devices which does not support copy, copy emulation is added.
> It is required for in-kernel users like fabrics, where file descriptor is
> not available and hence they can't use copy_file_range.
> Copy-emulation is implemented by reading from source into memory and
> writing to the corresponding destination.
> At present in kernel user of emulation is fabrics.

I still don't see the point of offering this in the block layer,
at least in this form.  Caller usually can pre-allocate a buffer
if they need regular copies instead of doing constant allocation
and freeing which puts a lot of stress on the page allocator.

> +static void *blkdev_copy_alloc_buf(ssize_t req_size, ssize_t *alloc_size,
> +				   gfp_t gfp)
> +{
> +	int min_size = PAGE_SIZE;
> +	char *buf;
> +
> +	while (req_size >= min_size) {
> +		buf = kvmalloc(req_size, gfp);
> +		if (buf) {
> +			*alloc_size = req_size;
> +			return buf;
> +		}
> +		req_size >>= 1;
> +	}
> +
> +	return NULL;

And requiring a kernel mapping for data is is never used through the
kernel mapping is pretty silly as well.


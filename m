Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB014657E7;
	Tue, 16 Jun 2026 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632473; cv=none; b=YDQf6W9oDhQfSgrk8e3roL4CfBldzRRJBEWcrrJ1FmGiZYjfI9qSWnKoqR0LXCOmSTRPeyVGD2mHos5e/f7hPflqqYgb327EosHq6RTil0WO0hD2jEFWwlscGxTn1cNljjJfPUE1Hq5taIK6Tm+Cp40vz/T5Z1F5ZOjXHNjegxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632473; c=relaxed/simple;
	bh=l0pbyjP09o8FNoIDyajDQYnxVvIg8tX1XCfl1xdVAEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lns9Aii7ORXn3cqQ8q73YPE7KTsB00igURgHdBaBpdV9WF62k8GeEfR7kjb7QWx0RXABB85PE+17I7E3KJ8DIBm8xMX96P5kQBe+HyGf9TGf4vLvVNP7A6kG3aFDTFRp5R4fO5NbBAhpMSXHTTTF3sIzhNIKhDkwBh06yzbSn6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=SvXlq4vc; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="SvXlq4vc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=wP+K+QDgyUM2WNcGhn6E6YmvZ/oVZqPGt3F8XD9Ndog=; b=SvXlq4vcri6hv7vw
	Yp1pAww2wZZuh7En54RWlMXd5u41IiCevLGcrdbhzrhJ1JVFxhYtRu34sZVi4K6zPtzM0MELq9peP
	ITjP2+WhVMbmlv4r+OYL8mI/mdcxFx2HZGut+SvWMACdZrGgnyDG0HhiUmX25tljpRxashDcXIZtl
	hGS8Fj6bOQcn+AQof0lZ91nerZA9G7yHdTMxm3Q3IHYH+YDgXFDRhpQErQve/XLkALY/VWeY5UXZQ
	9EesuFC5CqbBX2HP9h0RDZvWlNhXOrYeMXihZwhmFQTrGr10hqlXCXtNBfijQhVD4vYXVYug1L7pk
	JEqTxR3uOSmhQu/2BA==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZXzY-000000087Wq-3Yk7;
	Tue, 16 Jun 2026 17:54:28 +0000
Date: Tue, 16 Jun 2026 17:54:28 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Keith Busch <kbusch@meta.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	mpatocka@redhat.com, Keith Busch <kbusch@kernel.org>,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajGN1OKun3qyvqMc@gallifrey>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20260616150554.1686662-2-kbusch@meta.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 17:52:05 up 31 days, 21:04,  2 users,  load average: 0.01, 0.01,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@meta.com) wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> BLK_STS_INVAL indicates the I/O request itself was invalid (for example a
> misaligned direct I/O), not that the device has failed. dm-raid1 treated
> any read or write completion error as a device failure: it failed the
> mirror leg, retried on the alternatives - which fail identically - and
> eventually returned EIO while spuriously degrading the array.
> 
> Since commit 5ff3f74e145a ("block: simplify direct io validity check") the
> direct I/O path no longer rejects misaligned buffers up front, so an
> invalid bio now reaches the lower block layers, which fail it with
> BLK_STS_INVAL. dm-io collapses the block status into a per-region error
> bit before invoking the completion callback, so record BLK_STS_INVAL on
> the originating bio and have the dm-raid1 read, write and end_io paths
> propagate it instead of failing the device.
> 
> This mirrors the raid1/raid10 fix in commit f7b24c7b41f23
> ("md/raid1,raid10: don't fail devices for invalid IO errors") for the
> device-mapper mirror target.
> 
> Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
> Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
> Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
> Reported-by: Vjaceslavs Klimovs <vklimovs@gmail.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

OK, for this pair I think would be fair for a Tested-by me as well;
they certainly resolve the hang and the WARN/BUGs.
I still see the errors as EIO on my tests, and on the older mirror type
get the stuck resync on write, and on the newer mirror I see the write
apparently succeed (did it really?)

I suggest given the BUG/WARN and the number of people who've tripped over
this, and it's triggerable as a normal user, that it's a candidate for stable.

Thanks again,

Dave

> ---
>  drivers/md/dm-io.c    | 14 +++++++++++++-
>  drivers/md/dm-raid1.c | 28 +++++++++++++++++++++++++++-
>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index 28adfeb58f240..f382e9f9be059 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -37,6 +37,7 @@ struct io {
>  	struct dm_io_client *client;
>  	io_notify_fn callback;
>  	void *context;
> +	struct bio *orig_bio;
>  	void *vma_invalidate_address;
>  	unsigned long vma_invalidate_size;
>  } __aligned(DM_IO_MAX_REGIONS);
> @@ -132,8 +133,18 @@ static void complete_io(struct io *io)
>  
>  static void dec_count(struct io *io, unsigned int region, blk_status_t error)
>  {
> -	if (error)
> +	if (error) {
>  		set_bit(region, &io->error_bits);
> +		/*
> +		 * BLK_STS_INVAL means the bio was not valid for the underlying
> +		 * device (e.g. a misaligned direct I/O), which is a caller error
> +		 * rather than a device failure. Record it on the original bio so
> +		 * bio-based targets can propagate it instead of treating it as a
> +		 * media error and failing the device.
> +		 */
> +		if (error == BLK_STS_INVAL && io->orig_bio)
> +			io->orig_bio->bi_status = error;
> +	}
>  
>  	if (atomic_dec_and_test(&io->count))
>  		complete_io(io);
> @@ -398,6 +409,7 @@ static void async_io(struct dm_io_client *client, unsigned int num_regions,
>  	io->client = client;
>  	io->callback = fn;
>  	io->context = context;
> +	io->orig_bio = dp->orig_bio;
>  
>  	io->vma_invalidate_address = dp->vma_invalidate_address;
>  	io->vma_invalidate_size = dp->vma_invalidate_size;
> diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
> index de5c00704e69c..022ad791c2957 100644
> --- a/drivers/md/dm-raid1.c
> +++ b/drivers/md/dm-raid1.c
> @@ -524,6 +524,17 @@ static void read_callback(unsigned long error, void *context)
>  		return;
>  	}
>  
> +	/*
> +	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
> +	 * e.g. a misaligned direct I/O. That is a caller error, not a device
> +	 * failure, so propagate it rather than failing the mirror and retrying
> +	 * on the other legs, which would fail the same way.
> +	 */
> +	if (bio->bi_status == BLK_STS_INVAL) {
> +		bio_endio(bio);
> +		return;
> +	}
> +
>  	fail_mirror(m, DM_RAID1_READ_ERROR);
>  
>  	if (likely(default_ok(m)) || mirror_available(m->ms, bio)) {
> @@ -622,6 +633,16 @@ static void write_callback(unsigned long error, void *context)
>  		return;
>  	}
>  
> +	/*
> +	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
> +	 * e.g. a misaligned direct I/O. Propagate the error without degrading
> +	 * the array.
> +	 */
> +	if (bio->bi_status == BLK_STS_INVAL) {
> +		bio_endio(bio);
> +		return;
> +	}
> +
>  	/*
>  	 * If the bio is discard, return an error, but do not
>  	 * degrade the array.
> @@ -1262,7 +1283,12 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
>  		return DM_ENDIO_DONE;
>  	}
>  
> -	if (*error == BLK_STS_NOTSUPP)
> +	/*
> +	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
> +	 * e.g. a misaligned direct I/O. Propagate it rather than failing the
> +	 * mirror and retrying, which would fail the same way on every leg.
> +	 */
> +	if (*error == BLK_STS_NOTSUPP || *error == BLK_STS_INVAL)
>  		goto out;
>  
>  	if (bio->bi_opf & REQ_RAHEAD)
> -- 
> 2.52.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

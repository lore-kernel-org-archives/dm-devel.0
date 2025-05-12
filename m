Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B54317DFE7
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 05:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747026926; cv=none; b=Ss+s1xMF55FOl1Nnc3jvUdty9E5Uzhbu622n0Gt25pP2bGzhVPoyMmfrufsnmShjZdcaq0V3JAN+fba0E1DkCdy6iPUqByAA3ccMw1upYX5XqxPz71TYZi4Gz1kveqaVfPOgJvTf9ZmS85Uso01WQvvM/dedyXcwwbNh+St5oXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747026926; c=relaxed/simple;
	bh=qxNCH0olhL2j0JT0LDPSEkUWY09CmuIKJJZkHxB5DXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7DW50FPfEGiFQ2sX3MoNqWjohm7ZN7TVQUKCDttbFJaQs3QLtRUxjZqgqJKaMS9MBYck0uQ/qyS4dsL05or5UPV/1FAvz0YvZHvx+2alPHFK4YiGry1/3RE2d5BiUpsMsDRQyVfdC6GRIIPRocXBjEKIHo/vMT+DajlkymVKtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 41A0A68AA6; Mon, 12 May 2025 07:15:20 +0200 (CEST)
Date: Mon, 12 May 2025 07:15:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 11/19] md/md-llbitmap: implement bitmap
 IO
Message-ID: <20250512051519.GA1555@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-12-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-12-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 09:19:19AM +0800, Yu Kuai wrote:
> +static bool is_raid456(struct mddev *mddev)
> +{
> +	return (mddev->level == 4 || mddev->level == 5 || mddev->level == 6);
> +}

This really should be in a common helper somewhere..

> +static int llbitmap_read(struct llbitmap *llbitmap, enum llbitmap_state *state,
> +			 loff_t pos)
> +{
> +	pos += BITMAP_SB_SIZE;
> +	*state = llbitmap->barrier[pos >> PAGE_SHIFT].data[offset_in_page(pos)];
> +	return 0;
> +}

This always return 0, and could just return void.

> +static void llbitmap_set_page_dirty(struct llbitmap *llbitmap, int idx, int offset)

Overly long line.

Also should the second and third argument be unsigned?

> +	/*
> +	 * if the bit is already dirty, or other page bytes is the same bit is
> +	 * already BitDirty, then mark the whole bytes in the bit as dirty
> +	 */
> +	if (test_and_set_bit(bit, barrier->dirty)) {
> +		infectious = true;
> +	} else {
> +		for (pos = bit * io_size; pos < (bit + 1) * io_size - 1;
> +		     pos++) {
> +			if (pos == offset)
> +				continue;
> +			if (barrier->data[pos] == BitDirty ||
> +			    barrier->data[pos] == BitNeedSync) {
> +				infectious = true;
> +				break;
> +			}
> +		}
> +
> +	}
> +	if (!infectious)
> +		return;

Mabe use a goto and/or a helper function containing the for loop to
clean up the control flow here a bit?

> +static int llbitmap_write(struct llbitmap *llbitmap, enum llbitmap_state state,
> +			  loff_t pos)
> +{
> +	int idx;
> +	int offset;

Unsigned?

> +
> +	pos += BITMAP_SB_SIZE;
> +	idx = pos >> PAGE_SHIFT;
> +	offset = offset_in_page(pos);
> +
> +	llbitmap->barrier[idx].data[offset] = state;
> +	if (state == BitDirty || state == BitNeedSync)
> +		llbitmap_set_page_dirty(llbitmap, idx, offset);
> +	return 0;

and this could also be a void return.

> +		sector = mddev->bitmap_info.offset + (idx << PAGE_SECTORS_SHIFT);

Overly long line.

> +			if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))

Same here.

> +	int nr_pages = (llbitmap->chunks + BITMAP_SB_SIZE + PAGE_SIZE - 1) / PAGE_SIZE;

Unsigned for the type, and DIV_ROUND_UP for the calculation.

> +	struct page *page;
> +	int i = 0;
> +
> +	llbitmap->nr_pages = nr_pages;
> +	while (i < nr_pages) {
> +		page = llbitmap_read_page(llbitmap, i);
> +		if (IS_ERR(page)) {
> +			llbitmap_free_pages(llbitmap);
> +			return PTR_ERR(page);
> +		}
> +
> +		if (percpu_ref_init(&llbitmap->barrier[i].active, active_release,
> +				    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> +			__free_page(page);
> +			return -ENOMEM;

Doesn't this also need a llbitmap_free_pages for the error case?


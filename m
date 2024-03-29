Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947E67460
	for <dm-devel@lists.linux.dev>; Fri, 29 Mar 2024 00:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711672738; cv=none; b=k1qzzt9IA4JM2jWYucCfhYBVTKVgocpJraAMUBTrNvFU8WNlxxSmOBy2stfhjxKWyXeipxXJoVI1L/uI4s56PrVwlxO0F+SeWXU3ou2Nu8weGR4Ge06Flo6rUxkIWk3L7GIZIJb+jvm+MykINZwqFB2ggrq0lqdkE1GthmK7PYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711672738; c=relaxed/simple;
	bh=DHVONMtQrE26uCLUJvXxRWUA9KXIAo6c33CSK8BVD84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4PrHdGR8HoxgPnVyLGorYS9Imm1qbkNY7HI1iHk8K1VU6QugyM6nzbwyVc6IluUxYgK+Sk5jftHZRewf0uU0e9hgoolEeUewLSe+8T3ViFZfpk6fx76Zvp7qxbnwBnO/xPbxXKceYzZCaXVGdKw9U7+LO/5F9Zv1VRWP9CTWp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MYhG9xQ6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MYhG9xQ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711672735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ApZfz4GFfGLnqu37dTR/iN0FL+FFW8qx/5WzrtjWr8Q=;
	b=MYhG9xQ6hTfu4BogaYgmRjAZmRFcpaKfWLpHDmCkvTo9LfeZznJi/pHFfn29lExZbPQzic
	aTuQiN4RZsk2VXkCudnKYul/U+UVp2Z9a/mBbOZ7dXfn1hNMky9KY8+OaXpnHpBmGp9e8X
	y2hHLCPL89fl5cZk1ZOnTL8mJ/gG3/U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-q-1AXpbeOy2nOUjyJQLiMQ-1; Thu, 28 Mar 2024 20:38:51 -0400
X-MC-Unique: q-1AXpbeOy2nOUjyJQLiMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 322CE1869C61;
	Fri, 29 Mar 2024 00:38:50 +0000 (UTC)
Received: from redhat.com (unknown [10.2.16.33])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 701E33C20;
	Fri, 29 Mar 2024 00:38:47 +0000 (UTC)
Date: Thu, 28 Mar 2024 19:38:20 -0500
From: Eric Blake <eblake@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	David Teigland <teigland@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@lst.de>, Joe Thornber <ejt@redhat.com>
Subject: Re: [RFC 4/9] dm: add llseek(SEEK_HOLE/SEEK_DATA) support
Message-ID: <6awt5gq36kzwhuobabtye5vhnexc6cufuamy4frymehuv57ky5@esel3f5naqyu>
References: <20240328203910.2370087-1-stefanha@redhat.com>
 <20240328203910.2370087-5-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328203910.2370087-5-stefanha@redhat.com>
User-Agent: NeoMutt/20240201
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Thu, Mar 28, 2024 at 04:39:05PM -0400, Stefan Hajnoczi wrote:
> Delegate SEEK_HOLE/SEEK_DATA to device-mapper targets. The new
> dm_seek_hole_data() callback allows target types to customize behavior.
> The default implementation treats the target as all data with no holes.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  include/linux/device-mapper.h |  5 +++
>  drivers/md/dm.c               | 68 +++++++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+)
> 

> +/* Default implementation for targets that do not implement the callback */
> +static loff_t dm_blk_seek_hole_data_default(loff_t offset, int whence,
> +		loff_t size)
> +{
> +	switch (whence) {
> +	case SEEK_DATA:
> +		if ((unsigned long long)offset >= size)
> +			return -ENXIO;
> +		return offset;
> +	case SEEK_HOLE:
> +		if ((unsigned long long)offset >= size)
> +			return -ENXIO;
> +		return size;

These fail with -ENXIO if offset == size (matching what we do on files)...

> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static loff_t dm_blk_do_seek_hole_data(struct dm_table *table, loff_t offset,
> +		int whence)
> +{
> +	struct dm_target *ti;
> +	loff_t end;
> +
> +	/* Loop when the end of a target is reached */
> +	do {
> +		ti = dm_table_find_target(table, offset >> SECTOR_SHIFT);
> +		if (!ti)
> +			return whence == SEEK_DATA ? -ENXIO : offset;

...but this blindly returns offset for SEEK_HOLE, even when offset is
beyond the end of the dm.  I think you want 'return -ENXIO;'
unconditionally here.

> +
> +		end = (ti->begin + ti->len) << SECTOR_SHIFT;
> +
> +		if (ti->type->seek_hole_data)
> +			offset = ti->type->seek_hole_data(ti, offset, whence);

Are we guaranteed that ti->type->seek_hole_data will not return a
value exceeding end?  Or can dm be used to truncate the view of an
underlying device, and the underlying seek_hold_data can now return an
answer beyond where dm_table_find_target should look for the next part
of the dm's view?

In which case, should the blkdev_seek_hole_data callback be passed a
max size parameter everywhere, similar to how fixed_size_llseek does
things?

> +		else
> +			offset = dm_blk_seek_hole_data_default(offset, whence, end);
> +
> +		if (whence == SEEK_DATA && offset == -ENXIO)
> +			offset = end;

You have a bug here.  If I have a dm contructed of two underlying targets:

|A  |B  |

and A is all data, then whence == SEEK_HOLE will have offset = -ENXIO
at this point, and you fail to check whether B is also data.  That is,
you have silently treated the rest of the block device as data, which
is semantically not wrong (as that is always a safe fallback), but not
optimal.

I think the correct logic is s/whence == SEEK_DATA &&//.

> +	} while (offset == end);

I'm trying to make sure that we can never return the equivalent of
lseek(dm, 0, SEEK_END).  If you make my above suggested changes, we
will iterate through the do loop once more at EOF, and
dm_table_find_target() will then fail to match at which point we do
get the desired -ENXIO for both SEEK_HOLE and SEEK_DATA.

> +
> +	return offset;
> +}
> +

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.
Virtualization:  qemu.org | libguestfs.org


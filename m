Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1D33E49E
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 09:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713173215; cv=none; b=SMahta1unlGQzS+xNzU9mFW0vF9BgLK8DE8YFTfq4PCGfiai6b4Mu0G6iHcCEfHXsUoafx/XhqHhzNlJv3ij9tA/TvhqsnPFR+H9/p2yctmJeGawdTvstsuTYVkh4A7lmlB39nVFg013RxA0RotC32LfpJN6k/wf2IkmPG37bc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713173215; c=relaxed/simple;
	bh=sA5fgX9HWhMU42nF38m0dAA/l+qdQMZG3Q8ualuuI4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TAGKtKrEn5T6tfWJLP9OqEU9M+Tbqt3Tj0pbrFhO1JoTZxVPv2ECytfDsmsrJahYhWgm3oJPzu4QxrHXLN2FKG+GmTen9IK0cL6a76kcksd6+kd5MB9GAjaPWkPcxsBrTg16WLkDv1hTLSnEg8zcpPHngUBQPJK/3/nrYKQaXFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QApRJ6+L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QApRJ6+L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713173212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JKW7sMkNKvCDKzXl0a+7+sB/76+8oNdGXWP00zBOyoM=;
	b=QApRJ6+LL8rskW2BAZztk5rAqyzq/mNCxusbUzC36w5Ek3exb30N4L9JCsqS9D3OAZDwS/
	5yQNg3jo33GwyjAoWo+c1sF7mG47hkEbC53g0FphgHp0QD3owzrQNGkp3DOy8/mANB5n0u
	iUx+xOcspg4/uLapjfGI6JpXsvcqMug=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-b4_-Er1KM7i5HB7d0PL9cw-1; Mon, 15 Apr 2024 05:26:49 -0400
X-MC-Unique: b4_-Er1KM7i5HB7d0PL9cw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9C35830E77;
	Mon, 15 Apr 2024 09:26:48 +0000 (UTC)
Received: from fedora (unknown [10.72.116.13])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 774E92BA;
	Mon, 15 Apr 2024 09:26:43 +0000 (UTC)
Date: Mon, 15 Apr 2024 17:26:19 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 04/34] md: port block device access to file
Message-ID: <Zhzyu6pQYkSNgvuh@fedora>
References: <20240123-vfs-bdev-file-v2-0-adbd023e19cc@kernel.org>
 <20240123-vfs-bdev-file-v2-4-adbd023e19cc@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123-vfs-bdev-file-v2-4-adbd023e19cc@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Hello,

On Tue, Jan 23, 2024 at 02:26:21PM +0100, Christian Brauner wrote:
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  drivers/md/dm.c               | 23 +++++++++++++----------
>  drivers/md/md.c               | 12 ++++++------
>  drivers/md/md.h               |  2 +-
>  include/linux/device-mapper.h |  2 +-
>  4 files changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 8dcabf84d866..87de5b5682ad 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c

...

> @@ -775,7 +778,7 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
>  {
>  	if (md->disk->slave_dir)
>  		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
> -	bdev_release(td->dm_dev.bdev_handle);
> +	fput(td->dm_dev.bdev_file);

The above change caused regression on 'dmsetup remove_all'.

blkdev_release() is delayed because of fput(), so dm_lock_for_deletion
returns -EBUSY, then this dm disk is skipped in remove_all().

Force to mark DMF_DEFERRED_REMOVE might solve it, but need our device
mapper guys to check if it is safe.

Or other better solution?

thanks,
Ming


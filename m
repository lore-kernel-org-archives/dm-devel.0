Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2822472AF
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686388; cv=none; b=Yq5scirlLzlv8HIAuafVwiCjABRJydUeRlfYYMlZuk3ieQSdxwc6oSC+YJQNzBFoaLn+13eKBRjp+w8d4fOU4TFzeghkNORQqv52s6hIZ+EiNYOm+Uv1IQhbIamGGozfhyYpONs9M1eyNXuYbSbeaBAKXQ/E3A8IMkzzPsU4bxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686388; c=relaxed/simple;
	bh=dV+NLoLFFAnBWC7LgLGgfRPjNhC2AXojzazTAxYhdkA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OsAvBGxpcP1p/eDVLLwUZjarriCMX3sHs/x/nCd9ZCYdw+CHkj4K7IyNGk8/+hORSAPlAlXSzsL6taVxMNO8I09zdmVI7Af/ijXEwx236is7h+NEtZ0833NiFI+NbN+xR+65mHrXc2t/442sa1Jz/+Y9MUfrv3rzQjZLj4LVTag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LT04Slsp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LT04Slsp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750686385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GbhU1qOmDvfWTIoKRCMkcKJ/AjduelLrhNYIMjJrdiw=;
	b=LT04SlspxCzPHfZSCL9/pRQ/0u/LWy/WBB4aiWzZoHhZuUGJ5iUSbf6eq9ftWJVp8gAnQa
	sdM9qzPRr49Xh/iRD4W7eqaZXPP0u/eGT4LVQzqrs0Q+zuVUJYP1DUxjAAPgr/aovvFhIH
	KcwfjIAfdUTwuml6CINFzGVROm5gIjU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-TxzmK-JbN8uEsnQzOUXttA-1; Mon,
 23 Jun 2025 09:46:22 -0400
X-MC-Unique: TxzmK-JbN8uEsnQzOUXttA-1
X-Mimecast-MFC-AGG-ID: TxzmK-JbN8uEsnQzOUXttA_1750686381
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B277819560A1;
	Mon, 23 Jun 2025 13:46:21 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71EBC30001A1;
	Mon, 23 Jun 2025 13:46:20 +0000 (UTC)
Date: Mon, 23 Jun 2025 15:46:17 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH 1/2] dm: dm-crypt: Prevent splitting of emulated zone
 append operations
In-Reply-To: <20250611011340.92226-2-dlemoal@kernel.org>
Message-ID: <b5f54f1e-bd70-1003-a94f-fb6b8e131b4c@redhat.com>
References: <20250611011340.92226-1-dlemoal@kernel.org> <20250611011340.92226-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -rlO3XpZV4vKPfSOuh3xgz3KHPUJgM8NEkJ0jkfQgO4_1750686381
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Applied, thanks.

Mikulas



On Wed, 11 Jun 2025, Damien Le Moal wrote:

> For a zoned dm-crypt device, the native support for zone append
> operations (REQ_OP_ZONE_APPEND) is not enabled and instead dm-crypt
> relies on the emulation done by the block layer using regular write
> operations. This still requires to properly return the written sector as
> the BIO sector of the original BIO. However, this can be done correctly
> only and only if there is a single clone BIO used for processing the
> original zone append operation issued by the user. If the size of a zone
> append operation is larger than dm-crypt max_write_size, then the
> orginal BIO will be split and processed as a chain of regular write
> operations. Such chaining result in an incorrect written sector being
> returned to the zone append issuer using the original BIO sector.
> This in turn results in file system data corruptions using xfs or btrfs.
> 
> Fix this by modifying crypt_io_hints() to cap the max_hw_sectors limit
> for the dm-crypt device to the max_write_size limit. As this limit also
> caps the device max_zone_append_sectors limit, this forces the caller to
> issue zone append operations smaller than this limit, thus moving the
> splitting of large append operations to the caller instead of the
> incorrect internal splitting.
> 
> This change does not have any effect on the size of BIOs received by
> dm-crypt since the block layer does not automatically splits BIOs for
> BIO-based devices. So there is no impact on the performance of regular
> read and write operations.
> 
> Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/md/dm-crypt.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 9dfdb63220d7..7b1e88781a82 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3730,6 +3730,18 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
>  	limits->io_min = max_t(unsigned int, limits->io_min, cc->sector_size);
>  	limits->dma_alignment = limits->logical_block_size - 1;
> +
> +	/*
> +	 * For zoned devices, we cannot split write operations used to emulate
> +	 * zone append operations. And since all write requests are going to be
> +	 * split on get_max_request_size(cc, true) size, apply this limit to the
> +	 * maximum hardware I/O size so that we have a cap on the
> +	 * max_zone_append_sectors limit when the zone limits are validated by
> +	 * the block layer.
> +	 */
> +	if (ti->emulate_zone_append)
> +		limits->max_hw_sectors = min(limits->max_hw_sectors,
> +					     get_max_request_size(cc, true));
>  }
>  
>  static struct target_type crypt_target = {
> -- 
> 2.49.0
> 


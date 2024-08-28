Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419521EB3D
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 13:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724852992; cv=none; b=tCRSSZ9baeWrqhb4GRRbLO6WwbP/d9YoT15zwDf2LhJ0S2J9O75jWWtindsDgPuAw9vpQ6vyqbhr17wZTjNOu9NWBDbWFwTlTP627dc4Y68Chb2XxosuhrZZyp0FJATeTwj3YYrMuLfTxW/niPPRLXvgicz1CfBntznlJcgB8wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724852992; c=relaxed/simple;
	bh=XdnxS+ThTom5ki5hiMAbnDn3XAJSkM7Zm9DKdFjTWLs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=esWkHadGlYUNUvp4KorHkyyTrypaLqkuv0vAFJDI34+v0ruIdJx0b3qbsOWyuCXZpx3hwGQgy+u78j0/NVqAo+d+UB88gedoeMGg+PF6yHPfVXAmTaOe30D9K+/nAuwm5l5VHQLBntjX/A/ftrIDJag3Yba8qnswcodAYhQHFXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PLelQTnX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PLelQTnX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724852990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gJDSm433FYP55u2CYP1GWdEVQeqpBvgJzKAy8UxrTOE=;
	b=PLelQTnXFRFikUTV+wgOZVLlNL60O6CGxt/fvlii8Ql6ch8XxHdJ51QeGlZZ8ztmoaD+h/
	ttjrwMwlsXIUjgb6Q0PMU8riXZhPdCnX5WMnFCNoFVJVGyPLjblFRuKyUv0IugMslzSPqc
	pevqlmTWc22y3uC76Q1o1ov9YYuM8FI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-BT5Gj52DNgCyXLeFxjQAFg-1; Wed,
 28 Aug 2024 09:49:49 -0400
X-MC-Unique: BT5Gj52DNgCyXLeFxjQAFg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA9411955BED;
	Wed, 28 Aug 2024 13:49:47 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9516919560A3;
	Wed, 28 Aug 2024 13:49:45 +0000 (UTC)
Date: Wed, 28 Aug 2024 15:49:41 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-2?Q?=A3ukasz_Patron?= <priv.luk@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: Implement set_read_only
In-Reply-To: <0a02f887-aa70-4c7a-be58-3920596c175e@gmail.com>
Message-ID: <0d430a00-192a-5aa3-4286-c5f47b9c7cd4@redhat.com>
References: <20240821213048.726082-1-priv.luk@gmail.com> <da447e8f-0068-d847-b712-47081fa9f2e7@redhat.com> <0a02f887-aa70-4c7a-be58-3920596c175e@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-1869205479-1724852987=:948041"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-1869205479-1724852987=:948041
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Wed, 28 Aug 2024, Łukasz Patron wrote:

> Hi
> 
> >I'd like to ask why is this patch needed? Why do you want to set read-only
> >status using this ioctl instead of using the existing table flag?
> 
> I basically just wanted to be able to use `blockdev --setrw {}` on
> Android for a block device that had its table mapped as read only. I
> believe that used to work on 5.10 or so, but not anymore.

Yes, I looked at the older kernel and it will just flip the read-only flag 
regardress of whether the driver supports it or not.

What specific partition do you need to write to? Is it possible to just 
reload the table instead of using blockdev --setrw?

Is it required for rooting the phone or for some other activity?

> >If this is needed, we need to add another flag that is being set by
> >dm_blk_set_read_only, so that dm_blk_set_read_only and dm_resume won't
> >step over each other's changes.
> 
> The following diff should address that, however I noticed that
> set_disk_ro() itself, triggers an uevent message that makes upstream
> lvm2/udev/10-dm.rules.in <http://10-dm.rules.in> disable a dm device, so not
> sure if this is
> good to have, after all.

This patch doesn't address that - when someone loads a new table and then 
does suspend+resume to swap the table, set_disk_ro will be called and the 
value specified by dm_blk_set_read_only will be overwritten.

Another problem is that if the table is read-only and you forcefully flip 
it to read-write, then the underlying devices will still be read-only and 
you would be writing to them. This is something that shouldn't be done. 
Unforunatelly, older lvm does that - so the kernel just prints a warning 
instead of rejecting the write. But I just don't want to add more places 
where we are writing to read-only devices.

Mikulas

> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -412,6 +412,19 @@ static int dm_blk_getgeo(struct block_device *bdev,
> struct hd_geometry *geo)
>   static int dm_blk_set_read_only(struct block_device *bdev, bool ro)
>  {
> +	struct mapped_device *md = bdev->bd_disk->private_data;
> +	int srcu_idx;
> +	struct dm_table *table;
> +
> +	table = dm_get_live_table(md, &srcu_idx);
> +	if (table) {
> +		if (ro)
> +			table->mode &= ~BLK_OPEN_WRITE;
> +		else
> +			table->mode = ~BLK_OPEN_WRITE;
> +	}
> +	dm_put_live_table(md, srcu_idx);
> +
>  	set_disk_ro(bdev->bd_disk, ro);
>  	return 0;
>  }
---1463811712-1869205479-1724852987=:948041--


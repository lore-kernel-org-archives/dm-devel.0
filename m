Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2FD64A
	for <dm-devel@lists.linux.dev>; Tue, 27 Aug 2024 17:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781140; cv=none; b=QUq6tfD0l8vCRURlsrf9GfomJGxT4900d5JF7I6WkmDMlU3vcdBzp1T0BYOO1Ba9Wg6ClBiR4DtmL8cw1zF74gxIvJsHiSglOdr9in4TTdIRcmTyk7blrWExZ3f4ARWGc5CDgQa3cwPumWe6EC/okUFkiDRZ0M5She4LwF7FOck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781140; c=relaxed/simple;
	bh=e7BKM5olZ94L3g9T2tqv0EdE7YzzCKLnErdUyr4cFak=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=m3Laoqa1o/2QT8iUfVyqAqlLP2mftce99P38Tu/Pbvae9FwR9WAygOwT6vBsMW8ILhQylung3fizNMUAO0w2VKxA46OEtlFiEq1rI6qZ1oIRsxVkbVV+OzRqe9KSOz2TSfSBiBxSTFnH5poeU7Zcm+Ud+vMVDSbjFjP+kymAx0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J3uUyeTZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J3uUyeTZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724781137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7HPuEU7mzMlv+Rhl994NDb/ii54cFT6bi9t362pW9Pk=;
	b=J3uUyeTZtmYwZ0+sqzxKBdicM6FLX0i+NDsQGF8kGje7dj3fJRVe89ZyUUhu5PiimhDmwt
	C5xL5a6wAGf/UMuZCxwX8feWPRsY64pa8dpK+P5nefpYl7l6QyubzmY5Hn9LuX1/Xy2X0k
	+6esfIN1ZJPJO4uMGMDoSRXNXTvbhbM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-KxS0O9jGOEComt96m23FkQ-1; Tue,
 27 Aug 2024 13:52:14 -0400
X-MC-Unique: KxS0O9jGOEComt96m23FkQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E21141955BF2;
	Tue, 27 Aug 2024 17:52:11 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FEC519560A3;
	Tue, 27 Aug 2024 17:52:09 +0000 (UTC)
Date: Tue, 27 Aug 2024 19:52:05 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-2?Q?=A3ukasz_Patron?= <priv.luk@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: Implement set_read_only
In-Reply-To: <20240821213048.726082-1-priv.luk@gmail.com>
Message-ID: <da447e8f-0068-d847-b712-47081fa9f2e7@redhat.com>
References: <20240821213048.726082-1-priv.luk@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811712-837155280-1724761611=:915355"
Content-ID: <c128e9d3-00f9-b4bb-ea49-474e3a00510d@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-837155280-1724761611=:915355
Content-Type: text/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Content-ID: <62eac86b-f87a-04be-2451-5a96461c9b07@redhat.com>



On Wed, 21 Aug 2024, £ukasz Patron wrote:

> This lets us change the read-only flag for device mapper block devices
> via the BLKROSET ioctl.
> 
> Signed-off-by: £ukasz Patron <priv.luk@gmail.com>
> ---
>  drivers/md/dm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 87bb90303435..538a93e596d7 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -410,6 +410,12 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>  	return dm_get_geometry(md, geo);
>  }
>  
> +static int dm_blk_set_read_only(struct block_device *bdev, bool ro)
> +{
> +	set_disk_ro(bdev->bd_disk, ro);
> +	return 0;
> +}
> +
>  static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
>  			    struct block_device **bdev)
>  {
> @@ -3666,6 +3672,7 @@ static const struct block_device_operations dm_blk_dops = {
>  	.release = dm_blk_close,
>  	.ioctl = dm_blk_ioctl,
>  	.getgeo = dm_blk_getgeo,
> +	.set_read_only = dm_blk_set_read_only,
>  	.report_zones = dm_blk_report_zones,
>  	.pr_ops = &dm_pr_ops,
>  	.owner = THIS_MODULE
> -- 
> 2.46.0

Hi

Device mapper already calls set_disk_ro in the do_resume function. So, the 
problem here is that the value set using set_read_only will be overwritten 
as soon as a new table will be loaded.

I'd like to ask why is this patch needed? Why do you want to set read-only 
status using this ioctl instead of using the existing table flag?

If this is needed, we need to add another flag that is being set by 
dm_blk_set_read_only, so that dm_blk_set_read_only and dm_resume won't 
step over each other's changes.

Mikulas
---1463811712-837155280-1724761611=:915355--


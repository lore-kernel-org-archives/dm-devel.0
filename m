Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB0C43AB3
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 15:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720106965; cv=none; b=tdsa/uIXSzpY6Ob3Gd5vI0D5G/KF0s4egugBDksDcXlvz2wb9G8wsEBBj2VMOpP0tMJU0Z8+BDcAfgVD9HDEh+L1XujGv754WADq/9+miEbyMp0TMkrYPebmujjXggp0q5jRQvcitkp+0ijK599n0qMfCbWIgakzcTcvS4gmiMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720106965; c=relaxed/simple;
	bh=P76FYceHrJYP3VHRuG3OJOpUDhLADam7CDPSRK6G1uA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OZ5B5FoL0RzczxgKIZySWGF2KqNSDzf4Yeq1pHBC8mSGqZWjMIgNHxTVsJozGm2YiPV5r023xZBr0vOwXsJMrPr0excBOzqABQOe679TsN2nvEZIxV/6PMdBWvQSNUMddmLko6PdvIGMxu+Ghol6i4HYlS8a9+C1aT2uLyHaqeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bUJSEEgZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bUJSEEgZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720106963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VMo09GIbeWWei76D143X+Swf4hFzKnjD2EXCX4KLGFs=;
	b=bUJSEEgZAnhfq+xOZc3tR7vH668cMzwhMBwsT3MUzXXoNjwdlC97WL3HuuYErpV9dDnF5s
	AuyxBM4gqLR4sLQefomAne7HFSv8+sAaLGgE+wcc8qxBOjXcs8Sj9xlgcnUce53LjTqWYb
	fKd7tPq6RkNOICNMuJvyJQTisPROX9E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-wXl8dIxCNLSLp0e58Hk67w-1; Thu,
 04 Jul 2024 11:29:21 -0400
X-MC-Unique: wXl8dIxCNLSLp0e58Hk67w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D007196CE02;
	Thu,  4 Jul 2024 15:29:20 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0503195605A;
	Thu,  4 Jul 2024 15:29:19 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id B3EF730C1C14; Thu,  4 Jul 2024 15:29:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id B163D3FB52;
	Thu,  4 Jul 2024 17:29:18 +0200 (CEST)
Date: Thu, 4 Jul 2024 17:29:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Li Dong <lidong@vivo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    "open list:DEVICE-MAPPER  (LVM)" <dm-devel@lists.linux.dev>, 
    open list <linux-kernel@vger.kernel.org>, opensource.kernel@vivo.com
Subject: Re: [PATCH] dm-table:fix zone block_device not aligned with
 zonesize
In-Reply-To: <20240704151549.1365-1-lidong@vivo.com>
Message-ID: <cd05398-cffa-f4ca-2ac3-74433be2316c@redhat.com>
References: <20240704151549.1365-1-lidong@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Thu, 4 Jul 2024, Li Dong wrote:

> For zone block devices, device_area_is_invalid may return an incorrect 
> value.
> 
> Failure log:
> [   19.337657]: device-mapper: table: 254:56: len=836960256 not aligned to
> h/w zone size 3244032 of sde
> [   19.337665]: device-mapper: core: Cannot calculate initial queue limits
> [   19.337667]: device-mapper: ioctl: unable to set up device queue for 
> new table.
> 
> Actually, the device's zone length is aligned to the zonesize.
> 
> Fixes: 5dea271b6d87 ("dm table: pass correct dev area size to device_area_is_valid")
> Signed-off-by: Li Dong <lidong@vivo.com>
> ---
>  drivers/md/dm-table.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 33b7a1844ed4..0bddae0bee3c 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -257,7 +257,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  	if (bdev_is_zoned(bdev)) {
>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>  
> -		if (start & (zone_sectors - 1)) {
> +		if (start % zone_sectors) {
>  			DMERR("%s: start=%llu not aligned to h/w zone size %u of %pg",
>  			      dm_device_name(ti->table->md),
>  			      (unsigned long long)start,
> @@ -274,7 +274,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  		 * devices do not end up with a smaller zone in the middle of
>  		 * the sector range.
>  		 */
> -		if (len & (zone_sectors - 1)) {
> +		if (len % zone_sectors) {
>  			DMERR("%s: len=%llu not aligned to h/w zone size %u of %pg",
>  			      dm_device_name(ti->table->md),
>  			      (unsigned long long)len,
> -- 
> 2.31.1.windows.1

Hi

This probably won't compile on 32-bit architectures because the operators 
for 64-bit divide and modulo don't work there.

Please, rework the patch using dm_sector_div64.

Mikulas


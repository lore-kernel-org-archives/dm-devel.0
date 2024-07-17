Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C748B433D0
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 19:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721245506; cv=none; b=Aovzepk/OvLvpIboUOXl6zuJjT80bKK6WEGVnGnEKGnpt+Qj05aDHZJwGV6FxFhsPuygJFkIG2soid4fy413b/gHMcbV2v9rMi+DmQhewqJ9iWmSp7r6qr+abyhO4txtFYjZtbbNj8viOo6aVH3i0E8hor1VLiklQnpyLz60pxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721245506; c=relaxed/simple;
	bh=98HdpnFc2tWBwxft8wevlXjm8ZdBXiXUpoH8kl92uUU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fYeHPbnz21TLuVWTN37CibbOlQxZO8HXE7oohC1Fssm6c41Q0qEkatXkOWM443GUKVP5/mhD2hZBrvUc0xOTAQs1F04EG/gDZCSnlvXLGcv94oSj6jvcQSAq1fZC56XqxZkX99wO95ASSZqLaFisQL4x5UdNiYTTe/tuccDSqT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gwDadWFU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gwDadWFU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721245503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/zjaOVE5En3QNSXhyeu+Je7Q56EgtTLTti0wlepJuJg=;
	b=gwDadWFUCD8kw1Bb3AxDIiegetW5/ym7y0vVJJ7wypJWTumVZcqPuIyrBxWkmRVTIcCCv9
	hti/L1iY9KaKNjQ/I3NYT+xFynIQf8bcrm2oa2nXH5Eu6LiB63WKgjqNN6u16abI200IEr
	Okmzu+BsvYAzLnCttWyHaBb/XDgL25c=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583--1DdqlkZO9y8SBUIUI4xSw-1; Wed,
 17 Jul 2024 15:45:00 -0400
X-MC-Unique: -1DdqlkZO9y8SBUIUI4xSw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 044AB1955D45;
	Wed, 17 Jul 2024 19:44:59 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F6A83000186;
	Wed, 17 Jul 2024 19:44:58 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 63D8E30C1C16; Wed, 17 Jul 2024 19:44:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 6102F3FB48;
	Wed, 17 Jul 2024 21:44:57 +0200 (CEST)
Date: Wed, 17 Jul 2024 21:44:57 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Khazhismel Kumykov <khazhy@chromium.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <thornber@redhat.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [RFC PATCH] dm ioctl: fix erroneous EINVAL when signaled
In-Reply-To: <20240717185640.1026114-1-khazhy@google.com>
Message-ID: <43954d4-6130-f36a-384c-9f18eda892@redhat.com>
References: <20240717185640.1026114-1-khazhy@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi

I am wondering why does do_resume need to call dm_suspend at all. Does 
anyone here remember why is this code path needed?

Mikulas



On Wed, 17 Jul 2024, Khazhismel Kumykov wrote:

> do_resume when loading a new map first calls dm_suspend, which could
> silently fail. When we proceeded to dm_swap_table, we would bail out
> with EINVAL. Instead, restore new_map and return ERESTARTSYS when
> signaled.
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> ---
>  drivers/md/dm-ioctl.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> 
> RFC as I am rather unfamiliar with the locking semantics here - whether
> we do need to re-grab hash_lock to write to an hc we previously grabbed,
> and whether the device becoming unhashed while we're in this function is
> really something that needs to be checked. However, this patch does fix
> the issue we were seeing - we'd get EINVAL when thread in ioctl was
> signaled.
> 
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index c2c07bfa6471..b81650c6d096 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1181,8 +1181,22 @@ static int do_resume(struct dm_ioctl *param)
>  			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
>  		if (param->flags & DM_NOFLUSH_FLAG)
>  			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
> -		if (!dm_suspended_md(md))
> -			dm_suspend(md, suspend_flags);
> +		if (!dm_suspended_md(md)) {
> +			r = dm_suspend(md, suspend_flags);
> +			if (r == -EINTR)
> +				r = -ERESTARTSYS;
> +			if (r) {
> +				down_write(&_hash_lock);
> +				hc = dm_get_mdptr(md);
> +				if (!hc)
> +					r = -ENXIO;
> +				else
> +					hc->new_map = new_map;
> +				up_write(&_hash_lock);
> +				dm_put(md);
> +				return r;
> +			}
> +		}
>  
>  		old_size = dm_get_size(md);
>  		old_map = dm_swap_table(md, new_map);
> -- 
> 2.45.2.993.g49e7a77208-goog
> 


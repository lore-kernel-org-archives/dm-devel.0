Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B77413AA3A
	for <dm-devel@lists.linux.dev>; Mon, 29 Apr 2024 18:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714416722; cv=none; b=kGZjGwBnCwwTPwTuP2R4jMG71ysKTO7IHQD+ten2jtkFp6f6z3N8x6XW69La0AigxuX3hCC1WnyoFRMdLCZOpdEy7v3YyD8YmtxJD1b2wGaHPdzgtdg4eB08QKD2JpWRZqCobxk0r81Gw4Xn0EeQ3lAFnDCy5lqwcBCfxKlyQN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714416722; c=relaxed/simple;
	bh=qFdDPPD/aAmct1n59KAzDlWg0emzXXWcNK8VuHh0IuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=oVjq472eG6Gr5wyhLtQbakrjCXWebM0JN1O3zXE5Ogn87G7FZ3Xl9TTqecL9DlIsRfaZk0A8OaMVzFF4ifaILXa9Oi0OMQl/L0JFtgeSyHgb7hgjoYGsKomPPODVQVw8nrYCB9Zmei+0SL3Hrl7EsebNBZ1vM0Q4cCImSEol/2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NpPHTrzi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NpPHTrzi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714416720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pAoxLEu/ZHd/IbIIe1miczbMB1y37U90w5sxxBGfx1w=;
	b=NpPHTrziaYzJ8CzrdQKiFRhwWM4YQCRnmeQvonFJ1fSBVIAklo6Z1xQPFAJdXAYifDDEc1
	39XOAM68oES9i//TM9AYGZ2bl0VbVbrtynNJM5OZamIJQHwrorq8dJZi+eixGfC0152wsS
	n3Tsgoo3X83JTQd/sy2sUll/dW2W75c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-z1WY3pi9OwqjMVftuVAYHw-1; Mon, 29 Apr 2024 14:51:56 -0400
X-MC-Unique: z1WY3pi9OwqjMVftuVAYHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F245830D37;
	Mon, 29 Apr 2024 18:51:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78E4340C6CC1;
	Mon, 29 Apr 2024 18:51:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43TIpudr2169862
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 14:51:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43TIpt6E2169861;
	Mon, 29 Apr 2024 14:51:55 -0400
Date: Mon, 29 Apr 2024 14:51:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Liao Yuanhong <liaoyuanhong@vivo.com>
Cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
        bo.wu@vivo.com
Subject: Re: [PATCH] dm-table:remove the restriction on zone sector being
 align to pow2
Message-ID: <Zi_sSyu7CWdFS_v7@redhat.com>
References: <20240429025029.1620-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240429025029.1620-1-liaoyuanhong@vivo.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 29, 2024 at 10:50:29AM +0800, Liao Yuanhong wrote:
> For zoned-UFS, sector size may not aligned to pow2, so we need to remove 
> the pow2 limitation.

When was non-power-of-2 support added to zone devices? AFAIK, the last
attempt to add support for it was:

https://lore.kernel.org/dm-devel/20220923173618.6899-2-p.raghav@samsung.com/

Which was not merged. See that email thread for other necessary dm
changes to support this.

-Ben

> 
> Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
> ---
>  drivers/md/dm-table.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 41f1d731ae5a..823f2f6a2d53 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1663,10 +1663,6 @@ static int validate_hardware_zoned(struct dm_table *t, bool zoned,
>  		return -EINVAL;
>  	}
>  
> -	/* Check zone size validity and compatibility */
> -	if (!zone_sectors || !is_power_of_2(zone_sectors))
> -		return -EINVAL;
> -
>  	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
>  		DMERR("%s: zone sectors is not consistent across all zoned devices",
>  		      dm_device_name(t->md));
> -- 
> 2.25.1
> 


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9270347DD
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685440; cv=none; b=IcBH999CteLBjp8vffZ0Jjbl8JAOC9qafGt8TCxWcr6dszllcaPzloLzIu9u92sUO++c69VdiHOY/nlAsBqTz6zVASwd5NHKxbx5L/PKW8/yHDJUYdj33J6QByHStv6U9lnXtbbD7Nh5Sd6skf8iZK3FWVVX1oDZO5umU1x+yok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685440; c=relaxed/simple;
	bh=mGCuu/KDtlXlvNHusT5UZL/Icddm2gItF9UjbVasS6k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cAqsqFB8ICEUiU8dCFGGRRW8AO0P5P0h66ojvWdMk19QlEhxaFr00M8XjxlByRUR9FxtM/oYBtZt8tsLrLraZ91larP2sShcmvQA/JeUmfJZ9eF4yLwDoCxVU6Cj5YIfQscIMlXlThe4ETPpOqwyHDc37GzVLzIctouZPgi4Sws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NR8jSxmR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NR8jSxmR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750685436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cR9m+JKYJzUgRxYJo/hZ/AkvnY5kd4Rta2fwgNZ7gTc=;
	b=NR8jSxmR3TObP2YhEgPtgi7MTXXfWCp9oAp/5n6LktRRSmxLpUPzc/+sAJ8PrTXhQmvNZ9
	yV0OChlue0/9fINBu5/QUm4VH8ZF+JDrBkgY8cPRj4xfXLl1cRA3eSEiKfeeHpgBC6lIoB
	cIgMRQh1rHjm4XVpx8pdreepi8/glWs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-462-a7UekhuBP7yWhHenfsXrBg-1; Mon,
 23 Jun 2025 09:30:34 -0400
X-MC-Unique: a7UekhuBP7yWhHenfsXrBg-1
X-Mimecast-MFC-AGG-ID: a7UekhuBP7yWhHenfsXrBg_1750685433
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF00D180029E
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 13:30:33 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E227C19560A3;
	Mon, 23 Jun 2025 13:30:32 +0000 (UTC)
Date: Mon, 23 Jun 2025 15:30:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: heinzm@redhat.com
cc: dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm raid: fix variable in journal device check
In-Reply-To: <62c4102aae63d2c7bbd5e140353194b7e6b8678c.1749581474.git.heinzm@redhat.com>
Message-ID: <28c04795-4016-8c59-e79e-a27b73943ac4@redhat.com>
References: <62c4102aae63d2c7bbd5e140353194b7e6b8678c.1749581474.git.heinzm@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JnXYxz_5uoK0Joh68MWwg750gq5rIYrJkA2s2oKkZGY_1750685433
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 10 Jun 2025, heinzm@redhat.com wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> Replace "rdev" wih correct loop variable name "r".
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

Applied, thanks.

Mikulas

> ---
>  drivers/md/dm-raid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 5ae3f059e072..99e15a005bfb 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -2407,7 +2407,7 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
>  	 */
>  	sb_retrieve_failed_devices(sb, failed_devices);
>  	rdev_for_each(r, mddev) {
> -		if (test_bit(Journal, &rdev->flags) ||
> +		if (test_bit(Journal, &r->flags) ||
>  		    !r->sb_page)
>  			continue;
>  		sb2 = page_address(r->sb_page);
> -- 
> 2.49.0
> 


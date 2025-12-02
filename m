Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254772D5932
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764701952; cv=none; b=ro/D/RluInlXjtdNElxCG2JQLEKdKB8NwgOOzKj7z2y6SGVIVtKjtzjEOxVOTPhTK5VO66PjzTKxjCJY2nA+kl5x7/eGhx7TEXpZOXIXQkI+A0yAaVDsfwcBron3Hp2Gao2qaBPzm2qwYHtZUg4bRl4giFkEpksAYHzCKouu3c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764701952; c=relaxed/simple;
	bh=OmWWDnC5bahPNNNwTPKeXVC5ivB65E6Kci14oKdvsxY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Rrr+j7ArKBk5E4cAN4Qg+doBqqeehA+RgkKn8YrYMnia3JzuKYiHYRa0JspYF7w4yZd5nMwz8OT3ddI7m560Vnz/aTnuPpcpbyuGvMmicPfZNuRQ/C+QNmAKKQFE6dPa4gUi9S4YKBdXtn4PL0wPx3UUBvPFaB/HKbcowgL9zxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LgNxMjCM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LgNxMjCM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764701949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHVrktVur33TPdm5nz06kSUrsOyuJl5ewEsjBKOf0cQ=;
	b=LgNxMjCMXwcn3PbSp3+jPFZvLh2wxnWv6jkNd58xJvKofZ+W0IwNVW17njZ+3nkVwSi1PE
	shXaafprJGKoNlS7UPMPaPuGz4d8KO7oUlXJLi5PSOk/rEm5hWmQHEDNVdcEIjRbnrB3Sw
	yfaDbWg5NVdXxeAFOt8j4VAsV5kagHw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-Hhq9L2E6Pwa1xvhD-_ChNg-1; Tue,
 02 Dec 2025 13:59:07 -0500
X-MC-Unique: Hhq9L2E6Pwa1xvhD-_ChNg-1
X-Mimecast-MFC-AGG-ID: Hhq9L2E6Pwa1xvhD-_ChNg_1764701946
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D938019560B2;
	Tue,  2 Dec 2025 18:59:05 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55324180047F;
	Tue,  2 Dec 2025 18:59:03 +0000 (UTC)
Date: Tue, 2 Dec 2025 19:59:00 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alexey Simakov <bigalex934@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev, 
    lvc-project@linuxtesting.org
Subject: Re: [PATCH] dm-raid: fix possible NULL dereference with undefined
 raid type
In-Reply-To: <20251202171837.19885-1-bigalex934@gmail.com>
Message-ID: <7aeea665-ef17-1cd9-5c36-7f16b081347e@redhat.com>
References: <20251202171837.19885-1-bigalex934@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j3D4r0myk35kWAIGSJYNEOGIoCEacDXcyxjhfukMXg4_1764701946
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

OK, accepted.

Mikulas


On Tue, 2 Dec 2025, Alexey Simakov wrote:

> rs->raid_type is assigned from get_raid_type_by_ll(), which may return
> NULL. This NULL value could be dereferenced later in the condition
> 'if (!(rs_is_raid10(rs) && rt_is_raid0(rs->raid_type)))'.
> 
> Add a fail-fast check to return early with an error if raid_type is NULL,
> similar to other uses of this function.
> 
> Found by Linux Verification Center (linuxtesting.org) with Svace.
> 
> Fixes: 33e53f06850f ("dm raid: introduce extended superblock and new raid types to support takeover/reshaping")
> Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
> ---
>  drivers/md/dm-raid.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index c6f7129e43d3..4bacdc499984 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -2287,6 +2287,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
>  
>  			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
>  			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
> +			if (!rs->raid_type)
> +				return -EINVAL;
>  		}
>  
>  	} else {
> -- 
> 2.34.1
> 


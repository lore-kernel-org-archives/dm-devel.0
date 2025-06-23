Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149CF1F6667
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 09:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750672192; cv=none; b=dGqLlflwEIVk6w1QN2gqvWdlMphlTWePDrwFncI4Hg06pTRK8KOiY+sb1MVPTqOhrRQVB2NwIjqI5pXigEhkyp5XqMKcj0rj51kZANS2MmiMl7DUsuuY+WrO4bRM4HFrD/yah7J96xYuvfW+boKCD3lxJZYmJD1GJeUc8R/fnJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750672192; c=relaxed/simple;
	bh=tYYN68KIhKpUm94dvkFIqNu0JEd7ylMdObP13UaACv0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IGbcm/BD1P9koOBGZy/MvqQzh2rRE/hyeVzIEZKubd+M+MjQJo543OZw4uhLtwdR1JbT/WUEoGSLH2GJpyp7DLj6xo0Af7cksdbZrYYbQWe/T17qJwtUtbKAJ0KXGZFi/LxahNY6+wmEpAV7crHfkBt1DTZsvaVDEWAKHJzWqE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tg3/c1/I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tg3/c1/I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750672189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I3UBDVi5sXjr+Xruv6MaOfSJ09qNph1kaTFIkhQo8sc=;
	b=Tg3/c1/IStmKHUcLZAbKw13e7LRtxNyXy+CFkrWShv6CJKGCwCviUK2pAC3ZUWEktNYU+G
	6CStuEaB1/qUwH1OCJYTbdateKYqS09/AFMH+wALkNC33NJCekZhjV4XH1TFE1fARrWYOi
	kUdBfZg71OqNxbSkHPwLVOVb2KqLZc0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-100-wPkyuED1OGSDkcQVVfsOFQ-1; Mon,
 23 Jun 2025 05:49:46 -0400
X-MC-Unique: wPkyuED1OGSDkcQVVfsOFQ-1
X-Mimecast-MFC-AGG-ID: wPkyuED1OGSDkcQVVfsOFQ_1750672184
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E2D21955F06;
	Mon, 23 Jun 2025 09:49:43 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F36718046C7;
	Mon, 23 Jun 2025 09:49:34 +0000 (UTC)
Date: Mon, 23 Jun 2025 11:49:31 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com, 
    hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
    linux-block@vger.kernel.org, ojaswin@linux.ibm.com, 
    martin.petersen@oracle.com
Subject: Re: [PATCH v2 4/5] dm-stripe: limit chunk_sectors to the stripe
 size
In-Reply-To: <20250618083737.4084373-5-john.g.garry@oracle.com>
Message-ID: <0ba540a3-9434-c02a-f2ea-fa5ce13325e3@redhat.com>
References: <20250618083737.4084373-1-john.g.garry@oracle.com> <20250618083737.4084373-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111



On Wed, 18 Jun 2025, John Garry wrote:

> Same as done for raid0, set chunk_sectors limit to appropriately set the
> atomic write size limit.
> 
> Setting chunk_sectors limit in this way overrides the stacked limit
> already calculated based on the bottom device limits. This is ok, as
> when any bios are sent to the bottom devices, the block layer will still
> respect the bottom device chunk_sectors.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/md/dm-stripe.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index a7dc04bd55e5..5bbbdf8fc1bd 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
>  	struct stripe_c *sc = ti->private;
>  	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
>  
> +	limits->chunk_sectors = sc->chunk_size;
>  	limits->io_min = chunk_size;
>  	limits->io_opt = chunk_size * sc->stripes;
>  }
> -- 
> 2.31.1

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>


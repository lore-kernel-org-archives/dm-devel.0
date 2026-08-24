Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41288466AE6
	for <dm-devel@lists.linux.dev>; Mon, 24 Aug 2026 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787588899; cv=none; b=UrHEvNVsjscn8Alif9kgkoik93gkIz7baYBjlBkFr4Zk39IzVqgX/lQAdNYwbNOBzsM67YKJvhLFeNXt/15xAqH2HUgY3y1LAlqCTdkTQZ8mlHg3RRzJZSjxjec2KLdVjhAHKi6Dj8IzhmpGk0nnypUunzUhezJmoF8mvZg9yqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787588899; c=relaxed/simple;
	bh=53MYxQHygGRmNhM2Vile0ew07MSvX8FpWaARTeGaGpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=N0P9SGDvphnnFq93qpD3jXtWXD0gs/ubdLOSISo2psF6CnLXITD/k6rtuuHp56zrnYk9/6+LmU3O4wBGg5PAfY8bWDt439oRDYugRORjxxpIBy19cEFpyq8FFDxUXQ6ZxLCDjSU0GMogfBfdq4rbFpl8nihbnPAxV4hGCFgFbo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i94EEWAd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i94EEWAd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787588897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v2aXZ+3aYtOdfO/eaGtsnYR/4Lx+Rfaway8HdQMDMpM=;
	b=i94EEWAd8BOBC++qbSwJtUd5AOkXJbWMP3lePSjCach05fqg9MVmdeEADk82aTDz4NFo5U
	5KfkgNBmLmTpY9mv0Mh9FRWdiehi9YrfMRplYB+HW1Z95iTrrzMeSFdggSRP7uCMGsQspm
	7PDomFYf3YIW27gN4p83lGPrYwJOE88=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-x5hC3hABMpOrBGrqkYuUzw-1; Mon,
 24 Aug 2026 12:28:10 -0400
X-MC-Unique: x5hC3hABMpOrBGrqkYuUzw-1
X-Mimecast-MFC-AGG-ID: x5hC3hABMpOrBGrqkYuUzw_1787588889
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98515180ABEF;
	Mon, 24 Aug 2026 16:28:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 455E018005AD;
	Mon, 24 Aug 2026 16:28:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 67OGS8xD2535608
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 12:28:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 67OGS7iG2535603;
	Mon, 24 Aug 2026 12:28:07 -0400
Date: Mon, 24 Aug 2026 12:28:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Ming-Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH] dm cache: fix demotion stats in passthrough mode
Message-ID: <aoxxF39tLNz5uT25@redhat.com>
References: <20260818100547.79884-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260818100547.79884-1-mtsai@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bUq3cVtK1yrzBMp7oU5fmPpXi4qe36MEhOgfbM8EwGU_1787588889
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 18, 2026 at 06:05:47PM +0800, Ming-Hung Tsai wrote:
> The demotion counter is incremented per incoming write bio before the
> invalidation begins, causing the demotion count to exceed the actual
> number of cached blocks when multiple bios target the same cached
> block. Additionally, the counter is incremented unconditionally
> regardless of invalidation failure.
> 
> Reproduce steps:
> 
> 1. Create a cache device consisting of 512 cache entries
> 
> modprobe brd rd_size=262144
> dmsetup create cmeta --table "0 8192 linear /dev/ram0 0"
> dmsetup create cdata --table "0 65536 linear /dev/ram0 8192"
> dmsetup create corig --table "0 65536 linear /dev/ram0 262144"
> dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
> dmsetup create cache --table "0 65536 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
> 
> 2. Populate the cache, and record the number of cached blocks
> 
> fio --name=populate --filename=/dev/mapper/cache --rw=randwrite --bs=4k \
> --direct=1 --ioengine=libaio --iodepth=32 --io_size=2048m
> nr_cached=$(dmsetup status cache | awk '{split($7, a, "/"); print a[1]}')
> 
> 3. Reload the cache into passthrough mode
> 
> dmsetup suspend cache
> dmsetup reload cache --table "0 65536 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
> dmsetup resume cache
> 
> 4. Write to the passthrough cache with multiple jobs to trigger
>    multiple bios hitting the same cached block.
> 
> fio --filename=/dev/mapper/cache --name=test --rw=write --bs=4k \
> --direct=1 --ioengine=libaio --iodepth=32 --numjobs=4
> 
> 5. Check if demoted matches cached block count. These numbers should
>    match but may differ due to overcounting per bio.
> 
> nr_demoted=$(dmsetup status cache | awk '{print $12}')
> echo "$nr_cached, $nr_demoted"
> 
> Fix by moving the demotion counter increment into invalidate_complete(),
> gated on the success flag.
> 
> Reported-by: Ben Marzinski <bmarzins@redhat.com>
> Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
> Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  drivers/md/dm-cache-target.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 097315a9bf0f..b79206816956 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -1461,6 +1461,9 @@ static void invalidate_complete(struct dm_cache_migration *mg, bool success)
>  	struct bio_list bios;
>  	struct cache *cache = mg->cache;
>  
> +	if (success)
> +		atomic_inc(&cache->stats.demotion);
> +
>  	bio_list_init(&bios);
>  	if (mg->cell) {
>  		if (dm_cell_unlock_v2(cache->prison, mg->cell, &bios))
> @@ -1732,7 +1735,6 @@ static int map_bio(struct cache *cache, struct bio *bio, dm_oblock_t block,
>  		if (passthrough_mode(cache)) {
>  			if (bio_data_dir(bio) == WRITE) {
>  				bio_drop_shared_lock(cache, bio);
> -				atomic_inc(&cache->stats.demotion);
>  				invalidate_start(cache, cblock, block, bio);
>  				return DM_MAPIO_SUBMITTED;
>  			} else
> -- 
> 2.49.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F017464
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 18:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745434027; cv=none; b=nv4UWZJOOY3Pi7Jteu57Hc99F2kvRQSxZmSQppOWkOv5UatwictaaqeVH/aE2B6O8ME1kaIZFd69/+LrjYMEq6QLhjNTScqGqsh6BQ2+P/2O287czsypXXIsHccKLnAznIM5wHG+MauNBZ2P64LEEiG8YyUSNhpehFFGmpsdlsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745434027; c=relaxed/simple;
	bh=KYpdei64AHPkEj7+zFCJh7oDwHGRpUJmtGcUxkLJI8Q=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=o8P60vGi2AcRAWBTpl8OxmJUtvpIAtY0ukNRyzlY608At60MeubaGZsEhMGW5BkQvXAMMsQjkDzq/la7cQrrliZHEk4s+B+KE2AtP3tMrv1VyY3beU4oh7bQ+RPtSBQSt8E/B53Sx1fciMylkcsy4+OSISS35phzZA+bh0vYk84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DCbtMAH7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DCbtMAH7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745434024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v63IATN5Q1cW8d2KDixS4HNY/hq6986qs8KLWCQANyY=;
	b=DCbtMAH7DM/NkuO3Q+G4V166npS4sJiS+1eNJXPY6SC97B1V2Dy4lkL6Ag/p8qLRaR1uEu
	wSB56Kjg9HWhDvrjoARAI8eyzZsg4hrlIExgS/1Cug20fu5NjKVtvbjsQn4QTrphpL7evZ
	cf0TvmUnBO+a8dBg2zZLGBbTrGTBf+Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-TSi03hotM2CzO0OApdTW1Q-1; Wed,
 23 Apr 2025 14:47:01 -0400
X-MC-Unique: TSi03hotM2CzO0OApdTW1Q-1
X-Mimecast-MFC-AGG-ID: TSi03hotM2CzO0OApdTW1Q_1745434020
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6980180010A;
	Wed, 23 Apr 2025 18:46:59 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3FA71800352;
	Wed, 23 Apr 2025 18:46:57 +0000 (UTC)
Date: Wed, 23 Apr 2025 20:46:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: snitzer@kernel.org, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, guoweichao@oppo.com, ebiggers@kernel.org
Subject: Re: [PATCH] dm-verity: all verity devices share the same dm_io_client
 and recheck_pool.
In-Reply-To: <20250423115013.4004577-1-weilongping@oppo.com>
Message-ID: <4e48044b-0481-4d3c-9138-0c636d5a1a8d@redhat.com>
References: <20250423115013.4004577-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vYQaDm3z1brQ9rzw6dHduonGOtm3eSFJy0lBZJyAc_c_1745434020
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I nack this series of patches, because sharing mempools (or dm_io_client) 
is prone to deadlocks.

If you have two dm-verity devices stacked on each other, the upper device 
may deplete the mempool and the lower device has no way to do forward 
progress, resulting in a deadlock.

For example, suppose that you have dm-snapshot on the top of dm-verity on 
the top of another dm-verity device. If the kernel needs to write back 
dirty memory, it calls the dm-snapshot target, the dm-snapshot reads data 
from the upper dm-verity device, the upper dm-verity device depletes the 
shared mempool and the lower dm-verity device has no way to make forward 
progress - deadlock.

If you want to reduce memory consumption, set reserved_bio_based_ios to 1, 
that should be safe. (setting it to 0 is prone to deadlock).

I remember that the one of the first things that I did at Red Hat 17 years 
ago was removing shared resources from device mapper and making them 
per-device :-)

Mikulas


On Wed, 23 Apr 2025, LongPing Wei wrote:

> The size of biovec's memory of one dm_io_client will be
> reserved_bio_based_ios(default value is 16) * 4KiB memory.
> When the number of dm-verity devices is dozens,
> the total memory size will be several MiBs.
> 
> The number of dm-verity devices is 59 on my test device,
> and the size of biovec's memory here will be 3.87MiB.
> 
> This commit will reduce the memory usage of dm-verity
> by making all verity devices share the same dm_io_client and recheck_pool.
> 
> Fixes: 9177f3c0dea61 ("dm-verity: recheck the hash after a failure")
> 
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> ---
>  drivers/md/dm-verity-target.c | 71 ++++++++++++++++++++++++-----------
>  drivers/md/dm-verity.h        |  3 --
>  2 files changed, 49 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 3c427f18a04b..986c3386aa59 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -72,6 +72,9 @@ struct dm_verity_prefetch_work {
>  	unsigned int n_blocks;
>  };
>  
> +static struct dm_io_client *verity_io_client;
> +static mempool_t verity_recheck_pool;
> +
>  /*
>   * Auxiliary structure appended to each dm-bufio buffer. If the value
>   * hash_verified is nonzero, hash of the block has been verified.
> @@ -449,14 +452,14 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
>  	struct dm_io_request io_req;
>  	struct dm_io_region io_loc;
>  
> -	page = mempool_alloc(&v->recheck_pool, GFP_NOIO);
> +	page = mempool_alloc(&verity_recheck_pool, GFP_NOIO);
>  	buffer = page_to_virt(page);
>  
>  	io_req.bi_opf = REQ_OP_READ;
>  	io_req.mem.type = DM_IO_KMEM;
>  	io_req.mem.ptr.addr = buffer;
>  	io_req.notify.fn = NULL;
> -	io_req.client = v->io;
> +	io_req.client = verity_io_client;
>  	io_loc.bdev = v->data_dev->bdev;
>  	io_loc.sector = cur_block << (v->data_dev_block_bits - SECTOR_SHIFT);
>  	io_loc.count = 1 << (v->data_dev_block_bits - SECTOR_SHIFT);
> @@ -478,7 +481,7 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
>  	memcpy(dest, buffer, 1 << v->data_dev_block_bits);
>  	r = 0;
>  free_ret:
> -	mempool_free(page, &v->recheck_pool);
> +	mempool_free(page, &verity_recheck_pool);
>  
>  	return r;
>  }
> @@ -1075,10 +1078,6 @@ static void verity_dtr(struct dm_target *ti)
>  	if (v->verify_wq)
>  		destroy_workqueue(v->verify_wq);
>  
> -	mempool_exit(&v->recheck_pool);
> -	if (v->io)
> -		dm_io_client_destroy(v->io);
> -
>  	if (v->bufio)
>  		dm_bufio_client_destroy(v->bufio);
>  
> @@ -1625,20 +1624,6 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	}
>  	v->hash_blocks = hash_position;
>  
> -	r = mempool_init_page_pool(&v->recheck_pool, 1, 0);
> -	if (unlikely(r)) {
> -		ti->error = "Cannot allocate mempool";
> -		goto bad;
> -	}
> -
> -	v->io = dm_io_client_create();
> -	if (IS_ERR(v->io)) {
> -		r = PTR_ERR(v->io);
> -		v->io = NULL;
> -		ti->error = "Cannot allocate dm io";
> -		goto bad;
> -	}
> -
>  	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
>  		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
>  		dm_bufio_alloc_callback, NULL,
> @@ -1822,7 +1807,49 @@ static struct target_type verity_target = {
>  	.preresume	= verity_preresume,
>  #endif /* CONFIG_SECURITY */
>  };
> -module_dm(verity);
> +
> +static int __init dm_verity_init(void)
> +{
> +	int r;
> +
> +	r = mempool_init_page_pool(&verity_recheck_pool, 1, 0);
> +	if (unlikely(r)) {
> +		DMERR("Cannot allocate mempool");
> +		goto mempool_init_page_pool_failed;
> +	}
> +
> +	verity_io_client = dm_io_client_create();
> +	if (IS_ERR(verity_io_client)) {
> +		r = PTR_ERR(verity_io_client);
> +		verity_io_client = NULL;
> +		DMERR("Cannot allocate dm io");
> +		goto dm_io_client_create_failed;
> +	}
> +
> +	r = dm_register_target(&(verity_target));
> +	if (unlikely(r))
> +		goto dm_register_target_failed;
> +	return r;
> +
> +dm_register_target_failed:
> +	dm_io_client_destroy(verity_io_client);
> +	verity_io_client = NULL;
> +dm_io_client_create_failed:
> +	mempool_exit(&verity_recheck_pool);
> +mempool_init_page_pool_failed:
> +	return r;
> +}
> +module_init(dm_verity_init);
> +
> +static void __exit dm_verity_exit(void)
> +{
> +	dm_unregister_target(&(verity_target));
> +	mempool_exit(&verity_recheck_pool);
> +	if (verity_io_client)
> +		dm_io_client_destroy(verity_io_client);
> +	verity_io_client = NULL;
> +}
> +module_exit(dm_verity_exit)
>  
>  /*
>   * Check whether a DM target is a verity target.
> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> index 8cbb57862ae1..f28454f81249 100644
> --- a/drivers/md/dm-verity.h
> +++ b/drivers/md/dm-verity.h
> @@ -75,9 +75,6 @@ struct dm_verity {
>  	unsigned long *validated_blocks; /* bitset blocks validated */
>  
>  	char *signature_key_desc; /* signature keyring reference */
> -
> -	struct dm_io_client *io;
> -	mempool_t recheck_pool;
>  };
>  
>  struct dm_verity_io {
> -- 
> 2.34.1
> 


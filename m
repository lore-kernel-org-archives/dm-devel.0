Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB04223DEA
	for <dm-devel@lists.linux.dev>; Mon, 13 Apr 2026 02:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776046035; cv=none; b=YjiMbPieiU69NuHsI9JwXYXMBLkMM+x4BNH2JQoYFkcj/jFitv1B3N3OffUMUcz/ozxRO0oI7G7Ee6at7JWl77bG529iKOYyb6zS06pMgY9Eq4wj1qdkIl6gL6icIBroo3OyHfuxwf6ZFzhWdf3Dzc0R4HeWD3I7W0kNJRr4BRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776046035; c=relaxed/simple;
	bh=7sFyGGauP5gNRuwlpPuHM175HkedoJqyzmdS/Bmjlzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PdifMVBau5bZlsich6HHvH/4eRc+1Lwt4F5XA2AfVfKxBbvG7rlbN4ZaTRWWIV6Imm+EVOZr+xc9E0fuud9vNOPft6vTl03m9RLBebptQgC3H7wiOHaSrL1XVW9ziPp2IbIMZtGUXAXa8VJ61q1f+Sh+997ZWDK5Vb0Vp2lF53M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFlllZzG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFlllZzG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776046032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MNKfdBox0aRE/GHZk1rNSRCiPUp1KxmcHVJkXtQYAjE=;
	b=ZFlllZzGT72WjPGJCWLjc2fw5E9SQEXbbYsL/GaQYCOEfEO3zuyIZhGEX16FEcTJeXU0c7
	1uOZrhMBl3gvCDZtonqNNMBQkpSar0Q7rdDtspCaXiwRpcEbirgE5DIq0szJshkdtfgdMd
	U6dhVMrYDuKfK6y2mcWas23eG8gIoGo=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-MVdTpG37ObevCWA1iVSFlA-1; Sun, 12 Apr 2026 22:07:09 -0400
X-MC-Unique: MVdTpG37ObevCWA1iVSFlA-1
X-Mimecast-MFC-AGG-ID: MVdTpG37ObevCWA1iVSFlA_1776046029
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35da97f6a6dso4166476a91.0
        for <dm-devel@lists.linux.dev>; Sun, 12 Apr 2026 19:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776046028; x=1776650828;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MNKfdBox0aRE/GHZk1rNSRCiPUp1KxmcHVJkXtQYAjE=;
        b=XxdTcfsyz7eTj6KPzZXRbDWErZRda5/14oU/AKjrAL4S95EQC+hyI106LDvHedT3GR
         rAvG1MUeaIDAK7fvoo99pz3ag4ktvRb3DRXW8dhzmaXVVdwADdnnhLvS9q7LAJWGFeHZ
         i4ytGyI35ky4moMuCQ4DBfwF9h2F+1pAaW0YiMgNR9iYEJmzS6hN3mJgM6AYulo9aSZ3
         mfzy5Wjl3HXkrlQJLvPpqL3lzEMlzKiCUhtNxqYys/Mibr0WXbsA0bKA7s/YUvybN/Ei
         sUz8QYo/w9MW9u7/ljpUwj2b8y/WdHRAB5QlNm3KqPRSzyGtcUD6wa/kSwAWZITcWGXv
         pHtA==
X-Forwarded-Encrypted: i=1; AJvYcCU9oqNHbQAMe2aiRUDGt2I7oQeYd1MyBFRmAQA5rIuVSesHB/907+hxOKcIU6fx8+fVtx+aIPfatw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4SjyP8v7CL9i4RAsYxCqcgYJIJIfAZ8YqVNeW00BXb5iBIcEg
	AK3HivEZfNKyVTrUZAveVBn94mgSBo6VnRipXv4Dc3sQ+dVng3J9ZK1QkPNVGubQ5Ox9jGqklwk
	dvk7wxebUnfTD7b3OVrbYCNrlHAxiPGWQuETG74K+nzqLk9Dkpus9LolsNcq4
X-Gm-Gg: AeBDievezb/AU87nOFVk/eE3RnA8Gs+dvl2TJbB7rk0EORwlUVX6WMQMSjMe0tuGfJn
	r1u1fooPBIrTWiZ1elmd2poRr2Gx/tZKYK0qTHLAb1DdYXb9qLG9rHx6b3ms7kwkWbCgyvfVuWP
	a44vRU85g0ua5CE67oSy5SSBe92tnOU6zYufSFNEroMam2EA2oeKkL0RcLZnlf2clC5YRSOSu1U
	mSZhZsQLVFp0TvW33SBmK/L7KNA5iLVDsAeQf0QjPz9ru+yeEUzXMRN+cSODj/1dioOJ2mpZPJp
	76c+oLttKjvHIvsYdVeIz0cdg8bQ5sx5Mqa6tVq+OVUbCF4BbbqZZv0iFdCANuTwSRvn7+3vAqX
	OclHFrEnAv3KjSDnR7mSyBCbp+P2UcAhctZIhDfeU72OJec8hiRyf7g9vXq19hZG3+6qjDd9SXP
	UQN8mN5eyA8idDK+en7TYZb2vaTetvkXP8
X-Received: by 2002:a05:6a20:9389:b0:39f:23d9:99bd with SMTP id adf61e73a8af0-39fe3d0e786mr11111023637.20.1776046028403;
        Sun, 12 Apr 2026 19:07:08 -0700 (PDT)
X-Received: by 2002:a05:6a20:9389:b0:39f:23d9:99bd with SMTP id adf61e73a8af0-39fe3d0e786mr11111002637.20.1776046027922;
        Sun, 12 Apr 2026 19:07:07 -0700 (PDT)
Received: from [10.72.112.77] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c50d874sm9298638b3a.59.2026.04.12.19.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2026 19:07:06 -0700 (PDT)
Message-ID: <3fed2f45-37a5-44cf-b862-f778ca685af9@redhat.com>
Date: Mon, 13 Apr 2026 10:07:01 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
 Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>
Cc: linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 Nigel Croxon <ncroxon@redhat.com>
References: <20260408043548.1695157-1-bmarzins@redhat.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20260408043548.1695157-1-bmarzins@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eB5E5pH_xnYKvI9QE4BxWixQckiSkVENH6co9vb9RaU_1776046029
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/4/8 12:35, Benjamin Marzinski 写道:
> If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> raid5_make_request() will free the cloned bio. But raid5_make_request()
> can call make_stripe_request() multiple times, writing to the various
> stripes. If that bio got added to the toread or towrite lists of a
> stripe disk in an earlier call to make_stripe_request(), then it's not
> safe to just free the bio if a later part of it is found to cross the
> reshape position. Doing so can lead to a UAF error, when bio_endio()
> is called on the bio for the earlier stripes.
>
> Instead, raid5_make_request() needs to wait until all parts of the bio
> have called bio_endio(). To do this, bios that cross the reshape
> position while the reshape can't make progress are flagged as needing to
> wait for all parts to complete. When raid5_make_request() has a bio that
> failed make_stripe_request() with STRIPE_WAIT_RESHAPE, it sets
> bi->bi_private to a completion struct and waits for completion after
> ending the bio.  When the bio_endio() is called for the last time on a
> clone bio with bi->bi_private set, it wakes up the waiter. This
> guarantees that raid5_make_request() doesn't return until the cloned bio
> needing a retry for io across the reshape boundary is safely cleaned up.
>
> There is a simple reproducer available at [1]. Compile the kernel with
> KASAN for more useful reporting when the error is triggered (this is not
> necessary to see the bug).
>
> [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa5
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>
> Changes from v1:
> - Removed mddev->pending_retry_bios, mddev->retry_bios_wait, and
>    md_io_clone->must_retry. Instead, use a completion struct
>    pointed to by bi->bi_private, as suggested by Xiao Ni and Yu Kuai.
>
>   drivers/md/md.c    | 31 ++++++++-----------------------
>   drivers/md/md.h    |  1 -
>   drivers/md/raid5.c |  7 ++++++-
>   3 files changed, 14 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ce6f9e9d38e..4318d875a5f6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9215,9 +9215,11 @@ static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
>   
>   static void md_end_clone_io(struct bio *bio)
>   {
> -	struct md_io_clone *md_io_clone = bio->bi_private;
> +	struct md_io_clone *md_io_clone = container_of(bio, struct md_io_clone,
> +						       bio_clone);
>   	struct bio *orig_bio = md_io_clone->orig_bio;
>   	struct mddev *mddev = md_io_clone->mddev;
> +	struct completion *reshape_completion = bio->bi_private;
>   
>   	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
>   		md_bitmap_end(mddev, md_io_clone);
> @@ -9229,7 +9231,10 @@ static void md_end_clone_io(struct bio *bio)
>   		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>   
>   	bio_put(bio);
> -	bio_endio(orig_bio);
> +	if (unlikely(reshape_completion))
> +		complete(reshape_completion);
> +	else
> +		bio_endio(orig_bio);
>   	percpu_ref_put(&mddev->active_io);
>   }
>   
> @@ -9254,7 +9259,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
>   	}
>   
>   	clone->bi_end_io = md_end_clone_io;
> -	clone->bi_private = md_io_clone;
> +	clone->bi_private = NULL;
>   	*bio = clone;
>   }
>   
> @@ -9265,26 +9270,6 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
>   }
>   EXPORT_SYMBOL_GPL(md_account_bio);
>   
> -void md_free_cloned_bio(struct bio *bio)
> -{
> -	struct md_io_clone *md_io_clone = bio->bi_private;
> -	struct bio *orig_bio = md_io_clone->orig_bio;
> -	struct mddev *mddev = md_io_clone->mddev;
> -
> -	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
> -		md_bitmap_end(mddev, md_io_clone);
> -
> -	if (bio->bi_status && !orig_bio->bi_status)
> -		orig_bio->bi_status = bio->bi_status;
> -
> -	if (md_io_clone->start_time)
> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
> -
> -	bio_put(bio);
> -	percpu_ref_put(&mddev->active_io);
> -}
> -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
> -
>   /* md_allow_write(mddev)
>    * Calling this ensures that the array is marked 'active' so that writes
>    * may proceed without blocking.  It is important to call this before
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ac84289664cd..5d57fee22901 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -917,7 +917,6 @@ extern void md_finish_reshape(struct mddev *mddev);
>   void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>   			struct bio *bio, sector_t start, sector_t size);
>   void md_account_bio(struct mddev *mddev, struct bio **bio);
> -void md_free_cloned_bio(struct bio *bio);
>   
>   extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
>   void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a8e8d431071b..dc0c680ca199 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6217,7 +6217,12 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   
>   	mempool_free(ctx, conf->ctx_pool);
>   	if (res == STRIPE_WAIT_RESHAPE) {
> -		md_free_cloned_bio(bi);
> +		DECLARE_COMPLETION_ONSTACK(done);
> +		WRITE_ONCE(bi->bi_private, &done);
> +
> +		bio_endio(bi);
> +
> +		wait_for_completion(&done);
>   		return false;
>   	}
>   


The patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>



Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A851A13AD0
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729582247; cv=none; b=sWZS+rGMHUwMYq8IloW/UoLdO/DhH4i83u2TuextJATv4WCmSZn7dWtYskgrWrd/9poFoskazeesO2NxuzriIAQa5+j15ytctmNZEVPD62w0DgWjJZdAVTLzohf1fza8xywU/Mb11PM69BwRHhsH6CmasiNdkOHrVYYJhGDWpi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729582247; c=relaxed/simple;
	bh=hM8xVqS9LFRpeFFY0CQ47zcsqsGW2epnw8c50TNIIHA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XxGxiSpro1AVsctLLlerJPEHhePMcONZtsZLOqH2bff0i+3uqOYkHpN+1OvhfknaL0vieDA/epRpqzj0F0DS1pBvXw7eADWHWuzqW4vSXHJXw2GM+wEmoj1H3GpGEnjNZmf4wzBv6bKuEDGd10cCPv7K52euvgHIkcZN5Vhstv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UZblQU69; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UZblQU69"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729582244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kpMURlKFelnT+QWiN3vxLB+iKUoCDsfMsnrv8BYrHTg=;
	b=UZblQU69zozBSX3k1pMoRkYmBOW5LlcfMTDF1Q21xyvB8kbXkIf1fdhgLdtS5iK8BiKtPq
	1j1hEsKvV5iCTzxiUWrCJdeH5nnO2MvtJysXsp/rAlGsr+X4NK9hFs2ECAW84V0N/sg48Y
	Ma3ZV3c9WJ8D1tyd6MPlFcJ9K8qQHgI=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-_ii4B3ciOJWlTP4KwDoGIw-1; Tue, 22 Oct 2024 03:30:42 -0400
X-MC-Unique: _ii4B3ciOJWlTP4KwDoGIw-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e17bb508bb9so9245671276.2
        for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 00:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729582242; x=1730187042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kpMURlKFelnT+QWiN3vxLB+iKUoCDsfMsnrv8BYrHTg=;
        b=tx82yvxkAasGQZu0qcbmCNkNfHNAU1xeCgNI5epnWEPfL9j3hNy/DrZIvjUqlfh95c
         drxo+svxp6KV4pSfb1fQfAo5jEj75zPF5jXSXAIEGEnYR/cJFsNhzhrTTVbGf8Ja9ao5
         97hRSBdb5WzBvfLGc4i1AH95cTG8AUYnc5t3m/7qu39uMhZ8jJT/ReHpdHkrCPkgCNHc
         rwWvgpA3LdRyo/coz7sv3q0l3c+B7vbhB1kM4HOrsF+i1cOlqEHAlwD4xBAKZjXO6Pbf
         2nTc8bqyNLjjST8LixF2eAKi/r+x5h8qwJq65eSjyeb16tMfogPBeWJXJ296J2+NMutX
         5+qg==
X-Gm-Message-State: AOJu0Yz+K6ZtXznJfbOfPb3vRyFYngIq8VxWF5a4Yvbx0wtenRaBFMYt
	eeTwHvi3HKNzFAzZaaovZ3SEVkIUgzQ7ydGKOoX+eS522nDACvHLHqCLk5rg1RKnwH3QlZBqhq/
	Xf7Nqm0U94AcxklQ2ojSe8ZQjj4fL7W5G0Zq5C32c2oHil86Xi1mMXOy4B6FYnp+FiD3Di5sQUO
	n/0PFHIhiUVOVO8KuAfy1mfu/gzSNWvBM=
X-Received: by 2002:a05:6902:2404:b0:e29:1a79:efe8 with SMTP id 3f1490d57ef6-e2bb16939cemr12003818276.44.1729582242079;
        Tue, 22 Oct 2024 00:30:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUIcxaGZTosO1iZ0NPj6bG3RpbXjBWiVHu5TrlPOdFc+GJlsLjHr6mhrMMnKdHpNTPsOFddoS+CM78yuyK0Ek=
X-Received: by 2002:a05:6902:2404:b0:e29:1a79:efe8 with SMTP id
 3f1490d57ef6-e2bb16939cemr12003798276.44.1729582241768; Tue, 22 Oct 2024
 00:30:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241022071249.778584-1-mtsai@redhat.com>
In-Reply-To: <20241022071249.778584-1-mtsai@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 22 Oct 2024 08:30:13 +0100
Message-ID: <CAJ0trDbcKwB5MEbouDN9AMrGSqqmNyeC7bqTbemShL0p4tgG9w@mail.gmail.com>
Subject: Re: [PATCH 2/5] dm cache: fix flushing uninitialized delayed_work on
 cache_ctr error
To: Ming-Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, luomeng12@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ack

On Tue, Oct 22, 2024 at 8:13=E2=80=AFAM Ming-Hung Tsai <mtsai@redhat.com> w=
rote:
>
> An unexpected WARN_ON from flush_work() may occur when cache creation
> fails, caused by destroying the uninitialized delayed_work waker in the
> error path of cache_create(). For example, the warning appears on the
> superblock checksum error.
>
> Reproduce steps:
>
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
> dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
> dd if=3D/dev/urandom of=3D/dev/mapper/cmeta bs=3D4k count=3D1 oflag=3Ddir=
ect
> dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
>
> Kernel logs:
>
> (snip)
> WARNING: CPU: 0 PID: 84 at kernel/workqueue.c:4178 __flush_work+0x5d4/0x8=
90
>
> Fix by pulling out the cancel_delayed_work_sync() from the constructor's
> error path. This patch doesn't affect the use-after-free fix for
> concurrent dm_resume and dm_destroy (commit 6a459d8edbdb ("dm cache: Fix
> UAF in destroy()")) as cache_dtr is not changed.
>
> Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
> Fixes: 6a459d8edbdb ("dm cache: Fix UAF in destroy()")
> ---
>  drivers/md/dm-cache-target.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 90772b42c234..68e9a1abd303 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -1905,16 +1905,13 @@ static void check_migrations(struct work_struct *=
ws)
>   * This function gets called on the error paths of the constructor, so w=
e
>   * have to cope with a partially initialised struct.
>   */
> -static void destroy(struct cache *cache)
> +static void __destroy(struct cache *cache)
>  {
> -       unsigned int i;
> -
>         mempool_exit(&cache->migration_pool);
>
>         if (cache->prison)
>                 dm_bio_prison_destroy_v2(cache->prison);
>
> -       cancel_delayed_work_sync(&cache->waker);
>         if (cache->wq)
>                 destroy_workqueue(cache->wq);
>
> @@ -1942,13 +1939,22 @@ static void destroy(struct cache *cache)
>         if (cache->policy)
>                 dm_cache_policy_destroy(cache->policy);
>
> +       bioset_exit(&cache->bs);
> +
> +       kfree(cache);
> +}
> +
> +static void destroy(struct cache *cache)
> +{
> +       unsigned int i;
> +
> +       cancel_delayed_work_sync(&cache->waker);
> +
>         for (i =3D 0; i < cache->nr_ctr_args ; i++)
>                 kfree(cache->ctr_args[i]);
>         kfree(cache->ctr_args);
>
> -       bioset_exit(&cache->bs);
> -
> -       kfree(cache);
> +       __destroy(cache);
>  }
>
>  static void cache_dtr(struct dm_target *ti)
> @@ -2561,7 +2567,7 @@ static int cache_create(struct cache_args *ca, stru=
ct cache **result)
>         *result =3D cache;
>         return 0;
>  bad:
> -       destroy(cache);
> +       __destroy(cache);
>         return r;
>  }
>
> @@ -2612,7 +2618,7 @@ static int cache_ctr(struct dm_target *ti, unsigned=
 int argc, char **argv)
>
>         r =3D copy_ctr_args(cache, argc - 3, (const char **)argv + 3);
>         if (r) {
> -               destroy(cache);
> +               __destroy(cache);
>                 goto out;
>         }
>
> --
> 2.47.0
>


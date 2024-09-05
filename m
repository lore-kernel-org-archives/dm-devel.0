Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BAA187554
	for <dm-devel@lists.linux.dev>; Thu,  5 Sep 2024 18:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560523; cv=none; b=djf06RSQI4CIEnkkSJaXp6lJphuDqfc8UPQbzh+Quw12eVQGj3at/EDnWQS4jBS67dUZysFsBAtND623du+/UJH+11mHu/J3JTUgLC29zmgVro6OOgcyOXbYx1kz8rmSfMsdytIQMVFuwsltz74sgPmXl32Sz9Et8wRfrWTacZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560523; c=relaxed/simple;
	bh=Hby1hOdwKYCfXNR4WIB+PqjAkcRH83kj+jNz8JiJ2Uc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=j8LCN6bUNm5v/iTZPYlE3fh9hgEC/FPyR21LTOejFKDDE3W99vIRsflquDIkUDOStBAKKI3KoKNCnjk9PYWGlOnTbnzY4/rDZIJjLjYLfjNS8JNl0RXKQ/21+PXjU7NSnHcydYx89qNYQEwvXKhsgS3Vr0MWjtzI210brNmw6Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CUSC9FhZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUSC9FhZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725560520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZVrq2tmtI8yniXwYB5nDBHMyXlS7xVzITGYCNH+G7Q=;
	b=CUSC9FhZJARV5LZLnEWrXR7XL1jw61TbmjoHIyOlIHy5TPH9+Fc4ojLd4QZQFfVYsDjeAw
	N26IAUYYqyochSp0kI6u1wvzP7U8+5BjLsNVtvOxciAg6eenh1drSATeRHqOn/auVjJ6rO
	YdzCCC3dScOyadvJftF0pPIfnEoteJM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-ixL1IET2MEKSKlEPYgR2kA-1; Thu,
 05 Sep 2024 14:21:55 -0400
X-MC-Unique: ixL1IET2MEKSKlEPYgR2kA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE7DF195608B;
	Thu,  5 Sep 2024 18:21:53 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B84F330001AB;
	Thu,  5 Sep 2024 18:21:50 +0000 (UTC)
Date: Thu, 5 Sep 2024 20:21:46 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, Tejun Heo <tj@kernel.org>, 
    Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org, Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm verity: don't use WQ_MEM_RECLAIM
In-Reply-To: <20240904040444.56070-1-ebiggers@kernel.org>
Message-ID: <086a76c4-98da-d9d1-9f2f-6249c3d55fe9@redhat.com>
References: <20240904040444.56070-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Tue, 3 Sep 2024, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> Since dm-verity doesn't support writes, the kernel's memory reclaim code
> will never wait on dm-verity work.  That makes the use of WQ_MEM_RECLAIM
> in dm-verity unnecessary.  WQ_MEM_RECLAIM has been present from the
> beginning of dm-verity, but I could not find a justification for it;
> I suspect it was just copied from dm-crypt which does support writes.
> 
> Therefore, remove WQ_MEM_RECLAIM from dm-verity.  This eliminates the
> creation of an unnecessary rescuer thread per dm-verity device.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Hmm. I can think about a case where you have read-only dm-verity device, 
on the top of that you have dm-snapshot device and on the top of that you 
have a writable filesystem.

When the filesystem needs to write data, it submits some write bios. When 
dm-snapshot receives these write bios, it will read from the dm-verity 
device and write to the snapshot's exception store device. So, dm-verity 
needs WQ_MEM_RECLAIM in this case.

Mikulas

> ---
>  drivers/md/dm-verity-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index cf659c8feb29f..051e84ca401dc 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1488,11 +1488,11 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	 * Also as required for the "try_verify_in_tasklet" feature: WQ_HIGHPRI
>  	 * allows verify_wq to preempt softirq since verification in BH workqueue
>  	 * will fall-back to using it for error handling (or if the bufio cache
>  	 * doesn't have required hashes).
>  	 */
> -	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
> +	v->verify_wq = alloc_workqueue("kverityd", WQ_HIGHPRI, 0);
>  	if (!v->verify_wq) {
>  		ti->error = "Cannot allocate workqueue";
>  		r = -ENOMEM;
>  		goto bad;
>  	}
> 
> base-commit: 88fac17500f4ea49c7bac136cf1b27e7b9980075
> -- 
> 2.46.0
> 


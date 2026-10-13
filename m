Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A226C3F44FC
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900919; cv=none; b=lrlOVy+vBVdqNdMdzwP3fRArXEY0R/Qy0yXA88AQq8GbxXWGOHA1lgFAXwnkv/gcyK2Pl/eRIAqm/vRyJIU5XpuF9kU5eWed1rUzmx2pGZesivpMdHsuDI8aslvXMwQghGdelNUiZxvp24zjgVinKyRV9MI8vpfh5erHR7ZNY9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900919; c=relaxed/simple;
	bh=G3r+JrQBvdMbusJLzq7rvczPnUg0XgTz1KJurpXkLBk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=W37mB76qQ+QS/HF2Nu+vVLgNHarNTy5cqgv5ADy2ksQtnbdc09+gKKpeoM+m42+EKnLwOnsF1unHVy3RZhHqELPGgNsNJ9irFNMCew2AZGOp9F5Cf8o/6SOSnOL49RQROM32ctCWnfBT8GygZunPh+JDFw1rhiw/SPV+MB8zR+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gRp0NCan; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gRp0NCan"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791900916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UUCK6QgQl7DA2PWtzzRDceLSdUPdXfokVnHPGcq9DBo=;
	b=gRp0NCan0DMGPM378CF0A3yV3wTDnWJnGAllRsdgQz0gaUrbkZ3TSDiSbAzo2/XuvC31jF
	GQxoALoOuhwNwkuEw5BZ9Hlj7zAfVzz3Yh9xu4rZZWzMMMnyNDjrZEiu8EGcB/AHA9KV+c
	dSbk9BNOHP1KbCNWd1xyBJtqBK8hSkM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-up0FcNekNCivUacI1EW-MQ-1; Tue,
 13 Oct 2026 14:15:15 +0000
X-MC-Unique: up0FcNekNCivUacI1EW-MQ-1
X-Mimecast-MFC-AGG-ID: up0FcNekNCivUacI1EW-MQ_1791900913
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86BFD1829E20;
	Tue, 13 Oct 2026 14:15:13 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAE695BC;
	Tue, 13 Oct 2026 14:15:10 +0000 (UTC)
Date: Tue, 13 Oct 2026 16:15:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Fan Wu <wufan@kernel.org>
cc: dm-devel@lists.linux.dev, snitzer@kernel.org, agk@redhat.com, 
    bmarzins@redhat.com, paul@paul-moore.com, 
    linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-verity: clear LSM integrity state on suspend
In-Reply-To: <20260921220516.121589-1-wufan@kernel.org>
Message-ID: <75c7cbec-dbb8-923a-c2ed-da5156538c92@redhat.com>
References: <20260921220516.121589-1-wufan@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: vG7XJBIRO8dqZcZKNC9ywGDL-XL1DdOHkiEtgHwUOn4_1791900913
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Accepted, thanks.

I've just deleted the "Fixes:" line, so that it doesn't go into -stable 
kernels.

Mikulas



On Mon, 21 Sep 2026, Fan Wu wrote:

> dm-verity publishes its root hash and signature state to LSMs in
> verity_preresume(). LSMs such as IPE store this information in the block
> device's security blob and use it to authorize access to files.
> 
> The original LSM integration relied on DM_TARGET_IMMUTABLE to prevent
> verity from being replaced by a different target type. However, DM allows
> tables containing a DM_TARGET_WILDCARD target to replace immutable
> targets. The block device can then retain the old integrity state even
> though its data is no longer verified by dm-verity.
> 
> Clear the published root hash and signature state in verity_postsuspend()
> so that the block device does not retain stale dm-verity attributes after
> the verity target is replaced.
> 
> Fixes: a6af7bc3d72f ("dm-verity: expose root hash digest and signature data to LSMs")
> Assisted-by: gpt-6-astra
> Signed-off-by: Fan Wu <wufan@kernel.org>
> ---
>  drivers/md/dm-verity-target.c | 39 ++++++++++++++++++++++++++++-------
>  1 file changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index cb105ccc47ec..6d589867623c 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -825,13 +825,6 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
>  	return DM_MAPIO_SUBMITTED;
>  }
>  
> -static void verity_postsuspend(struct dm_target *ti)
> -{
> -	struct dm_verity *v = ti->private;
> -	flush_workqueue(v->verify_wq);
> -	dm_bufio_client_reset(v->bufio);
> -}
> -
>  /*
>   * Status: V (valid) or C (corruption found)
>   */
> @@ -1733,6 +1726,11 @@ static int verity_security_set_signature(struct block_device *bdev,
>  					  v->sig_size);
>  }
>  
> +static void verity_security_clear_signature(struct block_device *bdev)
> +{
> +	security_bdev_setintegrity(bdev, LSM_INT_DMVERITY_SIG_VALID, NULL, 0);
> +}
> +
>  #else
>  
>  static inline int verity_security_set_signature(struct block_device *bdev,
> @@ -1741,6 +1739,10 @@ static inline int verity_security_set_signature(struct block_device *bdev,
>  	return 0;
>  }
>  
> +static inline void verity_security_clear_signature(struct block_device *bdev)
> +{
> +}
> +
>  #endif /* CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG */
>  
>  /*
> @@ -1779,8 +1781,31 @@ static int verity_preresume(struct dm_target *ti)
>  	return r;
>  }
>  
> +static void verity_security_clear_integrity(struct dm_target *ti)
> +{
> +	struct block_device *bdev = dm_disk(dm_table_get_md(ti->table))->part0;
> +
> +	security_bdev_setintegrity(bdev, LSM_INT_DMVERITY_ROOTHASH, NULL, 0);
> +	verity_security_clear_signature(bdev);
> +}
> +
> +#else
> +
> +static inline void verity_security_clear_integrity(struct dm_target *ti)
> +{
> +}
> +
>  #endif /* CONFIG_SECURITY */
>  
> +static void verity_postsuspend(struct dm_target *ti)
> +{
> +	struct dm_verity *v = ti->private;
> +
> +	flush_workqueue(v->verify_wq);
> +	dm_bufio_client_reset(v->bufio);
> +	verity_security_clear_integrity(ti);
> +}
> +
>  static struct target_type verity_target = {
>  	.name		= "verity",
>  /* Note: the LSMs depend on the singleton and immutable features */
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5
> -- 
> 2.55.0
> 


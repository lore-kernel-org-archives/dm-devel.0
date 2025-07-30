Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8384A23
	for <dm-devel@lists.linux.dev>; Wed, 30 Jul 2025 10:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753872402; cv=none; b=BwaAIg0MAHbidSne02rXMa3hUWW4SXL3cNdqRqp5FXh6Jz91BjGDztPx3sEd9MzYdF1a2kcKsmQQVpb4v7Xl0oqrOqh2FdQMj+kzp0VwUQ8KmFKvPoIOeTVx0BmWti2/emPNVfuYYQIx2kJ9JrlYwIu/Q+2BAPG66aiCzkEiPmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753872402; c=relaxed/simple;
	bh=Gj4HEu33FQ9QjMxkF2kRpZhxrSOBS+RAmAeJA+vthYw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=silDG0nAk1g5739WRkZKQcvW/5yTQVK9wYtBymTepl1FH5RA2yv8vs3VEIKwQ3Th3oZoBSmnn1923Tpk36Nn8T97rIrDaRw6IqZglSYca3jLjV8r7lBtTecDWHbezz0UW8DMxoN1EaAD6to2xq6BhzlQfx7t0wfM7sSWWYa2rPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HrH+c/SY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrH+c/SY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753872398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BUzZFPiP3XqN+XnHcU67IqtcPaa0TtDHCAbfjV73fO8=;
	b=HrH+c/SYmvuTPX5ZQbN6oBGcvGYiFXR1nEA6/ok+FodLwTNuuRx0s8D9X/ML0tgFWnivfT
	j0nVlZLevSVKSVT32qr91j23+9hhpleRXqw9yDf6NUJeKXtVEKbx78cgMdcvz40XqTIXmj
	9f1MwqX0klpA4R64jC9kwCMaIsoUorw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-cAMu6zJXOHKwQCGrW0FFKA-1; Wed,
 30 Jul 2025 06:46:35 -0400
X-MC-Unique: cAMu6zJXOHKwQCGrW0FFKA-1
X-Mimecast-MFC-AGG-ID: cAMu6zJXOHKwQCGrW0FFKA_1753872394
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 314D21956089;
	Wed, 30 Jul 2025 10:46:34 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7268F1800242;
	Wed, 30 Jul 2025 10:46:32 +0000 (UTC)
Date: Wed, 30 Jul 2025 12:46:23 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org
Subject: Re: [PATCH] dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin
In-Reply-To: <20250730061718.1966686-1-weilongping@oppo.com>
Message-ID: <0d84258e-daa5-2f96-78e3-ac52b8d35452@redhat.com>
References: <20250730061718.1966686-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CXivmqO5GiDpu1l9xub2shEo8PqQ-5vGQ7tcJ9lbvMI_1753872394
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 30 Jul 2025, LongPing Wei wrote:

> dm-thin obviously can pass through inline crypto support.

Hi

I'm not sure about it. What if dm-thin performs copy-on-write? How would 
that interact with inline crypto?

Mikulas

> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> ---
>  drivers/md/dm-thin.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 05cf4e3f2bbe..42f218dcf99f 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -4111,7 +4111,7 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  static struct target_type pool_target = {
>  	.name = "thin-pool",
>  	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
> -		    DM_TARGET_IMMUTABLE,
> +		    DM_TARGET_IMMUTABLE | DM_TARGET_PASSES_CRYPTO,
>  	.version = {1, 23, 0},
>  	.module = THIS_MODULE,
>  	.ctr = pool_ctr,
> @@ -4509,6 +4509,7 @@ static struct target_type thin_target = {
>  	.status = thin_status,
>  	.iterate_devices = thin_iterate_devices,
>  	.io_hints = thin_io_hints,
> +	.features = DM_TARGET_PASSES_CRYPTO,
>  };
>  
>  /*----------------------------------------------------------------*/
> -- 
> 2.34.1
> 


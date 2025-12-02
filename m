Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA5A23E229
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 18:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764701437; cv=none; b=E0MmhJ09mRxAWVPVULHOFYVjOAze/8wCjX3Bve+i7DxR14JDnXQeJPUrrsYb05jofJ2kuNuMbUABUfU7HQksahiB5W3Sh55MLhGe4GxmJVD0zJKhck9rl+Zt4fWQuf1OThNumZiDw1F4XMCNT1DoiJ8zMVJkvWlT7aPpvNRCI/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764701437; c=relaxed/simple;
	bh=l6qOzSDgJKXALiEz9u+JHbV1R2m5bLW3zl7cS5ijKyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPTHleKdcXmnhbFOpIeMhmXrRnOEgGg+qgGewcduOKMKGHZt5kwxWXDPcxm60a68MadGK3u8LeHuqqwT/2kpeiTkwTHeWmz/oEm/Ylby/J/T6Znly+fiBPanyeAm9hQMjzBfWk2vdz/Jn73MaYS4ryn2q60nT4XAYS0ZYbsd8aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BNpZ5bIV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BNpZ5bIV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764701435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9CV3mpZzpHguaaps+/3g6S9l3TQhkm0N/2Ju8y5xfTM=;
	b=BNpZ5bIV9w+IkNUvUJYeJfC2m5ErhSBvB5OE4rftuQbaNPg256ZtMYSL/Azg4Tvl7tpKhR
	QcajeTNsqDHDJNPgzz+LQD+eP0AxDDfXMFKDob/bDx01pNXsMlIiAtOEJkKbh1NZz4Nf7F
	9ELMavNe63Fdau6sI9D3z+4MCjSZSSY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-wlr8N-CMNQelIgs9QXGlyw-1; Tue,
 02 Dec 2025 13:50:32 -0500
X-MC-Unique: wlr8N-CMNQelIgs9QXGlyw-1
X-Mimecast-MFC-AGG-ID: wlr8N-CMNQelIgs9QXGlyw_1764701431
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 050CE195605A;
	Tue,  2 Dec 2025 18:50:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5AC91800451;
	Tue,  2 Dec 2025 18:50:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B2IoTbE1459150
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 2 Dec 2025 13:50:29 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B2IoSCT1459149;
	Tue, 2 Dec 2025 13:50:28 -0500
Date: Tue, 2 Dec 2025 13:50:28 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm log-writes: Add missing set_freezable() for freezable
 kthread
Message-ID: <aS809CQLuXlyCcv6@redhat.com>
References: <20251201074103.1281-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201074103.1281-1-vulab@iscas.ac.cn>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Dec 01, 2025 at 03:41:03PM +0800, Haotian Zhang wrote:
> The log_writes_kthread() calls try_to_freeze() but lacks set_freezable(),
> rendering the freeze attempt ineffective since kernel threads are
> non-freezable by default. This prevents proper thread suspension during
> system suspend/hibernate.
> 
> Add set_freezable() to explicitly mark the thread as freezable.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Fixes: 0e9cebe72459 ("dm: add log writes target")
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
> ---
>  drivers/md/dm-log-writes.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
> index 679b07dee229..1f8fbc27a12f 100644
> --- a/drivers/md/dm-log-writes.c
> +++ b/drivers/md/dm-log-writes.c
> @@ -432,6 +432,7 @@ static int log_writes_kthread(void *arg)
>  	struct log_writes_c *lc = arg;
>  	sector_t sector = 0;
>  
> +	set_freezable();
>  	while (!kthread_should_stop()) {
>  		bool super = false;
>  		bool logging_enabled;
> -- 
> 2.50.1.windows.1
> 


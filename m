Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73346366DCE
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485900; cv=none; b=OU4qbS6U8yxY2HmIGdB36Qife23y+ZPjIirKqF5oV27qDed6gPopjMt/IQEZAbmJRzxsmz1U9w1nPACzeMIi7l2lOBkdI1YG1mmsp419xsB6c0zmf/xcRVhcx87jOyZl4hKqQaPvzzwVFwRmMshWuMbTI0lourmZEyZg4txEOyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485900; c=relaxed/simple;
	bh=8F7FyQTtH/LQiAuboSYqitZweSzX1OHBbtcBJCMSAmI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OFmC98BgomjdHqmxXenp1vVao50eIAds1otNjCt4CAIXDdX+sT8H4TVq9rfYwUJEZOreWCQIOYFwBMW4DIPa8yXHonaPsItZhUliUg0KYLdPWDFTgdwbYyV2ijIYhj0+/5UeMbTRZ5UvUE+u6BEhdJeoUpI7KiDsqrx8nnKaJ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cdq1zlaY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cdq1zlaY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763485897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oa0uFbG1pHLBk+q11NFpxeHhUTIu+/q428nd5ORzwnU=;
	b=Cdq1zlaYLVLAUR1PavVMuSW2ENZY8Yd4JjFYr4TLQxhLZw3xRswB2pI3g8lbKONWFW2s4F
	zQnGXpogEuNhqt/gCiB8zktr/RDy+3ghDDAzV8oSqI1d+SdJcAEGjPiJymxUdnfOMOaqmE
	Rv9RIr4b+t3aWUvLt0jg/TYjr4jd2zs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-ke3OAL2cM32pVDKsXhr5jg-1; Tue,
 18 Nov 2025 12:11:33 -0500
X-MC-Unique: ke3OAL2cM32pVDKsXhr5jg-1
X-Mimecast-MFC-AGG-ID: ke3OAL2cM32pVDKsXhr5jg_1763485892
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C67719560A1;
	Tue, 18 Nov 2025 17:11:32 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E62EC19560B0;
	Tue, 18 Nov 2025 17:11:30 +0000 (UTC)
Date: Tue, 18 Nov 2025 18:11:28 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Aiden Ma <jiaheng_ma@yeah.net>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-verity: correct the name of verify wq
In-Reply-To: <20251118154506.17647-1-jiaheng_ma@yeah.net>
Message-ID: <3192678d-7daa-4ecb-4c02-5c04c0c6fa52@redhat.com>
References: <20251118154506.17647-1-jiaheng_ma@yeah.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6bN-0Mu3RkwmESGRIHa3a7liGwRuprfLrvBNrA2XB3g_1763485892
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 18 Nov 2025, Aiden Ma wrote:

> The name of workqueue verify_wq should be "kverifyd", not "kverityd".
> 
> Signed-off-by: Aiden Ma <jiaheng_ma@yeah.net>
> ---
>  drivers/md/dm-verity-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 66a00a8ccb39..e8f1300f5f25 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1549,7 +1549,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	 * will fall-back to using it for error handling (or if the bufio cache
>  	 * doesn't have required hashes).
>  	 */
> -	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
> +	v->verify_wq = alloc_workqueue("kverifyd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
>  	if (!v->verify_wq) {
>  		ti->error = "Cannot allocate workqueue";
>  		r = -ENOMEM;
> -- 
> 2.43.0

Hi

The target is called "verity", not "verify", so I think that "kverityd" - 
as "kernel-verity-daemon" is OK.

Mikulas


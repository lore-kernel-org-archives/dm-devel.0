Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AF02222CC
	for <dm-devel@lists.linux.dev>; Thu,  1 Oct 2026 00:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790813278; cv=none; b=tS0BEy9gihU/7RzYWCVbvJbfO44Mlpq/ukiLVg8n7MAjIl//eAh2+3+a6vbWO59XNzQ78D3jbxNX3cV2IuypoO0GRqxtEozDewnD9vPUbaswayZYsdlhLf5i+sVl6CWKMlyLVxtXVnr1mKrC1074UL6g76VAq+1CiBfRErrR2mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790813278; c=relaxed/simple;
	bh=2Qd8CxcbA4BCxGW6QR1OV767HK85YH/ep0qZBW0nfJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=TgpsnlGtFbk1Ob00oWSu+dBZTICH3DSMuTgiKtp1dv2ScV38beB9x2Ryv8sAcBWlDrSLSkBiB/KHMw4k8429AG+F0NKmxWxZraaLBLDmzXRQKtpiblyadlqu12gSi8KsFzZFp4rYzWRoeAp6NhskOcLB/7/UtSZcUwxAjZeHYC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LYTRXI0n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LYTRXI0n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790813275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m87iEaSDr3mOtflb2GgabXmiciEwGANNMABx6d95zVU=;
	b=LYTRXI0nNvb2SP5qWl+Ts+LL97+UxGJwvWf+PNTQAUyGziu+VUnBv5LSDQFJj2pPz/cBSK
	Xs+9cd7jRckuQn3uTRDrUzDvWZLiN23sdMtpqaY9JVfLSXsy3ppfNPQrpFMc34AwxMGuYa
	gvRyb8FCqHOc2fEOAd7qBsfy9gkNFcc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-8u1S0wGdPoKyGCJX00FgSw-1; Wed,
 30 Sep 2026 20:07:54 -0400
X-MC-Unique: 8u1S0wGdPoKyGCJX00FgSw-1
X-Mimecast-MFC-AGG-ID: 8u1S0wGdPoKyGCJX00FgSw_1790813272
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35EFD180FFCB;
	Thu,  1 Oct 2026 00:07:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41AC51801AD2;
	Thu,  1 Oct 2026 00:06:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69106sdF881397
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 20:06:54 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69106rn9881320;
	Wed, 30 Sep 2026 20:06:53 -0400
Date: Wed, 30 Sep 2026 20:06:53 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.de
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 4/4] libmultipath: use mmap in lookup_wwid()
Message-ID: <ar2kHTTbrVuDrctn@redhat.com>
References: <20260925214014.2464499-1-mwilck@suse.de>
 <20260925214014.2464499-5-mwilck@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260925214014.2464499-5-mwilck@suse.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1W4SYqc1VaShzERlOAYE-rC9esLOmsj4LVDrRIEIOMY_1790813272
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 25, 2026 at 11:40:09PM +0200, mwilck@suse.de wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Replace the line-by-line reading in lookup_wwid() with mmap()
> and a simple loop over the in-memory structures.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/wwids.c | 71 ++++++++++++++++++++++++--------------------
>  1 file changed, 38 insertions(+), 33 deletions(-)
> 
> diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
> index c193b97..42455de 100644
> --- a/libmultipath/wwids.c
> +++ b/libmultipath/wwids.c

[snip]

> @@ -245,7 +250,7 @@ int check_wwids_file(const char *wwid, int write_wwid)

Since lookup_wwid now takes a fd, check_wwids_file() doesn't need the
fdopen() anymore, right?

-Ben

>  		close(fd);
>  		return -1;
>  	}
> -	found = lookup_wwid(f, wwid);
> +	found = lookup_wwid(fd, wwid);
>  	if (found) {
>  		ret = 0;
>  		goto out;
> -- 
> 2.55.0
> 


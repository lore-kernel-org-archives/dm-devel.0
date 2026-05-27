Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FD719D093
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 23:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779923817; cv=none; b=gAVPPiVJCVy5zFXY42pC4266koq0GJJgkdybQZVUQ4+0SOdvHNI96jRYUyTTLiB+GznNSeWWfE4q/k9zeloZHJUBeIlu0U3G6makFGk6ud35w3j55rCAHMfnr89Kpe9kN2vIyR27I2eV2JqZn3ep+km1Q54rKCjYvrvKjGKnp9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779923817; c=relaxed/simple;
	bh=EdKGAcrnWQJ1JZTPvNpNSJAqxop5vYBXPcUmyvSaMWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=UL+rlNx5LhiUKmI7TZHSuD3e8FH8AFFQz/qdL2KC+eIeORRDmeF+DkObpa0HgNZdxoqlmRFxuVDhgqBVbZt38TIE+RMi2JSeUSzrOJM2E6EuCnY9c2is7+RaCv7DAEKGYA6goCQOnP/uyg0av0C/icN2ct6acEWmgZjdqRrLbkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PPtoKzEl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPtoKzEl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779923815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mW+817rLq2ZR1LPWkucEv0uY1C+jXowDkwrHOnCLvzU=;
	b=PPtoKzEllPnz4MleO1/11H3uhDtfTzyU4KI1cqoj5WXKWT1L4yUDikmps2sQcGG27HrjT9
	eIVW8TAseGeTmw5gj7JyrAAqwSQmKpQMQ8Ihnuf8y3junAm2zR7y4zofuqkR5i/c4aDj+W
	cHSYwMmgsRtfVR1/zg5iNFB+DWcFrOs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-393-YgmkBDVMMcSmzXxOpuunag-1; Wed,
 27 May 2026 19:16:49 -0400
X-MC-Unique: YgmkBDVMMcSmzXxOpuunag-1
X-Mimecast-MFC-AGG-ID: YgmkBDVMMcSmzXxOpuunag_1779923807
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDC8119560AA;
	Wed, 27 May 2026 23:16:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 719481688;
	Wed, 27 May 2026 23:16:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64RNGk1q017821
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 19:16:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64RNGjKZ017820;
	Wed, 27 May 2026 19:16:45 -0400
Date: Wed, 27 May 2026 19:16:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 04/19] libmpathutil: add implementation of generic
 shared pointer
Message-ID: <ahd7Xcfe3alqjROA@redhat.com>
References: <20260522164415.846589-1-mwilck@suse.com>
 <20260522164415.846589-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260522164415.846589-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YahP_Qlyyp--tPS4SM-wvuNuCMAYpkjZnGPzhh4oc7A_1779923807
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 22, 2026 at 06:44:00PM +0200, Martin Wilck wrote:
> Add a set of simple functions to handle refcounted pointers.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmpathutil/libmpathutil.version |  7 +++++
>  libmpathutil/util.c               | 45 ++++++++++++++++++++++++++++---
>  libmpathutil/util.h               |  5 ++++
>  3 files changed, 53 insertions(+), 4 deletions(-)
> 
> diff --git a/libmpathutil/util.c b/libmpathutil/util.c
> index 23a9797..3c623ec 100644
> --- a/libmpathutil/util.c
> +++ b/libmpathutil/util.c
> @@ -384,3 +382,42 @@ void cleanup_udev_device(struct udev_device **udd)
>  	if (*udd)
>  		udev_device_unref(*udd);
>  }
> +
> +struct shared_ptr {
> +	long refcnt;
> +	void (*destructor)(void *);
> +	char __attribute__((aligned(sizeof(void *)))) ptr[];
> +};
> +
> +void *alloc_shared_ptr(size_t size, void (*destructor)(void *))
> +{
> +	struct shared_ptr *sp = malloc(sizeof(*sp) + size);
> +
> +	if (!sp)
> +		return NULL;
> +	uatomic_set(&sp->refcnt, 1);
> +	sp->destructor = destructor;
> +	return sp->ptr;
> +}
> +
> +void get_shared_ptr(void *ptr)
> +{

We should probably return here if ptr is NULL, like we do in
put_shared_ptr(). Alternatively, this might be a reasonable place for an
assert(), since nobody should be calling these with NULL pointers.

As far as the general question Hannes raise about this implentantion,
I'm happy with it as-is. 

-Ben

> +	struct shared_ptr *sp = container_of(ptr, struct shared_ptr, ptr);
> +
> +	if (uatomic_add_return(&sp->refcnt, 1) < 0)
> +		condlog(0, "%s: refcount overflow", __func__);
> +}
> +
> +void put_shared_ptr(void *ptr)
> +{
> +	struct shared_ptr *sp;
> +
> +	if (!ptr)
> +		return;
> +	sp = container_of(ptr, struct shared_ptr, ptr);
> +	if (uatomic_sub_return(&sp->refcnt, 1) == 0) {
> +		if (sp->destructor)
> +			sp->destructor(ptr);
> +		free(sp);
> +	}
> +}


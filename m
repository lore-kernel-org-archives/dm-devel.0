Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799B5625
	for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731456728; cv=none; b=r1ehleG6F0SpL5jXb/R0yLmlptb5OBV4mD7m+Hmwj1Ib1puJMh6dioO6P1+hEN1bTsFu0SfjHzkg4hMQyvocRQXUbCW1acx60/c1oBemUY3nj5rhqZb+rqRKYnXjIy2WNGQSEaAVEFLOdtMjwGBAmkXbUe0QOQFOEI5GALr3ISE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731456728; c=relaxed/simple;
	bh=f2T3yENb22PDpaf9BYg+XjHkapbvzHrJ+eqwsNIMu7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=c4/34ENr4dRwvfobWUegsSZrSeUGE8us1bdXWiXh2y03dIneRp+o2zbeo3rLa7frNTJa6csPdb5Azil9PO2mDEcEyqj3ypaOJSC1LBDM1zb2+LTsB3VQoOHU6n8t0ZTUq93d/krc1t90cLhDuksGqDpbXIEYjZFH3O3//0zVnrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QnXdzF6K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnXdzF6K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731456725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tmp8Z4LDxbs4Jg23IaT8DxQ7uuWrkKykBxLKOHLQPoY=;
	b=QnXdzF6Ka7NEcsVp5t8br5JqcCtNmso3835QzDmDWIlCCWGhAPq42zuwq1o9SMoDSkN5Vm
	zANWJyMaBH4MwLovdNEE0JzOLSPM/6E4wAGmmUIiMSKlh39Fyp4w3F3s8FhiktyZUsOnJI
	L2KKgXjfuSxyLaLvP65VdAPm6pUTGbo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-39-09fgPc82OWOrUpbu16jsww-1; Tue,
 12 Nov 2024 19:12:00 -0500
X-MC-Unique: 09fgPc82OWOrUpbu16jsww-1
X-Mimecast-MFC-AGG-ID: 09fgPc82OWOrUpbu16jsww
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E095919373DF;
	Wed, 13 Nov 2024 00:11:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 682101956086;
	Wed, 13 Nov 2024 00:11:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AD0BucH580774
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 19:11:56 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AD0BuLZ580773;
	Tue, 12 Nov 2024 19:11:56 -0500
Date: Tue, 12 Nov 2024 19:11:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 02/12] libmultipath: libmp_mapinfo(): return
 DMP_NO_MATCH for multi-target maps
Message-ID: <ZzPuzLATq1b4o-dA@redhat.com>
References: <20241112150215.90182-1-mwilck@suse.com>
 <20241112150215.90182-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241112150215.90182-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2N8Oe_u84SBFDLI7xj-JOsXO5cNatxR2mVF9feQ5rkY_1731456719
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2024 at 04:02:05PM +0100, Martin Wilck wrote:
> multi-target maps are more like maps with a single non-multipath
> target than like maps with no target at all.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 2 +-
>  tests/mapinfo.c          | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 52bfe9c..ab6eefc 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -719,7 +719,7 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
>  		if (dm_get_next_target(dmt, NULL, &start, &length,
>  				       &target_type, &params) != NULL) {
>  			condlog(2, "%s: map %s has multiple targets", fname__, map_id);
> -			return DMP_NOT_FOUND;
> +			return DMP_NO_MATCH;
>  		}
>  		if (!params) {
>  			condlog(2, "%s: map %s has no targets", fname__, map_id);

I feel like given the choice between DMP_NOT_FOUND and DMP_NO_MATCH, an
empty table should be DMP_NO_MATCH since we did find a device. I
assume you left this case alone because it will get changed with the
addition of a new error code for empty tables (I plan on posting that
shortly). So

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> diff --git a/tests/mapinfo.c b/tests/mapinfo.c
> index fca6462..66c81e8 100644
> --- a/tests/mapinfo.c
> +++ b/tests/mapinfo.c
> @@ -870,7 +870,7 @@ static void test_mapinfo_bad_next_target_01(void **state)
>  	rc = libmp_mapinfo(DM_MAP_BY_NAME,
>  			   (mapid_t) { .str = "foo", },
>  			   (mapinfo_t) { .size = &size });
> -	assert_int_equal(rc, DMP_NOT_FOUND);
> +	assert_int_equal(rc, DMP_NO_MATCH);
>  }
>  
>  static void test_mapinfo_bad_next_target_02(void **state)
> -- 
> 2.47.0


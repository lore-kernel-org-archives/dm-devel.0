Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A65380FCB
	for <dm-devel@lists.linux.dev>; Mon,  8 Jun 2026 14:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928378; cv=none; b=sq4Jm0OSoLyHewTln+h9akHV4bHDbNGzdRIHiIYZ62T3QMsCpNnMPBPcd3mCJv7/rlYdJcxloCxskJGoL/r3pnyybShCFZekTqiKS+13d97S3CVqXOz/H5bwSe7HVetmpYSrHeK6p2RcvwzBEFesNFmxvpzbtugbsRLviTv7+BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928378; c=relaxed/simple;
	bh=kBM6a5CZrIynDhrFKjkLJC3Au98q/nKeVE0HR49B+MQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZgedPB5l2Rjg2e+zGN90LimA1h8Tq0mzK8iqZRf4e+v3uUKRDPSWQB9eXJR/UYZO4IHIMv/l/4+2yvhCBOfbZlHhUMrDid+R3CwumvyoM5jCMZC5fg2Lpcy6+WdxmNftb5iJg2d6j/F06U0NeCbG11SUkD2zPHTtVLG1A/DW2wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CACFbpT2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CACFbpT2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780928376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ksEVz7zu8cddZveGMzSFRyDbw79gGlzSMPra+8QpguA=;
	b=CACFbpT2HnRBLEICL9FTwf4/C/ibwIvuhC1jynQDhdyPbod60e+rbeU2Bew2NgGwS6v12r
	WJFOezZ+SE1Pu6jHOXNVYreNdKllIaWpIl07H8Lz83BOjQXVlWoHoMctAE70eD8b7zqUeQ
	S828P3cq75H981JjeEbmIu0dD+3r7Gc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-sZu16Q8vOYK7rKPF-TgC_g-1; Mon,
 08 Jun 2026 10:19:32 -0400
X-MC-Unique: sZu16Q8vOYK7rKPF-TgC_g-1
X-Mimecast-MFC-AGG-ID: sZu16Q8vOYK7rKPF-TgC_g_1780928371
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 365B218011E6;
	Mon,  8 Jun 2026 14:19:31 +0000 (UTC)
Received: from [10.44.50.170] (unknown [10.44.50.170])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE77E1800367;
	Mon,  8 Jun 2026 14:19:28 +0000 (UTC)
Date: Mon, 8 Jun 2026 16:19:25 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Laight <david.laight.linux@gmail.com>
cc: Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org, 
    Arnd Bergmann <arnd@kernel.org>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH next] drivers/md/dm-zoned-metadata: User strscpy() to
 copy device name
In-Reply-To: <20260606202633.5018-12-david.laight.linux@gmail.com>
Message-ID: <4773c74f-5425-76fa-dc3a-5a5cf59f4e62@redhat.com>
References: <20260606202633.5018-12-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: lVc4eRgo1uLH5Q8PCkIavHUZ-0moZNZgtBeL9dNVkRg_1780928371
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I accepted the patch.

Mikulas


On Sat, 6 Jun 2026, david.laight.linux@gmail.com wrote:

> From: David Laight <david.laight.linux@gmail.com>
> 
> Signed-off-by: David Laight <david.laight.linux@gmail.com>
> ---
> This is one of a group of patches that remove potentially unbounded
> strcpy() calls.
> 
> They are mostly replaced by strscpy() or, when strlen() has just been
> called, with memcpy() (usually including the '\0').
> 
> Calls with copy string literals into arrays are left unchanged.
> They are safe and easily detected as such.
> 
> The changes were made by getting the compiler to detect the calls and
> then fixing the code by hand.
> 
> Note that all the changes are only compile tested.
> 
> Some Makefiles were changed to allow files to contain strcpy().
> As well as 'difficult to fix' files, this included 'show' functions
> as they really need to use sysfs_emit() or seq_printf().
> 
> All the patches are being sent individually to avoid very long cc lists.
> Apologies for the terse commit messages and likely unexpected tags.
> (There are about 100 patches in total.)
> 
>  drivers/md/dm-zoned-metadata.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index ec605acddd88..f4f81c79a080 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -2871,7 +2871,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
>  	if (!zmd)
>  		return -ENOMEM;
>  
> -	strcpy(zmd->devname, devname);
> +	strscpy(zmd->devname, devname);
>  	zmd->dev = dev;
>  	zmd->nr_devs = num_dev;
>  	zmd->mblk_rbtree = RB_ROOT;
> -- 
> 2.39.5
> 


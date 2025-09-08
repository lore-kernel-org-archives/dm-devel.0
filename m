Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB31830BB92
	for <dm-devel@lists.linux.dev>; Mon,  8 Sep 2025 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757339112; cv=none; b=Jh9oXfyBTkukJKZkzf7AnaUpL3vGuqjyN6/spG7d2HPTXsMW3bb8wAn61rZd7Ot2aA7kmq/mz6Nu7iElzyDXLHvhYFKl45NrbUFd4o1+YTCBavjnLHnazU3Hz3nAC7hDNwAJnihOXiUgTWyKINNMbZmIH4AVDXfkp8WfffQcK84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757339112; c=relaxed/simple;
	bh=If26awibRVYgUkPhnEbv+S6ehJyJcV11t7MVTPEys5c=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CXvN3+0wNIS1CkVskEbZxSqU5qFGcUo4BzL2UwXKxKNTMSSAunA41BYcvYapck4h9XhOaBHlAWjaWlrCvGW5Iafm+azysmyO4tmSzIntWEUdU9sRQ8gENPIXYwZH9woG0unlkeptHAJEupZlMcM29pVCXYh4hrnqCZv77rpO/q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KHQ+Jtpy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KHQ+Jtpy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757339109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mkI4CbkVJ/MPAdUsHepXrw2RZnRbTcHxDEQJp790iHQ=;
	b=KHQ+JtpyQE4G65EnqHiojVGOqnLbW8+o2GphuZpfTwO3Cb6MmxAd7ixDXrz2ZLWZMqU3V8
	5yu/q/FaWjN8WrZlATq7OfYCDsIW+Yh3MQMkKz7c8AVbi49NbsyoVqJoQgQjWHK9U/Rlwv
	c3eXF1ss1i0BNUjPaih99JY43SbxOJo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-ShfMb6jaMP6y04Sp9e1vww-1; Mon,
 08 Sep 2025 09:45:06 -0400
X-MC-Unique: ShfMb6jaMP6y04Sp9e1vww-1
X-Mimecast-MFC-AGG-ID: ShfMb6jaMP6y04Sp9e1vww_1757339105
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 006231955BF1;
	Mon,  8 Sep 2025 13:45:05 +0000 (UTC)
Received: from [10.44.32.12] (unknown [10.44.32.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E07B1800452;
	Mon,  8 Sep 2025 13:45:02 +0000 (UTC)
Date: Mon, 8 Sep 2025 15:44:59 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ivan Abramov <i.abramov@mt-integration.ru>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    lvc-project@linuxtesting.org
Subject: Re: [PATCH 1/1] dm-integrity: Remove unreachable code in
 dm_integrity_ctr()
In-Reply-To: <20250908120831.135419-1-i.abramov@mt-integration.ru>
Message-ID: <b4a06abf-eb97-055a-a986-6e629c59ca1b@redhat.com>
References: <20250908120831.135419-1-i.abramov@mt-integration.ru>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi

What if someone changes it to a larger type later? I think that if this 
branch doesn't do any harm and if it protects us from memory errors 
introduced by future changes, we may let it be there.

But I found another bug when looking at this - the user may set tag size 
up to MAX_TAG_SIZE (that is 0x1a8) and that gets truncated when it is 
assigned in "bi->metadata_size = ic->tag_size". I need to limit 
MAX_TAG_SIZE to 255.

Mikulas


On Mon, 8 Sep 2025, Ivan Abramov wrote:

> Since bi->metadata_size is an unsigned char, it's not practically
> possible for it to be > PAGE_SIZE / 2.
> 
> Thus, remove the corresponding if statement.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
> ---
>  drivers/md/dm-integrity.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index efeee0a873c0..b7ad7a5adb56 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -4752,11 +4752,6 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
>  			ti->error = "The integrity profile is smaller than tag size";
>  			goto bad;
>  		}
> -		if ((unsigned long)bi->metadata_size > PAGE_SIZE / 2) {
> -			r = -EINVAL;
> -			ti->error = "Too big tuple size";
> -			goto bad;
> -		}
>  		ic->tuple_size = bi->metadata_size;
>  		if (1 << bi->interval_exp != ic->sectors_per_block << SECTOR_SHIFT) {
>  			r = -EINVAL;
> -- 
> 2.39.5
> 
> 


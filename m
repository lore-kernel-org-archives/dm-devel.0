Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5591CEACB
	for <dm-devel@lists.linux.dev>; Thu, 22 Aug 2024 17:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346527; cv=none; b=TVCZ5Zh5UmRVkhLZqmfgNQCl7AgJFFfC+mA261V4yPrrHbIo5YkNH6m7dro//u07LmOd7UrFxJEkmyny1nbA4FX1oThBA61HBlE/ZylLNcem1paYNBJ9Z6A7GAFINk8q6GMEWiqigAeZU0yzNIMPv8hkwQsJ2Doi6fN/fYPSoVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346527; c=relaxed/simple;
	bh=1dg4YEe0xZrT5WAbxZSFaD+eiz2MppGoRrrcvzBa9ko=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=G6XrwsGrMDNjLal2WuL3y3ysuJBaCsyuUR/h2xfSvSDbNYozf9esyMqhvSb8eeU8ynqIfCUNqyXwzSkXMFuOl8Vgc8aUfwhEWAzxwFseeJt+TmEO13dajlJwKwkY1sTFxKd6qsSFX1f2ve5W1pg7lBtsK03Hr4LWWLHc5vYooW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hK0cuEPP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hK0cuEPP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724346524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VP0z4ZUja2rAQmlvGCWDjc4h6tAYEdJPEhXn0L4AZcQ=;
	b=hK0cuEPPfr0fpSzOL8yxWgBqqYOWkuRRYP+iBJ28YzaqeMrch5m7NgngzmbkDpNgutGdik
	Yv+rgF/r4B+guRgaEMfo0wSjD6tmvltofSMrTDLRGXgvmUHkcyPNugh/nJ/P2NYAGW9v6j
	r1HP/ls7BEFwfW2wS6km9n4bF4nKizw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-306-wggC0dfWPna8UYAvCztfpw-1; Thu,
 22 Aug 2024 13:08:41 -0400
X-MC-Unique: wggC0dfWPna8UYAvCztfpw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD6A81955D47;
	Thu, 22 Aug 2024 17:08:39 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A5723001FE8;
	Thu, 22 Aug 2024 17:08:37 +0000 (UTC)
Date: Thu, 22 Aug 2024 19:08:34 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Chen Yufan <chenyufan@vivo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    opensource.kernel@vivo.com
Subject: Re: [PATCH v1] Device-mapper(LVM): Convert to use time_after_eq
 macro
In-Reply-To: <20240822015416.3627-1-chenyufan@vivo.com>
Message-ID: <1abae895-7fb4-0342-21b9-1fd8e085dc9a@redhat.com>
References: <20240822015416.3627-1-chenyufan@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Thu, 22 Aug 2024, Chen Yufan wrote:

> Use time_after_eq macro instead of opening it for readability.
> 
> Signed-off-by: Chen Yufan <chenyufan@vivo.com>
> ---
>  drivers/md/dm-writecache.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 7ce8847b3..548d4d37e 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -16,6 +16,7 @@
>  #include <linux/pfn_t.h>
>  #include <linux/libnvdimm.h>
>  #include <linux/delay.h>
> +#include <linux/jiffies.h>
>  #include "dm-io-tracker.h"
>  
>  #define DM_MSG_PREFIX "writecache"
> @@ -1994,8 +1995,8 @@ static void writecache_writeback(struct work_struct *work)
>  	while (!list_empty(&wc->lru) &&
>  	       (wc->writeback_all ||
>  		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
> -		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
> -		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
> +		(time_after_eq(jiffies, container_of(wc->lru.prev, struct wc_entry, lru)->age +
> +		 (wc->max_age - wc->max_age / MAX_AGE_DIV))))) {
>  
>  		n_walked++;
>  		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
> -- 
> 2.39.0

I'm not sure about this. The old and new code is not really equivalent.

Mikulas


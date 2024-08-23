Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C6118B47C
	for <dm-devel@lists.linux.dev>; Fri, 23 Aug 2024 19:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724439685; cv=none; b=Yv0Ewvb18HxqEzdvX38oKY3YXm0iN79spS0gbCZoFF3sefA7j9ob7tIu+ej0GV7URZhj8ZcMgJC0fdo+kvvUpcGmHFaGCyti1A8RVDVJvQwfZyecHmO8+j+Jyqi77irAKv58m4pUUuF6LWz6EnZbCQAxHRFhe7U7HtTaICs3bvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724439685; c=relaxed/simple;
	bh=XM29QN1zNdWqSYn3JhQ8CIliLRh7S+UaeuU0ediUmVI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=p+/uCqCC7rdTh4uPUN8uNsz4f35UnImEe4TongMOAsKIkseOE23HkQtQnn5mmPwFeiXZzQ2XFHWIbwuyZxdBAOrmWl7HvB5WvIhOHtxuSdUzIm+BGTskcKRIiB5nQ+9PF5aM8KPpHUp/kJd3jnAbUIrbMjYx5FKbQdlxL1DGOig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EGj5RxzO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EGj5RxzO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724439683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bk3r4/l3ko/4wgWLAt441cHjNkjE8LMnufEljr7zc6g=;
	b=EGj5RxzOGhXciVk/TvQfRU+Br1/aknyrIPf77zXqnw+pNlcVPa0O6eNt+3N7zUV3F+WFnZ
	4wX62HRFBPG7eGxDsfwCvonHvykMWWFa7Isbv6wiqckyOvKxBQbxTwteyLDU31/nvY+4Fw
	3DuQUm4/iLBeqw4azELmKZkvRi00w8g=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-438-InkpVxeGPESYWMrwVhPYHA-1; Fri,
 23 Aug 2024 15:01:16 -0400
X-MC-Unique: InkpVxeGPESYWMrwVhPYHA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 800611956080;
	Fri, 23 Aug 2024 19:01:14 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B9D2300019C;
	Fri, 23 Aug 2024 19:01:11 +0000 (UTC)
Date: Fri, 23 Aug 2024 21:01:08 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?GB2312?B?s8LT8bey?= <chenyufan@vivo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    "opensource.kernel" <opensource.kernel@vivo.com>
Subject: Re: [PATCH v1] Device-mapper(LVM): Convert to use time_after_eq
 macro
In-Reply-To: <bc1025c5-fa3c-4a49-9d91-d2d90e7423b4@vivo.com>
Message-ID: <6f732dc5-b80e-0e79-a1dd-faebd0d91933@redhat.com>
References: <20240822015416.3627-1-chenyufan@vivo.com> <1abae895-7fb4-0342-21b9-1fd8e085dc9a@redhat.com> <bc1025c5-fa3c-4a49-9d91-d2d90e7423b4@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-1359953336-1724439674=:765655"
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-1359953336-1724439674=:765655
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Fri, 23 Aug 2024, 陈玉凡 wrote:

> 在 2024/8/23 1:08, Mikulas Patocka 写道:
> >
> > On Thu, 22 Aug 2024, Chen Yufan wrote:
> >
> >> Use time_after_eq macro instead of opening it for readability.
> >>
> >> Signed-off-by: Chen Yufan <chenyufan@vivo.com>
> >> ---
> >>   drivers/md/dm-writecache.c | 5 +++--
> >>   1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> >> index 7ce8847b3..548d4d37e 100644
> >> --- a/drivers/md/dm-writecache.c
> >> +++ b/drivers/md/dm-writecache.c
> >> @@ -16,6 +16,7 @@
> >>   #include <linux/pfn_t.h>
> >>   #include <linux/libnvdimm.h>
> >>   #include <linux/delay.h>
> >> +#include <linux/jiffies.h>
> >>   #include "dm-io-tracker.h"
> >>   
> >>   #define DM_MSG_PREFIX "writecache"
> >> @@ -1994,8 +1995,8 @@ static void writecache_writeback(struct work_struct *work)
> >>   	while (!list_empty(&wc->lru) &&
> >>   	       (wc->writeback_all ||
> >>   		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
> >> -		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
> >> -		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
> >> +		(time_after_eq(jiffies, container_of(wc->lru.prev, struct wc_entry, lru)->age +
> >> +		 (wc->max_age - wc->max_age / MAX_AGE_DIV))))) {
> >>   
> >>   		n_walked++;
> >>   		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
> >> -- 
> >> 2.39.0
> > I'm not sure about this. The old and new code is not really equivalent.
> >
> > Mikulas
> 
> The code here is susceptible to overflow issues, and the time_*() macros 
> can handle this.
> 
> Chen

So, describe some case (i.e. the values of jiffies, 
container_of(wc->lru.prev, struct wc_entry, lru)->age and wc->max_age) 
where the old code misbehaves and the new code doesn't.

If we want to fix a bug, we need to know what the bug actually is.

Mikulas
---1463811712-1359953336-1724439674=:765655--


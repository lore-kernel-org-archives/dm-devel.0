Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B97C2F34
	for <dm-devel@lists.linux.dev>; Mon, 26 Aug 2024 09:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724664221; cv=none; b=DU3U3ZfFh5e5hca6XCXbc1ClTSWvXnnyXWBqv+elcEaEAk7HNqAGSGq3hMhI4WSvsh93qcZq6a4+Gg+E4C3KnihHL0e/iV7KcsT0G/q99ImpAQx1T8nUEpku89cNXKE54xRgJjONXWwRMYBI5g0WtZcOFkkLKeotGk+tMWMzkZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724664221; c=relaxed/simple;
	bh=71telQe5u2/lKw7RfN9qGHW1wjYgdID/jPjgDLWtRq0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=q/O3qRlQdFuJuGpiKk8S8WM3IGQEUIv8l7R8sCz44rhUKa9dZmxvgX+wbgEgmgkapTuOZyis6XyrPEf5G/klx+xLIAbQhJCXc6Vnt3nywY+P2vEzSNxfcI1bF5oRqmQt9tgCpNqJQpQFU/RrBqZJo97T7FJzyuQFHzoewyXKKVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CQB1/Yz2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQB1/Yz2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724664218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MkjXy/+CcBoacZKR/Pjt2a/67DruiSDyT8kYHTqBAUg=;
	b=CQB1/Yz2Jo3dC6P+jfr9MmyJk3KwA/rDDzBfxQyIED/8y4+E8Ahjz+dza1qfVUUOU9pw5K
	F6SZ8QEV80dFZtw6ZY/FIOji5W/u2KlyhBd2Q72K8LlaUN+pcNd9PRLKk0PqZOCbjyB3L4
	CTue+KFyRStN3ba4zyyWXUuU9rG2lDs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-577-RMh53bYKOu6o21-_81pxJw-1; Mon,
 26 Aug 2024 05:23:34 -0400
X-MC-Unique: RMh53bYKOu6o21-_81pxJw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2DB8E1955D47;
	Mon, 26 Aug 2024 09:23:33 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07E1619560A3;
	Mon, 26 Aug 2024 09:23:30 +0000 (UTC)
Date: Mon, 26 Aug 2024 11:23:26 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?GB2312?B?s8LT8bey?= <chenyufan@vivo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    "opensource.kernel" <opensource.kernel@vivo.com>
Subject: Re: [PATCH v1] Device-mapper(LVM): Convert to use time_after_eq
 macro
In-Reply-To: <de43d61e-05c0-466f-b004-a97f2bf2ec39@vivo.com>
Message-ID: <9cdc4de9-82b8-87fe-4845-6b18ffe26d18@redhat.com>
References: <20240822015416.3627-1-chenyufan@vivo.com> <1abae895-7fb4-0342-21b9-1fd8e085dc9a@redhat.com> <bc1025c5-fa3c-4a49-9d91-d2d90e7423b4@vivo.com> <6f732dc5-b80e-0e79-a1dd-faebd0d91933@redhat.com> <de43d61e-05c0-466f-b004-a97f2bf2ec39@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-1301487623-1724664212=:882105"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-1301487623-1724664212=:882105
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Mon, 26 Aug 2024, 陈玉凡 wrote:

> 在 2024/8/24 3:01, Mikulas Patocka 写道:
> 
> 
> On Fri, 23 Aug 2024, 陈玉凡 wrote:
> 
> 在 2024/8/23 1:08, Mikulas Patocka 写道:
> 
> On Thu, 22 Aug 2024, Chen Yufan wrote:
> 
> Use time_after_eq macro instead of opening it for readability.
> 
> Signed-off-by: Chen Yufan <chenyufan@vivo.com>
> ---
>   drivers/md/dm-writecache.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 7ce8847b3..548d4d37e 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -16,6 +16,7 @@
>   #include <linux/pfn_t.h>
>   #include <linux/libnvdimm.h>
>   #include <linux/delay.h>
> +#include <linux/jiffies.h>
>   #include "dm-io-tracker.h"
>   
>   #define DM_MSG_PREFIX "writecache"
> @@ -1994,8 +1995,8 @@ static void writecache_writeback(struct work_struct *work)
>   	while (!list_empty(&wc->lru) &&
>   	       (wc->writeback_all ||
>   		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
> -		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
> -		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
> +		(time_after_eq(jiffies, container_of(wc->lru.prev, struct wc_entry, lru)->age +
> +		 (wc->max_age - wc->max_age / MAX_AGE_DIV))))) {
>   
>   		n_walked++;
>   		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
> -- 
> 2.39.0
> 
> I'm not sure about this. The old and new code is not really equivalent.
> 
> Mikulas
> 
> The code here is susceptible to overflow issues, and the time_*() macros 
> can handle this.
> 
> Chen
> 
> So, describe some case (i.e. the values of jiffies, 
> container_of(wc->lru.prev, struct wc_entry, lru)->age and wc->max_age) 
> where the old code misbehaves and the new code doesn't.
> 
> If we want to fix a bug, we need to know what the bug actually is.
> 
> Mikulas
> 
> When jiffies increased beyond the maximum value of unsigned long, it 
> wraps around to zero, and the value of jiffies would be smaller than the 
> container_of(wc->lru.prev, struct wc_entry, lru)->age value despite 
> logically being larger. Eventurally, because of the wraparound, the 
> result of the condition would be wrong.
> 
> Chen

For example, if "jiffies" is 0x10 (because it wrapped around) and 
"container_of(wc->lru.prev, struct wc_entry, lru)->age" is 0xfffffff0, 
then the expression "jiffies - container_of(wc->lru.prev, struct wc_entry, 
lru)->age" would be 0x20. That is the correct value, I don't see any 
problem with this.

Mikulas
---1463811712-1301487623-1724664212=:882105--


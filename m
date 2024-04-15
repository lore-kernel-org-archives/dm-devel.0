Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DC578C84
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713193502; cv=none; b=CmZZvuxqAW5OUV8jTIOQpDNzEEnIh2Xowa8CDqEtoIeu5CjgZ4HYR+bOaHqOv/1DU7ITQay7nvN/NoDxt/cYLxwcIJLfiMxb8YEx30FRqIoP8SnPMwaNoS1wB39+0yECJnXeHgsSvTu5z6i5SRRY3u6F++Q3u0LYGObFEZR+h9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713193502; c=relaxed/simple;
	bh=d5cmappnFJ0/wDvwY88Um505JFlXsV8IcwfFnmq2FlY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=VKPWLGkAljpc8BfbtmpftcEYke70APEDA0pzRXu1a9gPIVwcDI+bMlHAwFFR4IHlle1Wp33+O33gcZWHXNIn0NYrED4XmAP1PUzJyfIXsBNkXseqD0+ijVTI7a/3TIFEEOkyCjxaUjDLaeW2lZBOEjSXqQeVSRdNhAEKV4gxbMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FgPaRP8U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FgPaRP8U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713193499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z8xnurLSraf68tR7a2NWQu+yYrcYokZdoz7hggE/R38=;
	b=FgPaRP8UaeRc/+XP/CJCtnsQ09umNak/5Tk7oEN/gNIsw3qqarz1VLct1nozbGi1eQrLWW
	35+zI6HSqs8k7F8MXNZ8ZY8TB/8O7axYraxKZCbgAtkg/VtCD7MFNiVHcOyuRBkWdnio1V
	LhLvwzr5OGKrt7RJj+d97iRniLf1cVw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-cJDC2KeyNx6oY9pwZQnFzA-1; Mon, 15 Apr 2024 11:04:54 -0400
X-MC-Unique: cJDC2KeyNx6oY9pwZQnFzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7F96188ACA5;
	Mon, 15 Apr 2024 15:04:53 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11FD340C6DAE;
	Mon, 15 Apr 2024 15:04:53 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id E9A8C30C72AD; Mon, 15 Apr 2024 15:04:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id E51CE3FD7A;
	Mon, 15 Apr 2024 17:04:52 +0200 (CEST)
Date: Mon, 15 Apr 2024 17:04:52 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Li Lingfeng <lilingfeng3@huawei.com>
cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, 
    torvalds@linux-foundation.org, tglx@linutronix.de, 
    linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
    msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com, 
    houtao1@huawei.com, nhuck@google.com, peterz@infradead.org, 
    yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com, 
    lilingfeng@huaweicloud.com
Subject: Re: [PATCH 6.6] Revert "dm-crypt, dm-verity: disable tasklets"
In-Reply-To: <4e5e4634-a2d0-ce35-3884-829d385c0879@huawei.com>
Message-ID: <3bc637b9-f7b4-aef6-74a8-5066d0d646f3@redhat.com>
References: <20240411091539.361470-1-lilingfeng3@huawei.com> <7c17f31a-2cc3-1597-e2b5-832355de7647@redhat.com> <4e5e4634-a2d0-ce35-3884-829d385c0879@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="185210117-1508192850-1713191327=:1973731"
Content-ID: <57482597-77c8-9c50-5cee-a88780511284@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-1508192850-1713191327=:1973731
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <d4f484f-7d14-ecbc-5c9f-5e4cc90bd23@redhat.com>



On Fri, 12 Apr 2024, Li Lingfeng wrote:

> Hi
> 
> I'm having difficulty understanding "Workqueues and ksoftirqd may be scheduled
> arbitrarily".
> This is my understanding:
> kcryptd_queue_crypt
>  tasklet_schedule
>   __tasklet_schedule
>    __tasklet_schedule_common
>     raise_softirq_irqoff
>      wakeup_softirqd
>       wake_up_process // ksoftirqd
> 
> run_ksoftirqd
>  __do_softirq
>   softirq_handle_begin
>    __local_bh_disable_ip // Turn off preemption
> <---------- [1] ---------->
>   tasklet_action // h->action
>    tasklet_action_common
>     tasklet_trylock
>      kcryptd_crypt_tasklet // t->func(t->data)
>      ...
>       queue_work(cc->io_queue, &io->work)
> <---------- [2] ---------->
>     tasklet_unlock
> 
> // workqueue process
> kcryptd_io_bio_endio
>  ...
>  // free tasklet_struct
> 
> Since preemption has been turned off at [1], I'm confused about how the CPU
> can be scheduled out to do work first at [2].
> Would you mind explaining it to me?
> 
> Thanks

Yes, you are right that scheduling is disabled when ksoftirqd processes a 
softirq task.

But the upstream kernel switched to bh workqueues anyway, so there is no 
need to submit a different solution to the stable kernels.

Mikulas
--185210117-1508192850-1713191327=:1973731--


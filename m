Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DC0252298
	for <dm-devel@lists.linux.dev>; Mon, 14 Apr 2025 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744638753; cv=none; b=R1PDixb7ZNex3V1TzCynC0BtaAv5BU12eHfplieNf7bXgErcr+p8I6EJiJOMynNTusk1mPyHVlbL/lqOWd0+yNf3Kq6TnHUHpC7mmHhq+hMb5imFqExdJtBLc2Q5fXY9JZc3wW0slNbsD/AkI5DOqV3BK86Jp3DZPZEaSzCRR9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744638753; c=relaxed/simple;
	bh=4mXNJheCb43vBYUEPbb+N+k7Jmsj5yYT9AFNRMnzR0I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aVt045RkKB35fYu3npur3Tg7cWE+p8gN5pMMPe26WCiaFclGfCBY80GCCcyBO/0bT69KJLQudh/zi06IZEZr/IQOVkb7BuJLFmhHq2BU5vPQyCRFeDjIhTc9aj3iM+A8TXAD1C9iR98oNDAKioGB8dy6gHAT3zVNHLxNuOL5II8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JI1Av+0S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JI1Av+0S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744638750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i2TZR70IZ+86a+saPhGG9LhSxOVPKHHAIPhSL6YAwNc=;
	b=JI1Av+0SrxzqWtGukxNhOJvKGJ64nEvNusVgfHOJmYrOS7FY4Z77zWEAEeMJmXRD9LNj6T
	yJmO3YWHGws237myicAy7xVBhz/cFpc8y8rznSFN0L1MUQ26MvoLN5GORHrBAqLws2mKlX
	3MTy8XOra6T+qdzC8tKuL0VuOIBt+6I=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-BqKbaaNEO3GApoA6BzekSw-1; Mon,
 14 Apr 2025 09:52:26 -0400
X-MC-Unique: BqKbaaNEO3GApoA6BzekSw-1
X-Mimecast-MFC-AGG-ID: BqKbaaNEO3GApoA6BzekSw_1744638745
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 203FB18007E1;
	Mon, 14 Apr 2025 13:52:25 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF63F19560AD;
	Mon, 14 Apr 2025 13:52:22 +0000 (UTC)
Date: Mon, 14 Apr 2025 15:52:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    Damien Le Moal <dlemoal@kernel.org>, 
    Christian Loehle <christian.loehle@arm.com>
Subject: Re: [PATCH] dm-delay: don't busy-wait in kthread
In-Reply-To: <20250411205656.60709-1-bmarzins@redhat.com>
Message-ID: <459f3125-843a-0067-dc37-b04d5b67b556@redhat.com>
References: <20250411205656.60709-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OhiIup3oORMGHG3Hmu3IV6e_pGk6kAtDauw79BruoJ0_1744638745
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 11 Apr 2025, Benjamin Marzinski wrote:

> When using a kthread to delay the IOs, dm-delay would continuously loop,
> checking if IOs were ready to submit. It had a cond_resched() call in
> the loop, but might still loop hundreds of millions of times waiting for
> an IO that was scheduled to be submitted 10s of ms in the future. With
> the change to make dm-delay over zoned devices always use kthreads
> regardless of the length of the delay, this wasted work only gets worse.
> 
> To solve this and still keep roughly the same precision for very short
> delays, dm-delay now calls fsleep() for 1/8th of the smallest non-zero
> delay it will place on IOs, or 1 ms, whichever is smaller. The reason
> that dm-delay doesn't just use the actual expiration time of the next
> delayed IO to calculated the sleep time is that delay_dtr() must wait
> for the kthread to finish before deleting the table. If a zoned device
> with a long delay queued an IO shortly before being suspended and
> removed, the IO would be flushed in delay_presuspend(), but the removing
> the device would still have to wait for the remainder of the long delay.
> This time is now capped at 1 ms.
> 
> Fixes: 70bbeb29fab09 ("dm delay: for short delays, use kthread instead of timers and wq")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> This patch is meant to apply on top of Damien Le Moal's "dm-delay:
> Prevent zoned write reordering on suspend" patch. If people think it's
> important to avoid either this much smaller amount of looping or the
> possible 1 ms delay on deleting a table, I can send a patch that uses
> usleep_range_state() and msleep_interruptible() to do an interruptible
> sleep with a duration based on the expiration time of the next delayed
> IO.

Hi

worker_sleep_ns should be worker_sleep_us - as the value is in 
microseconds.

fsleep in flush_worker_fn should be called unconditionally, to not consume 
100% CPU when suspending.

cond_resched() shouldn't be removed because fsleep may fall back to 
udelay.

The patch should increase target version.

I fixed the patch so that it applies on the top Linus' tree and applied 
it to the linux-dm tree.

BTW. do we need to backport this to the stable kernels? I think not, but 
if you have some reason why should we backport it, explain it.

Mikulas


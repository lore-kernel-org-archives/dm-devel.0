Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B5B1990B7
	for <dm-devel@lists.linux.dev>; Mon, 14 Apr 2025 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744649609; cv=none; b=GWF8EACOD3VGTKagkhN/28OujpM+w7gnUX/zWWaITL9kLxAks9MjPRiemSfMCZ9nFTm2KKu2CRdmGelLaIE43GqE82fdTSSxOM6E5HXEyQQqLOpF8yhBVTEUk7EZgQmaqSuQoALwkYuglSLTkGhsJXpp9dskgN8t4mnY64noEpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744649609; c=relaxed/simple;
	bh=ehMkF8/Ixlnfyl52ULqMCCcj5Q9d9ldspQe6NWRqbDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=DBVqFKVV++RNiwiTlQiqe2+qDFlKMO0qivLlQzCMgo2+XWiydIjD7iFFrOGft4hNsApkVGyJC6YrLmpfYF1RmxKjsd701pau2dYnSy4lwPn9BrYgmW9Vh+WecpDteHU2uX5ctZpv6cEIg0pBEF/7yscWChezWIQBJnVUp4neRa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cq9zIxFj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cq9zIxFj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744649607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=luO2LuYJ7xPJhIS2/QuHdSpOw/T5HIp9C2u/3LRWRDs=;
	b=Cq9zIxFjY2Aql/TamJmpN9k0Dd+eP8mfwSFEDoogRiZMegS6rkhXkHv9TDvKAsrg7UwSq4
	iA1tM86wkVGxy4iGq4ogpxMW+sfGhQI53Xodan5Auo8kqUCUY8eZyFqc7VWfuPtcPE97wn
	JRDKOCHw3BkgPI3O7nU2j2U7a9hzb0s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-dEUarO--N8uIDaZ5PTYZgQ-1; Mon,
 14 Apr 2025 12:53:19 -0400
X-MC-Unique: dEUarO--N8uIDaZ5PTYZgQ-1
X-Mimecast-MFC-AGG-ID: dEUarO--N8uIDaZ5PTYZgQ_1744649598
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8622180035E;
	Mon, 14 Apr 2025 16:53:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58C91195609D;
	Mon, 14 Apr 2025 16:53:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53EGrF7V634572
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Apr 2025 12:53:15 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53EGrFtR634571;
	Mon, 14 Apr 2025 12:53:15 -0400
Date: Mon, 14 Apr 2025 12:53:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev,
        Damien Le Moal <dlemoal@kernel.org>,
        Christian Loehle <christian.loehle@arm.com>
Subject: Re: [PATCH] dm-delay: don't busy-wait in kthread
Message-ID: <Z_09e7Zddckboca9@redhat.com>
References: <20250411205656.60709-1-bmarzins@redhat.com>
 <459f3125-843a-0067-dc37-b04d5b67b556@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <459f3125-843a-0067-dc37-b04d5b67b556@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xxw6zn7Y9iQoYE-D-cdxGobn575vUWT69G9xr4rZnKo_1744649598
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 14, 2025 at 03:52:18PM +0200, Mikulas Patocka wrote:
> 
> 
> On Fri, 11 Apr 2025, Benjamin Marzinski wrote:
> 
> > When using a kthread to delay the IOs, dm-delay would continuously loop,
> > checking if IOs were ready to submit. It had a cond_resched() call in
> > the loop, but might still loop hundreds of millions of times waiting for
> > an IO that was scheduled to be submitted 10s of ms in the future. With
> > the change to make dm-delay over zoned devices always use kthreads
> > regardless of the length of the delay, this wasted work only gets worse.
> > 
> > To solve this and still keep roughly the same precision for very short
> > delays, dm-delay now calls fsleep() for 1/8th of the smallest non-zero
> > delay it will place on IOs, or 1 ms, whichever is smaller. The reason
> > that dm-delay doesn't just use the actual expiration time of the next
> > delayed IO to calculated the sleep time is that delay_dtr() must wait
> > for the kthread to finish before deleting the table. If a zoned device
> > with a long delay queued an IO shortly before being suspended and
> > removed, the IO would be flushed in delay_presuspend(), but the removing
> > the device would still have to wait for the remainder of the long delay.
> > This time is now capped at 1 ms.
> > 
> > Fixes: 70bbeb29fab09 ("dm delay: for short delays, use kthread instead of timers and wq")
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > This patch is meant to apply on top of Damien Le Moal's "dm-delay:
> > Prevent zoned write reordering on suspend" patch. If people think it's
> > important to avoid either this much smaller amount of looping or the
> > possible 1 ms delay on deleting a table, I can send a patch that uses
> > usleep_range_state() and msleep_interruptible() to do an interruptible
> > sleep with a duration based on the expiration time of the next delayed
> > IO.
> 
> Hi
> 
> worker_sleep_ns should be worker_sleep_us - as the value is in 
> microseconds.

Oops.

> fsleep in flush_worker_fn should be called unconditionally, to not consume 
> 100% CPU when suspending.

This is fine, but flush_worker_fn() won't busy-wait while suspending.
Since it is calling flush_delayed_bios() with flush_all equal to true,
it will handle all the bios on the list. As long as bios keep getting
added to the list while it's flushing the last batch, it will keep
looping to flush them. But it will be doing necessary work on each loop,
and flush_delayed_bios() has a cond_resched(), so even if there are a
flood of bios, it will still take breaks. As soon as bios stop
continuously arriving, flush_worker_fn() will see the empty list and the
kthread will stop.

Unconditionally sleeping here makes it more likely that dm-delay will
end up sleeping unnecessarily while a there are just a few remaining
bios on the list. Like I said in my commit message, this sleep will be
capped at 1 ms, so it's not that big of a deal. But it's a trade-off.
I'm o.k. with your version. I just not sure that it is the better
trade-off. Perhaps I'm overlooking something.

> cond_resched() shouldn't be removed because fsleep may fall back to 
> udelay.

Again, your version is fine, but I'm not sure that cond_resched() was
ever necessary, since there already is one in flush_delayed_bios().
Also, at least the way it's currently coded, fsleep() will only resort
to busy-waiting when the delay is 10 us or less, and the shortest it can
be with this code is 62 us, so I don't think this cond_resched() will
ever do anything.

> The patch should increase target version.
> 
> I fixed the patch so that it applies on the top Linus' tree and applied 
> it to the linux-dm tree.
> 
> BTW. do we need to backport this to the stable kernels? I think not, but 
> if you have some reason why should we backport it, explain it.

dm-delay is basically a testing target, so I agree that it seems
unnecessary to backport this.

-Ben

> 
> Mikulas


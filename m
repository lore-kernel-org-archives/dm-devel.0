Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B4B172BCB
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713376828; cv=none; b=Qu1nMKgwtx0IAFVVC8swzd25mZEqnYQksQ53BnDfsN4VrBR2on45rO/zcIkvyHsx/P56uMk6TBQY3MXVZsmX6W0SU43adatjJohUyBM8qncTReWmNky5vtV3dcVLUPqNilwrA06mlNlX5Sj3UqN02aoKy+MyevacBoHqlZVmBM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713376828; c=relaxed/simple;
	bh=Dq26QfCgnNaI2tOpF1lMZEHiWUNQ/2Uht7UQhqKYR3g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TdXa4zSNx5PS2Z/HBOdwzBqxmM5BFENN22csXFhjOhDkk06TZAVr2xwtN3k4A94RMX9ZuCFD1cF4/EVi2IZ40uuOBPJIeYlwfnH84HKtlHyOxZAibej+3OYdrvVSvqMTab61X/f+tGEvGLDq/60Kc6xGa0NskAVAAyW1ewODnGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9K/RXMI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9K/RXMI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713376826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4CqEU9pkrruCGPgaK3aKCqLwJU0gMOcZXnjX2G2B4QE=;
	b=g9K/RXMI5gRd3LQx1R01T1v5WCWW2lcDf1Oi2go9gCCdNi6ZLPkf9xHCDSZ9MRpoznbe9D
	I0vjBk0AyDKQytyo5JRhpfU1CPvTMsglRkYbyeDOE1sdOhihfV1fXlLXoB5ZeYEizFSgdi
	EeTAPYiP+EUFjmqLq177vEGY8tQqNOk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-RXnpd9TUMWycQMsvV3WMKA-1; Wed, 17 Apr 2024 14:00:23 -0400
X-MC-Unique: RXnpd9TUMWycQMsvV3WMKA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9583618A8260;
	Wed, 17 Apr 2024 18:00:22 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5522D4011FF7;
	Wed, 17 Apr 2024 18:00:22 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 392F330C2BF7; Wed, 17 Apr 2024 18:00:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 3583C3FA97;
	Wed, 17 Apr 2024 20:00:22 +0200 (CEST)
Date: Wed, 17 Apr 2024 20:00:22 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
cc: Mike Snitzer <msnitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
    Damien Le Moal <dlemoal@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
    Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
    Guangwu Zhang <guazhang@redhat.com>, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] completion: move blk_wait_io to
 kernel/sched/completion.c
In-Reply-To: <20240417175538.GP40213@noisy.programming.kicks-ass.net>
Message-ID: <546473fd-ca4b-3c64-349d-cc739088b748@redhat.com>
References: <31b118f3-bc8d-b18b-c4b9-e57d74a73f@redhat.com> <20240417175538.GP40213@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2



On Wed, 17 Apr 2024, Peter Zijlstra wrote:

> On Wed, Apr 17, 2024 at 07:49:17PM +0200, Mikulas Patocka wrote:
> > Index: linux-2.6/kernel/sched/completion.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched/completion.c	2024-04-17 19:41:14.000000000 +0200
> > +++ linux-2.6/kernel/sched/completion.c	2024-04-17 19:41:14.000000000 +0200
> > @@ -290,6 +290,26 @@ wait_for_completion_killable_timeout(str
> >  EXPORT_SYMBOL(wait_for_completion_killable_timeout);
> >  
> >  /**
> > + * wait_for_completion_long_io - waits for completion of a task
> > + * @x:  holds the state of this particular completion
> > + *
> > + * This is like wait_for_completion_io, but it doesn't warn if the wait takes
> > + * too long.
> > + */
> > +void wait_for_completion_long_io(struct completion *x)
> > +{
> > +	/* Prevent hang_check timer from firing at us during very long I/O */
> > +	unsigned long timeout = sysctl_hung_task_timeout_secs * HZ / 2;
> > +
> > +	if (timeout)
> > +		while (!wait_for_completion_io_timeout(x, timeout))
> > +			;
> > +	else
> > +		wait_for_completion_io(x);
> > +}
> > +EXPORT_SYMBOL(wait_for_completion_long_io);
> 
> Urgh, why is it a sane thing to circumvent the hang check timer? 

The block layer already does it - the bios can have arbitrary size, so 
waiting for them takes arbitrary time.

Mikulas


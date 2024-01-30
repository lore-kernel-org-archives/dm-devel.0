Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D86266B22
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 10:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706611610; cv=none; b=jUlIA0OQLxS+VnqO5N9atxjzGsYsSXmMZTa5VvSX9K4tGws+YfoJv3GXIYO41c6YDLrACAisbUiOop3a80MTxtFNhuxep6jyu6k1w0LfzxIEo9tM0EfDBj4ETsR8N2byXTpyfGd3GaaPhmyXZTitt/xdJ3W5EBBEeAdMSWYK3+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706611610; c=relaxed/simple;
	bh=z8HQZ1RIcZ9IQsXzY0ib1csxcJUvHVGeYNDGFA9KaCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Blru/OG4SMyzdU711AWTvPFjHbLWp4ZUzdnrKO5VFT0VWwzjIZ1t5nbzMCuw0PJdJZOJdFzp2WFZjFW2meH/ty9KQWiTePADFh41gehUBYrtSvqMfArXJ0+ZR+KzlYsgflNp2y4l++mQ2ljHOL+VJE5nPy5UDvNoHNzsA/+25EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=WXJSp/EZ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=g9jOMurh; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="WXJSp/EZ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="g9jOMurh"
Date: Tue, 30 Jan 2024 11:46:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1706611607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jglZkCKiKZBorhtlJAzaJu8vNan4QCT2HLdU9knygeA=;
	b=WXJSp/EZ1N/l9q1lUMdQ5hDV8/ys0TJGqlpxdzwZ7h1uL8kUAwDDr00WHuWUKbYOuUZ7KW
	nL4s+XDYJJ6pISw5YftB8Km+Fqzs2AhqB5AO3JXlG6SZgpdt7RacnZ+5u7ptl7kdcNDgN9
	gF7Lti8PkBNyJk0DmGY9p5y8aPRhsUYi1qRBsvMEn63w94ovc3QQuE1P7hXrPF1Zy9XrWp
	qUh/YmqKqBYejBa49rNstydAg1DO/uKn0QOHuxP6aCTCgEdL6dbN4xNpCaFCX/oQs1FtAW
	mVNvRmS31aHJ86KQepO7oj2p8ekzXnEvNX7VnMIQBcawMRb7POuRPVQmWRLKig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1706611607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jglZkCKiKZBorhtlJAzaJu8vNan4QCT2HLdU9knygeA=;
	b=g9jOMurhIPesxC/jgbn4sby1InW3YJmfL0KPXUeasEWNWb/AJmgVMipqcjLxe2GPieqSNA
	fuIygHbIQZJ/ugCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, tglx@linutronix.de
Subject: Re: [PATCH 7/8] dm-crypt: Convert from tasklet to BH workqueue
Message-ID: <20240130104645.Gvnx8KnC@linutronix.de>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-8-tj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240130091300.2968534-8-tj@kernel.org>

On 2024-01-29 23:11:54 [-1000], Tejun Heo wrote:
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2263,9 +2232,8 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)

                /*
                 * in_hardirq(): Crypto API's skcipher_walk_first() refuses to work in hard IRQ context.
                 * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
                 * it is being executed with irqs disabled.
                 */
>  		 * it is being executed with irqs disabled.
>  		 */
>  		if (in_hardirq() || irqs_disabled()) {
> -			io->in_tasklet = true;
> -			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
> -			tasklet_schedule(&io->tasklet);
> +			INIT_WORK(&io->work, kcryptd_crypt);
> +			queue_work(system_bh_wq, &io->work);

Why do we need the tasklet here in the first place? Couldn't we use
workqueue? As per comment, the request originates in hardirq and then it
is moved to tasklet. Couldn't it be moved to workqueue regardless?

>  			return;
>  		}
>  

Sebastian

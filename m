Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56848662E
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 12:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713875815; cv=none; b=IsKxQo3VmAHsXpdRmOieg6NPTHLkUYc/6fGev1ZR/KShgHyTDY6hlNVBwL82DpQmxBPYSUPYn/7Ur3RJPhdOtxTjrvvO+TSp7QPGbgvDULVuZwa+4CcmiqIbVVX330ejstydcMugyBSCtGkqzNDZKpY/+OGYyrjs3PUh32GXdCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713875815; c=relaxed/simple;
	bh=VvAME1LWxRbvx9VDh/G7d7/s1knb+JtsY3BVP7m4ZaU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rUr5HbTEvnCTKTgdEY7oMS2q00MLAgW8yv7DjZdCxpH0zKFA7hLK89SDE3tKW/DBwVY6vCRiSRUy64jUdvPAugaMwCygsD0TunsEWEj4Zop8U3XTFVWHi1pPJoXn9dXcnhPHjTR84EUNUU/EJgg49hPa4OH866RYLHly1CPhE3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=btFvEEBs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btFvEEBs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713875811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m5hTS5Su8xeK74rUb4KJF+eI0XGddiqGV3X2wh7pCMQ=;
	b=btFvEEBsMZF9gn+777W27D97HcdU2HX5rxfLE8u/+JYO0pUUyRviLW13IHczFFAEBm0LUv
	VQwCqufljgVhTCA6XhwiA8onddwn88mh/XscbAps1on4JWllTgmWU+YksyPK/fJFNZeVXe
	3IvubmmPvpqbMdKWHTLrAWpontSi4bA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-Xj5FVClHMBeSnhEOFqUCew-1; Tue, 23 Apr 2024 08:36:47 -0400
X-MC-Unique: Xj5FVClHMBeSnhEOFqUCew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8096981F317;
	Tue, 23 Apr 2024 12:36:46 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D93FC0E7C2;
	Tue, 23 Apr 2024 12:36:45 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 883ED30BE3F7; Tue, 23 Apr 2024 12:36:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 841A83FA97;
	Tue, 23 Apr 2024 14:36:45 +0200 (CEST)
Date: Tue, 23 Apr 2024 14:36:45 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <msnitzer@redhat.com>, 
    Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>, 
    Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
    Waiman Long <longman@redhat.com>, Guangwu Zhang <guazhang@redhat.com>, 
    dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] completion: move blk_wait_io to
 kernel/sched/completion.c
In-Reply-To: <20240422105956.GN30852@noisy.programming.kicks-ass.net>
Message-ID: <8ab5c16e-154-c66-d167-5ce9eb6ea331@redhat.com>
References: <31b118f3-bc8d-b18b-c4b9-e57d74a73f@redhat.com> <20240417175538.GP40213@noisy.programming.kicks-ass.net> <546473fd-ca4b-3c64-349d-cc739088b748@redhat.com> <ZiCoIHFLAzCva2lU@infradead.org> <20240422105956.GN30852@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8



On Mon, 22 Apr 2024, Peter Zijlstra wrote:

> On Wed, Apr 17, 2024 at 09:57:04PM -0700, Christoph Hellwig wrote:
> > On Wed, Apr 17, 2024 at 08:00:22PM +0200, Mikulas Patocka wrote:
> > > > > +EXPORT_SYMBOL(wait_for_completion_long_io);
> > > > 
> > > > Urgh, why is it a sane thing to circumvent the hang check timer? 
> > > 
> > > The block layer already does it - the bios can have arbitrary size, so 
> > > waiting for them takes arbitrary time.
> > 
> > And as mentioned the last few times around, I think we want a task
> > state to say that task can sleep long or even forever and not propagate
> > this hack even further.
> 
> A bit like TASK_NOLOAD (which is used to make TASK_IDLE work), but
> different I suppose.
> 
> TASK_NOHUNG would be trivial to add ofc. But is it worth it?
> 
> Anyway, as per the other email, anything like this needs to come with a
> big fat warning. You get to keep the pieces etc..

This seems better than the blk_wait_io hack.

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 3c2abbc587b4..83b25327c233 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -112,7 +112,8 @@ struct user_event_mm;
>  #define TASK_FREEZABLE			0x00002000
>  #define __TASK_FREEZABLE_UNSAFE	       (0x00004000 * IS_ENABLED(CONFIG_LOCKDEP))
>  #define TASK_FROZEN			0x00008000
> -#define TASK_STATE_MAX			0x00010000
> +#define TASK_NOHUNG			0x00010000
> +#define TASK_STATE_MAX			0x00020000
>  
>  #define TASK_ANY			(TASK_STATE_MAX-1)
>  
> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index b2fc2727d654..126fac835e5e 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -210,7 +210,8 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
>  		state = READ_ONCE(t->__state);
>  		if ((state & TASK_UNINTERRUPTIBLE) &&
>  		    !(state & TASK_WAKEKILL) &&
> -		    !(state & TASK_NOLOAD))
> +		    !(state & TASK_NOLOAD) &&
> +		    !(state & TASK_NOHUNG))
>  			check_hung_task(t, timeout);
>  	}
>   unlock:
> 


Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6C063CB;
	Fri, 24 May 2024 01:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716512978; cv=none; b=h64Wl5MN0cAHViwhyrN8/p7BLA/2dvSpCjAE61OefNV0GAjtQ9fcfXy1wa+Jinu1rVWiBkIEeVLM9zNLFxYpNX+YbLl/3vEK3PodehT1g99C6uAVMaJ000lBhkYofiM4ZAwsnfcAt32Y+W1x78SbKp1TUKQxMxeQ2EirmXCmkzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716512978; c=relaxed/simple;
	bh=DKYzJ7hjD6JFuqEN/bj9SwX3EBxt2SBvBFrB++TsDX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmCinFWAIFBRMA7LRDotafSxUm3jWni6saDVO9opRVoyAYugJtTpf7wll8T+W0hv0T5KKRti7Sv8L6/riuHaE1ZfC+edI1WxcIBGMeUFAv4yrTnSvOpK0ZQX31jekPDqAq88kpCy/vQO7kHyOPATV+/skh0FM7xVTEV7alkigMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=IZ0S2mWl; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="IZ0S2mWl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=9jocgfouEm7fZUmRdyzJbH9BH2DlQ+nVHBfnIEE3AFs=; b=IZ0S2mWlzKMb0Syb
	TV1ATQKWitfvvGqM5BfBquDTLg0+rF/eG6xq4RNXgJ4y+AJ/zW3SHTmkLqym8OIqEvDk7EwHfG/pz
	VXD8kuzOP/caMaTtiQ94NcPTDQpHod99TXRT2hruwmMoongYjuUZNWMTxjFUbqijxYF7Q9cwDbVWo
	h7R3w1hfQpBzCoVKjvLTLzLZoizYHBHJlPfWo5KMLijO1MxLGu9wVSkZZRdIqowlWZaLG8teSYI28
	jrfbLj7qGtiAh4elFZKsLqnhW2q5A850qr7vjFk5QyLyNFpwCh9EDyJrDMTl0umsAUU2TuHiGhPHh
	Kx6BbprX+c8K9PZjgQ==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1sAJR8-002KKC-2A;
	Fri, 24 May 2024 01:09:34 +0000
Date: Fri, 24 May 2024 01:09:34 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm vdo: remove unused struct 'uds_attribute'
Message-ID: <Zk_ozpHryOiMLx_Q@gallifrey>
References: <20240523210716.309324-1-linux@treblig.org>
 <5c063045-4bce-14e4-9930-77cc0ed2edad@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5c063045-4bce-14e4-9930-77cc0ed2edad@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 01:08:57 up 15 days, 12:22,  1 user,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Matthew Sakai (msakai@redhat.com) wrote:
> On 5/23/24 17:07, linux@treblig.org wrote:
> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> > 
> > 'uds_attribute' is unused since
> > commit a9da0fb6d8c6 ("dm vdo: remove all sysfs interfaces").
> > 
> > Remove it.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> 
> Yes, this was clearly an oversight on our part. Feel free to add:
> Reviewed-by: Matthew Sakai <msakai@redhat.com>

Thanks for the quick review.
Is this something you'll send a pull for, or do I need to
ask someone else to include it?

Dave

> > ---
> >   drivers/md/dm-vdo/dedupe.c | 5 -----
> >   1 file changed, 5 deletions(-)
> > 
> > diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
> > index 117266e1b3ae..39ac68614419 100644
> > --- a/drivers/md/dm-vdo/dedupe.c
> > +++ b/drivers/md/dm-vdo/dedupe.c
> > @@ -148,11 +148,6 @@
> >   #include "vdo.h"
> >   #include "wait-queue.h"
> > -struct uds_attribute {
> > -	struct attribute attr;
> > -	const char *(*show_string)(struct hash_zones *hash_zones);
> > -};
> > -
> >   #define DEDUPE_QUERY_TIMER_IDLE 0
> >   #define DEDUPE_QUERY_TIMER_RUNNING 1
> >   #define DEDUPE_QUERY_TIMER_FIRED 2
> 
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

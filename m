Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521521363
	for <dm-devel@lists.linux.dev>; Thu,  7 Dec 2023 04:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YHP3QE1I"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-286f8ee27aeso550325a91.3
        for <dm-devel@lists.linux.dev>; Wed, 06 Dec 2023 20:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701924119; x=1702528919; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v2QqlXWCI26gv+jGfNp5oJjKdW8trvqIMxHSQSlEVHs=;
        b=YHP3QE1IPli5FehWJ3bfVgmOVltTXM5/j1wsfAZRWddXNDMyPoey6aY4JGebcBWbs3
         o5x+QmRq5+pTaQf/MjfMYDk4Osu/YGxaJEBk1rZFL5Tr82YogVlD82omsjm9b5rD3NtM
         kAZOR2HjU797oFwmD8bbDj1SPyv+BuMm0K8LmfJDqxCosR9HZfP77b6iIWyM3IMMGvCu
         iriOZaRL5N3yrBlYFoc0Q6ouAcjHyooXfDwbTUXE7HU2PPir68q2VnI1ZhPnP1gi9mI9
         t10qe7oRGiAcPKFB9z4ux7lQ831NJc6TJHUyuHtmshZxnBjaCqAeRrHKkBUphQMW+y7T
         8A7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701924119; x=1702528919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2QqlXWCI26gv+jGfNp5oJjKdW8trvqIMxHSQSlEVHs=;
        b=dxqZ0ffEVzmKxlUMUi/sQBnTKQP5L64ddEavTRC2Nj9cFomKA62pcUHkgBCpaW0Zgb
         0TF4zm4/DXGM0SqyHr5MFEhn3v4L9ZvxlTWFXVdJIOPrIHn9YnpZa8Z9tpgxrdlu8xDD
         UM4WrVqfEc7T5rNfnumOenY1ymkrTIg9GOO1b9OhJ2Ee1dwn0kX3ZWlWBzMkM/ScXUE+
         J/aMZRRhC7fFYpH0uJ28qvIOVf9l+euKqVrqRu2z46p6GREjpB5gHUa/l8SCHevjKoe7
         ne3kVoMYPD0qcA7V7mcUuywsT+637aTtyqvr4LOVWM/rONnj9YpziVHcAWKVSSlEH3oL
         X0WA==
X-Gm-Message-State: AOJu0YxTfBL2Zvx+/nzseE611zvBFCO4E7CNNNZf2bhaoZVd6FDds1JG
	6NcPrJnlnGyrDRnkvgXoO0PqEg==
X-Google-Smtp-Source: AGHT+IEKMEQI+Kt2z5Onuh0MysWMqhlDFc/G7D/Ejlz0kBFz1I/zpQGv1eC/i6etrpu5sui34F8eUg==
X-Received: by 2002:a17:90a:ff14:b0:286:6cc1:781a with SMTP id ce20-20020a17090aff1400b002866cc1781amr1867568pjb.93.1701924119432;
        Wed, 06 Dec 2023 20:41:59 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id mm22-20020a17090b359600b00286901e226bsm293341pjb.28.2023.12.06.20.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 20:41:58 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rB6Cy-004vYN-0Q;
	Thu, 07 Dec 2023 15:41:56 +1100
Date: Thu, 7 Dec 2023 15:41:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-cachefs@redhat.com, dhowells@redhat.com, gfs2@lists.linux.dev,
	dm-devel@lists.linux.dev, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] list_bl: don't use bit locks for PREEMPT_RT or
 lockdep
Message-ID: <ZXFNFKai3ILLFdnR@dread.disaster.area>
References: <20231206060629.2827226-1-david@fromorbit.com>
 <20231206060629.2827226-11-david@fromorbit.com>
 <20231207041650.3tzzmv2jfrr5vppl@moria.home.lan>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207041650.3tzzmv2jfrr5vppl@moria.home.lan>

On Wed, Dec 06, 2023 at 11:16:50PM -0500, Kent Overstreet wrote:
> On Wed, Dec 06, 2023 at 05:05:39PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > hash-bl nests spinlocks inside the bit locks. This causes problems
> > for CONFIG_PREEMPT_RT which converts spin locks to sleeping locks,
> > and we're not allowed to sleep while holding a spinning lock.
> > 
> > Further, lockdep does not support bit locks, so we lose lockdep
> > coverage of the inode hash table with the hash-bl conversion.
> > 
> > To enable these configs to work, add an external per-chain spinlock
> > to the hlist_bl_head() and add helpers to use this instead of the
> > bit spinlock when preempt_rt or lockdep are enabled.
> > 
> > This converts all users of hlist-bl to use the external spinlock in
> > these situations, so we also gain lockdep coverage of things like
> > the dentry cache hash table with this change.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Sleepable bit locks can be done with wait_on_bit(), is that worth
> considering for PREEMPT_RT? Or are the other features of real locks
> important there?

I think wait_on_bit() is not scalable. It hashes down to one of 256
shared struct wait_queue_heads which have thundering herd
behaviours, and it requires the locker to always run
prepare_to_wait() and finish_wait(). This means there is at least
one spinlock_irqsave()/unlock pair needed, sometimes two, just to
get an uncontended sleeping bit lock.

So as a fast path operation that requires lock scalability, it's
going to be better to use a straight spinlock that doesn't require
irq safety as it's far less expensive than a sleeping bit lock.

Whether CONFIG_PREEMPT_RT changes that equation at all is not at all
clear to me, and so I'll leave that consideration to RT people if
they see a need to address it. In the mean time, we need to use an
external spinlock for lockdep validation so it really doesn't make
any sense at all to add a third locking variant with completely
different semantics just for PREEMPT_RT...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

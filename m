Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E112F9D3
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 03:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710903694; cv=none; b=JIjzcedAMScs+gwtNLX5pbAooV/N4VcLIeOGivoqz3RjIWDKiql3aY+KHzVfpnKKFa9C+2dSyInqGQ+2gjT6oH6sAQZu5eY311fzYiB4iM+tmpCBJhqwGkOOK9jU1y60aaUM5kicisYakX4WeSo9IANQ1OjLhQJxlY3azKJSJVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710903694; c=relaxed/simple;
	bh=TyLpdxJTBr3425nDHzYBQd+Ij8cler9kgdT3/QEAlqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYaeNeY47CNKzkTVTkyLSPojs/6dxfrtdQJOvSSdeIEg/3eW7XvbfkV16fvwi72vrC5AwNdnfvJ3qar6GIVpUH8crdfjYn7oPluBAZbEmZ0p+/krCCPInp2AgsZq+YDayTmP0Rq95aZXA/S9Wy4PaOMQsEB+bghV1Y+hjxMcMAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uz66A93g; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uz66A93g"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1def81ee762so8994695ad.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 20:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710903692; x=1711508492; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=35rpOMt9N0PQI1HtZYax5BoW4EBNkuuGWd0M4cm/nKw=;
        b=Uz66A93g0Vm/YGMKsaIfr5UTf6Wd1gYW1+igl+IQuv1K1bWFVDk1oKbw0tD8jQDB5q
         x6w+ZuSra1eJCmjaHYt/ETeP5MQPbgWxqxp+5XpZyqb6KpGlCwLA/OgGBeQwJrZsH/Ul
         dyvnACKKrGAPVN3rEr3QMC1D9bDaXEqrzfTh5NnzF0JL3qO3qg5h8/MSUrT8BaNp40at
         Gffd6yEJFFJmt9f+I4MeWKA9dWS9hTDU6cSz9EoWYGgQ53+OKWiPm8guunhpV9knfrSm
         BL9JgMGOm7ED7yb+jgScdbbjEG7LtNbVLj4hElMMcD73SNNDDuILVV7FsQvzbH589Gb/
         ovkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710903692; x=1711508492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=35rpOMt9N0PQI1HtZYax5BoW4EBNkuuGWd0M4cm/nKw=;
        b=aJl8t6EHOE7bKSHC3mPlmBt131Jbnik4L3jXKEmVS8J5kEtNmrtXqpUCLtki4UnZF2
         yMEX52wFAjMOyyhxMxEHsXkzEPPYPcTVpXSA43g8lxAhqvhoH029BN29dxk92g9u7l3e
         wssYciPSFtUZaggrdL/Rx9yjYNj36igXhK8gff4cBWsOj6anO4XEnECIcOfiLucXoSe5
         Qt3JQvBAjOHxEr8xd6GiF20OwqXBwxz8xsptPdWDUjm3bDnDWJL6HDtu7+YSZfJynfDI
         PyNv7pGzKdr3Aa7HVYIXz5y9KAGOp8bi0KgiAc0mH3RN8cJOWgUJ4gP3SNN4U+TFvvyz
         2/hQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0QCL/H9gbx8Sy8r5H9eDBimKbwYQy3P1CLC0trjdELMeuOFzHdhB8tf/qsoYW+IOnpFHzKrgLTow08F4NBpe7PW64Uvv4+EQ=
X-Gm-Message-State: AOJu0Yy8xZgQVe3L+6UlYniNG+xkMMnt0aOYq+3uZDbzx9Ua4M1phrLO
	um0V64inkPxS6saINVpL0rrhZ7+4HxwWNlTohUyqtVPKv8VE0AaK
X-Google-Smtp-Source: AGHT+IE2pZ+9Hs3pLB7GNfVXiBAJR9GLVUQZAmgXsl3JRbC6bSvpked11TQIwgYq2A8lQ95xjs/DLg==
X-Received: by 2002:a05:6a20:7f8f:b0:1a3:4721:ded3 with SMTP id d15-20020a056a207f8f00b001a34721ded3mr4617995pzj.1.1710903692352;
        Tue, 19 Mar 2024 20:01:32 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709026f0200b001db2b8b2da7sm12206955plk.122.2024.03.19.20.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 20:01:31 -0700 (PDT)
Date: Wed, 20 Mar 2024 11:01:27 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] treewide: Refactor heap related implementation
Message-ID: <ZfpRh1pcab4PFLiw@visitorckw-System-Product-Name>
References: <20240319180005.246930-1-visitorckw@gmail.com>
 <4t6kkvswhacphbjloh3fps7twqp5d3wgxv7yrkvthb5u3uzaoe@6pf7mnvsv3rm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4t6kkvswhacphbjloh3fps7twqp5d3wgxv7yrkvthb5u3uzaoe@6pf7mnvsv3rm>

On Tue, Mar 19, 2024 at 06:12:17PM -0400, Kent Overstreet wrote:
> On Wed, Mar 20, 2024 at 01:59:52AM +0800, Kuan-Wei Chiu wrote:
> > Hello,
> > 
> > This patch series focuses on several adjustments related to heap
> > implementation. Firstly, a type-safe interface has been added to the
> > min_heap, along with the introduction of several new functions to
> > enhance its functionality. Additionally, the heap implementation for
> > bcache and bcachefs has been replaced with the generic min_heap
> > implementation from include/linux. Furthermore, several typos have been
> > corrected.
> > 
> > Previous discussion with Kent Overstreet:
> > https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
> 
> Hey, thanks for doing this. Can you post a git repo link? I'll point my
> CI at it.
>
Here is the link to my GitHub repository:
https://github.com/visitorckw/linux.git

The patch series can be found on the 'refactor-heap' branch.

Regards,
Kuan-Wei

> > 
> > Regards,
> > Kuan-Wei
> > 
> > Kuan-Wei Chiu (13):
> >   perf/core: Fix several typos
> >   bcache: Fix typo
> >   bcachefs: Fix typo
> >   lib min_heap: Add type safe interface
> >   lib min_heap: Add min_heap_init()
> >   lib min_heap: Add min_heap_peek()
> >   lib min_heap: Add min_heap_full()
> >   lib min_heap: Add args for min_heap_callbacks
> >   lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
> >     values
> >   bcache: Remove heap-related macros and switch to generic min_heap
> >   lib min_heap: Add min_heap_del()
> >   lib min_heap: Add min_heap_sift_up()
> >   bcachefs: Remove heap-related macros and switch to generic min_heap
> > 
> >  drivers/md/bcache/alloc.c      |  66 ++++++++----
> >  drivers/md/bcache/bcache.h     |   2 +-
> >  drivers/md/bcache/bset.c       |  73 ++++++++-----
> >  drivers/md/bcache/bset.h       |  38 ++++---
> >  drivers/md/bcache/btree.c      |  27 ++++-
> >  drivers/md/bcache/extents.c    |  44 ++++----
> >  drivers/md/bcache/movinggc.c   |  40 ++++++--
> >  drivers/md/bcache/super.c      |  16 +++
> >  drivers/md/bcache/sysfs.c      |   3 +
> >  drivers/md/bcache/util.c       |   2 +-
> >  drivers/md/bcache/util.h       |  81 +--------------
> >  drivers/md/dm-vdo/repair.c     |  29 +++---
> >  drivers/md/dm-vdo/slab-depot.c |  21 ++--
> >  fs/bcachefs/clock.c            |  53 +++++++---
> >  fs/bcachefs/clock_types.h      |   2 +-
> >  fs/bcachefs/ec.c               |  99 +++++++++++-------
> >  fs/bcachefs/ec_types.h         |   2 +-
> >  fs/bcachefs/util.c             |   2 +-
> >  fs/bcachefs/util.h             | 127 ++---------------------
> >  include/linux/min_heap.h       | 180 ++++++++++++++++++++++++++-------
> >  kernel/events/core.c           |  53 +++++-----
> >  lib/test_min_heap.c            |  75 +++++++-------
> >  22 files changed, 565 insertions(+), 470 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 

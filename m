Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48902365
	for <dm-devel@lists.linux.dev>; Fri, 26 Apr 2024 00:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714090474; cv=none; b=jsdpA6D4zInUXkwa7ew+pq7InfQuxA6XjdilWp0bVgxz/F+G79HnJFO783wS4nZdLHCvgIX2oeyWfGweLnDN9K6HgwN1Z0ekcnAdSyyKQXP64uaBE16m+47gJ03uhMGn450YnsQI1dth5WAzlPHbxUB8V5NWnwa4u9oVb3QAuro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714090474; c=relaxed/simple;
	bh=BNlz4p2+5Fzq2Xhe9VHkNPnVhu1O/EhyxSF3fvihfqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kaCObGbApdOj5oDdBZHnYqCCnXWeqFGl0TxK9ZOyWoKqJwI8ZYAnd/AlJAjHTUTpN4IEPclVG4aA2b1EjST0beh6Re3Ip0Gipd3xMV3b49PDKtmWFTkgX+55zW5ITVCa5RQ1AREXWVHb6sQSFo2L7w5m68p9ITD3EyrFcyukkRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R9hnqcIL; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R9hnqcIL"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2af71daeec1so378876a91.0
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 17:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714090471; x=1714695271; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SunWQ9HwSBJxyYvtsaZOJFSGcbd0R6AuBnmBsgWqMEg=;
        b=R9hnqcILhxqYhtU4FLBwezIGCYONXUUIHkVAUsJTLXJi1JhETaYTJujLG8P3jhsHxc
         hhKVEr+KjhFuXP/eiDJxNQFgxwNqfuPe3vtS0yWS2pUq7yzrRWSlO5idtKyj+nyaQ95j
         HaiDx0yk2GxLCNPIsLGshWLaaY5waJcnnNqC8pJiuFA+8h7xknk46oOe9PVAramIAeRj
         v5O45ibOxRpFeibtKzfnUKT9RQfeGfdr6PiYQLOaAB5XqkJJqegmWoTRkVwp30+yq1LS
         iHbUPPHYbeedGwRLeJXtolD7uK+QY3ABfcPtT6C5OQ37Td/gbCtOUCflKb+ws+aLaXRD
         xAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714090471; x=1714695271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SunWQ9HwSBJxyYvtsaZOJFSGcbd0R6AuBnmBsgWqMEg=;
        b=F98KclA59qbcvgaJILRhoORsh4XTpriE68vOK0yzqdpGYkSQ/tN54A4PFV1iILHwLc
         M1m4/fFWaYL7ib91cwJp/tpOCD219vMB1IeT1uDvnF7jDQ3pIEYFRE+JHe3DnizM6MDN
         WGriHVBiiiP+kPqvYNoV0a97fNr7+T6OxwSLkhZJTwRAg4vgBUS8SMf6E+Z1pYstZqb+
         0+EBHYaJBqqsRjClF66pMwSMn640RkDcx7JEVdjII5efaOL9dcMBFRJOtsGGsMhdn4lw
         rLGCc5A11VtCLRvfu6GDRWe2bxoBnSk14QX1r+C7bz7ZTeXTH0pSwtox4tsJBhkLimnE
         2LHQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3ts6sAO7hlkvRYZyTbB+FocUF8xbIKuEhRN6KMkThpi8L+w/wlGVatmUILBVad6nmxsehoPHzu6R/Rts93fa/ia/CPpa4t/o=
X-Gm-Message-State: AOJu0YygIDBgCt0yTVitmMbEX5ZOPMf+QXSz2/8+Dn5Bo6+/VFsqGaOV
	ObFoM2Q4DIkxn6o7PY3DCbicWzN/y5dD9tIITBKwDZOxUrQzFG/2
X-Google-Smtp-Source: AGHT+IFhfYJmlZYX3JCY6d+4vobjo7z2a69ChmkVLT1hXUmpPBdCX2AmDP1EgXQSKYYW9pR9OczIEQ==
X-Received: by 2002:a05:6a00:880f:b0:6ec:ef1c:5c55 with SMTP id ho15-20020a056a00880f00b006ecef1c5c55mr1525090pfb.2.1714090471464;
        Thu, 25 Apr 2024 17:14:31 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id gm8-20020a056a00640800b006e740d23674sm14228279pfb.140.2024.04.25.17.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 17:14:30 -0700 (PDT)
Date: Fri, 26 Apr 2024 08:14:25 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, colyli@suse.de,
	msakai@redhat.com, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org,
	bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v4 00/16] treewide: Refactor heap related implementation
Message-ID: <Zirx4fCA8C6/hz8m@visitorckw-System-Product-Name>
References: <20240425141826.840077-1-visitorckw@gmail.com>
 <txga7kntgxylhmxqkzs3rdgmnjai2ftlstdezltkapdctn3ju6@ndyytejfyoc2>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <txga7kntgxylhmxqkzs3rdgmnjai2ftlstdezltkapdctn3ju6@ndyytejfyoc2>

On Thu, Apr 25, 2024 at 04:54:54PM -0400, Kent Overstreet wrote:
> Hey Stephen, I think this is ready for -next.
> 
> https://github.com/visitorckw/linux.git refactor-heap-v4
> 
> Kuan, please add my acked-by to the bcachefs patch as well.
> 
Acked-by tag has been added to the repository mentioned above and
pushed out.

Regards,
Kuan-Wei
> 
> On Thu, Apr 25, 2024 at 10:18:10PM +0800, Kuan-Wei Chiu wrote:
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
> > 
> > Regards,
> > Kuan-Wei
> > 
> > ---
> > 
> > You can preview this patch series on the 'refactor-heap-v4' branch of
> > the repository at the following link:
> > 
> > https://github.com/visitorckw/linux.git
> > 
> > Changes in v4:
> > - Change struct initializations to use designated initializers.
> > - Replace memcpy() with func->swp() in heap_del() due to issues with
> >   set_backpointer in bcachefs when setting idx.
> > - Fix an error in ec_stripes_heap_swap() where
> >   ec_stripes_heap_set_backpointer() should be called after swapping.
> > 
> > Changes in v3:
> > - Avoid heap->heap.nr to eliminate the nested types.
> > - Add MIN_HEAP_PREALLOCATED macro for preallocating some elements.
> > - Use min_heap_sift_up() in min_heap_push().
> > - Fix a bug in heap_del() where we should copy the last element to
> >   'data + idx * element_size' instead of 'data'.
> > - Add testcases for heap_del().
> > - Fix bugs in bcache/bcachefs patches where the parameter types in
> >   some compare functions should have been 'type **', but were
> >   mistakenly written as 'type *'.
> > 
> > Changes in v2:
> > - Add attribute __always_unused to the compare and swap functions
> >   that do not use the args parameter.
> > - Rename min_heapify() to min_heap_sift_down().
> > - Update lib/test_min_heap.c to use min_heap_init().
> > - Refine the commit message for bcache and bcachefs.
> > - Adjust the order of patches in the patch series.
> > 
> > Link to v3: https://lore.kernel.org/20240406164727.577914-1-visitorckw@gmail.com
> > Link to v2: https://lore.kernel.org/20240320145417.336208-1-visitorckw@gmail.com
> > Link to v1: https://lkml.kernel.org/20240319180005.246930-1-visitorckw@gmail.com
> > 
> > Kuan-Wei Chiu (16):
> >   perf/core: Fix several typos
> >   bcache: Fix typo
> >   bcachefs: Fix typo
> >   lib min_heap: Add type safe interface
> >   lib min_heap: Add min_heap_init()
> >   lib min_heap: Add min_heap_peek()
> >   lib min_heap: Add min_heap_full()
> >   lib min_heap: Add args for min_heap_callbacks
> >   lib min_heap: Add min_heap_sift_up()
> >   lib min_heap: Add min_heap_del()
> >   lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
> >     values
> >   lib min_heap: Rename min_heapify() to min_heap_sift_down()
> >   lib min_heap: Update min_heap_push() to use min_heap_sift_up()
> >   lib/test_min_heap: Add test for heap_del()
> >   bcache: Remove heap-related macros and switch to generic min_heap
> >   bcachefs: Remove heap-related macros and switch to generic min_heap
> > 
> >  drivers/md/bcache/alloc.c      |  64 ++++++++---
> >  drivers/md/bcache/bcache.h     |   2 +-
> >  drivers/md/bcache/bset.c       |  84 ++++++++++-----
> >  drivers/md/bcache/bset.h       |  14 +--
> >  drivers/md/bcache/btree.c      |  17 ++-
> >  drivers/md/bcache/extents.c    |  53 ++++++----
> >  drivers/md/bcache/movinggc.c   |  41 +++++--
> >  drivers/md/bcache/sysfs.c      |   2 +
> >  drivers/md/bcache/util.c       |   2 +-
> >  drivers/md/bcache/util.h       |  67 +-----------
> >  drivers/md/bcache/writeback.c  |   3 +
> >  drivers/md/dm-vdo/repair.c     |  19 ++--
> >  drivers/md/dm-vdo/slab-depot.c |  14 +--
> >  fs/bcachefs/clock.c            |  43 ++++++--
> >  fs/bcachefs/clock_types.h      |   2 +-
> >  fs/bcachefs/ec.c               |  76 ++++++++-----
> >  fs/bcachefs/ec_types.h         |   2 +-
> >  fs/bcachefs/util.c             |   2 +-
> >  fs/bcachefs/util.h             | 118 +--------------------
> >  include/linux/min_heap.h       | 188 +++++++++++++++++++++++++--------
> >  kernel/events/core.c           |  29 ++---
> >  lib/test_min_heap.c            |  75 +++++++++----
> >  22 files changed, 522 insertions(+), 395 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 

Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4D113D8B0
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 17:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893195; cv=none; b=fALNbzOr73/4YjzIVRIAxZopYfm/7TnnniPzvNmbVJhLAKmMvsa5WdJTWl2KjAbOZYM4jCVoSn6pbGaNkmy+Flx2tLP+WtEQh4xwU4oDsZp2LyzHV6g42kgiH4kHtOvjFxoDbr5jrOK6ryiIqA/miPLCPF7JE9Vfwu/ndDUGHuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893195; c=relaxed/simple;
	bh=aw5QyXTFrt0I6wkXNS1QSaH9h20uEcN6f5SlYI5wjiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARG56R7XclhJhpycI+YvseH0WEynzMGyJZtfmHP8q5DFQXDoDxVlTHtFO2Pik7Y93DsPO9Mg4jfuoXg3/JKOwuxZjqYm0Bw6n/2nFJc76ZS8tEQGmCLd/G2vF51/I/moE7ONWgfKxOgkUceu6EIwmJmu0+6fQnKst4DQKJLIkCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6eb848b5a2eso3277000a34.3
        for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 10:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713893192; x=1714497992;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ay/Z5MQ+WP1fncKf7FVy06TMnDYaQnNxLByiP4iYl+w=;
        b=bR/ziJwWjjSI80yRVPUD3X/7nDXOE6Z95U4dRFDHJ7OlRh8WIkwGrcjEyZNSJCWPUh
         1qoJblQRNywO0KH2uWyA8+559SQWSblY0HfJP1g0TpGd4nMAjTn0zwmsCYmtf4aT8Mol
         /qUlrcQNZPqdgotQUr0u4kWJy8dmsSsren41QMv+v/l8HdGGg20VvdxtaVZYLFhBgRce
         PJNzj9nIWaSE1tjDustV7+9r4yid1Wey3ZLHxIbZWiwlZRLrE9wjWumTZDAcWBiNOdMt
         M3UuX7eQ4FIWuCWOorng8jQJB/A8kCAxRuA0fdnw3nLjWpXvTm5MkAcT/JlJv/EZDWI4
         L62A==
X-Forwarded-Encrypted: i=1; AJvYcCXJWHxy6aCl9Wd7rkwaf93WDRA6YpDOKC87B/Obx1P3DdGoPWuyr48ISu0fOFhukLJZS6zpCmjKhgDpTweVgBIiDPPSykhPhwc=
X-Gm-Message-State: AOJu0YyE3XyXoOgxMSK56DjtEblV5JFwuFWDAD2IfhC+39SXiG248B+1
	zvm/BbpHWkGgg+Yz8PXvAsEYDH7SiCjh9wcw/8+FhV+RR7UFeMptdEBzJ/Tuag==
X-Google-Smtp-Source: AGHT+IFEGiPnPGvD+GhFoRFgm+os6owhJlcDyAfL5BQMgOPIDxTZsXR1XaWF0Tm2XxdfMwCWsBa8rw==
X-Received: by 2002:a05:6830:2047:b0:6eb:d850:ae05 with SMTP id f7-20020a056830204700b006ebd850ae05mr241306otp.20.1713893192679;
        Tue, 23 Apr 2024 10:26:32 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a022500b0078f13d368f3sm4967735qkm.95.2024.04.23.10.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 10:26:32 -0700 (PDT)
Date: Tue, 23 Apr 2024 13:26:31 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Dave Chinner <dchinner@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
	dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: RFE: dm-thin: fine-grained handling of REQ_FUA is needed
Message-ID: <ZifvR1_FXjPnjOO7@redhat.com>
References: <DBAEFDB2-76C5-45D9-B88B-47E992E0016E@redhat.com>
 <20210114081525.GB1923@rh>
 <7bb4980cec013e7e3accdb156f1c17f3c305e0b9.camel@redhat.com>
 <20210121064512.GD2431@rh>
 <5c47483805514c9dd7313e2e21f5d946953b508c.camel@redhat.com>
 <20210122023346.GF2431@rh>
 <20210122042536.GB6814@redhat.com>
 <20210125013435.GG2431@rh>
 <ZiftqzT1a8YO7gQN@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZiftqzT1a8YO7gQN@redhat.com>

[one more time with feeling, after fixing dm-devel address typo]

On Tue, Apr 23, 2024 at 01:19:39PM -0400, Mike Snitzer wrote:
> [adding snitzer@kernel.org and dm-devel to the Cc so I don't lose this important thread again]
> [this was old Red Hat internal discussion that I tripped over like a dead cat, but there isn't anything sensitive here: dm-thinp needs to improve]
> 
> On Sun, Jan 24 2021 at  8:34P -0500,
> Dave Chinner <dchinner@redhat.com> wrote:
> 
> > On Thu, Jan 21, 2021 at 11:25:37PM -0500, Mike Snitzer wrote:
> > > On Thu, Jan 21 2021 at  9:33pm -0500,
> > > Dave Chinner <dchinner@redhat.com> wrote:
> > > 
> > > > On Thu, Jan 21, 2021 at 04:23:20PM +0000, Joe Thornber wrote:
> > > > > On Thu, 2021-01-21 at 17:45 +1100, Dave Chinner wrote:
> > > > > > On Wed, Jan 20, 2021 at 10:34:01AM +0000, Joe Thornber wrote:
> > > > > > 
> > > > > > > - Currently the tools unshare _metadata_ when restoring/repairing
> > > > > > > pools
> > > > > > > with snapshots.  Combined with the hard 16gb limit on metadata size
> > > > > > > this means some systems with many snapshots can't be repaired if
> > > > > > > they
> > > > > > > run into trouble.  Next release of the tools will fix, but as said
> > > > > > > before, we have to assess the software as is.
> > > > > > 
> > > > > > Can you explain more about this limit and what it means? The test
> > > > > > I'm currently running (1000 iterations of "write 10,000 4kB IOs,
> > > > > > snapshot"
> > > > > 
> > > > > Right let's talk about your scenario.
> > > > > 
> > > > > Firstly metadata.  Our transactional model is based on persistent data
> > > > > structures in the functional programming sense.  To update metadata in
> > > > > a new transaction we COW key metadata pages to build a new data
> > > > > structure that shares data with that of the previous transaction.  We
> > > > > amortise the costs associated with this by holding the transactions
> > > > > open as long as possible and allowing real mutation *within* a
> > > > > transaction.
> > > > > 
> > > > > There are advantages and disadvantages with this scheme.
> > > > > 
> > > > > Advantages: It's simple.  It allows the 'take snapshot' operation to be
> > > > > very quick (just writing a handful of pages).  It also allows us to
> > > > > take a 'metadata snapshot' of all the metadata which userland can
> > > > > access safely.  So we can move the implementation of certain
> > > > > query/health functions entirely to userland. (see thin_check, thin_ls,
> > > > > thin_dump etc).
> > > > > 
> > > > > Disadvantages: The biggest down side is everything is done in one
> > > > > global transaction; if a commit is required by one thin device (eg, due
> > > > > to a REQ_FUA), then other active thin devices will be temporarily
> > > > > slowed as the transaction commits.
> > > > 
> > > > OUCH!
> > > > 
> > > > That means every journal IO from the filesystem on the thin vol will
> > > > trigger a globally serialising metadata commit. It also means every
> > > > user O_DSYNC/RWF_DSYNC direct IO (which we optimise to FUA writes
> > > > to avoid journal flushes) will trigger a thinp commit.
> > > 
> > > So XFS hijacks REQ_FUA to bypass its journaling _but_ expects that
> > > REQ_FUA to have no impact on the underlying storage?  Why not clear
> > > REQ_FUA after XFS decides to bypass its journal?  Why use REQ_FUA for
> > > this?  What are your assumptions about how the underlying block device
> > > will respond?
> > 
> > "Hijack" is a bit ... strong. We replaced a full device cache flush
> > with an FUA write at the request of a partner that demonstrated that
> > using FUA writes in their applications on other operating systems on
> > the same hardware configurations ran them 25-50% faster than on
> > RHEL/XFS.
> > 
> > I reproduced their results locally, and the difference in
> > performance was the device level overhead between write+full device
> > caceh flush (the traditional linux DIO O_DSYNC implementation) and
> > using FUA writes to avoid the full device cache flush when only the
> > data in the IO itself needed to be written to stable storage.
> > 
> > It's not at all controversial - REQ_FUA has been used by filesystems
> > for years for their journal writes to optimise away the post-write
> > cache flush on hardware that supports FUA. And ext4, gfs2, zonefs
> > and btrfs all use this same code direct IO code path now, so it's
> > not just XFS doing this...
> > 
> > FWIW, I mused on the weekend that we don't even need to check that
> > the block device supports FUA to make this optimisation, because the
> > block layer will convert REQ_FUA to a normal write + post write
> > cache flush if the underlying device doesn't support FUA. So we are
> > likely to make all pure O_DSYNC data overwrites use REQ_FUA in the
> > future, not just on devices that support FUA...
> > 
> > > > This is what enterprise applications do for IO performance - small,
> > > > random, highly concurrent O_DSYNC AIO+DIO overwrites - so it seems
> > > > like this is going to cause IO serialisation problems even if there is 
> > > > only one thin-vol in a thin-pool...
> > > 
> > > Yes, but I currently cannot say this is thinp's fault.  REQ_FUA must be
> > > honored.  If dm-thinp is being asked to flush caches and get a
> > > consistent point-in-time it cannot be ignored.
> > 
> > Yes, that's the point I was trying to make. FUA is not a cache flush
> > request - it's much more fine grained than that, and so can be used
> > to elide full device cache flushes. Hence requiring global commits
> > to honor FUA data writes defeats the higher level optimisations that
> > try to minimise the device cache flush overhead...
> > 
> > > So what additonal data structures and approach should we be taking to
> > > mask the impact of needing to keep data and metadata consistent?
> > 
> > I'm not a dm-thin expert, but I can describe the constraints for
> > using REQ_FUA because I think they probably apply to dm-thin, too
> > 
> > For filesystems, there are per-inode metadata trees, and that's all
> > we need to be stable w.r.t. O_DSYNC data writes. If the per-inode
> > metadata is up-to-date on disk (i.e. we are doing a pure overwrite
> > and no metadata needs to change to perform the data IO) then we can
> > issue a REQ_FUA write.  If there is any metadata that needs to be
> > modified to perform the write (e.g. we need an allocation, convert
> > an unwritten extent, etc) or something else dirtied the inode
> > metadata prior to the write, then we do a normal data write and a
> > post-write journal flush (which is REQ_PREFLUSH|REQ_FUA write) to
> > ensure both the data and the metadata that references it is on
> > stable storage.
> > 
> > See this commit:
> > 
> > commit 3460cac1ca76215a60acb086ebe97b3e50731628
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Wed May 2 12:54:53 2018 -0700
> > 
> >     iomap: Use FUA for pure data O_DSYNC DIO writes
> > ....
> > 
> > Also, check the current upstream tree for IOMAP_F_DIRTY so the fs
> > can indicate that inode has O_DSYNC dirty metadata (allocate,
> > unwritten) or IOMAP_F_SHARED (requires COW), and the iomap
> > implementation uses the IOMAP_DIO_WRITE_FUA and IOMAP_DIO_NEED_SYNC
> > flags to determine what to do at IO completion.
> > 
> > I suspect that dm-thin would need to do something similar for
> > REQ_FUA writes - if the thin-dev metadata (rather than the global
> > pool metadata) is clean and there's an already allocated block being
> > overwritten into, then you can just pass the FUA down and not have
> > to run a global transaction commit.  If there's anything dirty, or
> > the IO requires COW or allocation, then it needs to run through the
> > existing slow path...
> > 
> > > > > This limits the number of active
> > > > > thin devices.  Similarly if different thin devices are performing
> > > > > operations that allocate new data space (provisioning, COW), then there
> > > > > can be contention in the allocators.
> > > > 
> > > > Or we are doing concurrent IO to the same thin device...
> > > 
> > > Concurrent IO that is causing a denial-of-service due to floods of
> > > REQ_FUA IO?  Yeap.. that sounds like it'd hurt ;)
> > 
> > This is what enterprise applications like SAP, MS-SQL, Seastar, etc
> > all do to extract maximum performance out of the underlying storage.
> > They can have hundreds, even thousands of O_DSYNC AIO+DIO in flight at
> > once, generally only limited only by software and hardware queue depths.
> > 
> > So, yeah, if "general use" is the goal, this better not be a DOS
> > vector. ;)
> 
> Just bumping this thread because it has been over 3 years now and
> dm-thinp hasn't seen any changes to address its heavy handling of
> REQ_FUA.
> 
> Mike

Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E2DC77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685031513;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NFP/PE3pgiyEm2hbFCc995Flpjog/34uCfMozxSKVoU=;
	b=CfOkCo7iiK0CN4rGDj10Ig1HyLrArJOqsauOuvuo2PMPyIjv1N8PBTkBMNu29tDCQyaXcR
	BqN713alPyYeEc0VtsCzwfToeqKu9U1uhQgSwgvswmdQRxahsp2pOjQRrKVMXsdLoDq0SD
	PdqvoS+PCyCb3OQ2dNJp0zPt0KdJ9uo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-uoCCDuEKOhKf6bySVSV7zA-1; Thu, 25 May 2023 12:18:31 -0400
X-MC-Unique: uoCCDuEKOhKf6bySVSV7zA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68B6A811E91;
	Thu, 25 May 2023 16:18:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CAD77492B0A;
	Thu, 25 May 2023 16:18:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9416B19465A4;
	Thu, 25 May 2023 16:18:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 11AE319465A0
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 May 2023 16:17:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DC66C407DECB; Thu, 25 May 2023 16:17:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D4E85407DEC3
 for <dm-devel@redhat.com>; Thu, 25 May 2023 16:17:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3330101A52C
 for <dm-devel@redhat.com>; Thu, 25 May 2023 16:17:22 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-e0Mgj1LMO_Sa_1oknwjiNg-1; Thu, 25 May 2023 12:17:19 -0400
X-MC-Unique: e0Mgj1LMO_Sa_1oknwjiNg-1
Received: by mail-qk1-f200.google.com with SMTP id
 af79cd13be357-75b2c4b3e02so108465585a.1
 for <dm-devel@redhat.com>; Thu, 25 May 2023 09:17:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685031438; x=1687623438;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=kfI1228BT1lPSNTcQiaLIPB09CDTdUJPSFhJvqJ8/wQ=;
 b=Dw0HD2tn+0ai4OLIXFTWyHqaJNX2syzdIQB/1x8uMukCoSidg1XTxOfsTxfI5hHFdz
 OSVBa1b++WUXBSEkBH/24kVh0bNl654rNf/GtE0hB9Z1BtWA7tagGELsoVSqhHhpFYEg
 0dfmiveLM7cBhT473dd+4zogOMe9BC06/SaqvaDpV8HZDwYVPSZZds1leO/CaSPn9/Nk
 LKb5HWbt2nV4hGr5tzXLAg5bZskLmAkHEOqTLwdmLDV7oPjUePLXXJLuo7+jK7kgY36E
 X5oGQcjsSCw9EttEtS3Y5l9Y2phsScTVEKvIufyiZOa8hJJzzw17NGe147Iw0m40bLYg
 Cm8A==
X-Gm-Message-State: AC+VfDx0EkFB11pt7uCHpTOzusa6Tv9QKohIDgBD5cCSYFTKaFrDhyqy
 L5kQ7eUj1/B2YhWFAEzm4e1OYez5GrUol+/g+GD3A4TaLADO5n7qAvZzWOsPJxbfSqEvsWCjK3W
 Mxl9U+fbfXtNgC/Y=
X-Received: by 2002:a05:620a:2b9c:b0:75b:23a1:d8ce with SMTP id
 dz28-20020a05620a2b9c00b0075b23a1d8cemr2966406qkb.18.1685031438333; 
 Thu, 25 May 2023 09:17:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5URREXOgS18lIhJSr4njOTwBiUKlVD8Ep70/xv62Y6p9tMFNK+fvipBkeNUIxnJhB8w+F/gA==
X-Received: by 2002:a05:620a:2b9c:b0:75b:23a1:d8ce with SMTP id
 dz28-20020a05620a2b9c00b0075b23a1d8cemr2966378qkb.18.1685031437846; 
 Thu, 25 May 2023 09:17:17 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
 by smtp.gmail.com with ESMTPSA id
 a4-20020a05620a124400b0075b1c6f9628sm494265qkl.71.2023.05.25.09.17.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 25 May 2023 09:17:17 -0700 (PDT)
Date: Thu, 25 May 2023 12:19:47 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Message-ID: <ZG+KoxDMeyogq4J0@bfoster>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <ZGb2Xi6O3i2pLam8@infradead.org> <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area>
 <ZGu0LaQfREvOQO4h@redhat.com> <ZGzIJlCE2pcqQRFJ@bfoster>
 <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <ZG1dAtHmbQ53aOhA@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 24, 2023 at 10:40:34AM +1000, Dave Chinner wrote:
> On Tue, May 23, 2023 at 11:26:18AM -0400, Mike Snitzer wrote:
> > On Tue, May 23 2023 at 10:05P -0400, Brian Foster <bfoster@redhat.com> wrote:
> > > On Mon, May 22, 2023 at 02:27:57PM -0400, Mike Snitzer wrote:
> > > ... since I also happen to think there is a potentially interesting
> > > development path to make this sort of reserve pool configurable in terms
> > > of size and active/inactive state, which would allow the fs to use an
> > > emergency pool scheme for managing metadata provisioning and not have to
> > > track and provision individual metadata buffers at all (dealing with
> > > user data is much easier to provision explicitly). So the space
> > > inefficiency thing is potentially just a tradeoff for simplicity, and
> > > filesystems that want more granularity for better behavior could achieve
> > > that with more work. Filesystems that don't would be free to rely on the
> > > simple/basic mechanism provided by dm-thin and still have basic -ENOSPC
> > > protection with very minimal changes.
> > > 
> > > That's getting too far into the weeds on the future bits, though. This
> > > is essentially 99% a dm-thin approach, so I'm mainly curious if there's
> > > sufficient interest in this sort of "reserve mode" approach to try and
> > > clean it up further and have dm guys look at it, or if you guys see any
> > > obvious issues in what it does that makes it potentially problematic, or
> > > if you would just prefer to go down the path described above...
> > 
> > The model that Dave detailed, which builds on REQ_PROVISION and is
> > sticky (by provisioning same blocks for snapshot) seems more useful to
> > me because it is quite precise.  That said, it doesn't account for
> > hard requirements that _all_ blocks will always succeed.
> 
> Hmmm. Maybe I'm misunderstanding the "reserve pool" context here,
> but I don't think we'd ever need a hard guarantee from the block
> device that every write bio issued from the filesystem will succeed
> without ENOSPC.
> 

The bigger picture goal that I didn't get into in my previous mail is
the "full device" reservation model is intended to be a simple, crude
reference implementation that can be enabled for any arbitrary thin
volume consumer (filesystem or application). The idea is to build that
on a simple enough reservation mechanism that any such consumer could
override it based on its own operational model. The goal is to guarantee
that a particular filesystem never receives -ENOSPC from dm-thin on
writes, but the first phase of implementing that is to simply guarantee
every block is writeable.

As a specific filesystem is able to more explicitly provision its own
allocations in a way that it can guarantee to return -ENOSPC from
dm-thin up front (rather than at write bio time), it can reduce the need
for the amount of reservation required, ultimately to zero if that
filesystem provides the ability to pre-provision all of its writes to
storage in some way or another.

I think for filesystems with complex metadata management like XFS, it's
not very realistic to expect explicit 1-1 provisioning for all metadata
changes on a per-transaction basis in the same way that can (fairly
easily) be done for data, which means a pool mechanism is probably still
needed for the metadata class of writes. Therefore, my expectation for
something like XFS is that it grows the ability to explicitly provision
data writes up front (we solved this part years ago), and then uses a
much smaller pool of reservation for the purpose of dealing with
metadata.

I think what you describe below around preprovisioned perag metadata
ranges is interesting because it _very closely_ maps conceptually to
what I envisioned the evolution of the reserve pool scheme to end up
looking like, but just implemented rather differently to use
reservations instead of specific LBA ranges.

Let me try to connect the dots and identify the differences/tradeoffs...

> If the block device can provide a guarantee that a provisioned LBA
> range is always writable, then everything else is a filesystem level
> optimisation problem and we don't have to involve the block device
> in any way. All we need is a flag we can ready out of the bdev at
> mount time to determine if the filesystem should be operating with
> LBA provisioning enabled...
> 
> e.g. If we need to "pre-provision" a chunk of the LBA space for
> filesystem metadata, we can do that ahead of time and track the
> pre-provisioned range(s) in the filesystem itself.
> 
> In XFS, That could be as simple as having small chunks of each AG
> reserved to metadata (e.g. start with the first 100MB) and limiting
> all metadata allocation free space searches to that specific block
> range. When we run low on that space, we pre-provision another 100MB
> chunk and then allocate all metadata out of that new range. If we
> start getting ENOSPC to pre-provisioning, then we reduce the size of
> the regions and log low space warnings to userspace. If we can't
> pre-provision any space at all and we've completely run out, we
> simply declare ENOSPC for all incoming operations that require
> metadata allocation until pre-provisioning succeeds again.
> 

The more interesting aspect of this is not so much how space is
provisioned and allocated, but how the filesystem is going to consume
that space in a way that guarantees -ENOSPC is provided up front before
userspace is allowed to make modifications. You didn't really touch on
that here, so I'm going to assume we'd have something like a perag
counter of how many free blocks currently live in preprovisioned ranges,
and then an fs-wide total somewhere so a transaction has the ability to
consume these blocks at trans reservation time, the fs knows when to
preprovision more space (or go into -ENOSPC mode), etc.

Some accounting of that nature is necessary here in order to prevent the
filesystem from ever writing to unprovisioned space. So what I was
envisioning is rather than explicitly preprovision a physical range of
each AG and tracking all that, just reserve that number of arbitrarily
located blocks from dm for each AG.

The initial perag reservations can be populated at mount time,
replenished as needed in a very similar way as what you describe, and
100% released back to the thin pool at unmount time. On top of that,
there's no need to track physical preprovisioned ranges at all. Not just
for allocation purposes, but also to avoid things like having to protect
background trims from preprovisioned ranges of free space dedicated for
metadata, etc. 

> This is built entirely on the premise that once proactive backing
> device provisioning fails, the backing device is at ENOSPC and we
> have to wait for that situation to go away before allowing new data
> to be ingested. Hence the block device really doesn't need to know
> anything about what the filesystem is doing and vice versa - The
> block dev just says "yes" or "no" and the filesystem handles
> everything else.
> 

Yup, everything you describe about going into a simulated -ENOSPC mode
would work exactly the same. The primary difference is that the internal
provisioned space accounting in the filesystem is backed by dynamic
reservation in dm, rather than physically provisioned LBA ranges.

> It's worth noting that XFS already has a coarse-grained
> implementation of preferred regions for metadata storage. It will
> currently not use those metadata-preferred regions for user data
> unless all the remaining user data space is full.  Hence I'm pretty
> sure that a pre-provisioning enhancment like this can be done
> entirely in-memory without requiring any new on-disk state to be
> added.
> 
> Sure, if we crash and remount, then we might chose a different LBA
> region for pre-provisioning. But that's not really a huge deal as we
> could also run an internal background post-mount fstrim operation to
> remove any unused pre-provisioning that was left over from when the
> system went down.
> 

None of this is really needed..

> Further, managing shared pool exhaustion doesn't require a
> reservation pool in the backing device and for the filesystems to
> request space from it. Filesystems already have their own reserve
> pools via pre-provisioning. If we want the filesystems to be able to
> release that space back to the shared pool (e.g. because the shared
> backing pool is critically short on space) then all we need is an
> extension to FITRIM to tell the filesystem to also release internal
> pre-provisioned reserves.
> 
> Then the backing pool admin (person or automated daemon!) can simply
> issue a trim on all the filesystems in the pool and spce will be
> returned. Then filesystems will ask for new pre-provisioned space
> when they next need to ingest modifications, and the backing pool
> can manage the new pre-provisioning space requests directly....
> 

This is written as to imply that the reservation pool is some big
complex thing, which makes me think there is some
confusion/miscommunication. It's basically just an in memory counter of
space that is allocated out of a shared thin pool and is held in a
specific thin volume while it is currently in use. The counter on the
volume is managed indirectly by filesystem requests and/or direct
operations on the volume (like dm snapshots).

Sure, you could replace the counter and reservation interface with
explicitly provisioned/trimmed LBA ranges that the fs can manage to
provide -ENOSPC guarantees, but then the fs has to do those various
things you've mentioned:

- Provision those ranges in the fs and change allocation behavior
  accordingly.
- Do the background post-crash fitrim preprovision clean up thing.
- Distinguish between trims that are intended to return preprovisioned
  space vs. those that come from userspace.
- Have some daemon or whatever (?) responsible for communicating the
  need for trims in the fs to return space back to the pool.

Then this still depends on changing how dm thin snapshots work and needs
a way to deal with delayed allocation to actually guarantee -ENOSPC
protection..?

> Hence I think if we get the basic REQ_PROVISION overwrite-in-place
> guarantees defined and implemented as previously outlined, then we
> don't need any special coordination between the fs and block devices
> to avoid fatal ENOSPC issues with sparse and/or snapshot capable
> block devices...
> 

This all sounds like a good amount of coordination and unnecessary
complexity to me. What I was thinking as a next phase (i.e. after
initial phase full device reservation) approach for a filesystem like
XFS would be something like this.

- Support a mount option for a configurable size metadata reservation
  pool (with sane/conservative default).
- The pool is populated at mount time, else the fs goes right into
  simulated -ENOSPC mode.
- Thin pool reservation consumption is controlled by a flag on write
  bios that is managed by the fs (flag polarity TBD).
- All fs data writes are explicitly reserved up front in the write path.
  Delalloc maps to explicit reservation, overwrites are easy and just
  involve an explicit provision.
- Metadata writes are not reserved or provisioned at all. They allocate
  out of the thin pool on write (if needed), just as they do today. On
  an -ENOSPC metadata write error, the fs goes into simulated -ENOSPC mode
  and allows outstanding metadata writes to now use the bio flag to
  consume emergency reservation.

So this means that metadata -ENOSPC protection is only as reliable as
the size of the specified pool. This is by design, so the filesystem
still does not have to track provisioning, allocation or overwrites of
its own metadata usage. Users with metadata heavy workloads or who
happen to be sensitive to -ENOSPC errors can be more aggressive with
pool size, while other users might be able to get away with a smaller
pool. Users who are super paranoid and want perfection can continue to
reserve the entire device and pay for the extra storage.

Users who are not sure can test their workload in an appropriate
environment, collect some data/metrics on maximum outstanding dirty
metadata, and then use that as a baseline/minimum pool size for reliable
behavior going forward. This is also where something like Stratis can
come in to generate this sort of information, make recommendations or
implement heuristics (based on things like fs size, amount of RAM, for
e.g.) to provide sane defaults based on use case. I.e., this is
initially exposed as a userspace/tuning issue instead of a
filesystem/dm-thin hard guarantee.

Finally, if you really want to get to that last step of maximally
efficient and safe provisioning in the fs, implement a
'thinreserve=adaptive' mode in the fs that alters the acquisition and
consumption of dm-thin reserved blocks to be adaptive in nature and
promises to do it's own usage throttling against outstanding
reservation. I think this is the mode that most closely resembles your
preprovisioned range mechanism.

For example, adaptive mode could add the logic/complexity where you do
the per-ag provision thing (just using reservation instead of physical
ranges), change the transaction path to attempt to increase the
reservation pool or go into -ENOSPC mode, and flag all writes to be
satisfied from the reserve pool (because you've done the
provision/reservation up front).

At this point the "reserve pool" concept is very different and pretty
much managed entirely by the filesystem. It's just a counter of the set
of blocks the fs is anticipating to write to in the near term, but it's
built on the same underlying reservation mechanism used differently by
other filesystems. So something like ext4 could elide the need for an
adaptive mode, implement the moderate data/metadata pool mechanism and
rely on userspace tools or qualified administrators to do the sizing
correctly, while simultaneously using the same underlying mechanism that
XFS is using for finer grained provisioning.

> As a bonus, if we can implement the guarantees in dm-thin/-snapshot
> and have a filesystem make use of it, then we also have a reference
> implementation to point at device vendors and standards
> associations....
> 

I think that's a ways ahead yet.. :P

Thoughts on any of the above? Does that describe enough of the big
picture? (Mike, I hope this at least addresses the whole "why even do
this?" question). I am deliberately trying to work through a progression
that starts simple and generic but actually 100% solves the problem
(even if in a dumb way), then iterates to something that addresses the
biggest drawback with the reference implementation with minimal changes
required to individual filesystems (i.e. metadata pool sizing), and
finally ends up allowing any particular filesystem to refine from there
to achieve maximal efficiency based on its own cost/benefit analysis.

Another way to look at it is... step 1 is to implement the
'thinreserve=full' mount option, which can be trivially implemented by
any filesystem with a couple function calls. Step two is to implement
'thinsreserve=N' support, which consists of a standard iomap
provisioning implementation for data and a bio tagging/error handling
approach that is still pretty simple for most filesystems to implement.
Finally, 'thinreserve=adaptive' is the filesystems best effort to
guarantee -ENOSPC safety with maximal space efficiency.

One general tradeoff with using reservations vs. preprovisioning is the
the latter can just use the provision/trim primitives to alloc/free LBA
ranges. My thought on that is those primitives could possibly be
modified to do the same sort of things with reservation as for physical
allocations. That seems fairly easy to do with bio op flags/modifiers,
though one thing I'm not sure about is how to submit a provision bio to
request a certain amount location agnostic blocks. I'd have to
investigate that more.

So in summary, I can sort of see how this problem could be solved with
this combination of physically preprovisioned ranges and changes to
dm-thin snapshot behavior and whatnot (I'm still missing how this is
supposed to handle delalloc, mostly), but I think that involves more
complexity and customization work than is really necessary. Either way,
this is a distinctly different approach to what I was thinking of
morphing the prototype bits into. So to me the relevant question is does
something like the progression that is outlined above for a block
reservation approach seem a reasonable path to ultimately be able to
accomplish the same sort of results in the fs? If so, then I'm happy to
try and push things in that direction to at least try to prove it out.
If not, then I'm also happy to just leave it alone.. ;)

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


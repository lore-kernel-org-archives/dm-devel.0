Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B621CC77B7A
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 11:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685099080;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=wgyIoCNWZvw+rC0orS/8VWQjklvhmJzIJyLFG15dXg8=;
	b=L+G1cL+KWyAKo+E99GBTmIyRj6yk63LDHJd+OgBQ5O0XkET51YkxWss99smY2Awy2iDHbk
	2qXkcMxglEeziUf74vaHBft9sE06UTBs9sPuDkm3+kNNtOY6x5oYdZR0DQm1llzaH4deMf
	z1f47GD9tpKiOzRYwg0z2csvX0zLAuY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-LHP0F6qqNoy5zYbaWhTaXw-1; Fri, 26 May 2023 07:04:39 -0400
X-MC-Unique: LHP0F6qqNoy5zYbaWhTaXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3BBA3C397D3;
	Fri, 26 May 2023 11:04:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C53801121314;
	Fri, 26 May 2023 11:04:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4A4D319465A4;
	Fri, 26 May 2023 11:04:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 39CCB19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 11:04:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A1F740C6CCF; Fri, 26 May 2023 11:04:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21D0B400E118
 for <dm-devel@redhat.com>; Fri, 26 May 2023 11:04:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F20BE185A78B
 for <dm-devel@redhat.com>; Fri, 26 May 2023 11:04:04 +0000 (UTC)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-Y3i_YFhaOWewF_bqqKyG_g-1; Fri, 26 May 2023 07:04:03 -0400
X-MC-Unique: Y3i_YFhaOWewF_bqqKyG_g-1
Received: by mail-wr1-f69.google.com with SMTP id
 ffacd0b85a97d-3094b683f3dso260801f8f.1
 for <dm-devel@redhat.com>; Fri, 26 May 2023 04:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685099042; x=1687691042;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=X5jnHbGg+n7ue4t28snD5OcG6hjYvFod5Lt08q2SiJM=;
 b=H9SDGKTZ0DhlUkz5At+XNS8idzmu+8qESSjmawWGMv9HIw7REqJEWirVkF9iRZPxQK
 UkTyAQC08fvsmFPowOh+BEedQzZegPgd65M+wZF+OvlWjUT5zxWmdJ61vePHaapxm2wr
 E8Akywf+jEsr4rFsaOE7gvdaA5xxI7KMkaVjDX12CpceWJuRaFhlqNzrLlmoosHGPEQb
 /gPz4ErDydz9398xUl4ZVDCPIs8MFAgnERAf10RQBAQtcJ4XWzeElpjmEecSLtEiB1U9
 VxaQ5yTfrn/Fz3RI1qPXpC2I5S0N1Ie6qTgnlxWYnxAyhVa89yrYzAV1CZ7CFNwzJ3VM
 /XWA==
X-Gm-Message-State: AC+VfDwTYSf95Jja8/F1q4hyxMolmuOoBGl4b+a8n5ZJdBjsEIsQ26Sd
 dM3gF8k8SjxsXMmWeg/iliivFO+PeBSIpj0zExidvG2J32oaIGp1e+boYULjv1B886xXmPpRNoo
 ufELcdlLLK6H7QTY4+0608KRLo+D1t2o=
X-Received: by 2002:a5d:6d51:0:b0:2dc:c0da:409 with SMTP id
 k17-20020a5d6d51000000b002dcc0da0409mr1173259wri.27.1685099042092; 
 Fri, 26 May 2023 04:04:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5lPrEXu08UiE7wb8SHmoVSq131sT0+lbs0f25QrPp1FsTRvm10PehLPA7ZYAHZ0H8fNvyyZmqk7+vzeROzOoc=
X-Received: by 2002:a5d:6d51:0:b0:2dc:c0da:409 with SMTP id
 k17-20020a5d6d51000000b002dcc0da0409mr1173236wri.27.1685099041624; Fri, 26
 May 2023 04:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <ZGb2Xi6O3i2pLam8@infradead.org> <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area> <ZGu0LaQfREvOQO4h@redhat.com>
 <ZGzIJlCE2pcqQRFJ@bfoster> <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area>
 <ZG+KoxDMeyogq4J0@bfoster> <ZHB954zGG1ag0E/t@dread.disaster.area>
In-Reply-To: <ZHB954zGG1ag0E/t@dread.disaster.area>
From: Joe Thornber <thornber@redhat.com>
Date: Fri, 26 May 2023 12:04:02 +0100
Message-ID: <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Joe Thornber <ejt@redhat.com>, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7776123176921165008=="

--===============7776123176921165008==
Content-Type: multipart/alternative; boundary="000000000000c9a83605fc96b132"

--000000000000c9a83605fc96b132
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here's my take:

I don't see why the filesystem cares if thinp is doing a reservation or
provisioning under the hood.  All that matters is that a future write
to that region will be honoured (barring device failure etc.).

I agree that the reservation/force mapped status needs to be inherited
by snapshots.


One of the few strengths of thinp is the performance of taking a snapshot.
Most snapshots created are never activated.  Many other snapshots are
only alive for a brief period, and used read-only.  eg, blk-archive
(https://github.com/jthornber/blk-archive) uses snapshots to do very
fast incremental backups.  As such I'm strongly against any scheme that
requires provisioning as part of the snapshot operation.

Hank and I are in the middle of the range tree work which requires a
metadata
change.  So now is a convenient time to piggyback other metadata changes to
support reservations.


Given the above this is what I suggest:

1) We have an api (ioctl, bio flag, whatever) that lets you
reserve/guarantee a region:

  int reserve_region(dev, sector_t begin, sector_t end);

  This api should be used minimally, eg, critical FS metadata only.

2) Each thinp device will gain two extra fields in the metadata:

  - Total reserved (TR)
  - reserved actually provisioned (RAP)

  The difference between these two is the amount of space we need to
guarantee
  for this device.

3) Each individual mapping for a device will gain a flag indicating if it's
'reserved'.
   We will need to support 'reserved but unmapped' mappings.  There are
   two provisioning events:

  - unmapped but reserved -> mapped reserved.  Initial provision, RAP
incremented.
  - mapped and reserved -> ie. break sharing after snapshot.  Again RAP
incremented.

4) When a snapshot is taken:
  - Reset RAP to zero for origin
  - New snap has Total reserved set to that of origin, RAP <- 0
  - All mappings are shared, so the reserved flags for each mapping is
preserved
  - Only allow snapshot if there is enough free space for the new reserve
pool.


5) Reserve for the whole pool is the sum of (TR - RAP) for all devices.
This pool
   can only be touched if we're provisioning for a reserved mapping.

One drawback with this scheme is the double accounting due to RAP being
reset to zero for the origin device.  This comes about because after the
snapshot operation the two devices are equal, no sense of which device
is the origin is preserved or needed.  So a write to a given block
will trigger provisioning on whichever device it is written to first.
A later write to the other device will not trigger a provision.  I think
this problem can be solved without too much complexity.


Now this is a lot of work.  As well as the kernel changes we'll need to
update the userland tools: thin_check, thin_ls, thin_metadata_unpack,
thin_rmap, thin_delta, thin_metadata_pack, thin_repair, thin_trim,
thin_dump, thin_metadata_size, thin_restore.  Are we confident that we
have buy in from the FS teams that this will be widely adopted?  Are users
asking for this?  I really don't want to do 6 months of work for nothing.

- Joe

On Fri, May 26, 2023 at 10:37=E2=80=AFAM Dave Chinner <david@fromorbit.com>=
 wrote:

> On Thu, May 25, 2023 at 12:19:47PM -0400, Brian Foster wrote:
> > On Wed, May 24, 2023 at 10:40:34AM +1000, Dave Chinner wrote:
> > > On Tue, May 23, 2023 at 11:26:18AM -0400, Mike Snitzer wrote:
> > > > On Tue, May 23 2023 at 10:05P -0400, Brian Foster <
> bfoster@redhat.com> wrote:
> > > > > On Mon, May 22, 2023 at 02:27:57PM -0400, Mike Snitzer wrote:
> > > > > ... since I also happen to think there is a potentially interesti=
ng
> > > > > development path to make this sort of reserve pool configurable i=
n
> terms
> > > > > of size and active/inactive state, which would allow the fs to us=
e
> an
> > > > > emergency pool scheme for managing metadata provisioning and not
> have to
> > > > > track and provision individual metadata buffers at all (dealing
> with
> > > > > user data is much easier to provision explicitly). So the space
> > > > > inefficiency thing is potentially just a tradeoff for simplicity,
> and
> > > > > filesystems that want more granularity for better behavior could
> achieve
> > > > > that with more work. Filesystems that don't would be free to rely
> on the
> > > > > simple/basic mechanism provided by dm-thin and still have basic
> -ENOSPC
> > > > > protection with very minimal changes.
> > > > >
> > > > > That's getting too far into the weeds on the future bits, though.
> This
> > > > > is essentially 99% a dm-thin approach, so I'm mainly curious if
> there's
> > > > > sufficient interest in this sort of "reserve mode" approach to tr=
y
> and
> > > > > clean it up further and have dm guys look at it, or if you guys
> see any
> > > > > obvious issues in what it does that makes it potentially
> problematic, or
> > > > > if you would just prefer to go down the path described above...
> > > >
> > > > The model that Dave detailed, which builds on REQ_PROVISION and is
> > > > sticky (by provisioning same blocks for snapshot) seems more useful
> to
> > > > me because it is quite precise.  That said, it doesn't account for
> > > > hard requirements that _all_ blocks will always succeed.
> > >
> > > Hmmm. Maybe I'm misunderstanding the "reserve pool" context here,
> > > but I don't think we'd ever need a hard guarantee from the block
> > > device that every write bio issued from the filesystem will succeed
> > > without ENOSPC.
> > >
> >
> > The bigger picture goal that I didn't get into in my previous mail is
> > the "full device" reservation model is intended to be a simple, crude
> > reference implementation that can be enabled for any arbitrary thin
> > volume consumer (filesystem or application). The idea is to build that
> > on a simple enough reservation mechanism that any such consumer could
> > override it based on its own operational model. The goal is to guarante=
e
> > that a particular filesystem never receives -ENOSPC from dm-thin on
> > writes, but the first phase of implementing that is to simply guarantee
> > every block is writeable.
> >
> > As a specific filesystem is able to more explicitly provision its own
> > allocations in a way that it can guarantee to return -ENOSPC from
> > dm-thin up front (rather than at write bio time), it can reduce the nee=
d
> > for the amount of reservation required, ultimately to zero if that
> > filesystem provides the ability to pre-provision all of its writes to
> > storage in some way or another.
> >
> > I think for filesystems with complex metadata management like XFS, it's
> > not very realistic to expect explicit 1-1 provisioning for all metadata
> > changes on a per-transaction basis in the same way that can (fairly
> > easily) be done for data, which means a pool mechanism is probably stil=
l
> > needed for the metadata class of writes.
>
> I'm trying to avoid need for 1-1 provisioning and the need for a
> accounting based reservation pool approach. I've tried the
> reservation pool thing several times, and they've all collapsed
> under the complexity of behaviour guarantees under worst case write
> amplification situations.
>
> The whole point of the LBA provisioning approach is that it
> completely avoids the need to care about write amplification because
> the underlying device guarantees any write to a LBA that is
> provisioned will succeed. It takes care of the write amplification
> problem for us, and we can make it even easier for the backing
> device by aligning LBA range provision requests to device region
> sizes.
>
> > > If the block device can provide a guarantee that a provisioned LBA
> > > range is always writable, then everything else is a filesystem level
> > > optimisation problem and we don't have to involve the block device
> > > in any way. All we need is a flag we can ready out of the bdev at
> > > mount time to determine if the filesystem should be operating with
> > > LBA provisioning enabled...
> > >
> > > e.g. If we need to "pre-provision" a chunk of the LBA space for
> > > filesystem metadata, we can do that ahead of time and track the
> > > pre-provisioned range(s) in the filesystem itself.
> > >
> > > In XFS, That could be as simple as having small chunks of each AG
> > > reserved to metadata (e.g. start with the first 100MB) and limiting
> > > all metadata allocation free space searches to that specific block
> > > range. When we run low on that space, we pre-provision another 100MB
> > > chunk and then allocate all metadata out of that new range. If we
> > > start getting ENOSPC to pre-provisioning, then we reduce the size of
> > > the regions and log low space warnings to userspace. If we can't
> > > pre-provision any space at all and we've completely run out, we
> > > simply declare ENOSPC for all incoming operations that require
> > > metadata allocation until pre-provisioning succeeds again.
> > >
> >
> > The more interesting aspect of this is not so much how space is
> > provisioned and allocated, but how the filesystem is going to consume
> > that space in a way that guarantees -ENOSPC is provided up front before
> > userspace is allowed to make modifications.
>
> Yeah, that's trivial with REQ_PROVISION.
>
> If, at transaction reservation time, we don't have enough
> provisioned metadata space available for the potential allocations
> we'll need to make, we kick provisioning work off wait for more to
> come available. If that fails and none is available, we'll get an
> enospc error right there, same as if the filesystem itself has no
> blocks available for allocation.
>
> This is no different to, say, having xfs_create() fail reservation
> because ENOSPC, then calling xfs_flush_inodes() to kick off an inode
> cache walk to trim away all the unused post-eof allocations in
> memory to free up some space we can use. When that completes,
> we try the reservation again.
>
> There's no new behaviours we need to introduce here - it's just
> replication of existing behaviours and infrastructure.
>
> > You didn't really touch on
> > that here, so I'm going to assume we'd have something like a perag
> > counter of how many free blocks currently live in preprovisioned ranges=
,
> > and then an fs-wide total somewhere so a transaction has the ability to
> > consume these blocks at trans reservation time, the fs knows when to
> > preprovision more space (or go into -ENOSPC mode), etc.
>
> Sure, something like that. Those are all implementation details, and
> not really that complex to implement and is largely replication of
> reservation infrastructure we already have.
>
> > Some accounting of that nature is necessary here in order to prevent th=
e
> > filesystem from ever writing to unprovisioned space. So what I was
> > envisioning is rather than explicitly preprovision a physical range of
> > each AG and tracking all that, just reserve that number of arbitrarily
> > located blocks from dm for each AG.
> >
> > The initial perag reservations can be populated at mount time,
> > replenished as needed in a very similar way as what you describe, and
> > 100% released back to the thin pool at unmount time. On top of that,
> > there's no need to track physical preprovisioned ranges at all. Not jus=
t
> > for allocation purposes, but also to avoid things like having to protec=
t
> > background trims from preprovisioned ranges of free space dedicated for
> > metadata, etc.
>
> That's all well and good, but reading further down the email the
> breadth and depth of changes to filesystem and block device
> behaviour to enable this are ... significant.
>
> > > Further, managing shared pool exhaustion doesn't require a
> > > reservation pool in the backing device and for the filesystems to
> > > request space from it. Filesystems already have their own reserve
> > > pools via pre-provisioning. If we want the filesystems to be able to
> > > release that space back to the shared pool (e.g. because the shared
> > > backing pool is critically short on space) then all we need is an
> > > extension to FITRIM to tell the filesystem to also release internal
> > > pre-provisioned reserves.
> > >
> > > Then the backing pool admin (person or automated daemon!) can simply
> > > issue a trim on all the filesystems in the pool and spce will be
> > > returned. Then filesystems will ask for new pre-provisioned space
> > > when they next need to ingest modifications, and the backing pool
> > > can manage the new pre-provisioning space requests directly....
> > >
> >
> > This is written as to imply that the reservation pool is some big
> > complex thing, which makes me think there is some
> > confusion/miscommunication.
>
> No confusion, I'm just sceptical that it will work given my
> experience trying to implement reservation based solutions multiple
> different ways over the past decade. They've all failed because
> they collapse under either the complexity explosion or space
> overhead required to handle the worst case behavioural scenarios.
>
> At one point I calculated the worst case reservation needed ensure
> log recovery will always succeeded, ignoring write amplification,
> was about 16x the size of the log. If I took write amplification for
> dm-thinp having 64kB blocks and each inode hitting a different
> cluster in it's own dm thinp block, that write amplication hit 64x.
>
> So for recovering a 2GB log, if dm-thinp doesn't have a reserve of
> well over 100GB of pool space, there is no guarantee that log
> recovery will -always- succeed.
>
> It's worst case numbers like this which made me conclude that
> reservation based approaches cannot provide guarantees that ENOSPC
> will never occur. The numbers are just too large when you start
> considering journals that can hold a million dirty objects,
> intent chains that might require modifying hundreds of metadata
> blocks across a dozen transactions before they complete, etc.
>
> OTOH, REQ_PROVISION makes this "log recovery needs new space to be
> allocated" problem go away entirely. It provides a mechanism that
> ensures log recovery does not consume any new space in the backing
> pool as all the overwrites it performs are to previously provisioned
> metadata.....
>
> This is just one of the many reasons why I think the REQ_PROVISION
> method is far better than reservations - it solves problems that
> pure runtime reservations can't.
>
> > It's basically just an in memory counter of
> > space that is allocated out of a shared thin pool and is held in a
> > specific thin volume while it is currently in use. The counter on the
> > volume is managed indirectly by filesystem requests and/or direct
> > operations on the volume (like dm snapshots).
> >
> > Sure, you could replace the counter and reservation interface with
> > explicitly provisioned/trimmed LBA ranges that the fs can manage to
> > provide -ENOSPC guarantees, but then the fs has to do those various
> > things you've mentioned:
> >
> > - Provision those ranges in the fs and change allocation behavior
> >   accordingly.
>
> This is relatively simple - most of the allocator functionality is
> already there.
>
> > - Do the background post-crash fitrim preprovision clean up thing.
>
> We've already decided this is not needed.
>
> > - Distinguish between trims that are intended to return preprovisioned
> >   space vs. those that come from userspace.
>
> It's about ten lines of code in xfs_trim_extents() to do this.  i.e.
> the free space tree walk simply skips over free extents in the
> metadata provisioned region based on a flag value.
>
> > - Have some daemon or whatever (?) responsible for communicating the
> >   need for trims in the fs to return space back to the pool.
>
> Systems are already configured to run a periodic fstrim passes to do
> this via systemd units. And I'm pretty sure dm-thinp has a low space
> notification to userspace (via dbus?) that is already used by
> userspace agents to handle "near ENOSPC" events automatically.
>
> > Then this still depends on changing how dm thin snapshots work and need=
s
> > a way to deal with delayed allocation to actually guarantee -ENOSPC
> > protection..?
>
> I think you misunderstand: I'm not proposing to use REQ_PROVISION
> for writes the filesystem does not guarantee will succeed. Never
> have, I think it makes no sense at all.  If the filesystem
> can return ENOSPC for an unprovisioned user data write, then the
> block device can too.
>
> > > Hence I think if we get the basic REQ_PROVISION overwrite-in-place
> > > guarantees defined and implemented as previously outlined, then we
> > > don't need any special coordination between the fs and block devices
> > > to avoid fatal ENOSPC issues with sparse and/or snapshot capable
> > > block devices...
> > >
> >
> > This all sounds like a good amount of coordination and unnecessary
> > complexity to me. What I was thinking as a next phase (i.e. after
> > initial phase full device reservation) approach for a filesystem like
> > XFS would be something like this.
> >
> > - Support a mount option for a configurable size metadata reservation
> >   pool (with sane/conservative default).
>
> I want this to all to work without the user having be aware that
> there filesystem is running on a sparse device.
>
> > - The pool is populated at mount time, else the fs goes right into
> >   simulated -ENOSPC mode.
>
> What are the rules of this mode?
>
> Hmmmm.
>
> Log recovery needs to be able to allocate new metadata (i.e. in
> intent replay), so I'm guessing reservation is needed before log
> recovery? But if pool reservation fails, how do we then safely
> perform log recovery given the filesystem is in ENOSPC mode?
>
> > - Thin pool reservation consumption is controlled by a flag on write
> >   bios that is managed by the fs (flag polarity TBD).
>
> So we still need a bio flag to communicate "this IO consumes
> reservation".
>
> What are the semantics of this flag?  What happens on submission
> error? e.g. the bio is failed before it gets to the layer that
> consumes it - how does the filesystem know that reservation was
> consumed or not at completion?
>
> How do we know when to set it for user data writes?
>
> What happens if the device recieves a bio with this flag but there
> is no reservation remaining? e.g. the filesystem or device
> accounting have got out of whack?
>
> Hmmm. On that note, what about write amplification? Or should I call
> it "reservation amplification". i.e. a 4kB bio with a "consume
> reservation" flag might trigger a dm-region COW or allocation and
> require 512kB of dm-thinp pool space to be allocated. How much
> reservation actually gets consumed, and how do we reconcile the
> differences in physical consumption vs reservation consumption?
>
> > - All fs data writes are explicitly reserved up front in the write path=
.
> >   Delalloc maps to explicit reservation, overwrites are easy and just
> >   involve an explicit provision.
>
> This is the first you've mentioned an "explicit provision"
> operation. Is this like REQ_PROVISION, or something else?
>
> This seems to imply that the ->iomap_begin method has to do
> explicit provisioning callouts when we get a write that lands in an
> IOMAP_MAPPED extent? Or something else?
>
> Can you describe this mechanism in more detail?
>
> > - Metadata writes are not reserved or provisioned at all. They allocate
> >   out of the thin pool on write (if needed), just as they do today. On
> >   an -ENOSPC metadata write error, the fs goes into simulated -ENOSPC
> mode
> >   and allows outstanding metadata writes to now use the bio flag to
> >   consume emergency reservation.
>
> Okay. We need two pools in the backing device? The normal free space
> pool, and an emergency reservation pool?
>
> Without reading further, this implies that the filesystem is
> reliant on the emergency reservation pool being large enough that
> it can write any dirty metadata it has outstanding without ENOSPC
> occuring. How does the size of this emergency pool get configured?
>
> > So this means that metadata -ENOSPC protection is only as reliable as
> > the size of the specified pool. This is by design, so the filesystem
> > still does not have to track provisioning, allocation or overwrites of
> > its own metadata usage. Users with metadata heavy workloads or who
> > happen to be sensitive to -ENOSPC errors can be more aggressive with
> > pool size, while other users might be able to get away with a smaller
> > pool. Users who are super paranoid and want perfection can continue to
> > reserve the entire device and pay for the extra storage.
>
> Oh. Hand tuning. :(
>
> > Users who are not sure can test their workload in an appropriate
> > environment, collect some data/metrics on maximum outstanding dirty
> > metadata, and then use that as a baseline/minimum pool size for reliabl=
e
> > behavior going forward.  This is also where something like Stratis can
> > come in to generate this sort of information, make recommendations or
> > implement heuristics (based on things like fs size, amount of RAM, for
> > e.g.) to provide sane defaults based on use case. I.e., this is
> > initially exposed as a userspace/tuning issue instead of a
> > filesystem/dm-thin hard guarantee.
>
> Which are the same things people have been complaining about for years.
>
> > Finally, if you really want to get to that last step of maximally
> > efficient and safe provisioning in the fs, implement a
> > 'thinreserve=3Dadaptive' mode in the fs that alters the acquisition and
> > consumption of dm-thin reserved blocks to be adaptive in nature and
> > promises to do it's own usage throttling against outstanding
> > reservation. I think this is the mode that most closely resembles your
> > preprovisioned range mechanism.
> >
> > For example, adaptive mode could add the logic/complexity where you do
> > the per-ag provision thing (just using reservation instead of physical
> > ranges), change the transaction path to attempt to increase the
> > reservation pool or go into -ENOSPC mode, and flag all writes to be
> > satisfied from the reserve pool (because you've done the
> > provision/reservation up front).
>
> Ok, so why not just go straight to this model using REQ_PROVISION?
>
> If we then want to move to a different "accounting only" model for
> provisioning, we just change REQ_PROVISION?
>
> But I still see the problem of write amplification accounting being
> unsolved by the "filesystem accounting only" approach advocated
> here.  We have no idea when the backing device has snapshots taken,
> we have no idea when a filesystem write IO actually consumes more
> thinp blocks than filesystem blocks, etc.  How does the filesystem
> level reservation pool address these problems?
>
> > Thoughts on any of the above?
>
> I'd say it went wrong at the requirements stage, resulting in an
> overly complex, over-engineered solution.
>
> > One general tradeoff with using reservations vs. preprovisioning is the
> > the latter can just use the provision/trim primitives to alloc/free LBA
> > ranges. My thought on that is those primitives could possibly be
> > modified to do the same sort of things with reservation as for physical
> > allocations. That seems fairly easy to do with bio op flags/modifiers,
> > though one thing I'm not sure about is how to submit a provision bio to
> > request a certain amount location agnostic blocks. I'd have to
> > investigate that more.
>
> Sure, if the constrained LBA space aspect of the REQ_PROVISION
> implementation causes issues, then we see if we can optimise away
> the fixed LBA space requirement.
>
>
> --
> Dave Chinner
> david@fromorbit.com
>
>

--000000000000c9a83605fc96b132
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Here&#39;s my take:<br><br>I don&#39;t see why the filesys=
tem cares if thinp is doing a reservation or<br>provisioning under the hood=
.=C2=A0 All that matters is that a future write<br>to that region will be h=
onoured (barring device failure etc.).<br><br>I agree that the reservation/=
force mapped status needs to be inherited<br>by snapshots.<br><br><br>One o=
f the few strengths of thinp is the performance of taking a snapshot.<br>Mo=
st snapshots created are never activated.=C2=A0 Many other snapshots are<br=
>only alive for a brief period, and used read-only. =C2=A0eg, blk-archive<b=
r>(<a href=3D"https://github.com/jthornber/blk-archive">https://github.com/=
jthornber/blk-archive</a>) uses snapshots to do very<br>fast incremental ba=
ckups.=C2=A0 As such I&#39;m strongly against any scheme that<br>requires p=
rovisioning as part of the snapshot operation.<br><br>Hank and I are in the=
 middle of the range tree work which requires a metadata<br>change.=C2=A0 S=
o now is a convenient time to piggyback other metadata changes to<br>suppor=
t reservations.<br><br><br>Given the above this is what I suggest:<br><br>1=
) We have an api (ioctl, bio flag, whatever) that lets you reserve/guarante=
e a region:<br><br>=C2=A0 int reserve_region(dev, sector_t begin, sector_t =
end);<br><br>=C2=A0 This api should be used minimally, eg, critical FS meta=
data only.<br><br>2) Each thinp device will gain two extra fields in the me=
tadata:<br><br>=C2=A0 - Total reserved (TR)<br>=C2=A0 - reserved actually p=
rovisioned (RAP)<br><br>=C2=A0 The difference between these two is the amou=
nt of space we need to guarantee<br>=C2=A0 for this device.<br><br>3) Each =
individual mapping for a device will gain a flag indicating if it&#39;s &#3=
9;reserved&#39;.<br>=C2=A0 =C2=A0We will need to support &#39;reserved but =
unmapped&#39; mappings.=C2=A0 There are<br>=C2=A0 =C2=A0two provisioning ev=
ents:<br><br>=C2=A0 - unmapped but reserved -&gt; mapped reserved.=C2=A0 In=
itial provision, RAP incremented.<br>=C2=A0 - mapped and reserved -&gt; ie.=
 break sharing after snapshot.=C2=A0 Again RAP incremented.<br><br>4) When =
a snapshot is taken:<br>=C2=A0 - Reset RAP to zero for origin<br>=C2=A0 - N=
ew snap has Total reserved set to that of origin, RAP &lt;- 0<br>=C2=A0 - A=
ll mappings are shared, so the reserved flags for each mapping is preserved=
<br>=C2=A0 - Only allow snapshot if there is enough free space for the new =
reserve pool.<br><div><br></div><div><br>5) Reserve for the whole pool is t=
he sum of (TR - RAP) for all devices.=C2=A0 This pool<br>=C2=A0 =C2=A0can o=
nly be touched if we&#39;re provisioning for a reserved mapping.<br><br>One=
 drawback with this scheme is the double accounting due to RAP being<br>res=
et to zero for the origin device.=C2=A0 This comes about because after the<=
br>snapshot operation the two devices are equal, no sense of which device<b=
r>is the origin is preserved or needed.=C2=A0 So a write to a given block<b=
r>will trigger provisioning on whichever device it is written to first.<br>=
A later write to the other device will not trigger a provision.=C2=A0 I thi=
nk<br>this problem can be solved without too much complexity.<br><br><br>No=
w this is a lot of work.=C2=A0 As well as the kernel changes we&#39;ll need=
 to<br>update the userland tools: thin_check, thin_ls, thin_metadata_unpack=
,<br>thin_rmap, thin_delta, thin_metadata_pack, thin_repair, thin_trim,<br>=
thin_dump, thin_metadata_size, thin_restore.=C2=A0 Are we confident that we=
<br>have buy in from the FS teams that this will be widely adopted?=C2=A0 A=
re users<br>asking for this?=C2=A0 I really don&#39;t want to do 6 months o=
f work for nothing.<br><br>- Joe<br></div></div><br><div class=3D"gmail_quo=
te"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, May 26, 2023 at 10:37=E2=
=80=AFAM Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.com">david@from=
orbit.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">On Thu, May 25, 2023 at 12:19:47PM -0400, Brian Foster wrote:<br=
>
&gt; On Wed, May 24, 2023 at 10:40:34AM +1000, Dave Chinner wrote:<br>
&gt; &gt; On Tue, May 23, 2023 at 11:26:18AM -0400, Mike Snitzer wrote:<br>
&gt; &gt; &gt; On Tue, May 23 2023 at 10:05P -0400, Brian Foster &lt;<a hre=
f=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt=
; wrote:<br>
&gt; &gt; &gt; &gt; On Mon, May 22, 2023 at 02:27:57PM -0400, Mike Snitzer =
wrote:<br>
&gt; &gt; &gt; &gt; ... since I also happen to think there is a potentially=
 interesting<br>
&gt; &gt; &gt; &gt; development path to make this sort of reserve pool conf=
igurable in terms<br>
&gt; &gt; &gt; &gt; of size and active/inactive state, which would allow th=
e fs to use an<br>
&gt; &gt; &gt; &gt; emergency pool scheme for managing metadata provisionin=
g and not have to<br>
&gt; &gt; &gt; &gt; track and provision individual metadata buffers at all =
(dealing with<br>
&gt; &gt; &gt; &gt; user data is much easier to provision explicitly). So t=
he space<br>
&gt; &gt; &gt; &gt; inefficiency thing is potentially just a tradeoff for s=
implicity, and<br>
&gt; &gt; &gt; &gt; filesystems that want more granularity for better behav=
ior could achieve<br>
&gt; &gt; &gt; &gt; that with more work. Filesystems that don&#39;t would b=
e free to rely on the<br>
&gt; &gt; &gt; &gt; simple/basic mechanism provided by dm-thin and still ha=
ve basic -ENOSPC<br>
&gt; &gt; &gt; &gt; protection with very minimal changes.<br>
&gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; That&#39;s getting too far into the weeds on the future=
 bits, though. This<br>
&gt; &gt; &gt; &gt; is essentially 99% a dm-thin approach, so I&#39;m mainl=
y curious if there&#39;s<br>
&gt; &gt; &gt; &gt; sufficient interest in this sort of &quot;reserve mode&=
quot; approach to try and<br>
&gt; &gt; &gt; &gt; clean it up further and have dm guys look at it, or if =
you guys see any<br>
&gt; &gt; &gt; &gt; obvious issues in what it does that makes it potentiall=
y problematic, or<br>
&gt; &gt; &gt; &gt; if you would just prefer to go down the path described =
above...<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; The model that Dave detailed, which builds on REQ_PROVISION =
and is<br>
&gt; &gt; &gt; sticky (by provisioning same blocks for snapshot) seems more=
 useful to<br>
&gt; &gt; &gt; me because it is quite precise.=C2=A0 That said, it doesn&#3=
9;t account for<br>
&gt; &gt; &gt; hard requirements that _all_ blocks will always succeed.<br>
&gt; &gt; <br>
&gt; &gt; Hmmm. Maybe I&#39;m misunderstanding the &quot;reserve pool&quot;=
 context here,<br>
&gt; &gt; but I don&#39;t think we&#39;d ever need a hard guarantee from th=
e block<br>
&gt; &gt; device that every write bio issued from the filesystem will succe=
ed<br>
&gt; &gt; without ENOSPC.<br>
&gt; &gt; <br>
&gt; <br>
&gt; The bigger picture goal that I didn&#39;t get into in my previous mail=
 is<br>
&gt; the &quot;full device&quot; reservation model is intended to be a simp=
le, crude<br>
&gt; reference implementation that can be enabled for any arbitrary thin<br=
>
&gt; volume consumer (filesystem or application). The idea is to build that=
<br>
&gt; on a simple enough reservation mechanism that any such consumer could<=
br>
&gt; override it based on its own operational model. The goal is to guarant=
ee<br>
&gt; that a particular filesystem never receives -ENOSPC from dm-thin on<br=
>
&gt; writes, but the first phase of implementing that is to simply guarante=
e<br>
&gt; every block is writeable.<br>
&gt; <br>
&gt; As a specific filesystem is able to more explicitly provision its own<=
br>
&gt; allocations in a way that it can guarantee to return -ENOSPC from<br>
&gt; dm-thin up front (rather than at write bio time), it can reduce the ne=
ed<br>
&gt; for the amount of reservation required, ultimately to zero if that<br>
&gt; filesystem provides the ability to pre-provision all of its writes to<=
br>
&gt; storage in some way or another.<br>
&gt; <br>
&gt; I think for filesystems with complex metadata management like XFS, it&=
#39;s<br>
&gt; not very realistic to expect explicit 1-1 provisioning for all metadat=
a<br>
&gt; changes on a per-transaction basis in the same way that can (fairly<br=
>
&gt; easily) be done for data, which means a pool mechanism is probably sti=
ll<br>
&gt; needed for the metadata class of writes.<br>
<br>
I&#39;m trying to avoid need for 1-1 provisioning and the need for a<br>
accounting based reservation pool approach. I&#39;ve tried the<br>
reservation pool thing several times, and they&#39;ve all collapsed<br>
under the complexity of behaviour guarantees under worst case write<br>
amplification situations.<br>
<br>
The whole point of the LBA provisioning approach is that it<br>
completely avoids the need to care about write amplification because<br>
the underlying device guarantees any write to a LBA that is<br>
provisioned will succeed. It takes care of the write amplification<br>
problem for us, and we can make it even easier for the backing<br>
device by aligning LBA range provision requests to device region<br>
sizes.<br>
<br>
&gt; &gt; If the block device can provide a guarantee that a provisioned LB=
A<br>
&gt; &gt; range is always writable, then everything else is a filesystem le=
vel<br>
&gt; &gt; optimisation problem and we don&#39;t have to involve the block d=
evice<br>
&gt; &gt; in any way. All we need is a flag we can ready out of the bdev at=
<br>
&gt; &gt; mount time to determine if the filesystem should be operating wit=
h<br>
&gt; &gt; LBA provisioning enabled...<br>
&gt; &gt; <br>
&gt; &gt; e.g. If we need to &quot;pre-provision&quot; a chunk of the LBA s=
pace for<br>
&gt; &gt; filesystem metadata, we can do that ahead of time and track the<b=
r>
&gt; &gt; pre-provisioned range(s) in the filesystem itself.<br>
&gt; &gt; <br>
&gt; &gt; In XFS, That could be as simple as having small chunks of each AG=
<br>
&gt; &gt; reserved to metadata (e.g. start with the first 100MB) and limiti=
ng<br>
&gt; &gt; all metadata allocation free space searches to that specific bloc=
k<br>
&gt; &gt; range. When we run low on that space, we pre-provision another 10=
0MB<br>
&gt; &gt; chunk and then allocate all metadata out of that new range. If we=
<br>
&gt; &gt; start getting ENOSPC to pre-provisioning, then we reduce the size=
 of<br>
&gt; &gt; the regions and log low space warnings to userspace. If we can&#3=
9;t<br>
&gt; &gt; pre-provision any space at all and we&#39;ve completely run out, =
we<br>
&gt; &gt; simply declare ENOSPC for all incoming operations that require<br=
>
&gt; &gt; metadata allocation until pre-provisioning succeeds again.<br>
&gt; &gt; <br>
&gt; <br>
&gt; The more interesting aspect of this is not so much how space is<br>
&gt; provisioned and allocated, but how the filesystem is going to consume<=
br>
&gt; that space in a way that guarantees -ENOSPC is provided up front befor=
e<br>
&gt; userspace is allowed to make modifications.<br>
<br>
Yeah, that&#39;s trivial with REQ_PROVISION.<br>
<br>
If, at transaction reservation time, we don&#39;t have enough<br>
provisioned metadata space available for the potential allocations<br>
we&#39;ll need to make, we kick provisioning work off wait for more to<br>
come available. If that fails and none is available, we&#39;ll get an<br>
enospc error right there, same as if the filesystem itself has no<br>
blocks available for allocation.<br>
<br>
This is no different to, say, having xfs_create() fail reservation<br>
because ENOSPC, then calling xfs_flush_inodes() to kick off an inode<br>
cache walk to trim away all the unused post-eof allocations in<br>
memory to free up some space we can use. When that completes,<br>
we try the reservation again.<br>
<br>
There&#39;s no new behaviours we need to introduce here - it&#39;s just<br>
replication of existing behaviours and infrastructure.<br>
<br>
&gt; You didn&#39;t really touch on<br>
&gt; that here, so I&#39;m going to assume we&#39;d have something like a p=
erag<br>
&gt; counter of how many free blocks currently live in preprovisioned range=
s,<br>
&gt; and then an fs-wide total somewhere so a transaction has the ability t=
o<br>
&gt; consume these blocks at trans reservation time, the fs knows when to<b=
r>
&gt; preprovision more space (or go into -ENOSPC mode), etc.<br>
<br>
Sure, something like that. Those are all implementation details, and<br>
not really that complex to implement and is largely replication of<br>
reservation infrastructure we already have.<br>
<br>
&gt; Some accounting of that nature is necessary here in order to prevent t=
he<br>
&gt; filesystem from ever writing to unprovisioned space. So what I was<br>
&gt; envisioning is rather than explicitly preprovision a physical range of=
<br>
&gt; each AG and tracking all that, just reserve that number of arbitrarily=
<br>
&gt; located blocks from dm for each AG.<br>
&gt; <br>
&gt; The initial perag reservations can be populated at mount time,<br>
&gt; replenished as needed in a very similar way as what you describe, and<=
br>
&gt; 100% released back to the thin pool at unmount time. On top of that,<b=
r>
&gt; there&#39;s no need to track physical preprovisioned ranges at all. No=
t just<br>
&gt; for allocation purposes, but also to avoid things like having to prote=
ct<br>
&gt; background trims from preprovisioned ranges of free space dedicated fo=
r<br>
&gt; metadata, etc. <br>
<br>
That&#39;s all well and good, but reading further down the email the<br>
breadth and depth of changes to filesystem and block device<br>
behaviour to enable this are ... significant.<br>
<br>
&gt; &gt; Further, managing shared pool exhaustion doesn&#39;t require a<br=
>
&gt; &gt; reservation pool in the backing device and for the filesystems to=
<br>
&gt; &gt; request space from it. Filesystems already have their own reserve=
<br>
&gt; &gt; pools via pre-provisioning. If we want the filesystems to be able=
 to<br>
&gt; &gt; release that space back to the shared pool (e.g. because the shar=
ed<br>
&gt; &gt; backing pool is critically short on space) then all we need is an=
<br>
&gt; &gt; extension to FITRIM to tell the filesystem to also release intern=
al<br>
&gt; &gt; pre-provisioned reserves.<br>
&gt; &gt; <br>
&gt; &gt; Then the backing pool admin (person or automated daemon!) can sim=
ply<br>
&gt; &gt; issue a trim on all the filesystems in the pool and spce will be<=
br>
&gt; &gt; returned. Then filesystems will ask for new pre-provisioned space=
<br>
&gt; &gt; when they next need to ingest modifications, and the backing pool=
<br>
&gt; &gt; can manage the new pre-provisioning space requests directly....<b=
r>
&gt; &gt; <br>
&gt; <br>
&gt; This is written as to imply that the reservation pool is some big<br>
&gt; complex thing, which makes me think there is some<br>
&gt; confusion/miscommunication.<br>
<br>
No confusion, I&#39;m just sceptical that it will work given my<br>
experience trying to implement reservation based solutions multiple<br>
different ways over the past decade. They&#39;ve all failed because<br>
they collapse under either the complexity explosion or space<br>
overhead required to handle the worst case behavioural scenarios.<br>
<br>
At one point I calculated the worst case reservation needed ensure<br>
log recovery will always succeeded, ignoring write amplification,<br>
was about 16x the size of the log. If I took write amplification for<br>
dm-thinp having 64kB blocks and each inode hitting a different<br>
cluster in it&#39;s own dm thinp block, that write amplication hit 64x.<br>
<br>
So for recovering a 2GB log, if dm-thinp doesn&#39;t have a reserve of<br>
well over 100GB of pool space, there is no guarantee that log<br>
recovery will -always- succeed.<br>
<br>
It&#39;s worst case numbers like this which made me conclude that<br>
reservation based approaches cannot provide guarantees that ENOSPC<br>
will never occur. The numbers are just too large when you start<br>
considering journals that can hold a million dirty objects,<br>
intent chains that might require modifying hundreds of metadata<br>
blocks across a dozen transactions before they complete, etc.<br>
<br>
OTOH, REQ_PROVISION makes this &quot;log recovery needs new space to be<br>
allocated&quot; problem go away entirely. It provides a mechanism that<br>
ensures log recovery does not consume any new space in the backing<br>
pool as all the overwrites it performs are to previously provisioned<br>
metadata.....<br>
<br>
This is just one of the many reasons why I think the REQ_PROVISION<br>
method is far better than reservations - it solves problems that<br>
pure runtime reservations can&#39;t.<br>
<br>
&gt; It&#39;s basically just an in memory counter of<br>
&gt; space that is allocated out of a shared thin pool and is held in a<br>
&gt; specific thin volume while it is currently in use. The counter on the<=
br>
&gt; volume is managed indirectly by filesystem requests and/or direct<br>
&gt; operations on the volume (like dm snapshots).<br>
&gt;<br>
&gt; Sure, you could replace the counter and reservation interface with<br>
&gt; explicitly provisioned/trimmed LBA ranges that the fs can manage to<br=
>
&gt; provide -ENOSPC guarantees, but then the fs has to do those various<br=
>
&gt; things you&#39;ve mentioned:<br>
&gt; <br>
&gt; - Provision those ranges in the fs and change allocation behavior<br>
&gt;=C2=A0 =C2=A0accordingly.<br>
<br>
This is relatively simple - most of the allocator functionality is<br>
already there.<br>
<br>
&gt; - Do the background post-crash fitrim preprovision clean up thing.<br>
<br>
We&#39;ve already decided this is not needed.<br>
<br>
&gt; - Distinguish between trims that are intended to return preprovisioned=
<br>
&gt;=C2=A0 =C2=A0space vs. those that come from userspace.<br>
<br>
It&#39;s about ten lines of code in xfs_trim_extents() to do this.=C2=A0 i.=
e.<br>
the free space tree walk simply skips over free extents in the<br>
metadata provisioned region based on a flag value.<br>
<br>
&gt; - Have some daemon or whatever (?) responsible for communicating the<b=
r>
&gt;=C2=A0 =C2=A0need for trims in the fs to return space back to the pool.=
<br>
<br>
Systems are already configured to run a periodic fstrim passes to do<br>
this via systemd units. And I&#39;m pretty sure dm-thinp has a low space<br=
>
notification to userspace (via dbus?) that is already used by<br>
userspace agents to handle &quot;near ENOSPC&quot; events automatically.<br=
>
<br>
&gt; Then this still depends on changing how dm thin snapshots work and nee=
ds<br>
&gt; a way to deal with delayed allocation to actually guarantee -ENOSPC<br=
>
&gt; protection..?<br>
<br>
I think you misunderstand: I&#39;m not proposing to use REQ_PROVISION<br>
for writes the filesystem does not guarantee will succeed. Never<br>
have, I think it makes no sense at all.=C2=A0 If the filesystem<br>
can return ENOSPC for an unprovisioned user data write, then the<br>
block device can too.<br>
<br>
&gt; &gt; Hence I think if we get the basic REQ_PROVISION overwrite-in-plac=
e<br>
&gt; &gt; guarantees defined and implemented as previously outlined, then w=
e<br>
&gt; &gt; don&#39;t need any special coordination between the fs and block =
devices<br>
&gt; &gt; to avoid fatal ENOSPC issues with sparse and/or snapshot capable<=
br>
&gt; &gt; block devices...<br>
&gt; &gt; <br>
&gt; <br>
&gt; This all sounds like a good amount of coordination and unnecessary<br>
&gt; complexity to me. What I was thinking as a next phase (i.e. after<br>
&gt; initial phase full device reservation) approach for a filesystem like<=
br>
&gt; XFS would be something like this.<br>
&gt; <br>
&gt; - Support a mount option for a configurable size metadata reservation<=
br>
&gt;=C2=A0 =C2=A0pool (with sane/conservative default).<br>
<br>
I want this to all to work without the user having be aware that<br>
there filesystem is running on a sparse device.<br>
<br>
&gt; - The pool is populated at mount time, else the fs goes right into<br>
&gt;=C2=A0 =C2=A0simulated -ENOSPC mode.<br>
<br>
What are the rules of this mode?<br>
<br>
Hmmmm.<br>
<br>
Log recovery needs to be able to allocate new metadata (i.e. in<br>
intent replay), so I&#39;m guessing reservation is needed before log<br>
recovery? But if pool reservation fails, how do we then safely<br>
perform log recovery given the filesystem is in ENOSPC mode?<br>
<br>
&gt; - Thin pool reservation consumption is controlled by a flag on write<b=
r>
&gt;=C2=A0 =C2=A0bios that is managed by the fs (flag polarity TBD).<br>
<br>
So we still need a bio flag to communicate &quot;this IO consumes<br>
reservation&quot;.<br>
<br>
What are the semantics of this flag?=C2=A0 What happens on submission<br>
error? e.g. the bio is failed before it gets to the layer that<br>
consumes it - how does the filesystem know that reservation was<br>
consumed or not at completion?<br>
<br>
How do we know when to set it for user data writes?<br>
<br>
What happens if the device recieves a bio with this flag but there<br>
is no reservation remaining? e.g. the filesystem or device<br>
accounting have got out of whack?<br>
<br>
Hmmm. On that note, what about write amplification? Or should I call<br>
it &quot;reservation amplification&quot;. i.e. a 4kB bio with a &quot;consu=
me<br>
reservation&quot; flag might trigger a dm-region COW or allocation and<br>
require 512kB of dm-thinp pool space to be allocated. How much<br>
reservation actually gets consumed, and how do we reconcile the<br>
differences in physical consumption vs reservation consumption?<br>
<br>
&gt; - All fs data writes are explicitly reserved up front in the write pat=
h.<br>
&gt;=C2=A0 =C2=A0Delalloc maps to explicit reservation, overwrites are easy=
 and just<br>
&gt;=C2=A0 =C2=A0involve an explicit provision.<br>
<br>
This is the first you&#39;ve mentioned an &quot;explicit provision&quot;<br=
>
operation. Is this like REQ_PROVISION, or something else?<br>
<br>
This seems to imply that the -&gt;iomap_begin method has to do<br>
explicit provisioning callouts when we get a write that lands in an<br>
IOMAP_MAPPED extent? Or something else?<br>
<br>
Can you describe this mechanism in more detail?<br>
<br>
&gt; - Metadata writes are not reserved or provisioned at all. They allocat=
e<br>
&gt;=C2=A0 =C2=A0out of the thin pool on write (if needed), just as they do=
 today. On<br>
&gt;=C2=A0 =C2=A0an -ENOSPC metadata write error, the fs goes into simulate=
d -ENOSPC mode<br>
&gt;=C2=A0 =C2=A0and allows outstanding metadata writes to now use the bio =
flag to<br>
&gt;=C2=A0 =C2=A0consume emergency reservation.<br>
<br>
Okay. We need two pools in the backing device? The normal free space<br>
pool, and an emergency reservation pool?<br>
<br>
Without reading further, this implies that the filesystem is<br>
reliant on the emergency reservation pool being large enough that<br>
it can write any dirty metadata it has outstanding without ENOSPC<br>
occuring. How does the size of this emergency pool get configured?<br>
<br>
&gt; So this means that metadata -ENOSPC protection is only as reliable as<=
br>
&gt; the size of the specified pool. This is by design, so the filesystem<b=
r>
&gt; still does not have to track provisioning, allocation or overwrites of=
<br>
&gt; its own metadata usage. Users with metadata heavy workloads or who<br>
&gt; happen to be sensitive to -ENOSPC errors can be more aggressive with<b=
r>
&gt; pool size, while other users might be able to get away with a smaller<=
br>
&gt; pool. Users who are super paranoid and want perfection can continue to=
<br>
&gt; reserve the entire device and pay for the extra storage.<br>
<br>
Oh. Hand tuning. :(<br>
<br>
&gt; Users who are not sure can test their workload in an appropriate<br>
&gt; environment, collect some data/metrics on maximum outstanding dirty<br=
>
&gt; metadata, and then use that as a baseline/minimum pool size for reliab=
le<br>
&gt; behavior going forward.=C2=A0 This is also where something like Strati=
s can<br>
&gt; come in to generate this sort of information, make recommendations or<=
br>
&gt; implement heuristics (based on things like fs size, amount of RAM, for=
<br>
&gt; e.g.) to provide sane defaults based on use case. I.e., this is<br>
&gt; initially exposed as a userspace/tuning issue instead of a<br>
&gt; filesystem/dm-thin hard guarantee.<br>
<br>
Which are the same things people have been complaining about for years.<br>
<br>
&gt; Finally, if you really want to get to that last step of maximally<br>
&gt; efficient and safe provisioning in the fs, implement a<br>
&gt; &#39;thinreserve=3Dadaptive&#39; mode in the fs that alters the acquis=
ition and<br>
&gt; consumption of dm-thin reserved blocks to be adaptive in nature and<br=
>
&gt; promises to do it&#39;s own usage throttling against outstanding<br>
&gt; reservation. I think this is the mode that most closely resembles your=
<br>
&gt; preprovisioned range mechanism.<br>
&gt;<br>
&gt; For example, adaptive mode could add the logic/complexity where you do=
<br>
&gt; the per-ag provision thing (just using reservation instead of physical=
<br>
&gt; ranges), change the transaction path to attempt to increase the<br>
&gt; reservation pool or go into -ENOSPC mode, and flag all writes to be<br=
>
&gt; satisfied from the reserve pool (because you&#39;ve done the<br>
&gt; provision/reservation up front).<br>
<br>
Ok, so why not just go straight to this model using REQ_PROVISION?<br>
<br>
If we then want to move to a different &quot;accounting only&quot; model fo=
r<br>
provisioning, we just change REQ_PROVISION?<br>
<br>
But I still see the problem of write amplification accounting being<br>
unsolved by the &quot;filesystem accounting only&quot; approach advocated<b=
r>
here.=C2=A0 We have no idea when the backing device has snapshots taken,<br=
>
we have no idea when a filesystem write IO actually consumes more<br>
thinp blocks than filesystem blocks, etc.=C2=A0 How does the filesystem<br>
level reservation pool address these problems?<br>
<br>
&gt; Thoughts on any of the above?<br>
<br>
I&#39;d say it went wrong at the requirements stage, resulting in an<br>
overly complex, over-engineered solution.<br>
<br>
&gt; One general tradeoff with using reservations vs. preprovisioning is th=
e<br>
&gt; the latter can just use the provision/trim primitives to alloc/free LB=
A<br>
&gt; ranges. My thought on that is those primitives could possibly be<br>
&gt; modified to do the same sort of things with reservation as for physica=
l<br>
&gt; allocations. That seems fairly easy to do with bio op flags/modifiers,=
<br>
&gt; though one thing I&#39;m not sure about is how to submit a provision b=
io to<br>
&gt; request a certain amount location agnostic blocks. I&#39;d have to<br>
&gt; investigate that more.<br>
<br>
Sure, if the constrained LBA space aspect of the REQ_PROVISION<br>
implementation causes issues, then we see if we can optimise away<br>
the fixed LBA space requirement.<br>
<br>
<br>
-- <br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
<br>
</blockquote></div>

--000000000000c9a83605fc96b132--

--===============7776123176921165008==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7776123176921165008==--


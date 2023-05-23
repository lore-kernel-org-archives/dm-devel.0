Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E1B9C77B75
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 14:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684850747;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KBzZn6hMxRGKPgQATADu2JKGfXDtcZ8Xy89h9EwDhSg=;
	b=PNTTyPrWJZmmnxT3d3hNtFdonarqL0b7JCTxFXVvsNg2Dl22erQNUQbRlB/nY32s9Ogd4b
	0T8xAieD/B7ho2Zm9z8Tcr719TkxaDvyT4xiQaEKP01z6mZViHZEZMU65YKGTCVXTlCI++
	sibKJ60y8BTM22ewXN3x8dVRVThJlKY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-CK_OSAwaPHCLuXIqobTs_A-1; Tue, 23 May 2023 10:05:44 -0400
X-MC-Unique: CK_OSAwaPHCLuXIqobTs_A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24AF22A59575;
	Tue, 23 May 2023 14:03:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71DBC1121314;
	Tue, 23 May 2023 14:03:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2AD6E19465A8;
	Tue, 23 May 2023 14:03:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A8C9719465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 14:03:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 99BB91121315; Tue, 23 May 2023 14:03:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 915771121314
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:03:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71DBC185A78F
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:03:05 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-KMxTPG61NhqZ5TuR0AbAUg-1; Tue, 23 May 2023 10:02:58 -0400
X-MC-Unique: KMxTPG61NhqZ5TuR0AbAUg-1
Received: by mail-qv1-f69.google.com with SMTP id
 6a1803df08f44-6237c937691so30803306d6.0
 for <dm-devel@redhat.com>; Tue, 23 May 2023 07:02:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684850578; x=1687442578;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=d/0oQeB2oBb6hsvg356w0+OEi+j0PMCHZWqWc71xqRU=;
 b=WPciueZ/LFv1Qr0ie6raqvLbOeKVeLQ8fnH3p0pY+SoKVbKbQrqhakF7fpZD4Szzk1
 SIsQ4GpIaM/aySkFarW6mJw2psJmg6rO1yFVn+Y0cyfAZMYz8U9C1J/Ns1QxqgyZAaHh
 LpbZJ3Qs08u0vrgvMiMTGFGLAsruOuS142R9OWkwaRKKWrXnJSQylSWt4cQolMl8TXRg
 QpoynuHEKC95T1eGal/4oZqrvnIiZvyLxqucuEED7Qj3Pudy/wWW2GdS5ePGxO8VQH+x
 YqIO74jdCCeVI7As/oN1/ocl2+3NU7O4Na5WrOPIqRn+0qd7Iry2iOAL+aN7ckuigwYI
 Dv9g==
X-Gm-Message-State: AC+VfDzzzRwHyWfX0/yFGQoea8XzK1wIKvbCKc3cptdBR0CLnD9ak2e9
 zALHhJRGl6pZgLd8FvsuonA3g/T+r+qptWm6Epm28leV+aRg3cWJM95K93qDzCGJMrTS32HyNSy
 XfodTbq+L/8e6VsM=
X-Received: by 2002:a05:622a:1a05:b0:3f5:954:3fbb with SMTP id
 f5-20020a05622a1a0500b003f509543fbbmr24379211qtb.28.1684850578119; 
 Tue, 23 May 2023 07:02:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7f1Odnld8SY4FHdYvR1CI3aZa8QjS4u5jebOetOFz56gyyYuQhBC5DS+nR/RS/r0Srv7S16Q==
X-Received: by 2002:a05:622a:1a05:b0:3f5:954:3fbb with SMTP id
 f5-20020a05622a1a0500b003f509543fbbmr24379138qtb.28.1684850577260; 
 Tue, 23 May 2023 07:02:57 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
 by smtp.gmail.com with ESMTPSA id
 i14-20020ac871ce000000b003f4fa14decbsm67896qtp.52.2023.05.23.07.02.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 07:02:56 -0700 (PDT)
Date: Tue, 23 May 2023 10:05:26 -0400
From: Brian Foster <bfoster@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <ZGzIJlCE2pcqQRFJ@bfoster>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <ZGb2Xi6O3i2pLam8@infradead.org> <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area>
 <ZGu0LaQfREvOQO4h@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZGu0LaQfREvOQO4h@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, Sarthak Kukreti <sarthakkukreti@chromium.org>,
 dm-devel@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Dave Chinner <david@fromorbit.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 Joe Thornber <ejt@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 22, 2023 at 02:27:57PM -0400, Mike Snitzer wrote:
> On Fri, May 19 2023 at  7:07P -0400,
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Fri, May 19, 2023 at 10:41:31AM -0400, Mike Snitzer wrote:
> > > On Fri, May 19 2023 at 12:09P -0400,
> > > Christoph Hellwig <hch@infradead.org> wrote:
> > > 
> > > > FYI, I really don't think this primitive is a good idea.  In the
> > > > concept of non-overwritable storage (NAND, SMR drives) the entire
> > > > concept of a one-shoot 'provisioning' that will guarantee later writes
> > > > are always possible is simply bogus.
> > > 
> > > Valid point for sure, such storage shouldn't advertise support (and
> > > will return -EOPNOTSUPP).
> > > 
> > > But the primitive still has utility for other classes of storage.
> > 
> > Yet the thing people are wanting to us filesystem developers to use
> > this with is thinly provisioned storage that has snapshot
> > capability. That, by definition, is non-overwritable storage. These
> > are the use cases people are asking filesystes to gracefully handle
> > and report errors when the sparse backing store runs out of space.
> 
> DM thinp falls into this category but as you detailed it can be made
> to work reliably. To carry that forward we need to first establish
> the REQ_PROVISION primitive (with this series).
> 
> Follow-on associated dm-thinp enhancements can then serve as reference
> for how to take advantage of XFS's ability to operate reliably of
> thinly provisioned storage.
>  
> > e.g. journal writes after a snapshot is taken on a busy filesystem
> > are always an overwrite and this requires more space in the storage
> > device for the write to succeed. ENOSPC from the backing device for
> > journal IO is a -fatal error-. Hence if REQ_PROVISION doesn't
> > guarantee space for overwrites after snapshots, then it's not
> > actually useful for solving the real world use cases we actually
> > need device-level provisioning to solve.
> > 
> > It is not viable for filesystems to have to reprovision space for
> > in-place metadata overwrites after every snapshot - the filesystem
> > may not even know a snapshot has been taken! And it's not feasible
> > for filesystems to provision on demand before they modify metadata
> > because we don't know what metadata is going to need to be modified
> > before we start modifying metadata in transactions. If we get ENOSPC
> > from provisioning in the middle of a dirty transcation, it's all
> > over just the same as if we get ENOSPC during metadata writeback...
> > 
> > Hence what filesystems actually need is device provisioned space to
> > be -always over-writable- without ENOSPC occurring.  Ideally, if we
> > provision a range of the block device, the block device *must*
> > guarantee all future writes to that LBA range succeeds. That
> > guarantee needs to stand until we discard or unmap the LBA range,
> > and for however many writes we do to that LBA range.
> > 
> > e.g. If the device takes a snapshot, it needs to reprovision the
> > potential COW ranges that overlap with the provisioned LBA range at
> > snapshot time. e.g. by re-reserving the space from the backing pool
> > for the provisioned space so if a COW occurs there is space
> > guaranteed for it to succeed.  If there isn't space in the backing
> > pool for the reprovisioning, then whatever operation that triggers
> > the COW behaviour should fail with ENOSPC before doing anything
> > else....
> 
> Happy to implement this in dm-thinp.  Each thin block will need a bit
> to say if the block must be REQ_PROVISION'd at time of snapshot (and
> the resulting block will need the same bit set).
> 
> Walking all blocks of a thin device and triggering REQ_PROVISION for
> each will obviously make thin snapshot creation take more time.
> 
> I think this approach is better than having a dedicated bitmap hooked
> off each thin device's metadata (with bitmap being copied and walked
> at the time of snapshot). But we'll see... I'll get with Joe to
> discuss further.
> 

Hi Mike,

If you recall our most recent discussions on this topic, I was thinking
about the prospect of reserving the entire volume at mount time as an
initial solution to this problem. When looking through some of the old
reservation bits we prototyped years ago, it occurred to me that we have
enough mechanism to actually prototype this.

So FYI, I have some hacky prototype code that essentially has the
filesystem at mount time tell dm it's using the volume and expects all
further writes to succeed. dm-thin acquires reservation for the entire
range of the volume for which writes would require block allocation
(i.e., holes and shared dm blocks) or otherwise warns that the fs cannot
be "safely" mounted.

The reservation pool associates with the thin volume (not the
filesystem), so if a snapshot is requested from dm, the snapshot request
locates the snapshot origin and if it's currently active, increases the
reservation pool to account for outstanding blocks that are about to
become shared, or otherwise fails the snapshot with -ENOSPC. (I suspect
discard needs similar treatment, but I hadn't got to that yet.). If the
fs is not active, there is nothing to protect and so the snapshot
proceeds as normal.

This seems to work on my simple, initial tests for protecting actively
mounted filesystems from dm-thin -ENOSPC. This definitely needs a sanity
check from dm-thin folks, however, because I don't know enough about the
broader subsystem to reason about whether it's sufficiently correct. I
just managed to beat the older prototype code into submission to get it
to do what I wanted on simple experiments.

Thoughts on something like this? I think the main advantage is that it
significantly reduces the requirements on the fs to track individual
allocations. It's basically an on/off switch from the fs perspective,
doesn't require any explicit provisioning whatsoever (though it can be
done to improve things in the future) and in fact could probably be tied
to thin volume activation to be made completely filesystem agnostic.
Another advantage is that it requires no on-disk changes, no breaking
COWs up front during snapshots, etc.

The disadvantages are that it's space inefficient wrt to thin pool free
space, but IIUC this is essentially what userspace management layers
(such as Stratis) are doing today, they just put restrictions up front
at volume configuration/creation time instead of at runtime. There also
needs to be some kind of interface between the fs and dm. I suppose we
could co-opt provision and discard primitives with a "reservation"
modifier flag to get around that in a simple way, but that sounds
potentially ugly. TBH, the more I think about this the more I think it
makes sense to reserve on volume activation (with some caveats to allow
a read-only mode, explicit bypass, etc.) and then let the
cross-subsystem interface be dictated by granularity improvements...

... since I also happen to think there is a potentially interesting
development path to make this sort of reserve pool configurable in terms
of size and active/inactive state, which would allow the fs to use an
emergency pool scheme for managing metadata provisioning and not have to
track and provision individual metadata buffers at all (dealing with
user data is much easier to provision explicitly). So the space
inefficiency thing is potentially just a tradeoff for simplicity, and
filesystems that want more granularity for better behavior could achieve
that with more work. Filesystems that don't would be free to rely on the
simple/basic mechanism provided by dm-thin and still have basic -ENOSPC
protection with very minimal changes.

That's getting too far into the weeds on the future bits, though. This
is essentially 99% a dm-thin approach, so I'm mainly curious if there's
sufficient interest in this sort of "reserve mode" approach to try and
clean it up further and have dm guys look at it, or if you guys see any
obvious issues in what it does that makes it potentially problematic, or
if you would just prefer to go down the path described above...

Brian

> > Software devices like dm-thin/snapshot should really only need to
> > keep a persistent map of the provisioned space and refresh space
> > reservations for used space within that map whenever something that
> > triggers COW behaviour occurs. i.e. a snapshot needs to reset the
> > provisioned ranges back to "all ranges are freshly provisioned"
> > before the snapshot is started. If that space is not available in
> > the backing pool, then the snapshot attempt gets ENOSPC....
> > 
> > That means filesystems only need to provision space for journals and
> > fixed metadata at mkfs time, and they only need issue a
> > REQ_PROVISION bio when they first allocate over-write in place
> > metadata. We already have online discard and/or fstrim for releasing
> > provisioned space via discards.
> > 
> > This will require some mods to filesystems like ext4 and XFS to
> > issue REQ_PROVISION and fail gracefully during metadata allocation.
> > However, doing so means that we can actually harden filesystems
> > against sparse block device ENOSPC errors by ensuring they will
> > never occur in critical filesystem structures....
> 
> Yes, let's finally _do_ this! ;)
> 
> Mike
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


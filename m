Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54AADC77B7C
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 20:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684958584;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OlX9CkZgH9nDCIBtuCj+Pwxji58/DWJSvtrr9xsSftE=;
	b=CbGx074psR4ETfuuhneixG/tSrxigluvctHI8SPU0D3sBXajbDWFDlbJoHC92m66uBdOyG
	rRjKA7iIBqj5Bhq6bOJIeCXIXY94M1BFWOU3L/gWFa9UUyejOO0GIIFiwkRN5eZOJlQcwX
	rZyCx/04DUbB1XhK79RiyySvE2C/Irg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-adgY9MR8N6mU17BDeWRfzw-1; Wed, 24 May 2023 16:02:59 -0400
X-MC-Unique: adgY9MR8N6mU17BDeWRfzw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39741800888;
	Wed, 24 May 2023 20:02:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82CB9492B0A;
	Wed, 24 May 2023 20:02:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 20BAB19465A8;
	Wed, 24 May 2023 20:02:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F3E319465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 20:02:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E789492B0C; Wed, 24 May 2023 20:02:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07458492B0A
 for <dm-devel@redhat.com>; Wed, 24 May 2023 20:02:54 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF4143C17C62
 for <dm-devel@redhat.com>; Wed, 24 May 2023 20:02:53 +0000 (UTC)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-t7cufcNeP0WQndzYUER5SA-1; Wed, 24 May 2023 16:02:52 -0400
X-MC-Unique: t7cufcNeP0WQndzYUER5SA-1
Received: by mail-qk1-f172.google.com with SMTP id
 af79cd13be357-75b2a2bf757so9790985a.2
 for <dm-devel@redhat.com>; Wed, 24 May 2023 13:02:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684958571; x=1687550571;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=wc0lEJ6PvCd/xSxo1AL44vYdysUGzpOXm110SXEKBVE=;
 b=lRse7OV+gsKD2/i949Prrv7gp2xeFfolyZcsR3ZUSECAdVJ+pPsVsrmw8k7K1uYkhx
 zRgd74WCF3Yk0p3UrY7OxYwuOg/c5sev5r6GPgruMZOwx8DOHIn+Bu4tx1I7UBlLAEy5
 H/uSivSBMRZwAuvsJ+l1kNiGgtztEF0y/uV6fq8wsuf69aQjYF6Kh3UY65w/daqjfbpB
 G4QGPXHGmDYRGCzm5uak1nAms3c9nlCziIT20dgmeW8FAHMol+pT7el8XbIHwFjakhaR
 Pq5FwZPIGKprqzRoQp/1CS/1DSzrkJRd+7KuUd+Md7huf1KPe/4oA7T2HfYebv1eToYR
 nPww==
X-Gm-Message-State: AC+VfDxlGvjgsPAG847tmGC6MnbUTO1Uuj8xceeHt+gV3VFdyDL4mIUa
 lpdV5eSELTkbxsD9/SwfDE2gcKQ=
X-Google-Smtp-Source: ACHHUZ5Edu25T8oAO0AIn9AjhlUZ+gCHN9Nh8NKCZqGZXLB9J8KM/t5ZexjNCLqFmWACVt0TS1EBUg==
X-Received: by 2002:ae9:d60e:0:b0:75b:23a1:3671 with SMTP id
 r14-20020ae9d60e000000b0075b23a13671mr9242472qkk.50.1684958571318; 
 Wed, 24 May 2023 13:02:51 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 v20-20020a05620a123400b0074d60b697a6sm3496740qkj.12.2023.05.24.13.02.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 May 2023 13:02:50 -0700 (PDT)
Date: Wed, 24 May 2023 16:02:49 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Message-ID: <ZG5taYoXDRymo/e9@redhat.com>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <ZGb2Xi6O3i2pLam8@infradead.org> <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area>
 <ZGu0LaQfREvOQO4h@redhat.com> <ZGzIJlCE2pcqQRFJ@bfoster>
 <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <ZG1dAtHmbQ53aOhA@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23 2023 at  8:40P -0400,
Dave Chinner <david@fromorbit.com> wrote:

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

This is basically saying the same thing but:

It could be that the LBA space is fragmented and so falling back to
the smallest region size (that matches the thinp block size) would be
the last resort?  Then if/when thinp cannot even service allocating a
new free thin block, dm-thinp will transition to out-of-data-space
mode.

> This is built entirely on the premise that once proactive backing
> device provisioning fails, the backing device is at ENOSPC and we
> have to wait for that situation to go away before allowing new data
> to be ingested. Hence the block device really doesn't need to know
> anything about what the filesystem is doing and vice versa - The
> block dev just says "yes" or "no" and the filesystem handles
> everything else.

Yes.

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

This would be the FITRIM with extension you mention below?  Which is a
filesystem interface detail? So dm-thinp would _not_ need to have new
state that tracks "provisioned but unused" block?  Nor would the block
layer need an extra discard flag for a new class of "provisioned"
blocks.

If XFS tracked this "provisioned but unused" state, dm-thinp could
just discard the block like its told.  Would be nice to avoid dm-thinp
needing to track "provisioned but unused".

That said, dm-thinp does still need to know if a block was provisioned
(given our previous designed discussion, to allow proper guarantees
from this interface at snapshot time) so that XFS and other
filesystems don't need to re-provision areas they already
pre-provisioned.

However, it may be that if thinp did track "provisioned but unused"
it'd be useful to allow snapshots to share provisioned blocks that
were never used.  Meaning, we could then avoid "breaking sharing" at
snapshot-time for "provisioned but unused" blocks.  But allowing this
"optimization" undercuts the gaurantee that XFS needs for thinp
storage that allows snapshots... SO, I think I answered my own
question: thinp doesnt need to track "provisioned but unused" blocks
but we must always ensure snapshots inherit provisoned blocks ;)

> Further, managing shared pool exhaustion doesn't require a
> reservation pool in the backing device and for the filesystems to
> request space from it. Filesystems already have their own reserve
> pools via pre-provisioning. If we want the filesystems to be able to
> release that space back to the shared pool (e.g. because the shared
> backing pool is critically short on space) then all we need is an
> extension to FITRIM to tell the filesystem to also release internal
> pre-provisioned reserves.

So by default FITRIM will _not_ discard provisioned blocks.  Only if
a flag is used will it result in discarding provisioned blocks.

My dwelling on this is just double-checking that the 
 
> Then the backing pool admin (person or automated daemon!) can simply
> issue a trim on all the filesystems in the pool and spce will be
> returned. Then filesystems will ask for new pre-provisioned space
> when they next need to ingest modifications, and the backing pool
> can manage the new pre-provisioning space requests directly....
>
> Hence I think if we get the basic REQ_PROVISION overwrite-in-place
> guarantees defined and implemented as previously outlined, then we
> don't need any special coordination between the fs and block devices
> to avoid fatal ENOSPC issues with sparse and/or snapshot capable
> block devices...
> 
> As a bonus, if we can implement the guarantees in dm-thin/-snapshot
> and have a filesystem make use of it, then we also have a reference
> implementation to point at device vendors and standards
> associations....

Yeap.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


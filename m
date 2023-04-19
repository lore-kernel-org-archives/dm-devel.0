Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A69C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 19 Apr 2023 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681925208;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yKmadqJ8MUeawo/qsqwe562IFc9a9gccJTNgFTX8l3E=;
	b=JOxiwUNTlcdXVaZeEu5OBwiC9FSeOOmdn/2mvECjMKszjTOYCr+39Tbngcd2T+Uhmfvw5e
	dBZF85nyVViRpx3CExgtRFZurHq/MR56kYcmx1cK+qROnixbPXAOMZcwgbTjiEQGidrY96
	g50tnQZBNX8dIxRVN9A7yiA5mpM+RYQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-tPd-U5QcN6Knhc_VvVoLYg-1; Wed, 19 Apr 2023 13:26:45 -0400
X-MC-Unique: tPd-U5QcN6Knhc_VvVoLYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AFD41C189A7;
	Wed, 19 Apr 2023 17:26:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98ABA40BC798;
	Wed, 19 Apr 2023 17:26:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C05A19465B9;
	Wed, 19 Apr 2023 17:26:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F49D19465B5
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 17:26:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3F27D40C201F; Wed, 19 Apr 2023 17:26:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 378ED40C2064
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 17:26:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BB901C189A7
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 17:26:08 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-_mu-_X4TMmKklm9650SgqQ-1; Wed, 19 Apr 2023 13:26:04 -0400
X-MC-Unique: _mu-_X4TMmKklm9650SgqQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4B77064053;
 Wed, 19 Apr 2023 17:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6ABC433EF;
 Wed, 19 Apr 2023 17:26:02 +0000 (UTC)
Date: Wed, 19 Apr 2023 10:26:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <20230419172602.GE360881@frogsfrogsfrogs>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-2-sarthakkukreti@chromium.org>
 <20230419153611.GE360885@frogsfrogsfrogs>
 <ZEAUHnWqt9cIiJRb@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZEAUHnWqt9cIiJRb@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v4 1/4] block: Introduce provisioning
 primitives
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
 Theodore Ts'o <tytso@mit.edu>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 19, 2023 at 12:17:34PM -0400, Mike Snitzer wrote:
> On Wed, Apr 19 2023 at 11:36P -0400,
> Darrick J. Wong <djwong@kernel.org> wrote:
> 
> > On Tue, Apr 18, 2023 at 03:12:04PM -0700, Sarthak Kukreti wrote:
> > > Introduce block request REQ_OP_PROVISION. The intent of this request
> > > is to request underlying storage to preallocate disk space for the given
> > > block range. Block devices that support this capability will export
> > > a provision limit within their request queues.
> > > 
> > > This patch also adds the capability to call fallocate() in mode 0
> > > on block devices, which will send REQ_OP_PROVISION to the block
> > > device for the specified range,
> > > 
> > > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > > ---
> > >  block/blk-core.c          |  5 ++++
> > >  block/blk-lib.c           | 53 +++++++++++++++++++++++++++++++++++++++
> > >  block/blk-merge.c         | 18 +++++++++++++
> > >  block/blk-settings.c      | 19 ++++++++++++++
> > >  block/blk-sysfs.c         |  8 ++++++
> > >  block/bounce.c            |  1 +
> > >  block/fops.c              | 25 +++++++++++++-----
> > >  include/linux/bio.h       |  6 +++--
> > >  include/linux/blk_types.h |  5 +++-
> > >  include/linux/blkdev.h    | 16 ++++++++++++
> > >  10 files changed, 147 insertions(+), 9 deletions(-)
> > > 
> > 
> > <cut to the fallocate part; the block/ changes look fine to /me/ at
> > first glance, but what do I know... ;)>
> > 
> > > diff --git a/block/fops.c b/block/fops.c
> > > index d2e6be4e3d1c..e1775269654a 100644
> > > --- a/block/fops.c
> > > +++ b/block/fops.c
> > > @@ -611,9 +611,13 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > >  	return ret;
> > >  }
> > >  
> > > +#define	BLKDEV_FALLOC_FL_TRUNCATE				\
> > 
> > At first I thought from this name that you were defining a new truncate
> > mode for fallocate, then I realized that this is mask for deciding if we
> > /want/ to truncate the pagecache.
> > 
> > #define		BLKDEV_FALLOC_TRUNCATE_MASK ?
> > 
> > > +		(FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_ZERO_RANGE |	\
> > 
> > Ok, so discarding and writing zeroes truncates the page cache, makes
> > sense since we're "writing" directly to the block device.
> > 
> > > +		 FALLOC_FL_NO_HIDE_STALE)
> > 
> > Here things get tricky -- some of the FALLOC_FL mode bits are really an
> > opcode and cannot be specified together, whereas others select optional
> > behavior for certain opcodes.
> > 
> > IIRC, the mutually exclusive opcodes are:
> > 
> > 	PUNCH_HOLE
> > 	ZERO_RANGE
> > 	COLLAPSE_RANGE
> > 	INSERT_RANGE
> > 	(none of the above, for allocation)
> > 
> > and the "variants on a theme are":
> > 
> > 	KEEP_SIZE
> > 	NO_HIDE_STALE
> > 	UNSHARE_RANGE
> > 
> > not all of which are supported by all the opcodes.
> > 
> > Does it make sense to truncate the page cache if userspace passes in
> > mode == NO_HIDE_STALE?  There's currently no defined meaning for this
> > combination, but I think this means we'll truncate the pagecache before
> > deciding if we're actually going to issue any commands.
> > 
> > I think that's just a bug in the existing code -- it should be
> > validating that @mode is any of the supported combinations *before*
> > truncating the pagecache.
> > 
> > Otherwise you could have a mkfs program that starts writing new fs
> > metadata, decides to provision the storage (say for a logging region),
> > doesn't realize it's running on an old kernel, and then oops the
> > provision attempt fails but have we now shredded the pagecache and lost
> > all the writes?
> 
> While that just caused me to have an "oh shit, that's crazy" (in a
> scary way) belly laugh...

I just tried this and:

# xfs_io -c 'pwrite -S 0x58 1m 1m' -c fsync -c 'pwrite -S 0x59 1m 4096' -c 'pread -v 1m 64' -c 'falloc 1m 4096' -c 'pread -v 1m 64' /dev/sda
wrote 1048576/1048576 bytes at offset 1048576
1 MiB, 256 ops; 0.0013 sec (723.589 MiB/sec and 185238.7844 ops/sec)
wrote 4096/4096 bytes at offset 1048576
4 KiB, 1 ops; 0.0000 sec (355.114 MiB/sec and 90909.0909 ops/sec)
00100000:  59 59 59 59 59 59 59 59 59 59 59 59 59 59 59 59  YYYYYYYYYYYYYYYY
00100010:  59 59 59 59 59 59 59 59 59 59 59 59 59 59 59 59  YYYYYYYYYYYYYYYY
00100020:  59 59 59 59 59 59 59 59 59 59 59 59 59 59 59 59  YYYYYYYYYYYYYYYY
00100030:  59 59 59 59 59 59 59 59 59 59 59 59 59 59 59 59  YYYYYYYYYYYYYYYY
read 64/64 bytes at offset 1048576
64.000000 bytes, 1 ops; 0.0000 sec (1.565 MiB/sec and 25641.0256 ops/sec)
fallocate: Operation not supported
00100000:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58  XXXXXXXXXXXXXXXX
00100010:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58  XXXXXXXXXXXXXXXX
00100020:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58  XXXXXXXXXXXXXXXX
00100030:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58  XXXXXXXXXXXXXXXX
read 64/64 bytes at offset 1048576
64.000000 bytes, 1 ops; 0.0003 sec (176.554 KiB/sec and 2824.8588 ops/sec)

(Write 1MB of Xs, flush it to disk, write 4k of Ys, confirm the Y's are
in the page cache, fail to fallocate, reread and spot the Xs that we
supposedly overwrote.)

oops.

> (And obviously needs fixing independent of this patchset)
> 
> Shouldn't mkfs first check that the underlying storage supports
> REQ_OP_PROVISION by verifying
> /sys/block/<dev>/queue/provision_max_bytes exists and is not 0?
> (Just saying, we need to add new features more defensively.. you just
> made the case based on this scenario's implications alone)

Not for fallocate -- for regular files, there's no way to check if the
filesystem actually supports the operation requested other than to try
it and see if it succeeds.  We probably should've defined a DRY_RUN flag
for that purpose back when it was introduced.

For fallocate calls to block devices, yes, the program can check the
queue limits in sysfs if fstat says the supplied path is a block device,
but I don't know that most programs are that thorough.  The fallocate(1)
CLI program does not check.

Then I moved on to fs utilities:

ext4: For discard, mke2fs calls BLKDISCARD if it detects a block device
via fstat, and falloc(PUNCH|KEEP_SIZE) for anything else.  For zeroing,
it only uses falloc(ZERO) or falloc(PUNCH|KEEP_SIZE) and does not try to
use BLKZEROOUT.  It does not check sysfs queue limits at all.

XFS: mkfs.xfs issues BLKDISCARD before writing anything to the device,
so that's fine.  It uses falloc(ZERO) to erase the log, but since
xfsprogs provides its own buffer cache and uses O_DIRECT, pagecache
coherency problems aren't an issue.

btrfs: mkfs.btrfs only issues BLKDISCARD, and only before it starts
writing the new fs, so no problems there.

--D

> Sarthak, please note I said "provision_max_bytes": all other ops
> (e.g. DISCARD, WRITE_ZEROES, etc) have <op>_max_bytes exported through
> sysfs, not <op>_max_sectors.  Please export provision_max_bytes, e.g.:
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 202aa78f933e..2e5ac7b1ffbd 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -605,12 +605,12 @@ QUEUE_RO_ENTRY(queue_io_min, "minimum_io_size");
>  QUEUE_RO_ENTRY(queue_io_opt, "optimal_io_size");
>  
>  QUEUE_RO_ENTRY(queue_max_discard_segments, "max_discard_segments");
> -QUEUE_RO_ENTRY(queue_max_provision_sectors, "max_provision_sectors");
>  QUEUE_RO_ENTRY(queue_discard_granularity, "discard_granularity");
>  QUEUE_RO_ENTRY(queue_discard_max_hw, "discard_max_hw_bytes");
>  QUEUE_RW_ENTRY(queue_discard_max, "discard_max_bytes");
>  QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
>  
> +QUEUE_RO_ENTRY(queue_provision_max, "provision_max_bytes");
>  QUEUE_RO_ENTRY(queue_write_same_max, "write_same_max_bytes");
>  QUEUE_RO_ENTRY(queue_write_zeroes_max, "write_zeroes_max_bytes");
>  QUEUE_RO_ENTRY(queue_zone_append_max, "zone_append_max_bytes");

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


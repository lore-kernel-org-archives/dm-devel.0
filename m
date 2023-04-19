Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A19E3C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 19 Apr 2023 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681921064;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0bVwpBGkK/JsKHJr9yZkuOfixZtxBFHyHqpvMHsWknA=;
	b=FLubUpfsQgCFt347bZaZjHkyUNbmO/dgJq2XP7fuTPHQoXHfMCJkzCl+zpi8M30VaCnpa1
	Kucd4ezaYu2WKxGmItBUcMWcVQuTTD6tX2gI3vJuVq99bLIuVyFqOu3XfEoo8CKwlXcTuW
	Fyu4/QVKCt6LkXnkzEOSAhTS5QtRjFI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-Noue1XWvOruQa_33UB5rqg-1; Wed, 19 Apr 2023 12:17:42 -0400
X-MC-Unique: Noue1XWvOruQa_33UB5rqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F234E3C1024A;
	Wed, 19 Apr 2023 16:17:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A3505AB7A;
	Wed, 19 Apr 2023 16:17:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C7AD19465B9;
	Wed, 19 Apr 2023 16:17:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F04B19465B5
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 16:17:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 168CF492B05; Wed, 19 Apr 2023 16:17:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E65F492B04
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 16:17:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5DF0185A792
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 16:17:38 +0000 (UTC)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-1U5kHK2tPAKsBaOp77lygw-1; Wed, 19 Apr 2023 12:17:37 -0400
X-MC-Unique: 1U5kHK2tPAKsBaOp77lygw-1
Received: by mail-qv1-f46.google.com with SMTP id op30so178932qvb.3
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 09:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681921056; x=1684513056;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=z+h5fwYkvTPr/F+On2Hs94r2JzzOUgRtGOCFJcgB1Q4=;
 b=Lf3BLyNZRKh8O8HZQvYLy+8BYSL4LWUUGTlERUvf80tsMPY9+GEN8duX+W3xz/7yUy
 9fU9y7OFlbA/HPzkbSkimD6Z/NS5LQdbcVhKbaMujLjS70hiRhPSQrRMtpdbn+jzyDnG
 awdmhywCR3+RjgPzbq2XEAXMALrSvnj0EhELaVh+ndON8ffuhhnY+uAgbZLLTU0M/S6l
 lGP030r/2BGW5iikKgxW6E15tDn7MXKQgjVF5YrlqcgRlXGkveAFWyYo9v0fo3ULz1ul
 AuRLriJgV+zgwSxRHwN9heZ1wV94kDxNud1aCe+kbtjgWA73gkafqgkwR29J6tu/k8Mt
 Vgrw==
X-Gm-Message-State: AAQBX9cIItWN3vlhLoahwpc1G/KgY11XQaASnG4Wb54k7T99oQ5ZcNRZ
 7IodrcfspfnGqd/Bbs8Avr5EUzdBriccuhPrtGjz
X-Google-Smtp-Source: AKy350ZIve4mrPgTdbna5Cjf8hcJps/K5ObL3J7QcbMVD+OWL/kHf3+Ovv9X5lr5nNp8ov9iF7wtcw==
X-Received: by 2002:a05:6214:252a:b0:5ef:8004:e0b4 with SMTP id
 gg10-20020a056214252a00b005ef8004e0b4mr17326482qvb.48.1681921056440; 
 Wed, 19 Apr 2023 09:17:36 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b1-20020ac86bc1000000b003e65228ef54sm4902201qtt.86.2023.04.19.09.17.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Apr 2023 09:17:36 -0700 (PDT)
Date: Wed, 19 Apr 2023 12:17:34 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZEAUHnWqt9cIiJRb@redhat.com>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-2-sarthakkukreti@chromium.org>
 <20230419153611.GE360885@frogsfrogsfrogs>
MIME-Version: 1.0
In-Reply-To: <20230419153611.GE360885@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 19 2023 at 11:36P -0400,
Darrick J. Wong <djwong@kernel.org> wrote:

> On Tue, Apr 18, 2023 at 03:12:04PM -0700, Sarthak Kukreti wrote:
> > Introduce block request REQ_OP_PROVISION. The intent of this request
> > is to request underlying storage to preallocate disk space for the given
> > block range. Block devices that support this capability will export
> > a provision limit within their request queues.
> > 
> > This patch also adds the capability to call fallocate() in mode 0
> > on block devices, which will send REQ_OP_PROVISION to the block
> > device for the specified range,
> > 
> > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > ---
> >  block/blk-core.c          |  5 ++++
> >  block/blk-lib.c           | 53 +++++++++++++++++++++++++++++++++++++++
> >  block/blk-merge.c         | 18 +++++++++++++
> >  block/blk-settings.c      | 19 ++++++++++++++
> >  block/blk-sysfs.c         |  8 ++++++
> >  block/bounce.c            |  1 +
> >  block/fops.c              | 25 +++++++++++++-----
> >  include/linux/bio.h       |  6 +++--
> >  include/linux/blk_types.h |  5 +++-
> >  include/linux/blkdev.h    | 16 ++++++++++++
> >  10 files changed, 147 insertions(+), 9 deletions(-)
> > 
> 
> <cut to the fallocate part; the block/ changes look fine to /me/ at
> first glance, but what do I know... ;)>
> 
> > diff --git a/block/fops.c b/block/fops.c
> > index d2e6be4e3d1c..e1775269654a 100644
> > --- a/block/fops.c
> > +++ b/block/fops.c
> > @@ -611,9 +611,13 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >  	return ret;
> >  }
> >  
> > +#define	BLKDEV_FALLOC_FL_TRUNCATE				\
> 
> At first I thought from this name that you were defining a new truncate
> mode for fallocate, then I realized that this is mask for deciding if we
> /want/ to truncate the pagecache.
> 
> #define		BLKDEV_FALLOC_TRUNCATE_MASK ?
> 
> > +		(FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_ZERO_RANGE |	\
> 
> Ok, so discarding and writing zeroes truncates the page cache, makes
> sense since we're "writing" directly to the block device.
> 
> > +		 FALLOC_FL_NO_HIDE_STALE)
> 
> Here things get tricky -- some of the FALLOC_FL mode bits are really an
> opcode and cannot be specified together, whereas others select optional
> behavior for certain opcodes.
> 
> IIRC, the mutually exclusive opcodes are:
> 
> 	PUNCH_HOLE
> 	ZERO_RANGE
> 	COLLAPSE_RANGE
> 	INSERT_RANGE
> 	(none of the above, for allocation)
> 
> and the "variants on a theme are":
> 
> 	KEEP_SIZE
> 	NO_HIDE_STALE
> 	UNSHARE_RANGE
> 
> not all of which are supported by all the opcodes.
> 
> Does it make sense to truncate the page cache if userspace passes in
> mode == NO_HIDE_STALE?  There's currently no defined meaning for this
> combination, but I think this means we'll truncate the pagecache before
> deciding if we're actually going to issue any commands.
> 
> I think that's just a bug in the existing code -- it should be
> validating that @mode is any of the supported combinations *before*
> truncating the pagecache.
> 
> Otherwise you could have a mkfs program that starts writing new fs
> metadata, decides to provision the storage (say for a logging region),
> doesn't realize it's running on an old kernel, and then oops the
> provision attempt fails but have we now shredded the pagecache and lost
> all the writes?

While that just caused me to have an "oh shit, that's crazy" (in a
scary way) belly laugh...
(And obviously needs fixing independent of this patchset)

Shouldn't mkfs first check that the underlying storage supports
REQ_OP_PROVISION by verifying
/sys/block/<dev>/queue/provision_max_bytes exists and is not 0?
(Just saying, we need to add new features more defensively.. you just
made the case based on this scenario's implications alone)

Sarthak, please note I said "provision_max_bytes": all other ops
(e.g. DISCARD, WRITE_ZEROES, etc) have <op>_max_bytes exported through
sysfs, not <op>_max_sectors.  Please export provision_max_bytes, e.g.:

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 202aa78f933e..2e5ac7b1ffbd 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -605,12 +605,12 @@ QUEUE_RO_ENTRY(queue_io_min, "minimum_io_size");
 QUEUE_RO_ENTRY(queue_io_opt, "optimal_io_size");
 
 QUEUE_RO_ENTRY(queue_max_discard_segments, "max_discard_segments");
-QUEUE_RO_ENTRY(queue_max_provision_sectors, "max_provision_sectors");
 QUEUE_RO_ENTRY(queue_discard_granularity, "discard_granularity");
 QUEUE_RO_ENTRY(queue_discard_max_hw, "discard_max_hw_bytes");
 QUEUE_RW_ENTRY(queue_discard_max, "discard_max_bytes");
 QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
 
+QUEUE_RO_ENTRY(queue_provision_max, "provision_max_bytes");
 QUEUE_RO_ENTRY(queue_write_same_max, "write_same_max_bytes");
 QUEUE_RO_ENTRY(queue_write_zeroes_max, "write_zeroes_max_bytes");
 QUEUE_RO_ENTRY(queue_zone_append_max, "zone_append_max_bytes");

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


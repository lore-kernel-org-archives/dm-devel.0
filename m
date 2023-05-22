Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDB3C7EE23
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684780090;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=R5jvIoVzsNaIYebd0pkHTreZvXiWa3+vh2uUgjFy1h8=;
	b=b5P8OpZxr4tpWwLOq+60dOMpfVg95DCTcHwyB3lDzI1GEhdAmrYX/bnyb1HrqYlwbDOcyz
	Z61yBilc1CadxXWWDe9DAGEpEWS1TTEFgsW8rdChaTmvTppU9lnkFcdmPiTtPqGg8WEGSj
	v7Cb4BljpdK/VEWfPO1p/8zUudrXV4Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-JxA-x3SoPNWDQnhWTwGkGw-1; Mon, 22 May 2023 14:28:07 -0400
X-MC-Unique: JxA-x3SoPNWDQnhWTwGkGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86719185A78B;
	Mon, 22 May 2023 18:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16E32407DEC3;
	Mon, 22 May 2023 18:28:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CF4A819465A0;
	Mon, 22 May 2023 18:28:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D01021946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 18:28:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 62C72482062; Mon, 22 May 2023 18:28:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A955482060
 for <dm-devel@redhat.com>; Mon, 22 May 2023 18:28:02 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B7343C01BBC
 for <dm-devel@redhat.com>; Mon, 22 May 2023 18:28:02 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-Nh_E0h-6Mw-4BxLY0NjCbQ-1; Mon, 22 May 2023 14:28:00 -0400
X-MC-Unique: Nh_E0h-6Mw-4BxLY0NjCbQ-1
Received: by mail-qk1-f175.google.com with SMTP id
 af79cd13be357-7577e7a83a2so309856285a.3
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:28:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684780080; x=1687372080;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=p7GzxNEPB5RrqIL7H106LwNVqNBV2sg10P6y5N7WaSk=;
 b=X3R1mRO9WVWlx1w2jUWRKDPJTvrHQDa2InlBS49R2kA7d11n09+S7TkB7QhaGfvXeG
 N02xU/1WyFRRLcBDBC0pgBa4zqJEFQxnToFo67Xcwl7xjIzy3/qVjAMAuuTrn8AwNShC
 lOb6Iwb36Vp7UrzgTLlcZXiPeNEiBxalNPImh/CHUQzY2eWyfMIt+O+5wDi8U6hBiq2S
 0BP2sNmkx0qKcIu6xe7uqY7PpSKS4WonWkpzcA6Ubl2f//p266C3RVCD6crxXPOe6QPy
 maEyJJP5AATdSVLTurgDBCjC3akj2zKLwUbbVtsWiA8Wo6JgZ+kJ4UdVkWG8JY5/KMO7
 KDqw==
X-Gm-Message-State: AC+VfDwG3n/LfvUCwO3KAEmV+K5IWzIpMCQkc1ilqkFk/uP9zn5ozVTW
 HlSiqi4k6kZi4fLV4TLyaLlQeZI=
X-Google-Smtp-Source: ACHHUZ5cNHDfNJtYuuNT8G4J5JsInsTlSg1wDbr/+6XLCC/c6hq9pMKzuHMG58VXqxmVmQvtSAcUtw==
X-Received: by 2002:a05:6214:f22:b0:625:833e:8825 with SMTP id
 iw2-20020a0562140f2200b00625833e8825mr5440304qvb.4.1684780079641; 
 Mon, 22 May 2023 11:27:59 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 u12-20020a0ced2c000000b0061b5c45f970sm2137700qvq.74.2023.05.22.11.27.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 May 2023 11:27:59 -0700 (PDT)
Date: Mon, 22 May 2023 14:27:57 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Dave Chinner <david@fromorbit.com>, Joe Thornber <ejt@redhat.com>
Message-ID: <ZGu0LaQfREvOQO4h@redhat.com>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <ZGb2Xi6O3i2pLam8@infradead.org> <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <ZGgBQhsbU9b0RiT1@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 19 2023 at  7:07P -0400,
Dave Chinner <david@fromorbit.com> wrote:

> On Fri, May 19, 2023 at 10:41:31AM -0400, Mike Snitzer wrote:
> > On Fri, May 19 2023 at 12:09P -0400,
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > FYI, I really don't think this primitive is a good idea.  In the
> > > concept of non-overwritable storage (NAND, SMR drives) the entire
> > > concept of a one-shoot 'provisioning' that will guarantee later writes
> > > are always possible is simply bogus.
> > 
> > Valid point for sure, such storage shouldn't advertise support (and
> > will return -EOPNOTSUPP).
> > 
> > But the primitive still has utility for other classes of storage.
> 
> Yet the thing people are wanting to us filesystem developers to use
> this with is thinly provisioned storage that has snapshot
> capability. That, by definition, is non-overwritable storage. These
> are the use cases people are asking filesystes to gracefully handle
> and report errors when the sparse backing store runs out of space.

DM thinp falls into this category but as you detailed it can be made
to work reliably. To carry that forward we need to first establish
the REQ_PROVISION primitive (with this series).

Follow-on associated dm-thinp enhancements can then serve as reference
for how to take advantage of XFS's ability to operate reliably of
thinly provisioned storage.
 
> e.g. journal writes after a snapshot is taken on a busy filesystem
> are always an overwrite and this requires more space in the storage
> device for the write to succeed. ENOSPC from the backing device for
> journal IO is a -fatal error-. Hence if REQ_PROVISION doesn't
> guarantee space for overwrites after snapshots, then it's not
> actually useful for solving the real world use cases we actually
> need device-level provisioning to solve.
> 
> It is not viable for filesystems to have to reprovision space for
> in-place metadata overwrites after every snapshot - the filesystem
> may not even know a snapshot has been taken! And it's not feasible
> for filesystems to provision on demand before they modify metadata
> because we don't know what metadata is going to need to be modified
> before we start modifying metadata in transactions. If we get ENOSPC
> from provisioning in the middle of a dirty transcation, it's all
> over just the same as if we get ENOSPC during metadata writeback...
> 
> Hence what filesystems actually need is device provisioned space to
> be -always over-writable- without ENOSPC occurring.  Ideally, if we
> provision a range of the block device, the block device *must*
> guarantee all future writes to that LBA range succeeds. That
> guarantee needs to stand until we discard or unmap the LBA range,
> and for however many writes we do to that LBA range.
> 
> e.g. If the device takes a snapshot, it needs to reprovision the
> potential COW ranges that overlap with the provisioned LBA range at
> snapshot time. e.g. by re-reserving the space from the backing pool
> for the provisioned space so if a COW occurs there is space
> guaranteed for it to succeed.  If there isn't space in the backing
> pool for the reprovisioning, then whatever operation that triggers
> the COW behaviour should fail with ENOSPC before doing anything
> else....

Happy to implement this in dm-thinp.  Each thin block will need a bit
to say if the block must be REQ_PROVISION'd at time of snapshot (and
the resulting block will need the same bit set).

Walking all blocks of a thin device and triggering REQ_PROVISION for
each will obviously make thin snapshot creation take more time.

I think this approach is better than having a dedicated bitmap hooked
off each thin device's metadata (with bitmap being copied and walked
at the time of snapshot). But we'll see... I'll get with Joe to
discuss further.

> Software devices like dm-thin/snapshot should really only need to
> keep a persistent map of the provisioned space and refresh space
> reservations for used space within that map whenever something that
> triggers COW behaviour occurs. i.e. a snapshot needs to reset the
> provisioned ranges back to "all ranges are freshly provisioned"
> before the snapshot is started. If that space is not available in
> the backing pool, then the snapshot attempt gets ENOSPC....
> 
> That means filesystems only need to provision space for journals and
> fixed metadata at mkfs time, and they only need issue a
> REQ_PROVISION bio when they first allocate over-write in place
> metadata. We already have online discard and/or fstrim for releasing
> provisioned space via discards.
> 
> This will require some mods to filesystems like ext4 and XFS to
> issue REQ_PROVISION and fail gracefully during metadata allocation.
> However, doing so means that we can actually harden filesystems
> against sparse block device ENOSPC errors by ensuring they will
> never occur in critical filesystem structures....

Yes, let's finally _do_ this! ;)

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


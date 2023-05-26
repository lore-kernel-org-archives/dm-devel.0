Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA58C77B7C
	for <dm-devel@archiver.kernel.org>; Sat, 27 May 2023 00:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685146194;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uXJSZk8HuA+x0r8SVYO6hksUW9ND74be2QvpQeHDFzY=;
	b=TCVCvy6MLAzBu04m0bfplr7BBQiCluk7Tdtv/Amq48fuy96kN6JevVmDX8aYdlL62fwfT+
	+5CmKXNGbiwfJ7SbkYUTm+nIu2IvmKXGdU3TLsMOtyq6++C+3sterd5dDA9X9pw0VjwnoF
	hxZfcRHgAvbBtPPPJMS3BGfpjvuztD8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-GKgxW9_TOAevukG7yba3Hw-1; Fri, 26 May 2023 20:09:51 -0400
X-MC-Unique: GKgxW9_TOAevukG7yba3Hw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 194B829AA2D4;
	Sat, 27 May 2023 00:09:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 40E1D492B00;
	Sat, 27 May 2023 00:09:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14D1819465A8;
	Sat, 27 May 2023 00:09:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 808B119465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 23:45:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 700F4401024; Fri, 26 May 2023 23:45:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 68163492B00
 for <dm-devel@redhat.com>; Fri, 26 May 2023 23:45:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B83D28237C1
 for <dm-devel@redhat.com>; Fri, 26 May 2023 23:45:09 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-RKaXNredOQ23rj62nyZASQ-1; Fri, 26 May 2023 19:45:07 -0400
X-MC-Unique: RKaXNredOQ23rj62nyZASQ-1
Received: by mail-pf1-f172.google.com with SMTP id
 d2e1a72fcca58-64d24136663so1100085b3a.0
 for <dm-devel@redhat.com>; Fri, 26 May 2023 16:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685144706; x=1687736706;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=CWzxmQ8QxCg8O8dff9yLq2U6+xkvzRDR890XcXfK3mg=;
 b=d+ZknqqRmdqGXst1XieSj8W8bk5ViNL04P6wYpxvM+OKeVbj4XuHgtwIAqu5jtpcAT
 fjfQS5mRjaxvZXxQE0vcnnC3NaM5BPme+cWc3hn1WW+c/CGu/vcR/IOeC1KVNwUb3+RF
 goFfbHasmazPovAr5E7N9BwzNF9XnDjnLDtPWsi0gtZ5mVUVkIGMM2+W6PMuJojKZhdI
 RuMmmubWaHdUXOY0uCXVxzc1l6Wk4DA+w8PRJp4OBQfir/8OVIBG7GHbHl4UHValGsdC
 yUbSBD99ZRg54C4Ynut6Qc7xfyST6yZHmXHUjhv0TfAjiPI1YlZn/OvuuQ1gSzM3xNAR
 VXtg==
X-Gm-Message-State: AC+VfDzhoYaR65TvDhmCdwyw9BsZ+FFzFuwlENGH45viYdb1tV69F+c/
 ScqyN1RRG0783z0C6YOfd0Mxng==
X-Google-Smtp-Source: ACHHUZ4K3iebgteK6vCXrRpRxz8VUX6r/9jfq7BcWqxhVfO6CgyxLnisMFr2+io1W37C8mIwj9ZXTw==
X-Received: by 2002:a05:6a00:2d88:b0:64c:ecf7:f49a with SMTP id
 fb8-20020a056a002d8800b0064cecf7f49amr5438139pfb.21.1685144706285; 
 Fri, 26 May 2023 16:45:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au.
 [49.179.0.188]) by smtp.gmail.com with ESMTPSA id
 l11-20020a62be0b000000b0064f46570bb7sm3100448pff.167.2023.05.26.16.45.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 26 May 2023 16:45:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q2h7G-004Jsa-2r;
 Sat, 27 May 2023 09:45:02 +1000
Date: Sat, 27 May 2023 09:45:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Joe Thornber <thornber@redhat.com>
Message-ID: <ZHFEfngPyUOqlthr@dread.disaster.area>
References: <ZGb2Xi6O3i2pLam8@infradead.org> <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area>
 <ZGu0LaQfREvOQO4h@redhat.com> <ZGzIJlCE2pcqQRFJ@bfoster>
 <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area> <ZG+KoxDMeyogq4J0@bfoster>
 <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 26, 2023 at 12:04:02PM +0100, Joe Thornber wrote:
> Here's my take:
> 
> I don't see why the filesystem cares if thinp is doing a reservation or
> provisioning under the hood.  All that matters is that a future write
> to that region will be honoured (barring device failure etc.).
> 
> I agree that the reservation/force mapped status needs to be inherited
> by snapshots.
> 
> 
> One of the few strengths of thinp is the performance of taking a snapshot.
> Most snapshots created are never activated.  Many other snapshots are
> only alive for a brief period, and used read-only.  eg, blk-archive
> (https://github.com/jthornber/blk-archive) uses snapshots to do very
> fast incremental backups.  As such I'm strongly against any scheme that
> requires provisioning as part of the snapshot operation.
> 
> Hank and I are in the middle of the range tree work which requires a
> metadata
> change.  So now is a convenient time to piggyback other metadata changes to
> support reservations.
> 
> 
> Given the above this is what I suggest:
> 
> 1) We have an api (ioctl, bio flag, whatever) that lets you
> reserve/guarantee a region:
> 
>   int reserve_region(dev, sector_t begin, sector_t end);

A C-based interface is not sufficient because the layer that must do
provsioning is not guaranteed to be directly under the filesystem.
We must be able to propagate the request down to the layers that
need to provision storage, and that includes hardware devices.

e.g. dm-thin would have to issue REQ_PROVISION on the LBA ranges it
allocates in it's backing device to guarantee that the provisioned
LBA range it allocates is also fully provisioned by the storage
below it....

>   This api should be used minimally, eg, critical FS metadata only.

Keep in mind that "critical FS metadata" in this context is any
metadata which could cause the filesystem to hang or enter a global
error state if an unexpected ENOSPC error occurs during a metadata
write IO.

Which, in pretty much every journalling filesystem, equates to all
metadata in the filesystem. For a typical root filesystem, that
might be a in the range of a 1-200MB (depending on journal size).
For larger filesytems with lots of files in them, it will be in the
range of GBs of space.

Plan for having to support tens of GBs of provisioned space in
filesystems, not tens of MBs....

[snip]

> Now this is a lot of work.  As well as the kernel changes we'll need to
> update the userland tools: thin_check, thin_ls, thin_metadata_unpack,
> thin_rmap, thin_delta, thin_metadata_pack, thin_repair, thin_trim,
> thin_dump, thin_metadata_size, thin_restore.  Are we confident that we
> have buy in from the FS teams that this will be widely adopted?  Are users
> asking for this?  I really don't want to do 6 months of work for nothing.

I think there's a 2-3 solid days of coding to fully implement
REQ_PROVISION support in XFS, including userspace tool support.
Maybe a couple of weeks more to flush the bugs out before it's
largely ready to go.

So if there's buy in from the block layer and DM people for
REQ_PROVISION as described, then I'll definitely have XFS support
ready for you to test whenever dm-thinp is ready to go.

I can't speak for other filesystems, I suspect the only one we care
about is ext4.  btrfs and f2fs don't need dm-thinp and there aren't
any other filesystems that are used in production on top of
dm-thinp, so I think only XFS and ext4 matter at this point in time.

I suspect that ext4 would be fairly easy to add support for as well.
ext4 has a lot more fixed-place metadata than XFS has so much more
of it's metadata is covered by mkfs-time provisioning. Limiting
dynamic metadata to specific fully provisioned block groups and
provisioning new block groups for metadata when they are near full
would be equivalent to how I plan to provision metadata space in
XFS. Hence the implementation for ext4 looks to be broadly similar
in scope and complexity as XFS....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276DBC77B75
	for <dm-devel@archiver.kernel.org>; Fri, 19 May 2023 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684537695;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3XKgysg/bjY8kgMB5OfP2HwIGMnPtuebyoEUhSjt/3E=;
	b=YzJli817XG0dQQmZm9tR7xUQhHmEfrTWZTTOSEL+RMBZCyx0pbWIDC6joZwnZM+9YYQoMD
	uH+oCH8EHKnawDXo7jI72uqtdQM/Eeseo39XVyYKAzX5R3Va84nhgqNCfKdrmry70zFBXa
	wrpmc82qHDmxwNo3IOsifwRegSOzbLs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-RCpO1ODnMfm6FFR84Vb9rA-1; Fri, 19 May 2023 19:08:11 -0400
X-MC-Unique: RCpO1ODnMfm6FFR84Vb9rA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74AFD8007D9;
	Fri, 19 May 2023 23:08:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 262E27B7C;
	Fri, 19 May 2023 23:08:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CDAD919465B2;
	Fri, 19 May 2023 23:08:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE66019465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 19 May 2023 23:07:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1703DC54184; Fri, 19 May 2023 23:07:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E909C0004B
 for <dm-devel@redhat.com>; Fri, 19 May 2023 23:07:53 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B658101A52C
 for <dm-devel@redhat.com>; Fri, 19 May 2023 23:07:53 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-VLkXPDRtPH-bSHkuH14uUg-1; Fri, 19 May 2023 19:07:51 -0400
X-MC-Unique: VLkXPDRtPH-bSHkuH14uUg-1
Received: by mail-pf1-f181.google.com with SMTP id
 d2e1a72fcca58-64d2da69fdfso1920604b3a.0
 for <dm-devel@redhat.com>; Fri, 19 May 2023 16:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684537670; x=1687129670;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=vej0HUXiqshmcvqs7VBZTGkCXU+JddJuVreKpbmYuhw=;
 b=B9teHW12aF3660rHpXLKnzsdDj4xpgktCR8p8xYuFdITkB8MZ3t4vpsyVYoGecAkCM
 rUCGdh3fMnIRU/1C7oj3s3RVh7ZmsNTwxslnUYXlRBuaHyPRwmLe/1MUz+h+2UrCpq1z
 EwSXWNnheOYZPl/Dg6lomVxstchaGYHQ1Npn8PLk3voeCImyaJxwD5FtfjpD5q3JAe/j
 9DV8YL0u2Y+lAOIGhFajNRHI2oUNKpixZXIlJOxh8j31GkEAxgcGReSsMFpRWKSfrzgV
 3fWyWlylr1cU9Ly9n2/1XcKLFjG6B8wzHfkK9J7pXNA7cfsamW4znBAiAP5hh1hRoTVD
 Zd7w==
X-Gm-Message-State: AC+VfDxfz3/BhijjJGbVv0eAVbipvAJK4g1u8UzdJdClDH334xOQXSkh
 /tj69XO/9WeVyX0SRu9sLQmaRXOab3HcQo1oJ+g=
X-Google-Smtp-Source: ACHHUZ44Ml1ojpiPU8i/+mCvFac8UKDWss2kgW+R+G0QKFHgCdmutJq5p5DRKhkFYnyqqBTN1Dtx1w==
X-Received: by 2002:a05:6a00:1896:b0:63b:854c:e0f6 with SMTP id
 x22-20020a056a00189600b0063b854ce0f6mr5344668pfh.21.1684537670148; 
 Fri, 19 May 2023 16:07:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au.
 [49.179.0.188]) by smtp.gmail.com with ESMTPSA id
 i6-20020aa78d86000000b006414289ab69sm204704pfr.52.2023.05.19.16.07.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 May 2023 16:07:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q09CM-001WVR-2G;
 Sat, 20 May 2023 09:07:46 +1000
Date: Sat, 20 May 2023 09:07:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <ZGgBQhsbU9b0RiT1@dread.disaster.area>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <ZGb2Xi6O3i2pLam8@infradead.org> <ZGeKm+jcBxzkMXQs@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZGeKm+jcBxzkMXQs@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 19, 2023 at 10:41:31AM -0400, Mike Snitzer wrote:
> On Fri, May 19 2023 at 12:09P -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > FYI, I really don't think this primitive is a good idea.  In the
> > concept of non-overwritable storage (NAND, SMR drives) the entire
> > concept of a one-shoot 'provisioning' that will guarantee later writes
> > are always possible is simply bogus.
> 
> Valid point for sure, such storage shouldn't advertise support (and
> will return -EOPNOTSUPP).
> 
> But the primitive still has utility for other classes of storage.

Yet the thing people are wanting to us filesystem developers to use
this with is thinly provisioned storage that has snapshot
capability. That, by definition, is non-overwritable storage. These
are the use cases people are asking filesystes to gracefully handle
and report errors when the sparse backing store runs out of space.

e.g. journal writes after a snapshot is taken on a busy filesystem
are always an overwrite and this requires more space in the storage
device for the write to succeed. ENOSPC from the backing device for
journal IO is a -fatal error-. Hence if REQ_PROVISION doesn't
guarantee space for overwrites after snapshots, then it's not
actually useful for solving the real world use cases we actually
need device-level provisioning to solve.

It is not viable for filesystems to have to reprovision space for
in-place metadata overwrites after every snapshot - the filesystem
may not even know a snapshot has been taken! And it's not feasible
for filesystems to provision on demand before they modify metadata
because we don't know what metadata is going to need to be modified
before we start modifying metadata in transactions. If we get ENOSPC
from provisioning in the middle of a dirty transcation, it's all
over just the same as if we get ENOSPC during metadata writeback...

Hence what filesystems actually need is device provisioned space to
be -always over-writable- without ENOSPC occurring.  Ideally, if we
provision a range of the block device, the block device *must*
guarantee all future writes to that LBA range succeeds. That
guarantee needs to stand until we discard or unmap the LBA range,
and for however many writes we do to that LBA range.

e.g. If the device takes a snapshot, it needs to reprovision the
potential COW ranges that overlap with the provisioned LBA range at
snapshot time. e.g. by re-reserving the space from the backing pool
for the provisioned space so if a COW occurs there is space
guaranteed for it to succeed.  If there isn't space in the backing
pool for the reprovisioning, then whatever operation that triggers
the COW behaviour should fail with ENOSPC before doing anything
else....

Software devices like dm-thin/snapshot should really only need to
keep a persistent map of the provisioned space and refresh space
reservations for used space within that map whenever something that
triggers COW behaviour occurs. i.e. a snapshot needs to reset the
provisioned ranges back to "all ranges are freshly provisioned"
before the snapshot is started. If that space is not available in
the backing pool, then the snapshot attempt gets ENOSPC....

That means filesystems only need to provision space for journals and
fixed metadata at mkfs time, and they only need issue a
REQ_PROVISION bio when they first allocate over-write in place
metadata. We already have online discard and/or fstrim for releasing
provisioned space via discards.

This will require some mods to filesystems like ext4 and XFS to
issue REQ_PROVISION and fail gracefully during metadata allocation.
However, doing so means that we can actually harden filesystems
against sparse block device ENOSPC errors by ensuring they will
never occur in critical filesystem structures....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


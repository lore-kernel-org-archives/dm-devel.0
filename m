Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBAD2C7EE2F
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 00:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684888849;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AqwbnvyVQH0DGsmXduB23TyaMPsXS1FnGobPZISSdsM=;
	b=dAIWZrAZYvcECVociiRj7DWv0hKMoCPaYhKt+cpoyeBDau9qbSFmH8dSenXPd82lcJFORN
	A6Lq0qeOiu2tA2aKKV3mXPBIc1ztvGdPLB0TdIBoUwGmJ1jZgWqF9tgwViCi6WhC5VPD0J
	B4/Q47OAYbxvW/OvJmxnjiPG+d7wmas=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-KxjhwDCdMrSX_26F9GVGLg-1; Tue, 23 May 2023 20:40:48 -0400
X-MC-Unique: KxjhwDCdMrSX_26F9GVGLg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7721185A78B;
	Wed, 24 May 2023 00:40:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB09D492B00;
	Wed, 24 May 2023 00:40:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A4C9B19465A8;
	Wed, 24 May 2023 00:40:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA32819465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 00:40:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BA42F140E961; Wed, 24 May 2023 00:40:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B202D140E95D
 for <dm-devel@redhat.com>; Wed, 24 May 2023 00:40:41 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [170.10.128.131])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 937D429AA38A
 for <dm-devel@redhat.com>; Wed, 24 May 2023 00:40:41 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-3ApBt1gSN8--jeL85sTD0g-1; Tue, 23 May 2023 20:40:39 -0400
X-MC-Unique: 3ApBt1gSN8--jeL85sTD0g-1
Received: by mail-pl1-f181.google.com with SMTP id
 d9443c01a7336-1ae615d5018so2526375ad.1
 for <dm-devel@redhat.com>; Tue, 23 May 2023 17:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684888838; x=1687480838;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=g/2lRTEp2+vzgxmK+Q6yLfn+3h/GnU4pORxpfbfgDDM=;
 b=eS5PGj7rWXkGPD6xge0ehA+E97xFQQFxVQ7dHrFT4D+q2SB1WPSu45FMOUCvj63fqC
 dA0dc8KnkjodpMByTFEo0DuN7eN6BnJAYrhb4EUBcIloewWC5XbiTBA9KJv1E6JQPMtK
 fMUhziK5xbLu/pZfJLDgkAF2StDLajEde0/byiWkT8ugvQL0IipAdyes2FRvJFaGF6oP
 zxpYkgX9xFsOGkzOEfppAqLbmntAl5wH6S5x879jfDzXwn6P+JbFD2BvpAl3LRT+3HKR
 2jH96mkGGi8bgG8aKVc3w6/L//+R+79qnmhCqWl/6fpVVbTflWdi85VjvkaeSBDpX2eY
 kDQQ==
X-Gm-Message-State: AC+VfDyBXCwVAkKKiZwUnzOWvxcw0xBhyvd8iFnSCtyyJ5K5byPM4a51
 71E8Gjh4/M8dp9zqKquDMkDP+A==
X-Google-Smtp-Source: ACHHUZ4ELvS95kgltWKKI0sQaRwhfv49xLXoR0zfldqDVRDWfmH/jNA6qFVcem5euAQDD7dhRn3rkg==
X-Received: by 2002:a17:903:32c7:b0:1ae:513a:9439 with SMTP id
 i7-20020a17090332c700b001ae513a9439mr20480732plr.23.1684888838637; 
 Tue, 23 May 2023 17:40:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au.
 [49.179.0.188]) by smtp.gmail.com with ESMTPSA id
 u12-20020a17090282cc00b001a212a93295sm7370900plz.189.2023.05.23.17.40.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 17:40:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q1cYM-0038PM-19;
 Wed, 24 May 2023 10:40:34 +1000
Date: Wed, 24 May 2023 10:40:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <ZG1dAtHmbQ53aOhA@dread.disaster.area>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <ZGb2Xi6O3i2pLam8@infradead.org> <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area>
 <ZGu0LaQfREvOQO4h@redhat.com> <ZGzIJlCE2pcqQRFJ@bfoster>
 <ZGzbGg35SqMrWfpr@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZGzbGg35SqMrWfpr@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
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

On Tue, May 23, 2023 at 11:26:18AM -0400, Mike Snitzer wrote:
> On Tue, May 23 2023 at 10:05P -0400, Brian Foster <bfoster@redhat.com> wrote:
> > On Mon, May 22, 2023 at 02:27:57PM -0400, Mike Snitzer wrote:
> > ... since I also happen to think there is a potentially interesting
> > development path to make this sort of reserve pool configurable in terms
> > of size and active/inactive state, which would allow the fs to use an
> > emergency pool scheme for managing metadata provisioning and not have to
> > track and provision individual metadata buffers at all (dealing with
> > user data is much easier to provision explicitly). So the space
> > inefficiency thing is potentially just a tradeoff for simplicity, and
> > filesystems that want more granularity for better behavior could achieve
> > that with more work. Filesystems that don't would be free to rely on the
> > simple/basic mechanism provided by dm-thin and still have basic -ENOSPC
> > protection with very minimal changes.
> > 
> > That's getting too far into the weeds on the future bits, though. This
> > is essentially 99% a dm-thin approach, so I'm mainly curious if there's
> > sufficient interest in this sort of "reserve mode" approach to try and
> > clean it up further and have dm guys look at it, or if you guys see any
> > obvious issues in what it does that makes it potentially problematic, or
> > if you would just prefer to go down the path described above...
> 
> The model that Dave detailed, which builds on REQ_PROVISION and is
> sticky (by provisioning same blocks for snapshot) seems more useful to
> me because it is quite precise.  That said, it doesn't account for
> hard requirements that _all_ blocks will always succeed.

Hmmm. Maybe I'm misunderstanding the "reserve pool" context here,
but I don't think we'd ever need a hard guarantee from the block
device that every write bio issued from the filesystem will succeed
without ENOSPC.

If the block device can provide a guarantee that a provisioned LBA
range is always writable, then everything else is a filesystem level
optimisation problem and we don't have to involve the block device
in any way. All we need is a flag we can ready out of the bdev at
mount time to determine if the filesystem should be operating with
LBA provisioning enabled...

e.g. If we need to "pre-provision" a chunk of the LBA space for
filesystem metadata, we can do that ahead of time and track the
pre-provisioned range(s) in the filesystem itself.

In XFS, That could be as simple as having small chunks of each AG
reserved to metadata (e.g. start with the first 100MB) and limiting
all metadata allocation free space searches to that specific block
range. When we run low on that space, we pre-provision another 100MB
chunk and then allocate all metadata out of that new range. If we
start getting ENOSPC to pre-provisioning, then we reduce the size of
the regions and log low space warnings to userspace. If we can't
pre-provision any space at all and we've completely run out, we
simply declare ENOSPC for all incoming operations that require
metadata allocation until pre-provisioning succeeds again.

This is built entirely on the premise that once proactive backing
device provisioning fails, the backing device is at ENOSPC and we
have to wait for that situation to go away before allowing new data
to be ingested. Hence the block device really doesn't need to know
anything about what the filesystem is doing and vice versa - The
block dev just says "yes" or "no" and the filesystem handles
everything else.

It's worth noting that XFS already has a coarse-grained
implementation of preferred regions for metadata storage. It will
currently not use those metadata-preferred regions for user data
unless all the remaining user data space is full.  Hence I'm pretty
sure that a pre-provisioning enhancment like this can be done
entirely in-memory without requiring any new on-disk state to be
added.

Sure, if we crash and remount, then we might chose a different LBA
region for pre-provisioning. But that's not really a huge deal as we
could also run an internal background post-mount fstrim operation to
remove any unused pre-provisioning that was left over from when the
system went down.

Further, managing shared pool exhaustion doesn't require a
reservation pool in the backing device and for the filesystems to
request space from it. Filesystems already have their own reserve
pools via pre-provisioning. If we want the filesystems to be able to
release that space back to the shared pool (e.g. because the shared
backing pool is critically short on space) then all we need is an
extension to FITRIM to tell the filesystem to also release internal
pre-provisioned reserves.

Then the backing pool admin (person or automated daemon!) can simply
issue a trim on all the filesystems in the pool and spce will be
returned. Then filesystems will ask for new pre-provisioned space
when they next need to ingest modifications, and the backing pool
can manage the new pre-provisioning space requests directly....

Hence I think if we get the basic REQ_PROVISION overwrite-in-place
guarantees defined and implemented as previously outlined, then we
don't need any special coordination between the fs and block devices
to avoid fatal ENOSPC issues with sparse and/or snapshot capable
block devices...

As a bonus, if we can implement the guarantees in dm-thin/-snapshot
and have a filesystem make use of it, then we also have a reference
implementation to point at device vendors and standards
associations....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


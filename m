Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27326C77B7C
	for <dm-devel@archiver.kernel.org>; Fri, 12 May 2023 18:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683916125;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ojgras4PIf+sUJB0OMPUwrzwc34nGvoOR8fL86qv7D0=;
	b=eoxbKEdNfKGmmR0tpY53ddPpgtjZm+t55MpJJHomatKKnjXqKKDgRjJzjW9K1l68f13aXs
	qVIU7fFK7SmX6MHtmzpYFL+w0oxWwefES80nz+1A4ll+EB026yq66gIkGjgdx9JXIWQ+Ru
	+9+7lfQkix/TDJC+IZZ4p1MyjAnzxGQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-J7H6Z7lWPt-HxBPT50dSAQ-1; Fri, 12 May 2023 14:28:41 -0400
X-MC-Unique: J7H6Z7lWPt-HxBPT50dSAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5BBD3C0252B;
	Fri, 12 May 2023 18:28:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49BAC1121314;
	Fri, 12 May 2023 18:28:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F023E19451E4;
	Fri, 12 May 2023 18:28:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 789EF19451E3
 for <dm-devel@listman.corp.redhat.com>; Fri, 12 May 2023 18:28:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3AAB2492B07; Fri, 12 May 2023 18:28:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 336E0492C13
 for <dm-devel@redhat.com>; Fri, 12 May 2023 18:28:37 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 163C73814954
 for <dm-devel@redhat.com>; Fri, 12 May 2023 18:28:37 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-nmpp1NGLN7a5b43JHAu9sg-1; Fri, 12 May 2023 14:28:33 -0400
X-MC-Unique: nmpp1NGLN7a5b43JHAu9sg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 33AF3657D6;
 Fri, 12 May 2023 18:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88631C433EF;
 Fri, 12 May 2023 18:28:31 +0000 (UTC)
Date: Fri, 12 May 2023 11:28:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <20230512182831.GC858791@frogsfrogsfrogs>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230506062909.74601-1-sarthakkukreti@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v6 0/5] Introduce block provisioning
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
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 05, 2023 at 11:29:04PM -0700, Sarthak Kukreti wrote:
> Hi,
> 
> This patch series covers iteration 6 of adding support for block
> provisioning requests.

I didn't even notice there was a v6.  Could you start a fresh thread
when you bump the revision count, please?

--D

> Changes from v5:
> - Remove explicit supports_provision from dm devices.
> - Move provision sectors io hint to pool_io_hint. Other devices
>   will derive the provisioning limits from the stack.
> - Remove artifact from v4 to omit cell_defer_no_holder for
>   REQ_OP_PROVISION.
> - Fix blkdev_fallocate() called with invalid fallocate
>   modes to propagate errors correctly.
> 
> Sarthak Kukreti (5):
>   block: Don't invalidate pagecache for invalid falloc modes
>   block: Introduce provisioning primitives
>   dm: Add block provisioning support
>   dm-thin: Add REQ_OP_PROVISION support
>   loop: Add support for provision requests
> 
>  block/blk-core.c              |  5 +++
>  block/blk-lib.c               | 53 ++++++++++++++++++++++++++
>  block/blk-merge.c             | 18 +++++++++
>  block/blk-settings.c          | 19 ++++++++++
>  block/blk-sysfs.c             |  9 +++++
>  block/bounce.c                |  1 +
>  block/fops.c                  | 31 +++++++++++++---
>  drivers/block/loop.c          | 42 +++++++++++++++++++++
>  drivers/md/dm-crypt.c         |  4 +-
>  drivers/md/dm-linear.c        |  1 +
>  drivers/md/dm-snap.c          |  7 ++++
>  drivers/md/dm-table.c         | 23 ++++++++++++
>  drivers/md/dm-thin.c          | 70 +++++++++++++++++++++++++++++++++--
>  drivers/md/dm.c               |  6 +++
>  include/linux/bio.h           |  6 ++-
>  include/linux/blk_types.h     |  5 ++-
>  include/linux/blkdev.h        | 16 ++++++++
>  include/linux/device-mapper.h | 17 +++++++++
>  18 files changed, 319 insertions(+), 14 deletions(-)
> 
> -- 
> 2.40.1.521.gf1e218fcd8-goog
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


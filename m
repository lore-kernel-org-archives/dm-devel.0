Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9D9E95A67
	for <dm-devel@archiver.kernel.org>; Sun,  8 Oct 2023 23:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696807665;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gy6nrA8k5/e+cGtK5lCJYynwJ42cdEX4HLexYGcxBMs=;
	b=ONTvz1KRPQMbdcLTxfw5iOM+tWKDWgKYkXInBJd51OXmKIFiirMRGVKQzHS6sDtJdm+vs9
	qIZYcOhr0VEe71/zlbNTysCbgGxKrghBQBVYok03EmU86lElJuEs1PiW2BW5OsVH+biUeb
	ADDTxAzffopxEAExnJfxCFc/8YfxZxU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-fCZHVuYLNzavs3D_VvtKFw-1; Sun, 08 Oct 2023 19:27:41 -0400
X-MC-Unique: fCZHVuYLNzavs3D_VvtKFw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29DD1805BAC;
	Sun,  8 Oct 2023 23:27:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5123420268C8;
	Sun,  8 Oct 2023 23:27:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D70761946595;
	Sun,  8 Oct 2023 23:27:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DDA01194658C
 for <dm-devel@listman.corp.redhat.com>; Sun,  8 Oct 2023 23:27:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AA4CE20268CB; Sun,  8 Oct 2023 23:27:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A206520268C8
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:27:35 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 835738039C1
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:27:35 +0000 (UTC)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-OtLCHxCVOrWRqFQj6zpSKQ-1; Sun, 08 Oct 2023 19:27:33 -0400
X-MC-Unique: OtLCHxCVOrWRqFQj6zpSKQ-1
Received: by mail-pj1-f50.google.com with SMTP id
 98e67ed59e1d1-2773523b2b6so2259451a91.2
 for <dm-devel@redhat.com>; Sun, 08 Oct 2023 16:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696807652; x=1697412452;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=aS5wnORfWJ02Ic4UlNgXgG7erca/6rPk7A+dIWgu1xE=;
 b=bKh0VGykulLiTQijSW6ntbokXl2r8G+i+yT8tJfOrD02VKG8f0Qm+AWsoLc5UV2BzL
 JaRFHJkbuBPCDl1A6pQ4hyRWBuJ7UVHX5e28IqzOWnbMjtc+oxE4VBPa04Kz+yIq8t1g
 zOKP+MLZpekZ830UDFfiFfBAqTVUtqC6lG6LjNGmI0Uv4zG+c77BkxNqNgCrXwiWy8av
 SrhfxMkGwW3Oo1T/A5VSbWAvSckLBAU2j9GopD8dloHLtml6p1tTM/+jIuU2w7LdgJzr
 rF5AWTlVifSMEsh7lNsTpebSlidmIRzWgFGSHifywJY2ZN0GfH29WyiyUOGcHTEEYl2Z
 5taA==
X-Gm-Message-State: AOJu0YwvhD/e4UTZlJPsfxs4/5XbfnvrXuETfxaMxYmCyOn6wB6fOcOX
 lkz73+4N0kFKh5GJZ4lMDJQftQ==
X-Google-Smtp-Source: AGHT+IGc6rajtNnnrMTfh5c1WN82wupHs7ltG+HbFIhM8I8+f4cQIL9QXxrn5Dk/ibag1JxJfP4QTg==
X-Received: by 2002:a17:90b:4b06:b0:273:e689:8dfc with SMTP id
 lx6-20020a17090b4b0600b00273e6898dfcmr11740281pjb.32.1696807652373; 
 Sun, 08 Oct 2023 16:27:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au.
 [49.180.20.59]) by smtp.gmail.com with ESMTPSA id
 az12-20020a17090b028c00b0026d4100e0e8sm6954450pjb.10.2023.10.08.16.27.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 08 Oct 2023 16:27:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qpdBI-00BHvI-0p;
 Mon, 09 Oct 2023 10:27:28 +1100
Date: Mon, 9 Oct 2023 10:27:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZSM64EOTVyKNkc/X@dread.disaster.area>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
 <20231007012817.3052558-6-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20231007012817.3052558-6-sarthakkukreti@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v8 5/5] block: Pass unshare intent via
 REQ_OP_PROVISION
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
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 06, 2023 at 06:28:17PM -0700, Sarthak Kukreti wrote:
> Allow REQ_OP_PROVISION to pass in an extra REQ_UNSHARE bit to
> annotate unshare requests to underlying layers. Layers that support
> FALLOC_FL_UNSHARE will be able to use this as an indicator of which
> fallocate() mode to use.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  block/blk-lib.c           |  6 +++++-
>  block/fops.c              |  6 ++++--
>  drivers/block/loop.c      | 35 +++++++++++++++++++++++++++++------
>  include/linux/blk_types.h |  3 +++
>  include/linux/blkdev.h    |  3 ++-
>  5 files changed, 43 insertions(+), 10 deletions(-)

I have no idea how filesystems (or even userspace applications, for
that matter) are supposed to use this - they have no idea if the
underlying block device has shared blocks for LBA ranges it already
has allocated and provisioned. IOWs, I don't know waht the semantics
of this function is, it is not documented anywhere, and there is no
use case present that tells me how it might get used.

Yes, unshare at the file level means the filesystem tries to break
internal data extent sharing, but if the block layers or backing
devices are doing deduplication and sharing unknown to the
application or filesystem, how do they ever know that this operation
might need to be performed? In what cases do we need to be able to
unshare block device ranges, and how is that different to the
guarantees that REQ_PROVISION is already supposed to give for
provisioned ranges that are then subsequently shared by the block
device (e.g. by snapshots)?

Also, from an API perspective, this is an "unshare" data operation,
not a "provision" operation. Hence I'd suggest that the API should
be blkdev_issue_unshare() rather than optional behaviour to
_provision() which - before this patch - had clear and well defined
meaning....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79993C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jan 2022 01:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641866223;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yDMGpQb18CZKC6//QGckD8E5uF5yTXFDb8EMzaMFTMU=;
	b=YJ3OjwX+5YpAo9a150WMZ52oi/9b11FE9eGqGNZvA7z3kuSneGqAZqtmAtG/HWb+lcthT8
	3OB1q/pPpR3dbKTZWe/2nWa5FR9t6U1S/1kPBymyzAbjaEKPw4zlDUWcYi6Pj/j5GO4Rox
	tyEoXmPgeIG0hMnkdDn19oYqTtXZmjk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-7HvWJstuPpG8yvjcmU6ACw-1; Mon, 10 Jan 2022 20:56:59 -0500
X-MC-Unique: 7HvWJstuPpG8yvjcmU6ACw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A386A363A9;
	Tue, 11 Jan 2022 01:56:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C3F95BE1D;
	Tue, 11 Jan 2022 01:56:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 344C94BB7C;
	Tue, 11 Jan 2022 01:56:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20B1ulQU032714 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 20:56:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 039744EE1D; Tue, 11 Jan 2022 01:56:47 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 927A74EDC1;
	Tue, 11 Jan 2022 01:56:41 +0000 (UTC)
Date: Tue, 11 Jan 2022 09:56:36 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <Ydzj1JSoRGz+9g8B@T590>
References: <20220110075141.389532-1-ming.lei@redhat.com>
	<20220110075141.389532-2-ming.lei@redhat.com>
	<YdxuWlZAPJkPyr3h@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YdxuWlZAPJkPyr3h@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	lining <lining2020x@163.com>, Tejun Heo <tj@kernel.org>,
	Chunguang Xu <brookxu@tencent.com>
Subject: Re: [dm-devel] [PATCH 1/2] block: add resubmit_bio_noacct()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 10, 2022 at 09:35:22AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 10, 2022 at 03:51:40PM +0800, Ming Lei wrote:
> > Add block layer API of resubmit_bio_noacct() for handling blk-throttle
> > iops limit correctly. Typical use case is that bio split, and it isn't
> > good to export blk_throtl_charge_bio_split() for drivers, so add new API
> > for serving such purpose.
> 
> Umm, submit_bio_noacct is meant exactly for this case of resubmitting
> a bio.  We should not need another API for that.

Follows the background of the issue first:

1) IOPS limit throttle needs to cover split bio since iostat accounts
split bio actually, and user space setup iops limit throttle by the
feedback from iostat/diskstat;

2) block throttle is block layer internal stuff, and we shouldn't expose
blk_throtl_charge_bio_split() to driver.

Maybe rename the new API as submit_split_bio_noacct(), but we can't
reuse submit_bio_noacct() simply, otherwise blk_throtl_charge_bio_split()
needs to be exported.

Another ides is to clearing BIO_THROTTLED before calling submit_bio_noacct(),
meantime blk-throttle code needs to change to avoid double accounting of bio
bytes, so the caller of submit_bio_noacct() still needs some change.
This way can get smooth IOPS throttle, but needs to call __blk_throtl_bio
for split bio one more time.

Or other idea for this bio split vs. iops limit issue?


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


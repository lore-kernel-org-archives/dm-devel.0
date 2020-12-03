Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EC0C63777
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 07:11:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B6D92086A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 07:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B6D92086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606979481;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ryPUZrIqm9XG7c9YYwruLi/dzB382cv/FOJf6GaqyG8=;
	b=fRcFTxseQeB/dd9VmCBKbU+WTaDuggwKd+Vx1mQoa0rjU33gJJM76KW6dDA0xEn1Zyqp/f
	ROQ7JGgNN+O4xMzItwkY5NMBuPYSEe7mKFBRPU6EkjNoJshEQSqzCj6FsX8NeSX/B3knY+
	1/qkRI3dVL496p8lsXJe2JovL399HZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-RdxPnAPmNeOHNRXt0LJ5Hw-1; Thu, 03 Dec 2020 02:11:19 -0500
X-MC-Unique: RdxPnAPmNeOHNRXt0LJ5Hw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82F3D817B9A;
	Thu,  3 Dec 2020 07:11:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E0A1E13470;
	Thu,  3 Dec 2020 07:11:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BAE1D180954D;
	Thu,  3 Dec 2020 07:11:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B37B9je001528 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 02:11:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EB6CA60BFA; Thu,  3 Dec 2020 07:11:09 +0000 (UTC)
Received: from T590 (ovpn-13-173.pek2.redhat.com [10.72.13.173])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEEDD60BF1;
	Thu,  3 Dec 2020 07:10:59 +0000 (UTC)
Date: Thu, 3 Dec 2020 15:10:55 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201203071055.GA633702@T590>
References: <20201201165424.2030647-1-hch@lst.de>
	<20201201165424.2030647-4-hch@lst.de>
	<20201203063941.GA629758@T590>
MIME-Version: 1.0
In-Reply-To: <20201203063941.GA629758@T590>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 3/9] block: store a block_device pointer in
	struct bio
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03, 2020 at 02:40:04PM +0800, Ming Lei wrote:
> On Tue, Dec 01, 2020 at 05:54:18PM +0100, Christoph Hellwig wrote:
> > Replace the gendisk pointer in struct bio with a pointer to the newly
> > improved struct block device.  From that the gendisk can be trivially
> > accessed with an extra indirection, but it also allows to directly
> > look up all information related to partition remapping.
> 
> The extra indirection is often done in fast path, so just wondering why
> you don't consider to embed gendisk into block_device? Then the extra
> indirection can be avoided.

oops, that is only possible for disk, and indirection is still needed
for partitions.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


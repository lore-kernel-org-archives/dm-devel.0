Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE4B8C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 23 Dec 2021 04:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640233022;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oQagGeAXhW9wcvIWIgCzStQv+d3xnuHKG8hPsgiS3fk=;
	b=UWxUs5VwREJsDPYI9g0M4IIvJpobXetCNPjjd3Qgc0gXK2uDeWX77rBX2l83/HzxN6Rqz4
	hHLEvAhnQ/E1SSrnT9AT4HVlILJLq26pJOk3WPCAamSsTY3t9xGhBlLQBoGRvPR3U/QGv4
	Tuw29E/b9H3PgM7Uu/cHE7yQnYGJpzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-O27pJcpxOMCUKuDPwrOqZA-1; Wed, 22 Dec 2021 23:17:01 -0500
X-MC-Unique: O27pJcpxOMCUKuDPwrOqZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E10BB1800D50;
	Thu, 23 Dec 2021 04:16:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF94F4BC73;
	Thu, 23 Dec 2021 04:16:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A1D314CA93;
	Thu, 23 Dec 2021 04:16:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BN4Goi9018791 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 22 Dec 2021 23:16:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F084101E87D; Thu, 23 Dec 2021 04:16:50 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D2FC1017E27;
	Thu, 23 Dec 2021 04:16:27 +0000 (UTC)
Date: Thu, 23 Dec 2021 12:16:20 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YcP4FMG9an5ReIiV@T590>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
	<YcH/E4JNag0QYYAa@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YcH/E4JNag0QYYAa@infradead.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] blk-mq/dm-rq: support BLK_MQ_F_BLOCKING
	for dm-rq
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 21, 2021 at 08:21:39AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 21, 2021 at 10:14:56PM +0800, Ming Lei wrote:
> > Hello,
> > 
> > dm-rq may be built on blk-mq device which marks BLK_MQ_F_BLOCKING, so
> > dm_mq_queue_rq() may become to sleep current context.
> > 
> > Fixes the issue by allowing dm-rq to set BLK_MQ_F_BLOCKING in case that
> > any underlying queue is marked as BLK_MQ_F_BLOCKING.
> > 
> > DM request queue is allocated before allocating tagset, this way is a
> > bit special, so we need to pre-allocate srcu payload, then use the queue
> > flag of QUEUE_FLAG_BLOCKING for locking dispatch.
> 
> What is the benefit over just forcing bio-based dm-mpath for these
> devices?

At least IO scheduler can't be used for bio based dm-mpath, also there should
be other drawbacks for bio based mpath and request mpath is often the default
option, maybe Mike has more input about bio vs request dm-mpath.



Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A51C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jan 2022 08:48:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-s3GpenIRM9KI8TAF46PTcQ-1; Tue, 11 Jan 2022 03:47:53 -0500
X-MC-Unique: s3GpenIRM9KI8TAF46PTcQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC94583DEA6;
	Tue, 11 Jan 2022 08:47:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E1871F2F4;
	Tue, 11 Jan 2022 08:47:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8868A1809CB8;
	Tue, 11 Jan 2022 08:47:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20B8lkLn027912 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 Jan 2022 03:47:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6C526141DED6; Tue, 11 Jan 2022 08:47:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68013141DED5
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 08:47:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F1703C021A9
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 08:47:46 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-384-XXTriTRCNIqRxra8LTGWPA-1; Tue, 11 Jan 2022 03:47:42 -0500
X-MC-Unique: XXTriTRCNIqRxra8LTGWPA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1n7Cbu-00FKhf-2T; Tue, 11 Jan 2022 08:34:30 +0000
Date: Tue, 11 Jan 2022 00:34:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Yd1BFpYTBlQSPReW@infradead.org>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
	<YcH/E4JNag0QYYAa@infradead.org> <YcP4FMG9an5ReIiV@T590>
	<YcuB4K8P2d9WFb83@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YcuB4K8P2d9WFb83@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 28, 2021 at 04:30:08PM -0500, Mike Snitzer wrote:
> Yeah, people use request-based for IO scheduling and more capable path
> selectors. Imposing bio-based would be a pretty jarring workaround for 
> BLK_MQ_F_BLOCKING. request-based DM should properly support it.

Given that nvme-tcp is the only blocking driver that has multipath
driver that driver explicitly does not intend to support dm-multipath
I'm absolutely against adding block layer cruft for this particular
use case.

SCSI even has this:

	        /*
		 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
		 * calling synchronize_rcu() once is enough.
		 */
		WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


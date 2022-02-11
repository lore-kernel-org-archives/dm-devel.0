Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6719CC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:52:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-Uxsa9x7cPHmGuJKInvCZ1A-1; Fri, 11 Feb 2022 01:52:54 -0500
X-MC-Unique: Uxsa9x7cPHmGuJKInvCZ1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 817F72F25;
	Fri, 11 Feb 2022 06:52:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38450108DA;
	Fri, 11 Feb 2022 06:52:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9F61D1809CB8;
	Fri, 11 Feb 2022 06:52:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B6qjg7016074 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 01:52:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C6F5DC080BA; Fri, 11 Feb 2022 06:52:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C31FBC080B8
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 06:52:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE16F1161A60
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 06:52:45 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-440-HyMoUmiwNXKd7W8CgXmtzQ-1; Fri, 11 Feb 2022 01:52:43 -0500
X-MC-Unique: HyMoUmiwNXKd7W8CgXmtzQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nIPnO-0061Ll-Er; Fri, 11 Feb 2022 06:52:42 +0000
Date: Thu, 10 Feb 2022 22:52:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YgYHuj/GNpShJxcO@infradead.org>
References: <20220210223832.99412-1-snitzer@redhat.com>
	<20220210223832.99412-4-snitzer@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220210223832.99412-4-snitzer@redhat.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 03/14] dm: refactor dm_split_and_process_bio
	a bit
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

> +	error = __split_and_process_bio(&ci);
> +	if (ci.sector_count && !error) {

Maybe turn thisin to

	if (error || !ci.sector_count)
		goto out;

	ci.io->orig_bio = bio_split(bio, bio_sectors(bio) - ci.sector_count,
				    GFP_NOIO, &md->queue->bio_split);
	bio_chain(ci.io->orig_bio, bio);
	trace_block_split(ci.io->orig_bio, bio->bi_iter.bi_sector);
	submit_bio_noacct(bio);

and remove another layer of indentation uing the existing label?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


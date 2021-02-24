Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC86FC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 19:21:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DF32A64EBA
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 19:21:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF32A64EBA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-wzepNTvENx6yrVa07fj4Lw-1; Wed, 24 Feb 2021 14:21:40 -0500
X-MC-Unique: wzepNTvENx6yrVa07fj4Lw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15D84187654F;
	Wed, 24 Feb 2021 19:21:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C16E85D9D3;
	Wed, 24 Feb 2021 19:21:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 20A3F18095CB;
	Wed, 24 Feb 2021 19:21:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11OJLQ7e014059 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 14:21:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 01A68202A422; Wed, 24 Feb 2021 19:21:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F07F32026D48
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 19:21:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 894A81871BF5
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 19:21:23 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-456-cQ3xHrFbMxeDSPM9zGMN_Q-1; Wed, 24 Feb 2021 14:21:18 -0500
X-MC-Unique: cQ3xHrFbMxeDSPM9zGMN_Q-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lEzJh-009lGy-25; Wed, 24 Feb 2021 18:55:26 +0000
Date: Wed, 24 Feb 2021 18:55:21 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20210224185521.GA2326119@infradead.org>
References: <20210222211115.30416-1-chaitanya.kulkarni@wdc.com>
	<YDY+ObNNiBMMuSEt@stefanha-x1.localdomain>
	<f3141eb3-9938-a216-a9f8-cb193589a657@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <f3141eb3-9938-a216-a9f8-cb193589a657@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: ulf.hansson@linaro.org, snitzer@redhat.com, mst@redhat.com,
	jasowang@redhat.com, virtualization@lists.linux-foundation.org,
	bfields@fieldses.org, linux-ide@vger.kernel.org,
	dm-devel@redhat.com, target-devel@vger.kernel.org,
	alim.akhtar@samsung.com, agk@redhat.com, beanhuo@micron.com,
	stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
	cang@codeaurora.org, tim@cyberelk.net, dgilbert@interlog.com,
	vbadigan@codeaurora.org, richard.peng@oppo.com,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	jejb@linux.ibm.com, guoqing.jiang@cloud.ionos.com,
	linux-block@vger.kernel.org, avri.altman@wdc.com, bp@alien8.de,
	Stefan Hajnoczi <stefanha@redhat.com>, jaegeuk@kernel.org,
	Kai.Makisara@kolumbus.fi, linux-nfs@vger.kernel.org,
	martin.petersen@oracle.com, baolin.wang@linaro.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	fujita.tomonori@lab.ntt.co.jp, chuck.lever@oracle.com,
	zliua@micron.com, pbonzini@redhat.com, davem@davemloft.net,
	asutoshd@codeaurora.org
Subject: Re: [dm-devel] [RFC PATCH] blk-core: remove blk_put_request()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 24, 2021 at 09:48:21AM -0700, Jens Axboe wrote:
> Would make sense to rename blk_get_request() to blk_mq_alloc_request()
> and then we have API symmetry. The get/put don't make sense when there
> are no references involved.
> 
> But it's a lot of churn for very little reward, which is always kind
> of annoying. Especially for the person that has to carry the patches.

Let's do the following:

 - move the initialize_rq_fn call from blk_get_request into
   blk_mq_alloc_request and make the former a trivial alias for the
   latter
 - migrate to the blk_mq_* versions on a per-driver/subsystem basis.
   The scsi migration depends on the first item above, so it will have
   to go with that or wait for the next merge window
 - don't migrate the legacy ide driver, as it is about to be removed and
   has a huge number of blk_get_request calls

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


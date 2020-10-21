Return-Path: <SRS0=YCRG=D4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4597EC4363D
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 04:44:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 78D7C20870
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 04:44:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78D7C20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-DAxQj_dVNyOWmaqs6BbbsQ-1; Wed, 21 Oct 2020 00:44:46 -0400
X-MC-Unique: DAxQj_dVNyOWmaqs6BbbsQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23A85803F42;
	Wed, 21 Oct 2020 04:44:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF93360C15;
	Wed, 21 Oct 2020 04:44:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0562C8C7D1;
	Wed, 21 Oct 2020 04:44:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09L4iYa4017144 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Oct 2020 00:44:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0DD6F114F2C8; Wed, 21 Oct 2020 04:44:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09D6A114F2CB
	for <dm-devel@redhat.com>; Wed, 21 Oct 2020 04:44:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF3FB858282
	for <dm-devel@redhat.com>; Wed, 21 Oct 2020 04:44:31 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-511-OgLwzWr0PgOddfRh75rEfQ-1;
	Wed, 21 Oct 2020 00:44:27 -0400
X-MC-Unique: OgLwzWr0PgOddfRh75rEfQ-1
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net
	[172.10.235.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 4792220870;
	Wed, 21 Oct 2020 04:44:25 +0000 (UTC)
Date: Tue, 20 Oct 2020 21:44:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <20201021044423.GB3939@sol.localdomain>
References: <20201015214632.41951-1-satyat@google.com>
	<20201015214632.41951-2-satyat@google.com>
	<20201016072044.GB14885@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20201016072044.GB14885@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org,
	Satya Tangirala <satyat@google.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/4] block: keyslot-manager: Introduce
 passthrough keyslot manager
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 08:20:44AM +0100, Christoph Hellwig wrote:
> And this just validates my argument that calling the inline crypto work
> directly from the block layer instead of just down below in blk-mq was
> wrong.  We should not require any support from stacking drivers at the
> keyslot manager level.

I'm not sure what you're referring to here; could you clarify?

It's true that device-mapper devices don't need the actual keyslot management.
But they do need the ability to expose crypto capabilities as well as a key
eviction function.  And those are currently handled by
"struct blk_keyslot_manager".  Hence the need for a "passthrough keyslot
manager" that does those other things but not the actual keyslot management.

FWIW, I suggested splitting these up, but you disagreed and said you wanted the
crypto capabilities to remain part of the blk_keyslot_manager
(https://lkml.kernel.org/linux-block/20200327170047.GA24682@infradead.org/).
If you've now changed your mind, please be clear about it.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


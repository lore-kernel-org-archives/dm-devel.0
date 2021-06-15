Return-Path: <SRS0=rgwX=LJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4CEC48BDF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 05:28:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E3F161410
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 05:28:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E3F161410
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-SPde3_fzO8KFAq-VUOT3gQ-1; Tue, 15 Jun 2021 01:28:24 -0400
X-MC-Unique: SPde3_fzO8KFAq-VUOT3gQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 566741084F46;
	Tue, 15 Jun 2021 05:28:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F5105C1B4;
	Tue, 15 Jun 2021 05:28:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7281A1809CAC;
	Tue, 15 Jun 2021 05:28:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15F5SBfi024810 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 01:28:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 053FA19D7D; Tue, 15 Jun 2021 05:28:11 +0000 (UTC)
Received: from deadmen.hmeau.com (ovpn-13-142.pek2.redhat.com [10.72.13.142])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89F0919C66;
	Tue, 15 Jun 2021 05:28:01 +0000 (UTC)
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
	by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
	id 1lt1cE-0006rV-UH; Tue, 15 Jun 2021 13:27:58 +0800
Received: from herbert by gondobar with local (Exim 4.92)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1lt1E3-0001MR-0g; Tue, 15 Jun 2021 13:02:59 +0800
Date: Tue, 15 Jun 2021 13:02:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ira Weiny <ira.weiny@intel.com>, "David S. Miller" <davem@davemloft.net>
Message-ID: <20210615050258.GA5208@gondor.apana.org.au>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-10-hch@lst.de>
	<20210609014822.GT3697498@iweiny-DESK2.sc.intel.com>
	<20210611065338.GA31210@lst.de>
	<20210612040743.GG1600546@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
In-Reply-To: <20210612040743.GG1600546@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-arch@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	linux-sh@vger.kernel.org, Geoff Levand <geoff@infradead.org>,
	Tero Kristo <t-kristo@ti.com>, ceph-devel@vger.kernel.org,
	linux-mips@vger.kernel.org, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
	linux-csky@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ilya Dryomov <idryomov@gmail.com>, linuxppc-dev@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [dm-devel] [PATCH 09/16] ps3disk: use memcpy_{from,to}_bvec
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

On Fri, Jun 11, 2021 at 09:07:43PM -0700, Ira Weiny wrote:
>
> More recently this was added:
> 
> 7e34e0bbc644 crypto: omap-crypto - fix userspace copied buffer access
> 
> I'm CC'ing Tero and Herbert to see why they added the SLAB check.

Probably because the generic Crypto API has the same check.  This
all goes back to

commit 4f3e797ad07d52d34983354a77b365dfcd48c1b4
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Feb 9 14:22:14 2009 +1100

    crypto: scatterwalk - Avoid flush_dcache_page on slab pages

    It's illegal to call flush_dcache_page on slab pages on a number
    of architectures.  So this patch avoids doing so if PageSlab is
    true.

    In future we can move the flush_dcache_page call to those page
    cache users that actually need it.

    Reported-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

But I can't find any emails discussing this so let me ask Dave
directly and see if he can tell us what the issue was or might
have been.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=Vrzv=LM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34400C48BE5
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 03:38:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 59673613BD
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 03:38:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59673613BD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-d9xjAD0cMSmi2lsX8l6pfQ-1; Thu, 17 Jun 2021 23:38:48 -0400
X-MC-Unique: d9xjAD0cMSmi2lsX8l6pfQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EA661084F40;
	Fri, 18 Jun 2021 03:38:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D8C7D5C1D1;
	Fri, 18 Jun 2021 03:38:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 786C31809CAD;
	Fri, 18 Jun 2021 03:38:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15I3cW2o016364 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Jun 2021 23:38:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7540C60E3A; Fri, 18 Jun 2021 03:38:32 +0000 (UTC)
Received: from deadmen.hmeau.com (ovpn-13-118.pek2.redhat.com [10.72.13.118])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B533A60C4A;
	Fri, 18 Jun 2021 03:38:25 +0000 (UTC)
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
	by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
	id 1lu5KJ-0000aH-Fe; Fri, 18 Jun 2021 11:37:51 +0800
Received: from herbert by gondobar with local (Exim 4.92)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1lu5Jw-0004Nh-Un; Fri, 18 Jun 2021 11:37:28 +0800
Date: Fri, 18 Jun 2021 11:37:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ira Weiny <ira.weiny@intel.com>
Message-ID: <20210618033728.GA16787@gondor.apana.org.au>
References: <20210615132456.753241-1-hch@lst.de>
	<20210615132456.753241-2-hch@lst.de>
	<20210618030157.GA1905674@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
In-Reply-To: <20210618030157.GA1905674@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, "David S. Miller" <davem@davemloft.net>,
	Geoff Levand <geoff@infradead.org>,
	Christoph Lameter <cl@gentwo.de>, ceph-devel@vger.kernel.org,
	linux-mips@vger.kernel.org, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	dm-devel@redhat.com, linux-arch@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ilya Dryomov <idryomov@gmail.com>, linuxppc-dev@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 01/18] mm: add a kunmap_local_dirty helper
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

On Thu, Jun 17, 2021 at 08:01:57PM -0700, Ira Weiny wrote:
>
> > +		flush_kernel_dcache_page(__page);		\
> 
> Is this required on 32bit systems?  Why is kunmap_flush_on_unmap() not
> sufficient on 64bit systems?  The normal kunmap_local() path does that.
> 
> I'm sorry but I did not see a conclusion to my query on V1. Herbert implied the
> he just copied from the crypto code.[1]  I'm concerned that this _dirty() call
> is just going to confuse the users of kmap even more.  So why can't we get to
> the bottom of why flush_kernel_dcache_page() needs so much logic around it
> before complicating the general kernel users.
> 
> I would like to see it go away if possible.

This thread may be related:

https://lwn.net/Articles/240249/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


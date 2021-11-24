Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63049C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 06:39:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-JqHhdj3nNzWuqwuq_G1QGw-1; Wed, 24 Nov 2021 01:39:50 -0500
X-MC-Unique: JqHhdj3nNzWuqwuq_G1QGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70A8B1DDE4;
	Wed, 24 Nov 2021 06:39:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 520C417D61;
	Wed, 24 Nov 2021 06:39:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 048271809C8A;
	Wed, 24 Nov 2021 06:39:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO6diN0002568 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 01:39:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 557C71121318; Wed, 24 Nov 2021 06:39:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 511EC1121315
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 06:39:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B429181E063
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 06:39:41 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-35-YCE6xIYbMWCb1W4Ey1gYrg-1; Wed, 24 Nov 2021 01:39:38 -0500
X-MC-Unique: YCE6xIYbMWCb1W4Ey1gYrg-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id D92CF68AFE; Wed, 24 Nov 2021 07:39:34 +0100 (CET)
Date: Wed, 24 Nov 2021 07:39:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <20211124063934.GC6889@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-15-hch@lst.de>
	<20211123223642.GI266024@magnolia>
MIME-Version: 1.0
In-Reply-To: <20211123223642.GI266024@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 14/29] fsdax: simplify the pgoff calculation
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

On Tue, Nov 23, 2021 at 02:36:42PM -0800, Darrick J. Wong wrote:
> > -	phys_addr_t phys_off = (start_sect + sector) * 512;
> > -
> > -	if (pgoff)
> > -		*pgoff = PHYS_PFN(phys_off);
> > -	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
> 
> AFAICT, we're relying on fs_dax_get_by_bdev to have validated this
> previously, which is why the error return stuff goes away?

Exactly.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE1EC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Dec 2021 08:26:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-dMkyYUZAOY-4XeM0aUg5tA-1; Mon, 13 Dec 2021 03:26:35 -0500
X-MC-Unique: dMkyYUZAOY-4XeM0aUg5tA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D93A8192FDA1;
	Mon, 13 Dec 2021 08:26:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7142F60C04;
	Mon, 13 Dec 2021 08:26:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 782341809CB8;
	Mon, 13 Dec 2021 08:26:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BD8ORlK004340 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 03:24:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6BE4C4010FDD; Mon, 13 Dec 2021 08:24:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6745F4010E97
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 08:24:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53CF51C03363
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 08:24:27 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-466-Kfpk2NIPMv6_25zpRIT9GA-1; Mon, 13 Dec 2021 03:24:23 -0500
X-MC-Unique: Kfpk2NIPMv6_25zpRIT9GA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 60ABF68BFE; Mon, 13 Dec 2021 09:24:20 +0100 (CET)
Date: Mon, 13 Dec 2021 09:24:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20211213082420.GC21462@lst.de>
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-5-hch@lst.de>
	<CAPcyv4gZjkVW0vwNLChXCCBVF8CsSZityzSVmcGAk79-mt9yOw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gZjkVW0vwNLChXCCBVF8CsSZityzSVmcGAk79-mt9yOw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/5] dax: remove the copy_from_iter and
 copy_to_iter methods
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Dec 12, 2021 at 06:39:16AM -0800, Dan Williams wrote:
> >         /* flag to check if device supports synchronous flush */
> >         DAXDEV_SYNC,
> > +       /* do not use uncached operations to write data */
> > +       DAXDEV_CACHED,
> > +       /* do not use mcsafe operations to read data */
> > +       DAXDEV_NOMCSAFE,
> 
> Linus did not like the mcsafe name, and this brings it back. Let's
> flip the polarity to positively indicate which routine to use, and to
> match the 'nofault' style which says "copy and handle faults".
> 
> /* do not leave the caches dirty after writes */
> DAXDEV_NOCACHE
> 
> /* handle CPU fetch exceptions during reads */
> DAXDEV_NOMC
> 
> ...and then flip the use cases around.

Sure we can do that.  But let's finish the discussion if we actually
need the virtiofs special casing, as it seems pretty fishy in many
aspects.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


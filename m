Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C81C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:51:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-tFNfF6XoPMy_JchTdDSQVA-1; Tue, 23 Nov 2021 17:51:09 -0500
X-MC-Unique: tFNfF6XoPMy_JchTdDSQVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92FF0BAF80;
	Tue, 23 Nov 2021 22:51:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12B40179B3;
	Tue, 23 Nov 2021 22:51:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 87D2F4EA37;
	Tue, 23 Nov 2021 22:51:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANMj6Ci025181 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 17:45:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 855432026D69; Tue, 23 Nov 2021 22:45:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77C922026D6A
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:45:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BB98803DDA
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:45:03 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-2-2JugcwjJNDqi5HR08uIhGw-1; Tue, 23 Nov 2021 17:44:59 -0500
X-MC-Unique: 2JugcwjJNDqi5HR08uIhGw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D4E860E08;
	Tue, 23 Nov 2021 22:44:58 +0000 (UTC)
Date: Tue, 23 Nov 2021 14:44:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20211123224457.GL266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-18-hch@lst.de>
	<CAPcyv4imPgBEbhDCQpDwCQUTxOQy=RT9ZkAueBQdPKXOLNmrAQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4imPgBEbhDCQpDwCQUTxOQy=RT9ZkAueBQdPKXOLNmrAQ@mail.gmail.com>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 17/29] fsdax: factor out a dax_memzero helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 23, 2021 at 01:22:13PM -0800, Dan Williams wrote:
> On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Factor out a helper for the "manual" zeroing of a DAX range to clean
> > up dax_iomap_zero a lot.
> >
> 
> Small / optional fixup below:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/dax.c | 36 +++++++++++++++++++-----------------
> >  1 file changed, 19 insertions(+), 17 deletions(-)
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index d7a923d152240..dc9ebeff850ab 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1121,34 +1121,36 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
> >  }
> >  #endif /* CONFIG_FS_DAX_PMD */
> >
> > +static int dax_memzero(struct dax_device *dax_dev, pgoff_t pgoff,
> > +               unsigned int offset, size_t size)
> > +{
> > +       void *kaddr;
> > +       long rc;
> > +
> > +       rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
> > +       if (rc >= 0) {
> 
> Technically this should be "> 0" because dax_direct_access() returns
> nr_available_pages @pgoff, but this isn't broken because
> dax_direct_access() converts the "zero pages available" case into
> -ERANGE.

Agreed.  With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> > +               memset(kaddr + offset, 0, size);
> > +               dax_flush(dax_dev, kaddr + offset, size);
> > +       }
> > +       return rc;
> > +}
> > +
> >  s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
> >  {
> >         pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
> >         long rc, id;
> > -       void *kaddr;
> > -       bool page_aligned = false;
> >         unsigned offset = offset_in_page(pos);
> >         unsigned size = min_t(u64, PAGE_SIZE - offset, length);
> >
> > -       if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
> > -               page_aligned = true;
> > -
> >         id = dax_read_lock();
> > -
> > -       if (page_aligned)
> > +       if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
> >                 rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
> >         else
> > -               rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
> > -       if (rc < 0) {
> > -               dax_read_unlock(id);
> > -               return rc;
> > -       }
> > -
> > -       if (!page_aligned) {
> > -               memset(kaddr + offset, 0, size);
> > -               dax_flush(iomap->dax_dev, kaddr + offset, size);
> > -       }
> > +               rc = dax_memzero(iomap->dax_dev, pgoff, offset, size);
> >         dax_read_unlock(id);
> > +
> > +       if (rc < 0)
> > +               return rc;
> >         return size;
> >  }
> >
> > --
> > 2.30.2
> >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


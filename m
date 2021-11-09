Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A941C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 07:02:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E93B161151
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 07:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E93B161151
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-cWXjOQkDNXapAKAfBdmOxw-1; Tue, 09 Nov 2021 02:02:26 -0500
X-MC-Unique: cWXjOQkDNXapAKAfBdmOxw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 713131023F51;
	Tue,  9 Nov 2021 07:02:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 763D2226E9;
	Tue,  9 Nov 2021 07:02:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 13E32181A1D0;
	Tue,  9 Nov 2021 07:02:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A95RvGi002257 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 00:27:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ACB262026D67; Tue,  9 Nov 2021 05:27:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A79EF2026D60
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 05:27:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7991F8011A5
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 05:27:53 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-349-XCE7PKEZN0y9BSyBiAUfrA-1;
	Tue, 09 Nov 2021 00:27:51 -0500
X-MC-Unique: XCE7PKEZN0y9BSyBiAUfrA-1
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="213112915"
X-IronPort-AV: E=Sophos;i="5.87,219,1631602800"; d="scan'208";a="213112915"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
	by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	08 Nov 2021 21:26:42 -0800
X-IronPort-AV: E=Sophos;i="5.87,219,1631602800"; d="scan'208";a="491526669"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
	by orsmga007-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:26:41 -0800
Date: Mon, 8 Nov 2021 21:26:41 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <20211109052640.GG3538886@iweiny-DESK2.sc.intel.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-2-jane.chu@oracle.com>
	<CAPcyv4jcgFxgoXFhWL9+BReY8vFtgjb_=Lfai-adFpdzc4-35Q@mail.gmail.com>
	<63f89475-7a1f-e79e-7785-ba996211615b@oracle.com>
MIME-Version: 1.0
In-Reply-To: <63f89475-7a1f-e79e-7785-ba996211615b@oracle.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
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
X-Mailman-Approved-At: Tue, 09 Nov 2021 02:01:34 -0500
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-xfs <linux-xfs@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/2] dax: Introduce normal and recovery
 dax operation modes
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 08, 2021 at 09:02:29PM +0000, Jane Chu wrote:
> On 11/6/2021 9:48 AM, Dan Williams wrote:
> > On Fri, Nov 5, 2021 at 6:17 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> Introduce DAX_OP_NORMAL and DAX_OP_RECOVERY operation modes to
> >> {dax_direct_access, dax_copy_from_iter, dax_copy_to_iter}.
> >> DAX_OP_NORMAL is the default or the existing mode, and
> >> DAX_OP_RECOVERY is a new mode for data recovery purpose.
> >>
> >> When dax-FS suspects dax media error might be encountered
> >> on a read or write, it can enact the recovery mode read or write
> >> by setting DAX_OP_RECOVERY in the aforementioned APIs. A read
> >> in recovery mode attempts to fetch as much data as possible
> >> until the first poisoned page is encountered. A write in recovery
> >> mode attempts to clear poison(s) in a page-aligned range and
> >> then write the user provided data over.
> >>
> >> DAX_OP_NORMAL should be used for all non-recovery code path.
> >>
> >> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> > [..]
> >> diff --git a/include/linux/dax.h b/include/linux/dax.h
> >> index 324363b798ec..931586df2905 100644
> >> --- a/include/linux/dax.h
> >> +++ b/include/linux/dax.h
> >> @@ -9,6 +9,10 @@
> >>   /* Flag for synchronous flush */
> >>   #define DAXDEV_F_SYNC (1UL << 0)
> >>
> >> +/* dax operation mode dynamically set by caller */
> >> +#define        DAX_OP_NORMAL           0
> > 
> > Perhaps this should be called DAX_OP_FAILFAST?
> 
> Sure.
> 
> > 
> >> +#define        DAX_OP_RECOVERY         1
> >> +
> >>   typedef unsigned long dax_entry_t;
> >>
> >>   struct dax_device;
> >> @@ -22,8 +26,8 @@ struct dax_operations {
> >>           * logical-page-offset into an absolute physical pfn. Return the
> >>           * number of pages available for DAX at that pfn.
> >>           */
> >> -       long (*direct_access)(struct dax_device *, pgoff_t, long,
> >> -                       void **, pfn_t *);
> >> +       long (*direct_access)(struct dax_device *, pgoff_t, long, int,
> > 
> > Would be nice if that 'int' was an enum, but I'm not sure a new
> > parameter is needed at all, see below...
> 
> Let's do your suggestion below. :)
> 
> > 
> >> +                               void **, pfn_t *);
> >>          /*
> >>           * Validate whether this device is usable as an fsdax backing
> >>           * device.
> >> @@ -32,10 +36,10 @@ struct dax_operations {
> >>                          sector_t, sector_t);
> >>          /* copy_from_iter: required operation for fs-dax direct-i/o */
> >>          size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
> >> -                       struct iov_iter *);
> >> +                       struct iov_iter *, int);
> > 
> > I'm not sure the flag is needed here as the "void *" could carry a
> > flag in the pointer to indicate that is a recovery kaddr.
> 
> Agreed.

Not sure if this is implied but I would like some macros or other helper
functions to check these flags hidden in the addresses.

For me I'm a bit scared about having flags hidden in the address like this
because I can't lead to some confusions IMO.

But if we have some macros or other calls which can make this more obvious of
what is going on I think that would help.

Apologies if this was what you were already going to do...  :-D

Ira

> 
> > 
> >>          /* copy_to_iter: required operation for fs-dax direct-i/o */
> >>          size_t (*copy_to_iter)(struct dax_device *, pgoff_t, void *, size_t,
> >> -                       struct iov_iter *);
> >> +                       struct iov_iter *, int);
> > 
> > Same comment here.
> > 
> >>          /* zero_page_range: required operation. Zero page range   */
> >>          int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
> >>   };
> >> @@ -186,11 +190,11 @@ static inline void dax_read_unlock(int id)
> >>   bool dax_alive(struct dax_device *dax_dev);
> >>   void *dax_get_private(struct dax_device *dax_dev);
> >>   long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
> >> -               void **kaddr, pfn_t *pfn);
> >> +               int mode, void **kaddr, pfn_t *pfn);
> > 
> > How about dax_direct_access() calling convention stays the same, but
> > the kaddr is optionally updated to carry a flag in the lower unused
> > bits. So:
> > 
> > void **kaddr = NULL; /* caller only cares about the pfn */
> > 
> > void *failfast = NULL;
> > void **kaddr = &failfast; /* caller wants -EIO not recovery */
> > 
> > void *recovery = (void *) DAX_OP_RECOVERY;
> > void **kaddr = &recovery; /* caller wants to carefully access page(s)
> > containing poison */
> > 
> 
> Got it.
> 
> thanks!
> -jane
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


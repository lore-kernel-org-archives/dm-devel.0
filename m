Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D0EC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 06:08:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-ZaG_ysGsO7SuBTzJOmpDUQ-1; Wed, 23 Mar 2022 02:08:39 -0400
X-MC-Unique: ZaG_ysGsO7SuBTzJOmpDUQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79A01185A7A4;
	Wed, 23 Mar 2022 06:08:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB0414B8D43;
	Wed, 23 Mar 2022 06:08:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B9231940340;
	Wed, 23 Mar 2022 06:08:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9CF361949762
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 06:08:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2301D40D2823; Wed, 23 Mar 2022 06:08:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1ECBE40D2820
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 06:08:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D19373C01B80
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 06:08:30 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-Vrp3m0PLNNCX5el9SOxB2A-1; Wed, 23 Mar 2022 02:08:27 -0400
X-MC-Unique: Vrp3m0PLNNCX5el9SOxB2A-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nWtok-00CoLR-Fp; Wed, 23 Mar 2022 05:45:58 +0000
Date: Tue, 22 Mar 2022 22:45:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <Yjq0FspfsLrN/mrx@infradead.org>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-5-jane.chu@oracle.com>
 <YjmQdJdOWUr2IYIP@infradead.org>
 <3dabd58b-70f2-12af-419f-a7dfc07fbb1c@oracle.com>
MIME-Version: 1.0
In-Reply-To: <3dabd58b-70f2-12af-419f-a7dfc07fbb1c@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v6 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "djwong@kernel.org" <djwong@kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 Christoph Hellwig <hch@infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 22, 2022 at 11:05:09PM +0000, Jane Chu wrote:
> > This DAX_RECOVERY doesn't actually seem to be used anywhere here or
> > in the subsequent patches.  Did I miss something?
> 
> dax_iomap_iter() uses the flag in the same patch,
> +               if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {
> +                       flags |= DAX_RECOVERY;
> +                       map_len = dax_direct_access(dax_dev, pgoff, nrpg,
> +                                               flags, &kaddr, NULL);

Yes, it passes it on to dax_direct_access, and dax_direct_access passes
it onto ->direct_access.  But nothing in this series actually checks
for it as far as I can tell.

> >> Also introduce a new dev_pagemap_ops .recovery_write function.
> >> The function is applicable to FSDAX device only. The device
> >> page backend driver provides .recovery_write function if the
> >> device has underlying mechanism to clear the uncorrectable
> >> errors on the fly.
> > 
> > Why is this not in struct dax_operations?
> 
> Per Dan's comments to the v5 series, adding .recovery_write to
> dax_operations causes a number of trivial dm targets changes.
> Dan suggested that adding .recovery_write to pagemap_ops could
> cut short the logistics of figuring out whether the driver backing
> up a page is indeed capable of clearing poison. Please see
> https://lkml.org/lkml/2022/2/4/31

But at least in this series there is  1:1 association between the
pgmap and the dax_device so that scheme won't work.   It would
have to lookup the pgmap based on the return physical address from
dax_direct_access.  Which sounds more complicated than just adding
the (annoying) boilerplate code to DM.

> include/linux/memremap.h doesn't know struct iov_iter which is defined 
> in include/linux/uio.h,  would you prefer to adding include/linux/uio.h 
> to include/linux/memremap.h ?

As it is not derefences just adding a

struct iov_iter;

line to memremap.h below the includes should be all that is needed.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


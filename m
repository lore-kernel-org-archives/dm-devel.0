Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764E2C5519F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:17:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B4C872224C
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4C872224C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-cvtmcI3NPyiFJdxnKvNdUA-1; Fri, 20 Nov 2020 04:17:32 -0500
X-MC-Unique: cvtmcI3NPyiFJdxnKvNdUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 630241005D59;
	Fri, 20 Nov 2020 09:17:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BB4019D9B;
	Fri, 20 Nov 2020 09:17:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C7EE44BB7B;
	Fri, 20 Nov 2020 09:17:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK9HOoP022163 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 04:17:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7F6A3E779D; Fri, 20 Nov 2020 09:17:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78DA0E77A3
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 09:17:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DC5E186E121
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 09:17:22 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-101-Vy4CPgg-OZSajnRCYw94Ow-1;
	Fri, 20 Nov 2020 04:17:17 -0500
X-MC-Unique: Vy4CPgg-OZSajnRCYw94Ow-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id E4E0067373; Fri, 20 Nov 2020 10:17:14 +0100 (CET)
Date: Fri, 20 Nov 2020 10:17:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Message-ID: <20201120091714.GF21715@lst.de>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-18-hch@lst.de>
	<20201119151316.GH29991@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <20201119151316.GH29991@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	linux-mm@kvack.org, Jan Kara <jack@suse.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 17/20] filemap: consistently use ->f_mapping
 over ->i_mapping
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 19, 2020 at 03:13:16PM +0000, Matthew Wilcox wrote:
> On Wed, Nov 18, 2020 at 09:47:57AM +0100, Christoph Hellwig wrote:
> > @@ -2887,13 +2887,13 @@ EXPORT_SYMBOL(filemap_map_pages);
> >  vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf)
> >  {
> >  	struct page *page = vmf->page;
> > -	struct inode *inode = file_inode(vmf->vma->vm_file);
> > +	struct inode *inode = vmf->vma->vm_file->f_mapping->host;
> >  	vm_fault_t ret = VM_FAULT_LOCKED;
> >  
> >  	sb_start_pagefault(inode->i_sb);
> >  	file_update_time(vmf->vma->vm_file);
> >  	lock_page(page);
> > -	if (page->mapping != inode->i_mapping) {
> > +	if (page->mapping != vmf->vma->vm_file->f_mapping) {
> 
> Bit messy.  I'd do:
> 
> 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> 
> 	sb_start_pagefault(mapping->host->i_sb);
> 
> 	if (page->mapping != mapping)
> 
> 	sb_end_pagefault(mapping->host->i_sb);

Fine with me.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


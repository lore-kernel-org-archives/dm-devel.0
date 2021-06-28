Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4D6C2B9F4
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 12:17:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E72A61C3D
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 12:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E72A61C3D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-MMBhGJ1IMdmiQwfLAYno3w-1; Mon, 28 Jun 2021 08:17:14 -0400
X-MC-Unique: MMBhGJ1IMdmiQwfLAYno3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B9FF804300;
	Mon, 28 Jun 2021 12:17:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B4C593B04;
	Mon, 28 Jun 2021 12:17:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6246B1809C99;
	Mon, 28 Jun 2021 12:17:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15SCH26P022195 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Jun 2021 08:17:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A8F621111C86; Mon, 28 Jun 2021 12:17:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4E9F1003332
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 12:16:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 491D98556F0
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 12:16:59 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-454-_HiBTrDZNQSjAJI4QwljVg-1; Mon, 28 Jun 2021 08:16:57 -0400
X-MC-Unique: _HiBTrDZNQSjAJI4QwljVg-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1lxpll-002vLV-Tr; Mon, 28 Jun 2021 11:49:53 +0000
Date: Mon, 28 Jun 2021 12:49:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <YNm3VeeWuI0m4Vcx@casper.infradead.org>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
	<20210628000218.387833-6-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <20210628000218.387833-6-ruansy.fnst@fujitsu.com>
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
Cc: nvdimm@lists.linux.dev, snitzer@redhat.com, darrick.wong@oracle.com,
	rgoldwyn@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v5 5/9] mm: Introduce mf_dax_kill_procs() for
	fsdax case
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jun 28, 2021 at 08:02:14AM +0800, Shiyang Ruan wrote:
> +/*
> + * dax_load_pfn - Load pfn of the DAX entry corresponding to a page
> + * @mapping:	The file whose entry we want to load
> + * @index:	offset where the DAX entry located in
> + *
> + * Return:	pfn number of the DAX entry
> + */

This is an externally visible function; why not add the second '*' and
make this kernel-doc?

> +unsigned long dax_load_pfn(struct address_space *mapping, unsigned long index)
> +{
> +	XA_STATE(xas, &mapping->i_pages, index);
> +	void *entry;
> +	unsigned long pfn;
> +
> +	xas_lock_irq(&xas);
> +	entry = xas_load(&xas);
> +	pfn = dax_to_pfn(entry);
> +	xas_unlock_irq(&xas);

Why do you need the i_pages lock to do this?  is the rcu_read_lock()
insufficient?  For that matter, why use the xas functions?  Why not
simply:

	void *entry = xa_load(&mapping->i_pages, index);
	return dax_to_pfn(entry);

Looking at it more though, how do you know this is a PFN entry?
It could be locked, for example.  Or the zero page, or empty.

But I think this is unnecessary; why not just pass the PFN into
mf_dax_kill_procs?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


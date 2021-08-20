Return-Path: <SRS0=Iac5=NL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61231C4338F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 16:54:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 48AA260F5E
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 16:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 48AA260F5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-OPgm6qX2O9WaZ6DwgvLfOg-1; Fri, 20 Aug 2021 12:54:34 -0400
X-MC-Unique: OPgm6qX2O9WaZ6DwgvLfOg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C9AF1966320;
	Fri, 20 Aug 2021 16:54:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB03E604CC;
	Fri, 20 Aug 2021 16:54:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9A9F84BB7C;
	Fri, 20 Aug 2021 16:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KGsPdw003992 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 12:54:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EE71B216780E; Fri, 20 Aug 2021 16:54:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E71032167814
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 16:54:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8315318A6541
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 16:54:21 +0000 (UTC)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
	[209.85.215.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-162-Z7CRrXDqP-2nE5Nme5s12w-1; Fri, 20 Aug 2021 12:54:18 -0400
X-MC-Unique: Z7CRrXDqP-2nE5Nme5s12w-1
Received: by mail-pg1-f177.google.com with SMTP id n18so9754528pgm.12
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 09:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=x/jv/65/o/pr3Arrh3DCsUW+kuq3VQXikqXf2iTWhR0=;
	b=YdHJt3usv7/uu9nUHNZaTXYFNMsD7olE6TC6cHSvBOMfmBPt34Crra3gnSR3GFv7UC
	MmV6ahPy+YM3LscfN5msXEIZh/m7620Oh6GWOfF7ox5B6RAbaOQf797MapneU0Yv7SMK
	ROvjW83eLY1oEOiF6UMwOeNwY0EDrR+ztvg5fcNSwuiTYvXZWx64O/wP2qLdcPkdC6NA
	9E0tXZkhbhQV2BUUhClCe6R0MRn1q05X9QqZ63+oYz2mUWriAiUSQ2S9H1D9OW4143/2
	J7JBVohNUnTfToVbQriwt4ULkeA6d6RhnQRKkxYvwLmG4VOz2Ft3FpoBrMYF9ne4chjW
	SWuA==
X-Gm-Message-State: AOAM532ofEM4Lw9ovgB1foCC8U+O+xYxoKokdDLg32Nh0t3+2A811kvu
	5QwXT0+6XgZwQ0s08EqcYs4zl0BqPZ21xobfNILifw==
X-Google-Smtp-Source: ABdhPJxOaSnUuSDnQi5DeVTlIJ2tZRX4+NfWecFNtpOa2DU5Lh7Ot8DcjqxkMAwkp+e/mA/IvF4DoFjucZJd3KA/Wvo=
X-Received: by 2002:a65:6642:: with SMTP id z2mr7510515pgv.240.1629478457626; 
	Fri, 20 Aug 2021 09:54:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-4-ruansy.fnst@fujitsu.com>
	<a5580cf5-9fcc-252d-5835-f199469516b0@oracle.com>
In-Reply-To: <a5580cf5-9fcc-252d-5835-f199469516b0@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 09:54:06 -0700
Message-ID: <CAPcyv4hQvR+KND8F1zGoX=jBJQ6bXhLtmEAPVb=O7rDwzHniiQ@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 3/9] mm: factor helpers for
	memory_failure_dev_pagemap
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Aug 5, 2021 at 6:01 PM Jane Chu <jane.chu@oracle.com> wrote:
>
>
> On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> > -     /*
> > -      * Prevent the inode from being freed while we are interrogating
> > -      * the address_space, typically this would be handled by
> > -      * lock_page(), but dax pages do not use the page lock. This
> > -      * also prevents changes to the mapping of this pfn until
> > -      * poison signaling is complete.
> > -      */
> > -     cookie = dax_lock_page(page);
> > -     if (!cookie)
> > -             goto out;
> > -
> >       if (hwpoison_filter(page)) {
> >               rc = 0;
> > -             goto unlock;
> > +             goto out;
> >       }
>
> why isn't dax_lock_page() needed for hwpoison_filter() check?

Good catch. hwpoison_filter() is indeed consulting page->mapping->host
which needs to be synchronized against inode lifetime.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


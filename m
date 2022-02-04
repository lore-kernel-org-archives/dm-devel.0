Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B71C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 05:23:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-2Sbym-wAMnWYQf3S6RG5ug-1; Fri, 04 Feb 2022 00:23:26 -0500
X-MC-Unique: 2Sbym-wAMnWYQf3S6RG5ug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79CAB81424A;
	Fri,  4 Feb 2022 05:23:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC1264E2DF;
	Fri,  4 Feb 2022 05:23:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 703AE180BAD1;
	Fri,  4 Feb 2022 05:23:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2145NIiK023939 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 00:23:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E399814582EE; Fri,  4 Feb 2022 05:23:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF9D414582E2
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 05:23:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C635C3802AC0
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 05:23:17 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
	[209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-628-nTWL5wXxOdmSdJkXSAKOzQ-1; Fri, 04 Feb 2022 00:23:14 -0500
X-MC-Unique: nTWL5wXxOdmSdJkXSAKOzQ-1
Received: by mail-pf1-f176.google.com with SMTP id v74so4177704pfc.1
	for <dm-devel@redhat.com>; Thu, 03 Feb 2022 21:23:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=QRfoBad6xaNnxHl59RhSeOObo1h7VnZyGCv6jI7PtEQ=;
	b=77dPhixAVYNiWHHRNMoRw/dxIwdc16NGua49oQcsMjE8AdN6LSX9N9oY4YfqdLZbIP
	bvMnwpIKyWNdfNFtZ4Kj5A4D3ewNP642hdMWfORlfwlFSXMsbkD972c/wcS0/v+a8lF7
	dBHtVfZhrVD8jN7XANHnFKAISgn2rCngwwIPATSayETM97xOSdmWUgCdWxB44fzTzrmN
	XOGrR/bk2JRagEkFp7P6UEYd6zfbWAsFeZ3yEFNy4++kp6VTjIMpgH8O478OK5IM23EZ
	m9xy+HnBOHQZohCtyFJZcHwQyUTUd6/Qbz2Hsz2RGsjkM17trG0T5Z+OAln+9VAYBuIe
	idNg==
X-Gm-Message-State: AOAM530vIWIbhI8IUnfTtHPtHbFeaO6vZ1SbwsPMJdxGM0y83K8fPhrJ
	qUhRnxtIulbGNXxOp42bqtVQQ7fnPgDIyqPjDAD7KQ==
X-Google-Smtp-Source: ABdhPJwHAc/oiydG42zh/YFy2yhojJMwzDJLfd2gzwA9VgAmUNWeZj1OWMAW4bLiBRXQIgjKFgKxpvZwQ+knnx1pEdw=
X-Received: by 2002:a05:6a00:1508:: with SMTP id
	q8mr1395954pfu.3.1643952193051; 
	Thu, 03 Feb 2022 21:23:13 -0800 (PST)
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-2-jane.chu@oracle.com>
	<YfqFWjFcdJSwjRaU@infradead.org>
	<d0fecaaa-8613-92d2-716d-9d462dbd3888@oracle.com>
	<950a3e4e-573c-2d9f-b277-d1283c7256cd@oracle.com>
	<YfvbyKdu812To3KY@infradead.org>
In-Reply-To: <YfvbyKdu812To3KY@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 21:23:00 -0800
Message-ID: <CAPcyv4g7Vqp6Z2+EXHdv95oqQxfdvPDAnzBiRG2KqobaHzOAsg@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 1/7] mce: fix set_mce_nospec to always
	unmap the whole page
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 3, 2022 at 5:42 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Feb 02, 2022 at 11:07:37PM +0000, Jane Chu wrote:
> > On 2/2/2022 1:20 PM, Jane Chu wrote:
> > >> Wouldn't it make more sense to move these helpers out of line rather
> > >> than exporting _set_memory_present?
> > >
> > > Do you mean to move
> > >     return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
> > > into clear_mce_nospec() for the x86 arch and get rid of _set_memory_present?
> > > If so, sure I'll do that.
> >
> > Looks like I can't do that.  It's either exporting
> > _set_memory_present(), or exporting change_page_attr_set().  Perhaps the
> > former is more conventional?
>
> These helpers above means set_mce_nospec and clear_mce_nospec.  If they
> are moved to normal functions instead of inlines, there is no need to
> export the internals at all.

Agree, {set,clear}_mce_nospec() can just move to arch/x86/mm/pat/set_memory.c.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


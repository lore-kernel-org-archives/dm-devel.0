Return-Path: <SRS0=3wtw=PV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02B9C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 16:04:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5D42B61052
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 16:04:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5D42B61052
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-lAVzkRRLMG6ZjlQ9ytXEJQ-1; Tue, 02 Nov 2021 12:04:21 -0400
X-MC-Unique: lAVzkRRLMG6ZjlQ9ytXEJQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B40719057BB;
	Tue,  2 Nov 2021 16:04:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1319F19D9D;
	Tue,  2 Nov 2021 16:04:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 21A7C1800FDD;
	Tue,  2 Nov 2021 16:04:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A2G49Ix003550 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Nov 2021 12:04:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CEB9F40D1B9D; Tue,  2 Nov 2021 16:04:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA8F840C1252
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 16:04:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 099FD1064E6D
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 16:04:09 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
	[209.85.210.173]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-491-nLaP3frrP8GmQ8wcGlStZg-1; Tue, 02 Nov 2021 12:04:07 -0400
X-MC-Unique: nLaP3frrP8GmQ8wcGlStZg-1
Received: by mail-pf1-f173.google.com with SMTP id t38so1876740pfg.12
	for <dm-devel@redhat.com>; Tue, 02 Nov 2021 09:04:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=pqUtMw42srMAJfM2b3lzp/b+ILplHJlRcpIaRS/3TQM=;
	b=Ndu9x7onTNld+EVvPqj3UIKOU9iO3WR8ktpjoTanGXcSNRY20dzX53AII3NGUZLjTB
	gPtN+N8zH0/C2xASjSu22NP8AoYue3s3XfnTp9WqEvMDE3nLPfvENIQc9gblneA0P8sK
	sEAhuWnYOoxPWnCtYaDUpRDZxcyvHNMFOT4iBIdgaUJxuARl/gsaB1GydR+smMYBFPWo
	bL1BxrQbBeAgOMFPrj+CA8KTFlmrGdmuS5rwWngYai4IkI9kmzM9d7mzwzUC6MjzSRT7
	8+ls86dniXy593TZOm5JBinhJhKSbQnWVZIiSFoNRS+/nekRkGJzP7u95Jvue8ZnIzdl
	YHZw==
X-Gm-Message-State: AOAM530HhiR2p4941czCMrcUC3R7UNZAYP+VQPWjTErwm/faxssVr3Ld
	8nLHfLSwQTR0TS+W6W4/1md5JPSYKqA4RkY+fkSBuQ==
X-Google-Smtp-Source: ABdhPJyi2jXIzQpJmrRalOBu2yRBUoqURsVK2whse/fQ0ZQUdF57+LmGNFNbptM0HlteOtS8dkMwnbU4y4A7thJeMNM=
X-Received: by 2002:a63:6302:: with SMTP id x2mr11074410pgb.5.1635869046166;
	Tue, 02 Nov 2021 09:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
In-Reply-To: <YXj2lwrxRxHdr4hb@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Nov 2021 09:03:55 -0700
Message-ID: <CAPcyv4hK18DetEf9+NcDqM5y07Vp-=nhysHJ3JSnKbS-ET2ppw@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
	RWF_RECOVERY_DATA flag
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 26, 2021 at 11:50 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Oct 22, 2021 at 08:52:55PM +0000, Jane Chu wrote:
> > Thanks - I try to be honest.  As far as I can tell, the argument
> > about the flag is a philosophical argument between two views.
> > One view assumes design based on perfect hardware, and media error
> > belongs to the category of brokenness. Another view sees media
> > error as a build-in hardware component and make design to include
> > dealing with such errors.
>
> No, I don't think so.  Bit errors do happen in all media, which is
> why devices are built to handle them.  It is just the Intel-style
> pmem interface to handle them which is completely broken.

No, any media can report checksum / parity errors. NVME also seems to
do a poor job with multi-bit ECC errors consumed from DRAM. There is
nothing "pmem" or "Intel" specific here.

> > errors in mind from start.  I guess I'm trying to articulate why
> > it is acceptable to include the RWF_DATA_RECOVERY flag to the
> > existing RWF_ flags. - this way, pwritev2 remain fast on fast path,
> > and its slow path (w/ error clearing) is faster than other alternative.
> > Other alternative being 1 system call to clear the poison, and
> > another system call to run the fast pwrite for recovery, what
> > happens if something happened in between?
>
> Well, my point is doing recovery from bit errors is by definition not
> the fast path.  Which is why I'd rather keep it away from the pmem
> read/write fast path, which also happens to be the (much more important)
> non-pmem read/write path.

I would expect this interface to be useful outside of pmem as a
"failfast" or "try harder to recover" flag for reading over media
errors.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


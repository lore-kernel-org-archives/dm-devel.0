Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E092CC433F5
	for <dm-devel@archiver.kernel.org>; Sun, 12 Dec 2021 15:03:27 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-zY9j083WOUui82ynky6YhA-1; Sun, 12 Dec 2021 10:03:23 -0500
X-MC-Unique: zY9j083WOUui82ynky6YhA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6ADC1023F4E;
	Sun, 12 Dec 2021 15:03:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E1B51002EFB;
	Sun, 12 Dec 2021 15:03:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C6A494BB7C;
	Sun, 12 Dec 2021 15:03:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BCF3FuY032246 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Dec 2021 10:03:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A6B11492CA4; Sun, 12 Dec 2021 15:03:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A118F492CA3
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 15:03:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87842185A79C
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 15:03:15 +0000 (UTC)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
	[209.85.216.44]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-556-zhGLbA5KP-iYALq_OpUkbA-1; Sun, 12 Dec 2021 10:03:14 -0500
X-MC-Unique: zhGLbA5KP-iYALq_OpUkbA-1
Received: by mail-pj1-f44.google.com with SMTP id
	gx15-20020a17090b124f00b001a695f3734aso11401849pjb.0
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 07:03:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=ndCqA56yDPdk4/U5zH+4CHcCyXDgYIZ2oi0MLXCjqSE=;
	b=FDSQVOUpol/QrRy1oxiYC/V0womaQZ9N7lvWWaq1lPERTOc2tCzscEXcoQYor5CkoM
	/RtC4a9xJXM9O6y+LWhJXa3YcLzeSt6bnz3N/vicK1w+03X3ij8QTstXtiogBCmHr8hX
	tphBlo0Rhi6NaVyScYB8DpjvLC23KyWdA2FhNVtNYldTHAKvGXGMOfSe0PTTrBsCDon+
	sRccqoP8pIEhFLX5YDkMb3fyvburOj6ye+uO5Q1UOLnRDtVwAaGtLFbU2AZcCgsYxwNb
	evLNEbXDCAiqDzY0er6DdxQsVq1A01hv3V7wia/O/fgdxRmhS8iLN3/cuEsgYugXT9cK
	+/mA==
X-Gm-Message-State: AOAM531rMX63vbHkozHoxRRm2Qi00kw8ZfCUApXalrargMAXiQ+8C0Tk
	BVWfWTWPhxYNGWxnw7l3bW39YnCKDe1oc3EsxF2ZzA==
X-Google-Smtp-Source: ABdhPJzM6ThjE9fb1jBuOnaTRvStJ0J72a1wwy0FvBkYR9v9S0zmF+mqndMBqw+OLDevQiB5qKGoueX9OBCB41euCZc=
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id
	i11-20020a1709026acb00b0014276c3d35fmr89560721plt.89.1639321392929;
	Sun, 12 Dec 2021 07:03:12 -0800 (PST)
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-6-hch@lst.de>
In-Reply-To: <20211209063828.18944-6-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 07:03:02 -0800
Message-ID: <CAPcyv4gYXqbNRLkM4zJUq=sZuw4h_T+BSTXmESXc8juiWijKbQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
	Ira Weiny <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] dax: always use _copy_mc_to_iter in
	dax_copy_to_iter
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 8, 2021 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> While using the MC-safe copy routines is rather pointless on a virtual device
> like virtiofs, it also isn't harmful at all.  So just use _copy_mc_to_iter
> unconditionally to simplify the code.

>From a correctness perspective, yes, but from a performance perspective, see:

enable_copy_mc_fragile()

...on those platforms fast-string copy implementation is replaced with
a manual unrolled copy. So this will cause a performance regression on
those platforms.

How about let's keep this as is / still only use it for PMEM where end
users are already dealing with the performance difference across
platforms? I considered exporting an indicator of which backend
routine has been selected from arch/x86/lib/copy_mc.c, but it got
messy quickly so I fell back to just keeping the status quo.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


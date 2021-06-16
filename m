Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA27C48BDF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 00:18:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9A63061246
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 00:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A63061246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-7jnJmD4rNLCfwM-vOGAZrg-1; Tue, 15 Jun 2021 20:18:52 -0400
X-MC-Unique: 7jnJmD4rNLCfwM-vOGAZrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEB261850609;
	Wed, 16 Jun 2021 00:18:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D4415C1C2;
	Wed, 16 Jun 2021 00:18:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0E34B1D8A;
	Wed, 16 Jun 2021 00:18:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15G0IZ0U031320 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 20:18:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7A27C10340D; Wed, 16 Jun 2021 00:18:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75D77AECA2
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 00:18:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E0B81857F1E
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 00:18:32 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
	[209.85.214.180]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-463-2Zj9jbOiPbej_86NK2EwXw-1; Tue, 15 Jun 2021 20:18:30 -0400
X-MC-Unique: 2Zj9jbOiPbej_86NK2EwXw-1
Received: by mail-pl1-f180.google.com with SMTP id c15so123100pls.13
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 17:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=U9ut0QO/e/N5V/O+/xxowpWen8UQyCbn6qtxkVe0D8Y=;
	b=ethUqQvQdhyuS10yzihB1Hcy5FH1AX93qPxc7uY3fmdNVUTdaJgVmozyPjv6UjUhDg
	WzrNKBJGn2ZOr8Upn66UVzakMhgYmiolMFsbt4BDY2bW2HhSqCC3F78DTt+WQtw0Izmj
	pXqQyTTvsumOvXs2XqlU3R/PJ2OEjNj3ig/U9t1BVJkaQGUBEP+4+lvdT68OBOQZKTa7
	/HB599rwy/wmcJhUlBw9ehbfKOSUeQoCBFt0u6mNZIi/JvkyE9yeIosZj+9yMpNHJm33
	tLxAJcRqMtUFlxlwq5bjeEGBqHh6/NlkhX92mOLYPMv0FeOtzDGX0lV5BJM4Fu9rljK+
	Kgcg==
X-Gm-Message-State: AOAM531gF/MfBdavCYZtTXeonMKF+KHqHBTo0Whjl4qj/oTiDqsF2W6e
	Do5hrwdsyUCeFQwMg17v2668SKa2vtwsb0Wlbp1GOQ==
X-Google-Smtp-Source: ABdhPJyDslf/YwZkzYx2Z/IqSadb826GT3g94w753bjCVGDQs7kdVkKXA5TwIzZBSN9veDsTezagh2Bmxl7wkmkaDYQ=
X-Received: by 2002:a17:90a:ea8c:: with SMTP id
	h12mr7432919pjz.149.1623802708921; 
	Tue, 15 Jun 2021 17:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
	<20210604011844.1756145-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210604011844.1756145-2-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jun 2021 17:18:18 -0700
Message-ID: <CAPcyv4ibuHeQ7o=sTZpQoryv=_3WuBFJhodBnAEVRPmvo=nAeQ@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 01/10] pagemap: Introduce
	->memory_failure()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

Hi Ruan, apologies for the delays circling back to this.

>
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the filesystem in which
> the corrupted page located in.  And finally call filesystem handler to
> deal with this error.
>
> The filesystem will try to recover the corrupted data if possiable.
>

Let's move this change to the patch that needs it, this patch does not
do anything on its own.

> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  include/linux/memremap.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 45a79da89c5f..473fe18c516a 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -87,6 +87,14 @@ struct dev_pagemap_ops {
>          * the page back to a CPU accessible page.
>          */
>         vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
> +
> +       /*
> +        * Handle the memory failure happens on one page.  Notify the processes
> +        * who are using this page, and try to recover the data on this page
> +        * if necessary.
> +        */

I thought we discussed that this needed to be range based here:

https://lore.kernel.org/r/CAPcyv4jhUU3NVD8HLZnJzir+SugB6LnnrgJZ-jP45BZrbJ1dJQ@mail.gmail.com

...but also incorporate Christoph's feedback to not use notifiers.

> +       int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
> +                             int flags);

Change this callback to

int (*notify_memory_failure)(struct dev_pagemap *pgmap, unsigned long
pfn, unsigned long nr_pfns)

...to pass a range and to clarify that this callback is for
memory_failure() to notify the pgmap, the pgmap notifies the owner via
the holder callbacks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


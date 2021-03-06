Return-Path: <SRS0=EI4u=IE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D35C433DB
	for <dm-devel@archiver.kernel.org>; Sat,  6 Mar 2021 20:37:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B42C5650AE
	for <dm-devel@archiver.kernel.org>; Sat,  6 Mar 2021 20:37:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B42C5650AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-CByAOFNgMaqsbCk2jBgAEg-1; Sat, 06 Mar 2021 15:37:04 -0500
X-MC-Unique: CByAOFNgMaqsbCk2jBgAEg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C93C1842142;
	Sat,  6 Mar 2021 20:36:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C89C5C239;
	Sat,  6 Mar 2021 20:36:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C87B11809C86;
	Sat,  6 Mar 2021 20:36:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 126Kap0U012765 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 6 Mar 2021 15:36:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5610F20113E6; Sat,  6 Mar 2021 20:36:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5136920113E0
	for <dm-devel@redhat.com>; Sat,  6 Mar 2021 20:36:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E0398551E2
	for <dm-devel@redhat.com>; Sat,  6 Mar 2021 20:36:47 +0000 (UTC)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com
	[209.85.218.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-403-OcW3_iFTNFG74dESdv8sQg-1; Sat, 06 Mar 2021 15:36:45 -0500
X-MC-Unique: OcW3_iFTNFG74dESdv8sQg-1
Received: by mail-ej1-f41.google.com with SMTP id dx17so11552568ejb.2
	for <dm-devel@redhat.com>; Sat, 06 Mar 2021 12:36:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=bVBJNOetXrqKceA6PQT3AoaWCMo1uBzTwNd40e3p5Mg=;
	b=J2KPs9eyQ51BabKaHOvxNbr+4sq9lcGCD2q9Z8gPfxDuvGvxQIAg4lkD1liMVRSLQP
	65Ab9RbBLpgOaQMmtaHnW7nOlg81AXt+iX+ErMBSdR+ja8afExwkdwFJaIs566ydHqu2
	6BaLOdIS2cKhh+MK6BZGKGZZI8H80Nr3XvGQr2KjzZQiY89d3t8g5+HfqhE+fM00G8BM
	/UE9INRTnLi3phEFVvuE/7mDGLTyMcug2HHfTUuY5K+cRkbmW2mnyBoT9YhGO0FV8kR3
	AQ51ouJp/kutacFrb/LYlwPI0wW9swTmixP/aNw4dM057xb6yB5YDFAag6RKH1PSWkuH
	afDQ==
X-Gm-Message-State: AOAM530OEnfnBiwUEeM2u+KKPAhATGAdbzrzJ52HwwmUTiFfi2y+baw1
	6i6ktRv1mD1yrziNvR0HBYoj1hlLytTF+b9eUGI2Vw==
X-Google-Smtp-Source: ABdhPJwWg5JZfa53VPl0WuQEKYMbCdynjlz48fz7pdzLNK+5tXI6itu2L3u8T4IRUn3/J6V3gGOhtuytQtomfVZ9FIo=
X-Received: by 2002:a17:906:2818:: with SMTP id
	r24mr8202331ejc.472.1615063004125; 
	Sat, 06 Mar 2021 12:36:44 -0800 (PST)
MIME-Version: 1.0
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 6 Mar 2021 12:36:39 -0800
Message-ID: <CAPcyv4jqEdPoF5YM+jSYJd74KqRTwbbEum7=moa3=Wyn6UyU9g@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
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
Cc: Yasunori Goto <y-goto@fujitsu.com>, qi.fuli@fujitsu.com,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvdimm <linux-nvdimm@lists.01.org>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 01/11] pagemap: Introduce
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

On Mon, Feb 8, 2021 at 2:55 AM Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:
>
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the block device where
> the error page locates in, and try to get the filesystem on this block
> device.  And finally call filesystem handler to deal with the error.
> The filesystem will try to recover the corrupted data if possiable.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  include/linux/memremap.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 79c49e7f5c30..0bcf2b1e20bd 100644
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
> +       int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
> +                             int flags);
>  };

After the conversation with Dave I don't see the point of this. If
there is a memory_failure() on a page, why not just call
memory_failure()? That already knows how to find the inode and the
filesystem can be notified from there.

Although memory_failure() is inefficient for large range failures, I'm
not seeing a better option, so I'm going to test calling
memory_failure() over a large range whenever an in-use dax-device is
hot-removed.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


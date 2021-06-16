Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C622CC48BDF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 00:49:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F87C61246
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 00:49:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F87C61246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-AJVXqML-OAWyYlV6WagNEQ-1; Tue, 15 Jun 2021 20:49:15 -0400
X-MC-Unique: AJVXqML-OAWyYlV6WagNEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E395107ACF6;
	Wed, 16 Jun 2021 00:49:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EB2F5D9DE;
	Wed, 16 Jun 2021 00:49:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 181ED1809CAD;
	Wed, 16 Jun 2021 00:49:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15G0n8vM000564 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 20:49:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F42161112846; Wed, 16 Jun 2021 00:49:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFA441112843
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 00:49:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 368D718E0920
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 00:49:05 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
	[209.85.216.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-543-xPuPCBJzNIuTXzxEfaaF_g-1; Tue, 15 Jun 2021 20:49:01 -0400
X-MC-Unique: xPuPCBJzNIuTXzxEfaaF_g-1
Received: by mail-pj1-f53.google.com with SMTP id
	m13-20020a17090b068db02901656cc93a75so2919386pjz.3
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 17:49:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=N705IiD7n6FnNdMOVPwQtLkiV4KgkJ6X1/De6zQZWwI=;
	b=BRP7YcJ45jsXQcBYnDjVkDT6a6Fi1m2rVFkZ9klZGPqr55K7MJqjIlwD2wFKcI5che
	uofehhpnRXTcjJaQRp7K+zPfIirpwRN0kaWRRiLcogNS8OUv87qyd3xn+wb/tXksl8ci
	y7knbVKvds6714k7ezJIlZzS+kI86bpilTkkLvNmDfnIg99CHEGC+1WtxzsTbCH5/HkW
	XyFu0uIjM4so7LR+jJtBOlbhupzYaokhQYYxeXLaFCrpvU3WPNsJ9P3+kAj8ZuqURX8e
	vEocRnxYrWGEQqcbRG2PhFni6uzNeWIvalZeYIQ5vdJZ6tPAM8Jrmfx/yEcrx7bV81q9
	dHJw==
X-Gm-Message-State: AOAM53167nuPaqreP86fJY7ox1Ur5cwGfmKnui5jey8WEUtU9GOOB/gu
	CiDn1tkfPezN0I1UvQacVbLr4Rfd7DOOOPSxAixRDknqV5I=
X-Google-Smtp-Source: ABdhPJyPFTJSM7pJ7JUKFEZ8HQ+iir1f0oux2sr4aUWcOno+cjQdFNUvLXFLljz8kRS7NiWvMxxI/6TF54PHQ215JUQ=
X-Received: by 2002:a17:90a:8589:: with SMTP id
	m9mr7683966pjn.168.1623804539893; 
	Tue, 15 Jun 2021 17:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
	<20210604011844.1756145-4-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210604011844.1756145-4-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jun 2021 17:48:49 -0700
Message-ID: <CAPcyv4h=bUCgFudKTrW09dzi8MWxg7cBC9m68zX1=HY24ftR-A@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 03/10] fs: Introduce ->corrupted_range()
	for superblock
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[ drop old linux-nvdimm@lists.01.org, add nvdimm@lists.linux.dev ]

On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Memory failure occurs in fsdax mode will finally be handled in
> filesystem.  We introduce this interface to find out files or metadata
> affected by the corrupted range, and try to recover the corrupted data
> if possiable.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  include/linux/fs.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c3c88fdb9b2a..92af36c4225f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2176,6 +2176,8 @@ struct super_operations {
>                                   struct shrink_control *);
>         long (*free_cached_objects)(struct super_block *,
>                                     struct shrink_control *);
> +       int (*corrupted_range)(struct super_block *sb, struct block_device *bdev,
> +                              loff_t offset, size_t len, void *data);

Why does the superblock need a new operation? Wouldn't whatever
function is specified here just be specified to the dax_dev as the
->notify_failure() holder callback?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


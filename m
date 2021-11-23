Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A423C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 23:13:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-twbZEsBCOkySRdDKc0x0eQ-1; Tue, 23 Nov 2021 18:13:34 -0500
X-MC-Unique: twbZEsBCOkySRdDKc0x0eQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59CCE1922023;
	Tue, 23 Nov 2021 23:13:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EFE61835B;
	Tue, 23 Nov 2021 23:13:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1BC161832E85;
	Tue, 23 Nov 2021 23:13:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANNDTmP027221 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 18:13:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EE6EF4010FFC; Tue, 23 Nov 2021 23:13:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E962040CFD04
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:13:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D109485A5B5
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:13:28 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-500-6AYp9pZtNEqevfzPNDirtw-1; Tue, 23 Nov 2021 18:13:27 -0500
X-MC-Unique: 6AYp9pZtNEqevfzPNDirtw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE20260FC3;
	Tue, 23 Nov 2021 23:13:25 +0000 (UTC)
Date: Tue, 23 Nov 2021 15:13:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211123231325.GV266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-29-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-29-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 28/29] iomap: build the block based code
	conditionally
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 09, 2021 at 09:33:08AM +0100, Christoph Hellwig wrote:
> Only build the block based iomap code if CONFIG_BLOCK is set.  Currently
> that is always the case, but it will change soon.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/Kconfig        | 4 ++--
>  fs/iomap/Makefile | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index a6313a969bc5f..6d608330a096e 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -15,11 +15,11 @@ config VALIDATE_FS_PARSER
>  	  Enable this to perform validation of the parameter description for a
>  	  filesystem when it is registered.
>  
> -if BLOCK
> -
>  config FS_IOMAP
>  	bool
>  
> +if BLOCK
> +
>  source "fs/ext2/Kconfig"
>  source "fs/ext4/Kconfig"
>  source "fs/jbd2/Kconfig"
> diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
> index 4143a3ff89dbc..fc070184b7faa 100644
> --- a/fs/iomap/Makefile
> +++ b/fs/iomap/Makefile
> @@ -9,9 +9,9 @@ ccflags-y += -I $(srctree)/$(src)		# needed for trace events
>  obj-$(CONFIG_FS_IOMAP)		+= iomap.o
>  
>  iomap-y				+= trace.o \
> -				   buffered-io.o \
> +				   iter.o
> +iomap-$(CONFIG_BLOCK)		+= buffered-io.o \
>  				   direct-io.o \
>  				   fiemap.o \
> -				   iter.o \
>  				   seek.o
>  iomap-$(CONFIG_SWAP)		+= swapfile.o
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


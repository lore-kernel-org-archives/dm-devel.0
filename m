Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABDEC56201
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 20:19:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ADB9F207BB
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 20:19:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADB9F207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-tEZCJXYcNQ-OPq6ide6_CA-1; Wed, 25 Nov 2020 15:19:52 -0500
X-MC-Unique: tEZCJXYcNQ-OPq6ide6_CA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1282100671C;
	Wed, 25 Nov 2020 20:19:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C4CB360854;
	Wed, 25 Nov 2020 20:19:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1E5504A7C6;
	Wed, 25 Nov 2020 20:19:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0APKJd9i032219 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 15:19:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A913E10FFE7F; Wed, 25 Nov 2020 20:19:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A465410FFE7C
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 20:19:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20B62103B803
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 20:19:37 +0000 (UTC)
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com
	[209.85.222.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-318-ij6h6allOaWtyarEEcBMtA-1; Wed, 25 Nov 2020 15:19:34 -0500
X-MC-Unique: ij6h6allOaWtyarEEcBMtA-1
Received: by mail-qk1-f195.google.com with SMTP id x25so4654671qkj.3;
	Wed, 25 Nov 2020 12:19:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=wTpG1f7I5Mn7omq14ZEE1b1D1RGafIOA8Nh3enwy9Pw=;
	b=hG49pAL4sS9+Hhoz4CRNv6owl5yZYeedaZQv7HietISbl0iCh6QpbGx+SiIbjfi/tr
	LWJirAb/M0dmDzR7HdCrxRDWgsZF6SwpL0BAEAaHcUV4POXqaAlWre/ulKTS6CVPhBYp
	Mxm6Ig26d4BFQkO0RDBSJYdJR+koNrKS1ddOXz6SrTVoLbv3nHWE+gIvRvmoWztC+ZyU
	7av2pJA4L0/QJatxaX69ZIk4B0L5GbUu4jtkRMIB7ghA5A3DsW+/SCYB9yuYzcO8A3/u
	4Hz0bJO6Z5t/HsZV51cA5BWnJmDT0cDIoOO+8cCjd9YXAlrzTOMrv5FSD7tcTvq492z0
	bIvg==
X-Gm-Message-State: AOAM530e7h4kyQS86tgPUY4R+g378xv0W4RZExWCHYe7XYQeT1ArmwLy
	OcQb/CAN7ZtqebXEpKfrMcI=
X-Google-Smtp-Source: ABdhPJzv1jmYfISttH52Qv7X3ML12jiaN/y3FPvYZps3l/Q0JJ9ycbQ/3m35eYW3aCrzEXDwhiCBYw==
X-Received: by 2002:a37:4796:: with SMTP id u144mr656941qka.235.1606335573858; 
	Wed, 25 Nov 2020 12:19:33 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id w54sm446145qtb.0.2020.11.25.12.19.32
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 25 Nov 2020 12:19:33 -0800 (PST)
Date: Wed, 25 Nov 2020 15:19:10 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X768PnFhrPtJk4U5@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-24-hch@lst.de>
	<X71g4Tm+3RiRg4Gf@mtj.duckdns.org> <20201125162926.GA1024@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201125162926.GA1024@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 23/45] block: remove i_bdev
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

On Wed, Nov 25, 2020 at 05:29:26PM +0100, Christoph Hellwig wrote:
> > I was wondering whether losing the stale bdev flushing in bd_acquire() would
> > cause user-visible behavior changes but can't see how it would given that
> > userland has no way of holding onto a specific instance of block inode.
> > Maybe it's something worth mentioning in the commit message?
> 
> With stale bdev flushing do you mean the call to bd_forget if
> i_bdev exists but is unhashed?  It doesn't actually flush anything but

Yeah.

> just detaches the old bdev from the inode so that the new one can be
> attached.  That problem goes away by definition if we don't attach
> the bdev to the inode.

Yeah, I think so. Was just wondering whether the problem actually goes away.

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE58C2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 21:20:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F4B6206E0
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 21:20:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F4B6206E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-5OaC5Eh6OT-tjX7FahKPnA-1; Tue, 24 Nov 2020 16:20:08 -0500
X-MC-Unique: 5OaC5Eh6OT-tjX7FahKPnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3F361DDF4;
	Tue, 24 Nov 2020 21:20:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE1C310023AF;
	Tue, 24 Nov 2020 21:20:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3FA094A7C6;
	Tue, 24 Nov 2020 21:20:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOLJxgq021165 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 16:20:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CD15A110F0A2; Tue, 24 Nov 2020 21:19:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6FBD100415F
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 21:19:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74332185A794
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 21:19:57 +0000 (UTC)
Received: from mail-qv1-f68.google.com (mail-qv1-f68.google.com
	[209.85.219.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-274-hInds3PYP9aJQyGieB2G0w-1; Tue, 24 Nov 2020 16:19:54 -0500
X-MC-Unique: hInds3PYP9aJQyGieB2G0w-1
Received: by mail-qv1-f68.google.com with SMTP id dm12so460433qvb.3;
	Tue, 24 Nov 2020 13:19:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=A2Ux7RQ7mBCZEojzGvR0WDuZtfXBN33NUKSWm/nAx2s=;
	b=AGLwTNAfColbTzvdLssnxv2gB2mhueiypa1mnrms/Q1ceMvvQgXtQ7yjBfETd6Ed/a
	DAGTkZ48oW3gBGO3dq81CoLB86SgV4F6O6yHrEsCmgWrJq0n9Jh3zz9oFY3irDjNhxXx
	mAt83iv+C6Xr+lAFP1Y4x9Q9NUkcp5Fx7ksxWT0sOHiDVlCpUHqNWEE1YOVxQkOQM45v
	1lKNBcl+gpfRbwT2JdMGAStU9gB0lP29qyX2W9NTQmgH4s85XvxCU0KfAAd9XbF/hnGt
	tgVWuLVCAwKWRXPAYzFckqf7UJngrNDtzDK2NO+dd2+jNCmipGvgo3zUToxd6Y5LKt8m
	mOYg==
X-Gm-Message-State: AOAM533y5vA6e1T3VSlBNDXc0MHQSalE+AM48UP1Z/5rssVtFGOhAjO0
	8nQSkVc9zsLInDGOyhUwKmY=
X-Google-Smtp-Source: ABdhPJxvWSMIcF1QvtVmsROEnFEfbgneWE4I12McWSmR7ItrCaZw+O6oSDwh472sj7fwnSIDMbgqhQ==
X-Received: by 2002:a05:6214:443:: with SMTP id
	cc3mr455144qvb.53.1606252794270; 
	Tue, 24 Nov 2020 13:19:54 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id l46sm308143qta.44.2020.11.24.13.19.53
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 13:19:53 -0800 (PST)
Date: Tue, 24 Nov 2020 16:19:31 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X7144xvjxqhopOck@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-27-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-27-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 26/45] block: remove ->bd_contains
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:32PM +0100, Christoph Hellwig wrote:
> Now that each hd_struct has a reference to the corresponding
> block_device, there is no need for the bd_contains pointer.  Add
> a bdev_whole() helper to look up the whole device block_device
> struture instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Jan Kara <jack@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8639C6369E
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:09:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0C87E221FB
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:09:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C87E221FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-C-8FkCeIP22Rmg6XU_HYKQ-1; Wed, 02 Dec 2020 18:09:34 -0500
X-MC-Unique: C-8FkCeIP22Rmg6XU_HYKQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B33F855901;
	Wed,  2 Dec 2020 23:09:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EAF45C1B4;
	Wed,  2 Dec 2020 23:09:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BFF37180954D;
	Wed,  2 Dec 2020 23:09:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2N9TZ8019680 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 18:09:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E345F1016D92; Wed,  2 Dec 2020 23:09:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEFBF100C28A
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 23:09:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FC61185A794
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 23:09:26 +0000 (UTC)
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com
	[209.85.222.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-201-KVoY61pvNl-1OMpqpZIVYg-1; Wed, 02 Dec 2020 18:09:24 -0500
X-MC-Unique: KVoY61pvNl-1OMpqpZIVYg-1
Received: by mail-qk1-f194.google.com with SMTP id v143so469211qkb.2
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 15:09:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=UrdtiO/QrBY20Yi4TmEbqEfbQLVKUAJywZnSXTzypgw=;
	b=hFQ1xa0cmo86FQJ3gJJefLIM6gF625vSsL7E7WcQcf6LC2dfcupIT4tGOflrwxwdLE
	WXwDy1O3Eu1cYbaVByJf4/FNDr15i81cjpoclznxU/6fIqFzW7iPqCLq2vrYqiR46xx7
	IYzuPC+Hkzigveyf+AH4kkkzDKcztkD8VcZL9fX6jkxtSpD5/nklrRmK0woXhidrXXcm
	qRA9yZnw1neSM8ZXKf2puyqWyghV3VIrg2nutRsx+1PrNvKGRs37sCuuvkms2vhAzYhG
	pxGE+POfZuusBL43Du6IgwQIRUMxjt5Zx11+axi4mPWxqtps9NxmgJNXQXrrGVN4mpND
	3byA==
X-Gm-Message-State: AOAM532ZTNPK+5bAu44ebEJkL9XAR2TojzyOwIrjSsArGjrXFsv7w5wr
	Ih5Sf7pgFNijlHHeXu7Kres=
X-Google-Smtp-Source: ABdhPJzqmlQiVDw6RKd2+jPOUsHCqhHzIKWhKxr7ZTfOl1seoWS7W/a/BZr7JZODJGPZBbBxPoV4zw==
X-Received: by 2002:ae9:de03:: with SMTP id s3mr134212qkf.218.1606950563515;
	Wed, 02 Dec 2020 15:09:23 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id v204sm155597qka.4.2020.12.02.15.09.22
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 15:09:22 -0800 (PST)
Date: Wed, 2 Dec 2020 18:08:54 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8gehr+JRCz8w4xt@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
	<20201201165424.2030647-8-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-8-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 7/9] block: add a disk_uevent helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 01, 2020 at 05:54:22PM +0100, Christoph Hellwig wrote:
> Add a helper to call kobject_uevent for the disk and all partitions, and
> unexport the disk_part_iter_* helpers that are now only used in the core
> block code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


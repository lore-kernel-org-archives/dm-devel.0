Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31D9C64E7A
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:38:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 38161206C0
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:38:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38161206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-sX_8_-KfOiac3vrMz2zWsw-1; Tue, 24 Nov 2020 12:38:49 -0500
X-MC-Unique: sX_8_-KfOiac3vrMz2zWsw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2684107AFD5;
	Tue, 24 Nov 2020 17:37:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56A9C4D;
	Tue, 24 Nov 2020 17:37:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A0CD180954D;
	Tue, 24 Nov 2020 17:37:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOHbex6021818 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 12:37:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9DED4112C086; Tue, 24 Nov 2020 17:37:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A16F1018E60
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:37:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66ED3811E98
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:37:38 +0000 (UTC)
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com
	[209.85.219.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-28-rozAIaU8NAmFsDAfEGZ-vQ-1; Tue, 24 Nov 2020 12:37:33 -0500
X-MC-Unique: rozAIaU8NAmFsDAfEGZ-vQ-1
Received: by mail-qv1-f65.google.com with SMTP id q7so10967734qvt.12;
	Tue, 24 Nov 2020 09:37:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=NMx3wGtNfY3eeaXC4utlwl41yJ4qPilA6BGetqYUorY=;
	b=qTlqzQlWDlv6nk+09NsAc6mvEjJeVZg5Bnny95/2SjWBWC4sfBdvZPT/DUb4xocl9a
	ugaOZzvLLeoGKUbl1vFxidY48//1ZNmRktAP49oZIkbAc1h9PEvgvFaTwpxY99PfgmdM
	zH6ED2m37W9hN4jCtzeRFlmCmRmKZRlgT+pDqEcyrokw3bcxm/TEYsaStpYPrzVp+JIT
	6AYQB+jaKUjO2b0mUR6dFaXuaCn+Hemkj0xVf8O6bizaExhEVUusvRdq1/unmCexv/k7
	jIqF37ZFuJi6inx+8pA8esPZg5cnMP0IpbKu49tIqGZpwd8MfzPgkaZvX6KuRE1uYHAi
	c/jA==
X-Gm-Message-State: AOAM533KjyVlR+oETvFPB24KAbwAwO803F00OyCF6or/s7D4p7Hj9Akc
	uxansCp5gapg6PKre/mzmiM=
X-Google-Smtp-Source: ABdhPJzX+Vh2Egxjq814YfOpUGajTbbALAhbpqH5gqFyQRlGy9nqyUOsvItkj0Gt+6yRJDRCbrF4QA==
X-Received: by 2002:a05:6214:4e5:: with SMTP id
	cl5mr5723077qvb.42.1606239452550; 
	Tue, 24 Nov 2020 09:37:32 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	k70sm13834520qke.46.2020.11.24.09.37.31
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 09:37:31 -0800 (PST)
Date: Tue, 24 Nov 2020 12:37:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71ExfXNm5IC7xMq@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-13-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-13-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 12/45] block: remove a superflous check in
	blkpg_do_ioctl
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:18PM +0100, Christoph Hellwig wrote:
> sector_t is now always a u64, so this check is not needed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


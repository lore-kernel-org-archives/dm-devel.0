Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEA4C6369E
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:16:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 99AB7206E0
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:16:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99AB7206E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-ft14OqPXMXCdFIOYyiLhHw-1; Wed, 02 Dec 2020 18:16:42 -0500
X-MC-Unique: ft14OqPXMXCdFIOYyiLhHw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63B0A423B9;
	Wed,  2 Dec 2020 23:16:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C8BB60854;
	Wed,  2 Dec 2020 23:16:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B10DE4BB7B;
	Wed,  2 Dec 2020 23:16:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2NGYg5020154 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 18:16:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9A3892166B2B; Wed,  2 Dec 2020 23:16:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93B192166B29
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 23:16:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC269811E76
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 23:16:28 +0000 (UTC)
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com
	[209.85.222.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-328-R0PxhAVwMTWaYSDZJ-8cUQ-1; Wed, 02 Dec 2020 18:16:27 -0500
X-MC-Unique: R0PxhAVwMTWaYSDZJ-8cUQ-1
Received: by mail-qk1-f194.google.com with SMTP id y18so427010qki.11
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 15:16:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=EeuwLeoomrRX1U6jiimxDGdm+UmMVxu8rCoS4eNDoAg=;
	b=tvmVLnpigu0+ymKYpf47OadiB9bHxmG/P8lm5g8D6DtJ4DVdII/cpY+zT1m7+n3VCM
	rIAIbNY/LhOTHg6wU7ioIUDJ06AXpmbP6AsywORHO/zuUuAc2hKQxMK6eCZDJAImR606
	tOFWp76w57hzP1/PnPWe0l2ZDSulb9dTzqAPeZ9fa9pNR+r4zep5CTY6ZrqV/dgrjxAx
	wxoBHVUgw/A8gX5FybiWRimDtRpdHlgdiQg6nWwKHLywODgMzVr8lIQhbwObX3gRup/n
	YBYcRF4l4ik8xr7bceR5NytX5htiXr6ndMnoiwSt9jEgBfSqgVSuiL8nQz5B6ZqglHFz
	QjQA==
X-Gm-Message-State: AOAM531Lm/NJvWQJz4wVUcWOzePL4Kfli+SAAy0PHcLhz+Vzs9XMCht+
	oV35uDY23Gy0ensG5pWpjeY=
X-Google-Smtp-Source: ABdhPJw74aI5NUv2CAvLU/CD9FKcox1VupQf9vmhaG7IqRQi0hDXcbQvftKzKEPArmc+kjavi+g65w==
X-Received: by 2002:a05:620a:164b:: with SMTP id
	c11mr135922qko.203.1606950986443; 
	Wed, 02 Dec 2020 15:16:26 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id p62sm149702qkf.50.2020.12.02.15.16.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 15:16:25 -0800 (PST)
Date: Wed, 2 Dec 2020 18:15:57 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8ggLXsNOCh6Mrj0@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
	<20201201165424.2030647-9-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-9-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 8/9] block: remove DISK_PITER_REVERSE
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

On Tue, Dec 01, 2020 at 05:54:23PM +0100, Christoph Hellwig wrote:
> There is good reason to iterate backwards when deleting all partitions in
> del_gendisk, just like we don't in blk_drop_partitions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, I was blindly keeping the iteration order. Can't find any explicit
explanation why it was that way. The reverse iteration there goes back to
the initial git import. But yeah, I can't think of any meaningful difference
which can come out of it.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


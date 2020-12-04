Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F757C4361B
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:43:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACC5B22AAF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:43:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACC5B22AAF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-PspXTLyjN6auw4DgpaU48w-1; Fri, 04 Dec 2020 11:43:39 -0500
X-MC-Unique: PspXTLyjN6auw4DgpaU48w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6A358F2678;
	Fri,  4 Dec 2020 16:43:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A547E6F44D;
	Fri,  4 Dec 2020 16:43:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 476B21809C9F;
	Fri,  4 Dec 2020 16:43:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4Gh8eC009932 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 11:43:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 599AD2028CD8; Fri,  4 Dec 2020 16:43:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54AD52026611
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 16:43:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA3ED8007DF
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 16:43:04 +0000 (UTC)
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com
	[209.85.166.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-382-B8JvnFohPm-G1DPJDGGL9A-1; Fri, 04 Dec 2020 11:43:02 -0500
X-MC-Unique: B8JvnFohPm-G1DPJDGGL9A-1
Received: by mail-il1-f196.google.com with SMTP id b8so5731706ila.13
	for <dm-devel@redhat.com>; Fri, 04 Dec 2020 08:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=eMCK196yGD9HEmztT5X4HDwb0AlO+qvFoU6onkVpAVY=;
	b=DRZRtcHr6IcMSvjfOnbDJsrFC5fG+tsollWp7kKLUdWYpsNbUYVIoyxs/6u9aNvMb6
	dKYJIPH7SxSHDSis4ArPMjHLNEyRqWusQgNA7OGVJbnWK/wTHz9sqAKW52NTdgBTE3LJ
	M+4uhcF4JJjYlL19W92LUW168IBD0AALwFHbbJ92d12xLNhT0iIDLfH2y45n9EmnrI8H
	UgHh3bMCOJ0QkIwn7cTZr5T/nkojzdGHDaWWfu/TaNKdOkPm87XvVHGEzYOsmajb+diN
	fD7BmPZ0VbVdACGUSS6/AXu46ykp9KGQQ53xucp7GqyRe6PvBxoF5rXQY2G9ofd2ywfY
	9GtQ==
X-Gm-Message-State: AOAM5304fXpW6sVt5mm36Lb55NQhYVBr45LOEnqimTx/SnWNhK9pa09l
	BEfmI9/RnOnKSCaFnFy+i9SFEA==
X-Google-Smtp-Source: ABdhPJzAzVGKZD0+jfQBEzVp6xMbQWg671BzhxHKVihCK0qVzrk8H6Zb94kitBpSOVrN+CsFf10McA==
X-Received: by 2002:a92:58cb:: with SMTP id z72mr7331084ilf.104.1607100181830; 
	Fri, 04 Dec 2020 08:43:01 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id h1sm1874781ilj.8.2020.12.04.08.43.00
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 04 Dec 2020 08:43:01 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <285e5e82-2e9c-a1db-b9b6-b82ec95aea6d@kernel.dk>
Date: Fri, 4 Dec 2020 09:43:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
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
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] store a pointer to the block_device in struct bio
	(again)
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/1/20 9:54 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series switches back from storing the gendisk + partno to storing
> a block_device pointer in struct bio.  The reason is two fold:  for one
> the new struct block_device actually is always available, removing the
> need to avoid originally.  Second the merge struct block_device is much
> more useful than the old one, as storing it avoids the need for looking
> up what used to be hd_struct during partition remapping and I/O
> accounting.
> 
> Note that this series depends on the posted but not merged
> "block tracepoint cleanups" series.

Applied, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


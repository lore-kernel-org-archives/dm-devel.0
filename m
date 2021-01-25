Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7A0C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 17:57:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2418622B3F
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 17:57:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2418622B3F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-E8Oyn-TtOCiYcB4Fhvv0RQ-1; Mon, 25 Jan 2021 12:57:16 -0500
X-MC-Unique: E8Oyn-TtOCiYcB4Fhvv0RQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D673B8144E1;
	Mon, 25 Jan 2021 17:57:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BECBF10021B3;
	Mon, 25 Jan 2021 17:57:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 606F018095FF;
	Mon, 25 Jan 2021 17:57:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PHrkXn002048 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 12:53:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 572C12166B28; Mon, 25 Jan 2021 17:53:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDE472166B2D
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 17:53:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91CB6811E86
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 17:53:43 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
	[209.85.215.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-433-kub2lTpFMYmz1xKlBy_yGg-1; Mon, 25 Jan 2021 12:53:41 -0500
X-MC-Unique: kub2lTpFMYmz1xKlBy_yGg-1
Received: by mail-pg1-f169.google.com with SMTP id t25so1491907pga.2
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 09:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:subject:to:cc:references:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=s6C9gJtxVOS7uf+wB+GNYwlfWiptrVoeydv0VcfghHQ=;
	b=lh09U7IIA1nQPvFg86feKvOmLE5la/ucAYJKoFsHF9e/Iy8Jve0tpPAWTvvQwSMucB
	EdYefq0cz0jHmz6DglrZ846LWGWzJk4HQuDog7cUPTg0vy1WhA8e9iE1Dj67mO99PXNJ
	wnfBB5EgjnC2f0C2bNdMEWWBBs7RA3Ks5pa9vIpRfDG7yeVQjuUyFNAJIwO6/cQFt++p
	9hR/onrsUhbCl7SOV7A/KIKmI2UOwtBBFl8tuQa+2Wm4Ph88QJEjUJcsrihHxswY9TAq
	cqd3O2NZfOs+CU45C0phEKLadouxDk/mSjFEuF6msSTOT0Aza6B1sZMQnNWXwMgYhht4
	5clw==
X-Gm-Message-State: AOAM533iOs6r+5nd3owblk34iBBJ4eDKalFTqtcn6QcUCpbW0aUfyf18
	J9vuYdzvcP2XhvaEH4ENczxKCA==
X-Google-Smtp-Source: ABdhPJz+3LqFBlzn1c2vwQXmjnqICAm1FJDtAAzq4zb0CLdcKLr0vlHa6YNJJKFSu/hugPFO9HX2QA==
X-Received: by 2002:aa7:80c6:0:b029:1b6:92ae:a199 with SMTP id
	a6-20020aa780c60000b02901b692aea199mr1363354pfn.71.1611597219540;
	Mon, 25 Jan 2021 09:53:39 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
	by smtp.gmail.com with ESMTPSA id
	n2sm17364646pfu.129.2021.01.25.09.53.37
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 25 Jan 2021 09:53:38 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
	<20210124100241.1167849-6-hch@lst.de>
Message-ID: <dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
Date: Mon, 25 Jan 2021 10:53:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210124100241.1167849-6-hch@lst.de>
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
Cc: linux-s390 <linux-s390@vger.kernel.org>,
	linux-bcache <linux-bcache@vger.kernel.org>, Coly Li <colyli@suse.de>,
	"open list:SOFTWARE RAID \(Multiple Disks\) SUPPORT"
	<linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-block <linux-block@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 05/10] block: do not reassig ->bi_bdev when
 partition remapping
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jan 24, 2021 at 3:05 AM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no good reason to reassign ->bi_bdev when remapping the
> partition-relative block number to the device wide one, as all the
> information required by the drivers comes from the gendisk anyway.
>
> Keeping the original ->bi_bdev alive will allow to greatly simplify
> the partition-away I/O accounting.

This one causes boot failures for me on my laptop...

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


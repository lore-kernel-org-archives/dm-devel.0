Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9490C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 19E4122C9E
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19E4122C9E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-wmmLaXrkNYy904iXQ9JoZw-1; Mon, 25 Jan 2021 13:15:20 -0500
X-MC-Unique: wmmLaXrkNYy904iXQ9JoZw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 189BB8144E4;
	Mon, 25 Jan 2021 18:15:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB7C060C9C;
	Mon, 25 Jan 2021 18:15:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B121718095FF;
	Mon, 25 Jan 2021 18:15:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PIFDHt004480 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 13:15:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C3182026D3B; Mon, 25 Jan 2021 18:15:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 772EE2026D37
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:15:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 253DD80122E
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:15:11 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
	[209.85.214.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-503-w_3zcfwoNUa7BoPq9j_DBw-1; Mon, 25 Jan 2021 13:15:09 -0500
X-MC-Unique: w_3zcfwoNUa7BoPq9j_DBw-1
Received: by mail-pl1-f175.google.com with SMTP id q2so5397286plk.4
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 10:15:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=iLTv01uXk/wv0jk2KXYxjzAWyCAaqM7QWnaj23VL+4A=;
	b=q0v48s+PYLoAJc5a7X1185HpLIvS38RpmUEqDrW3whOSeJjFTfhn0XtmPyusa6m4Tv
	stCu/Z78HiOKT/Hylip2Hk39DJ7rZLtbWrdYqAtjS5C4OMPAPwngm46uC9A3oxeBGkPX
	fq0NHYaRPD6lLEm4YilRDiCRe4XO+FGnJg2p/Xhrpmbf/6J5FU/gQP/30etJmFI49Y5E
	ynR8Pu+/1o0T3xt6Yj5OhJdds+BcEgM+v0du0I4I7FDPRGPe3hW3xzE+bX0/VnB/TfEJ
	bthRR696tcLbVpi+VKoGqzGvCKNY4I6dwUTSk3pQaBK86jLWguBrLfizq1b1T5XAjEOL
	ILbg==
X-Gm-Message-State: AOAM5306lZ92uP37wzozM3iUbHt/JO1WvxWsfAnLdyYhFOGgBH1s4EHT
	TsAWJ79F+BltebEDeWlR5hfFVfcQe5ZS4g==
X-Google-Smtp-Source: ABdhPJz8SyBo1RX92xF49AhFTV3BqR0FC5DwFrUN23IIQ1Vim/H9NC7K0PDXzYiDOKSkvVh6fA2QIg==
X-Received: by 2002:a17:90a:9912:: with SMTP id
	b18mr1531400pjp.120.1611598507845; 
	Mon, 25 Jan 2021 10:15:07 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
	by smtp.gmail.com with ESMTPSA id
	o13sm16813902pfg.124.2021.01.25.10.15.05
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 25 Jan 2021 10:15:07 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
	<20210124100241.1167849-6-hch@lst.de>
	<dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
	<20210125175528.GA13451@lst.de>
	<2b600368-96fa-7caf-f05b-321de616f7c9@kernel.dk>
	<13667b22-029b-d7be-02da-96fce22cfd8f@kernel.dk>
	<20210125181349.GA14432@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1c0fabdc-9b73-dfd7-f49d-c211d58cbf12@kernel.dk>
Date: Mon, 25 Jan 2021 11:15:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125181349.GA14432@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/25/21 11:13 AM, Christoph Hellwig wrote:
> On Mon, Jan 25, 2021 at 11:03:24AM -0700, Jens Axboe wrote:
>> Partition table entries are not in disk order.
> 
> And the issue shows up with the series just up to the this patch,
> without any later patches?

At that patch specifically. I bisected it, and then I double checked
by running the previous commit (boots fine), then apply this one, and
then I run into that error. So it should be 100% reliable.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


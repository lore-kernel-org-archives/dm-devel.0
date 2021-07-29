Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3881C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:02:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 360BA60EC0
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:02:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 360BA60EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-xRRABUBBP5m29wl6VPuYGw-1; Thu, 29 Jul 2021 11:02:08 -0400
X-MC-Unique: xRRABUBBP5m29wl6VPuYGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D34987D546;
	Thu, 29 Jul 2021 15:01:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C5C5E60877;
	Thu, 29 Jul 2021 15:01:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C2A3E180BAB0;
	Thu, 29 Jul 2021 15:01:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TF1mRj001792 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 11:01:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E0DB6209D0C5; Thu, 29 Jul 2021 15:01:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6C9320A8DDB
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 15:01:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22FC38D1387
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 15:01:45 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
	[209.85.221.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-530-RI7T0H37Nh2tdmFRURohjg-1; Thu, 29 Jul 2021 11:01:40 -0400
X-MC-Unique: RI7T0H37Nh2tdmFRURohjg-1
Received: by mail-wr1-f45.google.com with SMTP id h14so7304571wrx.10;
	Thu, 29 Jul 2021 08:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=V4O1I87U2stEkz/YUjYSiQ1/9SiHiehqPp46NQ2rxgg=;
	b=WFr7n8hVsksgY4dj6iAU6Rau5hicOFDM4ArbNaoly7lEabxOtJbDm34dfRDIv0Y7EJ
	FQjAcy4ZeGYZA7gEHQA3ULrMEKpozEVPAygxVGKm1owHrCBiRrOoPfGcKK2g91Qrusyh
	1QZ16IRzdXJ4wpX5cBxSzv1my6vr1Ec5Ac6fS5R7Ij5Fwr8wyvz/JRSz3NVfJsKHLMoq
	1mbCCbIdwiXB+5ZMi8yj3APg8xcPnvcmXy0uShkgHW7c+n24VUUVL8yg9rKNsGe/zEN6
	vnZe6eRInK10K41+sOzA1qrUZHHU4LGoaJOvNXdE+C5RmErqi+pimqcx2Gj4GBEG2rDY
	jQbQ==
X-Gm-Message-State: AOAM530TdvBZZJVGvF75cLqEpOttNkCQ2xIGxFbMTgOGqw+MKVMMrqMZ
	hkphHuNmO00hmxGF3z5+9PYOEndPFSY=
X-Google-Smtp-Source: ABdhPJxE8iS/k3YsL8C6WjITTXbMpLzLrNKRoRz3wfn+er3aI1WsiwbtBXf8HXoDfLKku0i+q22GHQ==
X-Received: by 2002:adf:ed45:: with SMTP id u5mr5369561wro.203.1627570899385; 
	Thu, 29 Jul 2021 08:01:39 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id t1sm3567140wma.28.2021.07.29.08.01.38
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 29 Jul 2021 08:01:38 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>
References: <20210725055458.29008-1-hch@lst.de> <YQAtNkd8T1w/cSLc@redhat.com>
	<20210727160226.GA17989@lst.de> <YQAxyjrGJpl7UkNG@redhat.com>
	<9c719e1d-f8da-f1f3-57a9-3802aa1312d4@gmail.com>
	<20210728070655.GA5086@lst.de>
	<9e668239-78cc-55ad-8998-b7e39f573c34@gmail.com>
	<20210728112430.GA22101@lst.de>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <b51ac16f-bede-15df-ac8c-b219e06f9060@gmail.com>
Date: Thu, 29 Jul 2021 17:01:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728112430.GA22101@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] use regular gendisk registration in device mapper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 28/07/2021 13:24, Christoph Hellwig wrote:
> On Wed, Jul 28, 2021 at 10:37:41AM +0200, Milan Broz wrote:
>> very specific hw attributes. So you have one emulated device compiled-in?
> 
> Yes.
> 
>> Or there is another way how to configure scsi_debug if compiled-in? (we use module parameters, I think it is
>> the same was how util-linux testsute works with scsi_debug).
> 
> Can can add hosts using the add_host sysfs file.  I thought that was the
> way to go generally, never thought of reloading the module just to
> add/delete hosts.

Heh, I just thought the opposite -that using kernel parameters is the way how to use it :-)

> 
>> (BTW could you send me output of the failed test run? I run it over Linus' tree and ti works so it is perhaps another
>> assumption that should be fixed.)
> 
> Output with everything from the README installed (a lot less failures now):

We cannot run some tests without scsi_debug as module, so I at least added detection for compiled-in scsi_debug
and some module error noise removal. (There is still a lot of operations tested without this.)

For the kernel dependencies:
For cryptsetup project and testsuite is good to have also enabled userspace crypto API interface (CONFIG_CRYPTO_USER)
and keyring (CONFIG_KEYS) but we should be able to run without it.
(The rest is specific crypto algs used in test images, but these are skipped if not available.)

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=q8o8=NG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74A7C4338F
	for <dm-devel@archiver.kernel.org>; Sun, 15 Aug 2021 14:28:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 588876112D
	for <dm-devel@archiver.kernel.org>; Sun, 15 Aug 2021 14:28:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 588876112D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-Y6jitwBqMUKVOZ-n_Btawg-1; Sun, 15 Aug 2021 10:27:58 -0400
X-MC-Unique: Y6jitwBqMUKVOZ-n_Btawg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EB6687D541;
	Sun, 15 Aug 2021 14:27:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7557160C82;
	Sun, 15 Aug 2021 14:27:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B5B574BB7C;
	Sun, 15 Aug 2021 14:27:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17FERkEr009912 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 15 Aug 2021 10:27:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A1813200A39A; Sun, 15 Aug 2021 14:27:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CDE72024CD4
	for <dm-devel@redhat.com>; Sun, 15 Aug 2021 14:27:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDEFC185A7A4
	for <dm-devel@redhat.com>; Sun, 15 Aug 2021 14:27:42 +0000 (UTC)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com
	[209.85.210.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-469-ax92BM_rMTClaXsv0VTkGA-1; Sun, 15 Aug 2021 10:27:40 -0400
X-MC-Unique: ax92BM_rMTClaXsv0VTkGA-1
Received: by mail-ot1-f54.google.com with SMTP id
	u13-20020a9d4d8d0000b02905177c9e0a4aso7405937otk.3; 
	Sun, 15 Aug 2021 07:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
	:date:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=6c7zBDU5BkSft4TW2fJaqiBbGNodfBo2siSVYmSoJjM=;
	b=ZO2G89NmTmahYXoPDkrljEuPWjMEA444FXio0hdY6SFjjHKfz6HxtJk5NtLv4G3Za2
	tjTynrzsMcv2xQSnmJCNOYJrW6HYFoKN4FJTlPlwsiUp7UWLs7fSxTrp+4Tvr1DUETW4
	LNfVrDSrKVtHSR24/KLHH3xM3Hv/MZ8xV8PfGN4HnLbBsfkfVxy2+ie7F6L0eVeh6YIF
	LmT9BXVk4ZD4UOJ9IMksIzhjpKtWo9ViJXqiGM2vvmbvBsG5C9jOoeFr+0EGXbjU+udW
	GZi7hoPWKAiBg+oFmynm4IoAY0FwLf8C0mI6OvBCi0cB3//2coQDh8+zGqZ7CIWdzg1Z
	1oxg==
X-Gm-Message-State: AOAM530mfIF1kTFWX7PmYELVp8KjHnWyP4e/mjbDnrzom2kapop+bSnh
	tlnK5kSPrztHlK+lUpaX73nxalGJlIs=
X-Google-Smtp-Source: ABdhPJyQ8HplngCONuGftc64bEc/JJ6coYh6og+bUJ6PeQJVELk4xOtqWPARJpZn+00/x6ypfMsS0Q==
X-Received: by 2002:a05:6830:2b25:: with SMTP id
	l37mr9405078otv.324.1629037659740; 
	Sun, 15 Aug 2021 07:27:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
	by smtp.gmail.com with ESMTPSA id
	bd3sm1557487oib.37.2021.08.15.07.27.38
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 15 Aug 2021 07:27:39 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
	<20210804094147.459763-5-hch@lst.de>
	<20210814211309.GA616511@roeck-us.net>
	<20210815070724.GA23276@lst.de>
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <a8d66952-ee44-d3fa-d699-439415b9abfe@roeck-us.net>
Date: Sun, 15 Aug 2021 07:27:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210815070724.GA23276@lst.de>
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
Subject: Re: [dm-devel] [PATCH 4/8] block: support delayed holder
	registration
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/15/21 12:07 AM, Christoph Hellwig wrote:
> On Sat, Aug 14, 2021 at 02:13:09PM -0700, Guenter Roeck wrote:
>> On Wed, Aug 04, 2021 at 11:41:43AM +0200, Christoph Hellwig wrote:
>>> device mapper needs to register holders before it is ready to do I/O.
>>> Currently it does so by registering the disk early, which can leave
>>> the disk and queue in a weird half state where the queue is registered
>>> with the disk, except for sysfs and the elevator.  And this state has
>>> been a bit promlematic before, and will get more so when sorting out
>>> the responsibilities between the queue and the disk.
>>>
>>> Support registering holders on an initialized but not registered disk
>>> instead by delaying the sysfs registration until the disk is registered.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> Reviewed-by: Mike Snitzer <snitzer@redhat.com>
>>
>> This patch results in lockdep splats when booting from flash.
>> Reverting it fixes the proboem.
> 
> Should be fixed by:
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.15/drivers&id=6e4df4c6488165637b95b9701cc862a42a3836ba
> 

No, it doesn't. I could not apply this patch alone, so I applied the entire series
on top of next-20210813 and gave it another try.

f53c2d11ac98 (HEAD -> master) nbd: reduce the nbd_index_mutex scope
f2f5254b356f nbd: refactor device search and allocation in nbd_genl_connect
d5b03177e069 nbd: return the allocated nbd_device from nbd_dev_add
350b3f6a6e6b nbd: remove nbd_del_disk
49efbeb9de86 nbd: refactor device removal
cdd920eb7cf2 nbd: do del_gendisk() asynchronously for NBD_DESTROY_ON_DISCONNECT
4b358aabb93a (tag: next-20210813, origin/master, origin/HEAD) Add linux-next specific files for 20210813

Still:
...

[   14.467748][    T1]  Possible unsafe locking scenario:
[   14.467748][    T1]
[   14.467928][    T1]        CPU0                    CPU1
[   14.468058][    T1]        ----                    ----
[   14.468187][    T1]   lock(&disk->open_mutex);
[   14.468317][    T1]                                lock(mtd_table_mutex);
[   14.468493][    T1]                                lock(&disk->open_mutex);
[   14.468671][    T1]   lock(mtd_table_mutex);

Guenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


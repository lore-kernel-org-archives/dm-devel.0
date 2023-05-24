Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CBA8C77B7C
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 05:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684907529;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JwQau56KZ0J6BiDvrjN8/HpQKR1xebOzJ4aBgy+eZnQ=;
	b=Y3nzXaadC8ZcrgURSqAVgJ7SIyNwMUgN4GWu0IOTpavK1WoARUiF4ZVAE6ZTvpcVchuPm8
	/YlizgGGJOyOwjwQdlux/GN3WtV/tFDIJV8BMP8xwhkj1aXTQ2Mke22PB3r32UnL4xUIKf
	ApsxGhP5zW4hza1IHnFKiEYh7GTWBlg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-E7hQPeB9NO6bmUcA_dcrjg-1; Wed, 24 May 2023 01:52:06 -0400
X-MC-Unique: E7hQPeB9NO6bmUcA_dcrjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F7F3802355;
	Wed, 24 May 2023 05:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0EFF940CFD45;
	Wed, 24 May 2023 05:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C5C8119465B6;
	Wed, 24 May 2023 05:52:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0B98219465A8
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 05:52:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E1D748162; Wed, 24 May 2023 05:52:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D99697AE4
 for <dm-devel@redhat.com>; Wed, 24 May 2023 05:52:02 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5076811E7C
 for <dm-devel@redhat.com>; Wed, 24 May 2023 05:52:02 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-Qxz9fazXNBGoB8BPUdU7Fg-1; Wed, 24 May 2023 01:51:55 -0400
X-MC-Unique: Qxz9fazXNBGoB8BPUdU7Fg-1
Received: from [2601:1c2:980:9ec0::2764]
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1gbH-00CMaO-18; Wed, 24 May 2023 04:59:51 +0000
Message-ID: <e96e4e85-7371-2859-b9a5-0f2c1f3b97d9@infradead.org>
Date: Tue, 23 May 2023 21:59:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Randy Dunlap <rdunlap@infradead.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-16-hch@lst.de>
 <b384f464-92c6-6a14-4072-1faa9fa6a6a8@infradead.org>
In-Reply-To: <b384f464-92c6-6a14-4072-1faa9fa6a6a8@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 15/24] block: move the code to do early boot
 lookup of block devices to block/
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 5/23/23 21:58, Randy Dunlap wrote:
> 
> 
> On 5/23/23 00:45, Christoph Hellwig wrote:
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index f08b83e62c6222..3f8cf6dc7de887 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -5452,7 +5452,7 @@
>>  			port and the regular usb controller gets disabled.
>>  
>>  	root=		[KNL] Root filesystem
>> -			See early_lookup_bdev comment in init/do_mounts.c.
>> +			See early_lookup_bdev comment in block/early-lookup.c
> 
> Patch 13 does this:
> 
>  	root=		[KNL] Root filesystem
> -			See name_to_dev_t comment in init/do_mounts.c.
> +			See early_lookup_bdev comment in init/do_mounts.c.
> 
> Should this latter chunk be dropped?
> 

Oh, oops, reverse order of patches?

-- 
~Randy

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


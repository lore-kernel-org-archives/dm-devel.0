Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8339FEB64D8
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 14:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687445051;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rup7r1B69HTbfzIuCGgK70HfQApFt09uASMgfSYgmIs=;
	b=b37JiLrBaCp6xo5eXStBVlcRb8V4LPm61bcpo0Rw1OXAcHPlWy46Ernl2ZaBSWMjbJ9sJM
	MUp2TdwmwSM4AgRNbDdiWKx2F0LVke6Hfjw67ScTMZ5lOvaSSQyG7GuWxE/3OSFAFkjEaY
	zUk6Ag/3DrsDnzHu1DlkVg8ZisZWnNY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-dYoZhycIOuC22-IWrm_liw-1; Thu, 22 Jun 2023 10:44:04 -0400
X-MC-Unique: dYoZhycIOuC22-IWrm_liw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEA363C1CCC9;
	Thu, 22 Jun 2023 14:42:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A7C140C2063;
	Thu, 22 Jun 2023 14:42:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6799D194658C;
	Thu, 22 Jun 2023 14:42:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 47B351946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 14:41:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DCBCFC478C8; Thu, 22 Jun 2023 14:41:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D5858C1ED98
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 14:41:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8041D3C15FBA
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 14:41:01 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-qQTGYENgMgqksniMdnWa1w-1; Thu, 22 Jun 2023 10:40:56 -0400
X-MC-Unique: qQTGYENgMgqksniMdnWa1w-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 4992C67373; Thu, 22 Jun 2023 16:40:42 +0200 (CEST)
Date: Thu, 22 Jun 2023 16:40:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Message-ID: <20230622144042.GA21415@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-15-hch@lst.de>
 <8c1992bc-110a-4dad-8643-766c14bf6fd4@roeck-us.net>
 <20230622035149.GA4667@lst.de>
 <2205ef1e-9bb6-fb1e-9ca3-367c1afe12ac@roeck-us.net>
 <20230622060001.GA8351@lst.de>
 <8e6c8365-5c2b-2bad-bf3c-df2d65cc8afa@roeck-us.net>
MIME-Version: 1.0
In-Reply-To: <8e6c8365-5c2b-2bad-bf3c-df2d65cc8afa@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 14/24] init: clear root_wait on all invalid
 root= strings
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
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 22, 2023 at 06:54:41AM -0700, Guenter Roeck wrote:
> On 6/21/23 23:00, Christoph Hellwig wrote:
>> Hi Guenter,
>>
>> can you try this patch?
>>
>> diff --git a/block/early-lookup.c b/block/early-lookup.c
>> index a5be3c68ed079c..66e4514d671179 100644
>> --- a/block/early-lookup.c
>> +++ b/block/early-lookup.c
>> @@ -174,7 +174,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
>>   	while (p > s && isdigit(p[-1]))
>>   		p--;
>>   	if (p == s || !*p || *p == '0')
>> -		return -EINVAL;
>> +		return -ENODEV;
>>     	/* try disk name without <part number> */
>>   	part = simple_strtoul(p, NULL, 10);
>
> Not completely. Tests with root=/dev/sda still fail.
>
> "name" passed to devt_from_devname() is "sda".
>
>        for (p = s; *p; p++) {
>                 if (*p == '/')
>                         *p = '!';
>         }
>
> advances 'p' to the end of the string.
>
>         while (p > s && isdigit(p[-1]))
> 		p--;
>
> moves it back to point to the first digit (if there is one).
>
>         if (p == s || !*p || *p == '0')
> 		return -EINVAL;
>
> then fails because *p is 0. In other words, the function only accepts
> drive names with digits at the end (and the first digit must not be '0').
>
> I don't recall how I hit the other condition earlier. I have various
> "/dev/mmcblkX" in my tests, where X can be any number including 0.
> Maybe those fail randomly as well.
>
> Overall I am not sure though what an "invalid" devicename is supposed
> to be in this context. I have "sda", "sr0", "vda", "mtdblkX",
> "nvme0n1", "mmcblkX", and "hda". Why would any of those not be eligible
> for "rootwait" ?
>
> In practice, everything not ending with a digit, or ending with
> '0', fails the first test. Everything ending with a digit > 0
> fails the second test. But "humptydump3p4" passes all those tests.


Yeah.  I guess I should give up on the idea of error out in this
particular parser.  The idea sounded good, but I guess it doesn't
work.  So we'll probably want his fix:


diff --git a/block/early-lookup.c b/block/early-lookup.c
index a5be3c68ed079c..9e2d5a19de1b3b 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -174,7 +174,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
 	while (p > s && isdigit(p[-1]))
 		p--;
 	if (p == s || !*p || *p == '0')
-		return -EINVAL;
+		return -ENODEV;
 
 	/* try disk name without <part number> */
 	part = simple_strtoul(p, NULL, 10);
@@ -185,7 +185,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
 
 	/* try disk name without p<part number> */
 	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
-		return -EINVAL;
+		return -ENODEV;
 	p[-1] = '\0';
 	*devt = blk_lookup_devt(s, part);
 	if (*devt)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


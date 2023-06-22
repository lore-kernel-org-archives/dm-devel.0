Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C975EEB64D8
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687446816;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/xUQHzL2iJY2+nneiUb5G140SE0XZsPKzTreNniPcEA=;
	b=U95J2nUiq8UHEeHIIyZpIYhodJdrxzYibfsSZvyfWuPtfPZgrjgZ6fXRb3mZKnEeufbhhM
	fcLDbnRK00HSycDUIAJ24OYqcWJdqb3npE16aacmBrcSo55vRKlHLRxUhIxYlvBAXW7GRO
	NfF0jLqPbEU5/sHejFig30rtnIIQS/8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-KAIvVMdZPt641YEOcGn4bw-1; Thu, 22 Jun 2023 11:12:49 -0400
X-MC-Unique: KAIvVMdZPt641YEOcGn4bw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0BBA38117F7;
	Thu, 22 Jun 2023 15:11:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0B12A492C13;
	Thu, 22 Jun 2023 15:11:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE0051946588;
	Thu, 22 Jun 2023 15:11:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DB43E1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 14:57:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5246940462BA; Thu, 22 Jun 2023 14:57:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AD6C40C6CD1
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 14:57:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 118DE8AB385
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 14:57:43 +0000 (UTC)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-4gvA6LcqNDyq3EAnfwk68A-1; Thu, 22 Jun 2023 10:57:39 -0400
X-MC-Unique: 4gvA6LcqNDyq3EAnfwk68A-1
Received: by mail-pf1-f174.google.com with SMTP id
 d2e1a72fcca58-668723729c5so3476199b3a.3
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 07:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687445857; x=1690037857;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :sender:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=jwOACF4Cm96Y53XmCdPinKvkgKtl8JixiB5Ndw9ya3w=;
 b=ekUI5vC1Y+596pnJ8/mb+s2U3hr/2TFVPa3CH03lmXFq9MfBMRZ3aN+kyN95PhInIC
 mGpDZHv1m0Eghq5etYCLx/24Iri3tNf05CBt9SyJHgURU9+1/i95vGvK5j4UXMvwlhHd
 fwYcZFA4MoVZNocKFp+4zMSW9+MuK6eSNRLvye+TD4rTBLSl+3o4CyUEd/HcwafIA0Jr
 3vrHKrEO1ZkWpNKNNX0Ys2XmzdB/g8qB3E6EF9oIum5YKblwHTiasXSDyrO60TrBNKjI
 GSWenLROK+QK4fgbIBZIt0vNpoexIk8QSdRNIGyP+8xDbGiukHRfNKrnCPhq9kO66Jex
 qciw==
X-Gm-Message-State: AC+VfDxe/E1HnJRjBej4NrsCiZqHBUJKFxm0GWWvWsJin23g7ec2dfSj
 n4Xh/wJCxIPWgmqvXFA3T1I=
X-Google-Smtp-Source: ACHHUZ7SykTFwUl4Pg0cnKe++eFMAAWwdMSv8sx+ts0vphadPA7YhT4gBMX8VVlYqUagi9Fq98njJQ==
X-Received: by 2002:a05:6a21:339b:b0:122:1fc:38b8 with SMTP id
 yy27-20020a056a21339b00b0012201fc38b8mr10410540pzb.48.1687445857125; 
 Thu, 22 Jun 2023 07:57:37 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c?
 ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 a9-20020a170902b58900b0019719f752c5sm5510512pls.59.2023.06.22.07.57.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 22 Jun 2023 07:57:36 -0700 (PDT)
Message-ID: <dd9dc41b-0830-0403-6abd-41d7aa664be3@roeck-us.net>
Date: Thu, 22 Jun 2023 07:57:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Christoph Hellwig <hch@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-15-hch@lst.de>
 <8c1992bc-110a-4dad-8643-766c14bf6fd4@roeck-us.net>
 <20230622035149.GA4667@lst.de>
 <2205ef1e-9bb6-fb1e-9ca3-367c1afe12ac@roeck-us.net>
 <20230622060001.GA8351@lst.de>
 <8e6c8365-5c2b-2bad-bf3c-df2d65cc8afa@roeck-us.net>
 <20230622144042.GA21415@lst.de>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230622144042.GA21415@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Joern Engel <joern@lazybastard.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: roeck-us.net
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/22/23 07:40, Christoph Hellwig wrote:
> On Thu, Jun 22, 2023 at 06:54:41AM -0700, Guenter Roeck wrote:
>> On 6/21/23 23:00, Christoph Hellwig wrote:
>>> Hi Guenter,
>>>
>>> can you try this patch?
>>>
>>> diff --git a/block/early-lookup.c b/block/early-lookup.c
>>> index a5be3c68ed079c..66e4514d671179 100644
>>> --- a/block/early-lookup.c
>>> +++ b/block/early-lookup.c
>>> @@ -174,7 +174,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
>>>    	while (p > s && isdigit(p[-1]))
>>>    		p--;
>>>    	if (p == s || !*p || *p == '0')
>>> -		return -EINVAL;
>>> +		return -ENODEV;
>>>      	/* try disk name without <part number> */
>>>    	part = simple_strtoul(p, NULL, 10);
>>
>> Not completely. Tests with root=/dev/sda still fail.
>>
>> "name" passed to devt_from_devname() is "sda".
>>
>>         for (p = s; *p; p++) {
>>                  if (*p == '/')
>>                          *p = '!';
>>          }
>>
>> advances 'p' to the end of the string.
>>
>>          while (p > s && isdigit(p[-1]))
>> 		p--;
>>
>> moves it back to point to the first digit (if there is one).
>>
>>          if (p == s || !*p || *p == '0')
>> 		return -EINVAL;
>>
>> then fails because *p is 0. In other words, the function only accepts
>> drive names with digits at the end (and the first digit must not be '0').
>>
>> I don't recall how I hit the other condition earlier. I have various
>> "/dev/mmcblkX" in my tests, where X can be any number including 0.
>> Maybe those fail randomly as well.
>>
>> Overall I am not sure though what an "invalid" devicename is supposed
>> to be in this context. I have "sda", "sr0", "vda", "mtdblkX",
>> "nvme0n1", "mmcblkX", and "hda". Why would any of those not be eligible
>> for "rootwait" ?
>>
>> In practice, everything not ending with a digit, or ending with
>> '0', fails the first test. Everything ending with a digit > 0
>> fails the second test. But "humptydump3p4" passes all those tests.
> 
> 
> Yeah.  I guess I should give up on the idea of error out in this
> particular parser.  The idea sounded good, but I guess it doesn't
> work.  So we'll probably want his fix:
> 

Yes, that fixes the problem for me.

Guenter

> 
> diff --git a/block/early-lookup.c b/block/early-lookup.c
> index a5be3c68ed079c..9e2d5a19de1b3b 100644
> --- a/block/early-lookup.c
> +++ b/block/early-lookup.c
> @@ -174,7 +174,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
>   	while (p > s && isdigit(p[-1]))
>   		p--;
>   	if (p == s || !*p || *p == '0')
> -		return -EINVAL;
> +		return -ENODEV;
>   
>   	/* try disk name without <part number> */
>   	part = simple_strtoul(p, NULL, 10);
> @@ -185,7 +185,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
>   
>   	/* try disk name without p<part number> */
>   	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
> -		return -EINVAL;
> +		return -ENODEV;
>   	p[-1] = '\0';
>   	*devt = blk_lookup_devt(s, part);
>   	if (*devt)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


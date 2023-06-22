Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB9BEB64DB
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687442198;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RUPW0ui2QhD1eZY2zLebQBe5qiKBASEXBX/wYDYoHPs=;
	b=S2gAe6iNtgpVxQ3SNvfpqvzqkrdDCF0ajvKBeoa33NxNXtYJLJVH+RUHLbZkvQsKSOVogB
	aqWTxk5FVCd7BvRif41AE5fudVYZG20T3ibQng9jAJ01gZD0rVm53Ha/YfcpXuCQT8kgxw
	VpfBNA5kEVHbmpL62tohqDNl2OxUJnc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-VadTN8d_P_i1HjOYbKY0Cw-1; Thu, 22 Jun 2023 09:56:35 -0400
X-MC-Unique: VadTN8d_P_i1HjOYbKY0Cw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2F57185A78B;
	Thu, 22 Jun 2023 13:56:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1F4740C6CD1;
	Thu, 22 Jun 2023 13:56:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7CCE11946588;
	Thu, 22 Jun 2023 13:56:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F19F51946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 13:54:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 77FBC112132C; Thu, 22 Jun 2023 13:54:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70A451121330
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 13:54:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 552A28ED761
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 13:54:49 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-iu88tnHhMT-RzCVQVOqnfA-1; Thu, 22 Jun 2023 09:54:46 -0400
X-MC-Unique: iu88tnHhMT-RzCVQVOqnfA-1
Received: by mail-pf1-f171.google.com with SMTP id
 d2e1a72fcca58-668723729c5so3414117b3a.3
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 06:54:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687442085; x=1690034085;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id:sender
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=U9uei6ikJRas22Hwp4mZTaUlT0qL8iBQnmHCBvfcXwE=;
 b=JaOi6qJrJYn7hMEg0wyHx6UuHQNXXj7lZFamUTJpfzO0U8ETFsCJaCFDMGThHV1q5h
 pixKlOD5+ehO9LmYMNobQ2KlqEs1i6aRF+1sHpN0TGz3/PoFCXlT+0Djco9YBxgI6iP3
 6rzixSCOS2ipI5sDdM9ORCt5Ht3OPB7OOqpX5ufTRMypvsIG2grLt2brAaDtvGgx/WTw
 LLlkgWReU245t68IwmIyCRVB/vKkGvxKQO7RPYYkH/5YUjvqsMAxA2l1wxZwbatTS7nf
 NMRZIdfOm6qrLxwARhuapBIqLWtbEe3JsM4vsXJnUNIzYMVHXxd6OyS22UVdRDFR9Jt+
 U4RA==
X-Gm-Message-State: AC+VfDwLNzCYubCoAZEeeqEsruy8AdkUKRZA1gB/gDMY2EuVoeD1nVar
 IYXP1pB3o5nfMRuAxkZCBnM=
X-Google-Smtp-Source: ACHHUZ4VL42ePsHWyAuI2cunIMNJN+2l9+MrvWkXvb25dMA29+z9x10vrON9kyt3JVkzTTwIqmP7Hw==
X-Received: by 2002:a05:6a00:b83:b0:668:6eed:7c1b with SMTP id
 g3-20020a056a000b8300b006686eed7c1bmr15157991pfj.14.1687442084782; 
 Thu, 22 Jun 2023 06:54:44 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c?
 ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 n4-20020a635904000000b00553b9e0510esm4778946pgb.60.2023.06.22.06.54.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 22 Jun 2023 06:54:43 -0700 (PDT)
Message-ID: <8e6c8365-5c2b-2bad-bf3c-df2d65cc8afa@roeck-us.net>
Date: Thu, 22 Jun 2023 06:54:41 -0700
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
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230622060001.GA8351@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: roeck-us.net
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/21/23 23:00, Christoph Hellwig wrote:
> Hi Guenter,
> 
> can you try this patch?
> 
> diff --git a/block/early-lookup.c b/block/early-lookup.c
> index a5be3c68ed079c..66e4514d671179 100644
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

Not completely. Tests with root=/dev/sda still fail.

"name" passed to devt_from_devname() is "sda".

        for (p = s; *p; p++) {
                 if (*p == '/')
                         *p = '!';
         }

advances 'p' to the end of the string.

         while (p > s && isdigit(p[-1]))
		p--;

moves it back to point to the first digit (if there is one).

         if (p == s || !*p || *p == '0')
		return -EINVAL;

then fails because *p is 0. In other words, the function only accepts
drive names with digits at the end (and the first digit must not be '0').

I don't recall how I hit the other condition earlier. I have various
"/dev/mmcblkX" in my tests, where X can be any number including 0.
Maybe those fail randomly as well.

Overall I am not sure though what an "invalid" devicename is supposed
to be in this context. I have "sda", "sr0", "vda", "mtdblkX",
"nvme0n1", "mmcblkX", and "hda". Why would any of those not be eligible
for "rootwait" ?

In practice, everything not ending with a digit, or ending with
'0', fails the first test. Everything ending with a digit > 0
fails the second test. But "humptydump3p4" passes all those tests.

Guenter

---
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#define EINVAL1	1
#define EINVAL2	2
#define EINVAL3	3
#define ENODEV	4

static int devt_from_devname(const char *name)
{
         int part;
         char s[32];
         char *p;

         if (strlen(name) > 31)
                 return EINVAL1;

         strcpy(s, name);
         for (p = s; *p; p++) {
                 if (*p == '/')
                         *p = '!';
         }

         /*
          * Try non-existent, but valid partition, which may only exist after
          * opening the device, like partitioned md devices.
          */
         while (p > s && isdigit(p[-1]))
                 p--;
         if (p == s || !*p || *p == '0') {
                 return EINVAL2;
         }

         /* try disk name without <part number> */
         part = strtoul(p, NULL, 10);
         *p = '\0';

         /* try disk name without p<part number> */
         if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p') {
                 return EINVAL3;
         }
         return ENODEV;
}

char *devnames[] = {
     "sda",
     "sda1",
     "mmcblk0",
     "mmcblk1",
     "mtdblk0",
     "mtdblk1",
     "vda",
     "hda",
     "nvme0n1",
     "sr0",
     "sr1",
     "humptydump3p4",
     NULL
};

int main(int argc, char **argv)
{
	char *str;
	int i;

	for (i = 0, str = devnames[0]; str; str = devnames[++i]) {
	    printf("%s: %d\n", str, devt_from_devname(str));
	}
}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


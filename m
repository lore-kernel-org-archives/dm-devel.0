Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8ABC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 30 Sep 2022 21:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664573101;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QmIFZA5b3r4/NWpqUPe/gx4F+2PlCy4dI9H8O0q0IKk=;
	b=eSVQ4x5v2iMiSCZsC+QoQVJfcYdrrgt/CSq2opaYykPEQA0HcK4ayfxVnMjNsuwqSAdU4t
	peZ6vltu5RBYKbNLc/Rwh6gpD5+YY2CKYHPFE1XYe7QQFgcJhuxYTQvnqscNb1XCZAB2ZI
	2FlKg6DFRT5gjJX2n7FC/MM9mKqeLjU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-BggVnCzNOEuZ7mnw08Pr-w-1; Fri, 30 Sep 2022 17:24:58 -0400
X-MC-Unique: BggVnCzNOEuZ7mnw08Pr-w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C38C3C0F439;
	Fri, 30 Sep 2022 21:24:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82812C15BA8;
	Fri, 30 Sep 2022 21:24:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C4C51946A67;
	Fri, 30 Sep 2022 21:24:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69B681946A52
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Sep 2022 21:24:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 467F62087442; Fri, 30 Sep 2022 21:24:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F56D2087440
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 21:24:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20F0E1C06ED4
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 21:24:52 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-312-36gpN_tAOEeHT8VqBEuYag-1; Fri, 30 Sep 2022 17:24:47 -0400
X-MC-Unique: 36gpN_tAOEeHT8VqBEuYag-1
Received: by mail-pf1-f180.google.com with SMTP id c198so5282426pfc.13
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 14:24:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=gQa4eGbEVBeAKBGzZEdWdAqwKEPR/qyaUUpn0AQUmcY=;
 b=iDQzo7oA3t4xhgxHnSITIkSd7xjbm+Fvmpor9diQO5XjM0yR0KroVlQlO2sUnGs9Pg
 CvnvKOrc4pkBKNM/JWQwYu740wRz4sLQKKizdPcEm4/KgA5n6lu3Gq0odQkCWbKGWQ7H
 eLSVuu9bbrOfyf8k1l2URTQadsMrSsN9R5akdYjGUzDPYgAUQRHKiQYVRiqLtHbGCSRp
 v42gJNgJ29aH6dI3rMrAnjQBBqk83HAHd6IPtvBhp0K2pm6E1MeVizezk2Xzt3heMmT2
 JGO7WggRVIl+IlvvU1QV8Q7zlOVk2D+rLR/49nyVGFIkXLskRbl8G9T5iHR98xqVuOIz
 pQoQ==
X-Gm-Message-State: ACrzQf1jTlWs0nJgynFwMGTJuuOpoXhl75/PDscEeb2hWP5Mrn0uzpIo
 5YVitkDcZsaeDjem7fmDuHGh/w==
X-Google-Smtp-Source: AMsMyM6bH8LWTyKM8E6TZPLLzzJcAnhCSq843METl4dQR8aOBKDpfMXeY2d7Z+NB8UVtrtjnFjkUSQ==
X-Received: by 2002:a63:d603:0:b0:43c:6762:20d9 with SMTP id
 q3-20020a63d603000000b0043c676220d9mr9108628pgg.68.1664573086605; 
 Fri, 30 Sep 2022 14:24:46 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 q15-20020a17090ad38f00b00209a12b3879sm2028502pju.37.2022.09.30.14.24.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 30 Sep 2022 14:24:46 -0700 (PDT)
Message-ID: <90b6d45e-61a5-3eb3-7525-8467f1a67587@kernel.dk>
Date: Fri, 30 Sep 2022 15:24:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
To: Bart Van Assche <bvanassche@acm.org>, Pankaj Raghav
 <p.raghav@samsung.com>, hch@lst.de, Keith Busch <kbusch@kernel.org>
References: <CGME20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65@eucas1p1.samsung.com>
 <20220923173618.6899-1-p.raghav@samsung.com>
 <5e9d678f-ffea-e015-53d8-7e80f3deda1e@samsung.com>
 <bd9479f4-ff87-6e5d-296e-e31e669fb148@kernel.dk>
 <0e5088a5-5408-c5bd-bf97-00803cb5faed@acm.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0e5088a5-5408-c5bd-bf97-00803cb5faed@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v15 00/13] support zoned block devices with
 non-power-of-2 zone sizes
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, pankydev8@gmail.com,
 matias.bjorling@wdc.com, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/30/22 1:38 PM, Bart Van Assche wrote:
> On 9/30/22 08:13, Jens Axboe wrote:
>> On 9/29/22 12:31 AM, Pankaj Raghav wrote:
>>>> Hi Jens,
>>>> ?? Please consider this patch series for the 6.1 release.
>>>>
>>>
>>> Hi Jens, Christoph, and Keith,
>>> ? All the patches have a Reviewed-by tag at this point. Can we queue this up
>>> for 6.1?
>>
>> It's getting pretty late for 6.1 and I'd really like to have both Christoph
>> and Martin sign off on these changes.
> 
> Hi Jens,
> 
> Agreed that it's getting late for 6.1.
> 
> Since this has not been mentioned in the cover letter, I want to add
> that in the near future we will need these patches for Android
> devices. JEDEC is working on supporting zoned storage for UFS devices,
> the storage devices used in all modern Android phones. Although it
> would be possible to make the offset between zone starts a power of
> two by inserting gap zones between data zones, UFS vendors asked not
> to do this and hence need support for zone sizes that are not a power
> of two. An advantage of not having to deal with gap zones is better
> filesystem performance since filesystem extents cannot span gap zones.
> Having to split filesystem extents because of gap zones reduces
> filesystem performance.

Noted. I'll find some time to review this as well separately, once we're
on the other side of the merge window.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A57C1C54EBD
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 22:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673044505;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1QB7DHc8iyLXXclU5Taf+e3Mg7aVq8Hf4gpXCHg8zyc=;
	b=blvLm9xPF0h0z5f/Bq3vGz7yTmi6s8vzmyKvRu1omMzDNtvFc1N4rR+HBgZns5h2YFI/b3
	6w1ATV2a+tcY9XY9KNpJIQhHlNtPxSjH5TywLdoBa0L8jlnAH2o5YzRBxL5LI76klq1wOH
	UdP4e6sASlT4q+Gsb7B0B2pVN7lT00w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-krHzyBZMMHKueWQknLMxSQ-1; Fri, 06 Jan 2023 17:35:02 -0500
X-MC-Unique: krHzyBZMMHKueWQknLMxSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E97C3C38FE2;
	Fri,  6 Jan 2023 22:35:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA1CF2026D4B;
	Fri,  6 Jan 2023 22:34:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B6C4B194707F;
	Fri,  6 Jan 2023 22:34:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 091FD1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 22:34:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D2623C15BAE; Fri,  6 Jan 2023 22:34:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9CDDC15BAD
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 22:34:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABA9418E6202
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 22:34:55 +0000 (UTC)
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com
 [209.85.215.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-GGY-Ilv0M225jtqM4NPvSw-1; Fri, 06 Jan 2023 17:34:53 -0500
X-MC-Unique: GGY-Ilv0M225jtqM4NPvSw-1
Received: by mail-pg1-f179.google.com with SMTP id 78so2099910pgb.8
 for <dm-devel@redhat.com>; Fri, 06 Jan 2023 14:34:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=SL5CM6lTlaQHHI1bmsPCCVPxAY0au15n5abe/FQT3nc=;
 b=MpMAR0hJn9tHQD4rTD1p5Fs4+6FZ5wLnUM5q3HPLxPWalD2wo/X/SbTO6x9m8+Tp9C
 XeCod/jv5Wv9inYnCRDOfA54ssodIdOO1sVZSJFSq/+WCbaO7EmPf0UEIa7B9N2mYWuq
 xVjxAKOZJ8k38OihOPbd7zmqwmcFzM4BS3aXJ4A4U4+0Ri/55sosfko1M/rwcu7mnrzZ
 ZyxM/LTM//iRBsFIuJCtacPkYf9cXmAKrff0OPq3pUGA+GTu5TvwXaY1Ymo5fuLelw+a
 Qa48LCZ9Swg5zkIEJgQZ86rHlY/1lypFj1pjWNAW2dIPwh6mu+TZisGCgOdXbAj4LwGF
 VxsA==
X-Gm-Message-State: AFqh2krT+DBHWIyqjN1Cwq7SsXX5kZpL1qbP2zbEupdbcwqvLjeH3XMB
 WvJzl2hIL0kV8N9shdkgdyE=
X-Google-Smtp-Source: AMrXdXvz8DmkTBfjAMd1ozT8pHBw5/b6wdaTed0SKRZNVvC3PYsvERMHsoJSt6vghLCnFNKh8DJLdg==
X-Received: by 2002:a62:2903:0:b0:57f:f2cd:6180 with SMTP id
 p3-20020a622903000000b0057ff2cd6180mr54274027pfp.0.1673044492663; 
 Fri, 06 Jan 2023 14:34:52 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:23c3:f25b:a19d:c75a?
 ([2620:15c:211:201:23c3:f25b:a19d:c75a])
 by smtp.gmail.com with ESMTPSA id
 a13-20020aa7970d000000b00582197fa7b4sm1597733pfg.7.2023.01.06.14.34.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Jan 2023 14:34:51 -0800 (PST)
Message-ID: <895e27b5-60cb-39f4-ce0c-774379453418@acm.org>
Date: Fri, 6 Jan 2023 14:34:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083319eucas1p1e58f4ab0d3ff59a328a2da2922d76038@eucas1p1.samsung.com>
 <20230106083317.93938-2-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230106083317.93938-2-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 1/7] block: remove superfluous check for
 request queue in bdev_is_zoned
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
Cc: gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/6/23 00:33, Pankaj Raghav wrote:
> Remove the superfluous request queue check in bdev_is_zoned() as the
> bdev_get_queue can never return NULL.

the bdev_get_queue -> bdev_get_queue()

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


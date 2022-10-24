Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C4FC38A2D
	for <dm-devel@archiver.kernel.org>; Mon, 24 Oct 2022 19:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666638178;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c9GH+Q8iNH1cH9OUs9wakIBx1i4kbycKpvKHgrU45+U=;
	b=ckf2hBrO7xTI/Fj2Ez/i7quF7ul7cNS+9Ob9eGAZ2g77oRDNSWeFFoggu3ZUX1MUdzZaZu
	xG+jEnZ0Z/8cgbNh5f9m3OgnzepLclU6MeqqgFsAqpdxnudIV0uu5feGCr6JI2O8OQSDMD
	3mcPAqI2wHwjTtKHSnYnYeyolDyMIfE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-NeES6J10PwGgv-5vp47dXg-1; Mon, 24 Oct 2022 15:02:56 -0400
X-MC-Unique: NeES6J10PwGgv-5vp47dXg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3E8E811E67;
	Mon, 24 Oct 2022 19:02:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5FA3E40C6E16;
	Mon, 24 Oct 2022 19:02:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3C7B01946597;
	Mon, 24 Oct 2022 19:02:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C93FD194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Oct 2022 19:02:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 756DD2166B34; Mon, 24 Oct 2022 19:02:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EB4C2166B2A
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 19:02:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F0913C02196
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 19:02:51 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-6yj7QM9rMAaaHGbnefxfEg-1; Mon, 24 Oct 2022 15:02:49 -0400
X-MC-Unique: 6yj7QM9rMAaaHGbnefxfEg-1
Received: by mail-pl1-f171.google.com with SMTP id g24so4247718plq.3;
 Mon, 24 Oct 2022 12:02:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=KpthEP7YXPpISJ6CGPHYOqUT6IOWvKcBQOAkgoQ0ELw=;
 b=e6evnU76s+p+5oIojXKf8u/z6fUm9VfOykwZ2V22r7XF4Nh360tXuLctROcZ9+klQU
 5mXR5WBdHZorYgRGzFb3HOHmX2B40NzsHC9l9JiQF0ZEmBTra6JDRVr39vs7Q7pOGaoH
 KUHT6kzS4DGeQqbKBB0JZnFkt6sz7/1comiXfX5CM+JHGKavVfkJr1A9bzWXsXdJfBc4
 CmZcxTptyd5+088aEbgW3PbduxLc3DwNLlr4t+l3zbi9YreY174fYIUOVnSKtTlyun4U
 xpU7hFipJyqnuPhdXd/GaxEbqyVWqEJutRx1OUQ1R4W6uRbYwjA6D7Wa0OPlVz3XuNeT
 lirQ==
X-Gm-Message-State: ACrzQf1qYX3HUaALW4HW2hWRdblHjC0fzxTqIjQJ5BzVxAWpu1mWiVNR
 +trU4tf9QqX4UC2r1y9J+vU=
X-Google-Smtp-Source: AMsMyM41hqd/uZatx/NIZkdddex4IQIsPyvThfppQJMTcjKSxixD9lMXD6LAtqRvj3T+q4RUKykUsQ==
X-Received: by 2002:a17:903:18b:b0:185:43e6:20df with SMTP id
 z11-20020a170903018b00b0018543e620dfmr34041445plg.4.1666638167863; 
 Mon, 24 Oct 2022 12:02:47 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
 by smtp.gmail.com with ESMTPSA id
 i27-20020a056a00005b00b0056203db46ffsm135961pfk.172.2022.10.24.12.02.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 24 Oct 2022 12:02:47 -0700 (PDT)
Message-ID: <dc89c70e-4931-baaf-c450-6801c200c1d7@acm.org>
Date: Mon, 24 Oct 2022 12:02:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Jens Axboe <axboe@kernel.dk>, Pankaj Raghav <p.raghav@samsung.com>,
 hch@lst.de, Keith Busch <kbusch@kernel.org>
References: <CGME20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65@eucas1p1.samsung.com>
 <20220923173618.6899-1-p.raghav@samsung.com>
 <5e9d678f-ffea-e015-53d8-7e80f3deda1e@samsung.com>
 <bd9479f4-ff87-6e5d-296e-e31e669fb148@kernel.dk>
 <0e5088a5-5408-c5bd-bf97-00803cb5faed@acm.org>
 <90b6d45e-61a5-3eb3-7525-8467f1a67587@kernel.dk>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <90b6d45e-61a5-3eb3-7525-8467f1a67587@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/30/22 14:24, Jens Axboe wrote:
> Noted. I'll find some time to review this as well separately, once we're
> on the other side of the merge window.

Hi Jens,

Now that we are on the other side of the merge window: do you perhaps 
want Pankaj to repost this patch series? From what I have heard in 
several fora (JEDEC, SNIA) all flash storage vendors except one (WDC) 
are in favor of a contiguous LBA space and hence are in favor of 
supporting zone sizes that are not a power of two.

As you may know in JEDEC we are working on standardizing zoned storage 
for UFS devices. We (JEDEC JC-64.1 committee members) would like to know 
whether or not we should require that the UFS zone size should be a 
power of two.

Thank you,

Bart.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


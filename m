Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54EF6C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 06:09:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-KnXWptkiNU2ZHeupxSWQRA-1; Wed, 30 Mar 2022 02:09:23 -0400
X-MC-Unique: KnXWptkiNU2ZHeupxSWQRA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CA9C8F11C2;
	Wed, 30 Mar 2022 06:09:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03DF85690E2;
	Wed, 30 Mar 2022 06:09:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 08AF31940348;
	Wed, 30 Mar 2022 06:08:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7F561940342
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Mar 2022 15:24:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93B1B40D2822; Tue, 29 Mar 2022 15:24:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E5F040D1B9B
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 15:24:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30260811E80
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 15:24:24 +0000 (UTC)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-30wT8P4jPba4XEcSPZJcwA-1; Tue, 29 Mar 2022 11:24:20 -0400
X-MC-Unique: 30wT8P4jPba4XEcSPZJcwA-1
Received: by mail-lf1-f53.google.com with SMTP id k21so30903573lfe.4
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 08:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=7p35TWvl6IRR76g48gZ/FV3yHCrma4H2n4XIVQjHGbU=;
 b=pwxoz/gZSGF84wrTgpp7M966KXFdxPzZAq3q8RS2+ljo+3PzjGUvEQWkU2fjqNcZNS
 1/UnbCX9BPt8rhf6hZGsCzRUaOsIbQsn1ybd+kkx02SDXlWFHvRvPv/+FfF9zIGECE3e
 XwgwJ+ClwQitpzl6NwD6WebEGfUWf35iUFbkL9Oxw4zXi8ToxLPm44gkeE2zBHbysJNo
 odMTnD78tE3hZOgfQU2nYsaWxyfH6eqXfZAE4swALONQbMiOv+MJcWf5SJCDIDWGHSA7
 /K0nthXIMSIV7j4qE9WMnrbkMTn6Jcji+40S2ww2igMEH1BrYqyEPjFFbAtll7zDiGS8
 2eXQ==
X-Gm-Message-State: AOAM5314aC0rszwCMQt9NSs6flvu6UPMpCXdpMRWYFRGogJeF7RQXlrn
 ffbzC84Ua/lHXZlAE9708e5iAg==
X-Google-Smtp-Source: ABdhPJxrgrgQ8/lRgdnygDMTeGxvGw9V2TWV8TndcAF6ht0JArKuArXclzzTgpLQB5WvXqaVSaNUrg==
X-Received: by 2002:a05:6512:39c1:b0:448:3d37:2cf0 with SMTP id
 k1-20020a05651239c100b004483d372cf0mr3128325lfu.273.1648567458347; 
 Tue, 29 Mar 2022 08:24:18 -0700 (PDT)
Received: from [192.168.0.120] ([2.92.192.13])
 by smtp.gmail.com with ESMTPSA id
 p8-20020a2ea408000000b00247e5087157sm2037603ljn.101.2022.03.29.08.24.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 29 Mar 2022 08:24:18 -0700 (PDT)
Message-ID: <241b972d-5f78-6282-4f67-131a2566d479@openvz.org>
Date: Tue, 29 Mar 2022 18:24:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Christoph Hellwig <hch@infradead.org>
References: <164846619932.251310.3668540533992131988.stgit@pro>
 <164846631540.251310.2398727490395218229.stgit@pro>
 <YkMK1cmWyEJGoMB+@infradead.org>
From: Kirill Tkhai <kirill.tkhai@openvz.org>
In-Reply-To: <YkMK1cmWyEJGoMB+@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Wed, 30 Mar 2022 06:08:49 +0000
Subject: Re: [dm-devel] [PATCH 3/4] dm-qcow2: Introduce driver to create
 block devices over QCOW2 files
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
Cc: axboe@kernel.dk, snitzer@redhat.com, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, song@kernel.org, dm-devel@redhat.com,
 agk@redhat.com, khorenko@virtuozzo.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 29.03.2022 16:34, Christoph Hellwig wrote:
> On Mon, Mar 28, 2022 at 02:18:35PM +0300, Kirill Tkhai wrote:
>> The driver is request based, since this allows to use blk-mq
>> merging of request. Driver splits requests itself, and every
>> request (i.e., qio) after splitting fits a single cluster.
>> (In some cases it is worth to create bigger splits, and this
>> is a subject of further optimizations).
> 
> Nak, please don't do that.  If you want finer grained processing use
> a bio based driver, not a request based one.  This is just getting us
> into tons of problems.

Could you explain what you mean? Why shouldn't I use generic bio merging
code, but implementing my own merging? Which problems you point?

Generic blk-mq is well tested and lots of people work on its performance.
It's not obvious reason I should better implement own realization.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


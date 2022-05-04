Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA96FC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 09:48:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-ROmS22tqPFCzbjXHoH-6yA-1; Wed, 04 May 2022 05:48:04 -0400
X-MC-Unique: ROmS22tqPFCzbjXHoH-6yA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7C25803D4E;
	Wed,  4 May 2022 09:48:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88D8644A180;
	Wed,  4 May 2022 09:48:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 476671947043;
	Wed,  4 May 2022 09:48:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E27C91947040
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 09:47:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7E764021D9; Wed,  4 May 2022 09:47:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C3A5D463E0B
 for <dm-devel@redhat.com>; Wed,  4 May 2022 09:47:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8F3B800186
 for <dm-devel@redhat.com>; Wed,  4 May 2022 09:47:59 +0000 (UTC)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com
 [209.85.208.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-kh6lHGlLN8-AlUG4yRrkXQ-1; Wed, 04 May 2022 05:47:56 -0400
X-MC-Unique: kh6lHGlLN8-AlUG4yRrkXQ-1
Received: by mail-ed1-f45.google.com with SMTP id be20so1054514edb.12;
 Wed, 04 May 2022 02:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=UMi5L4NU7YtuCRrDszdWe8xOLn3j2yayIhCAekkyhRM=;
 b=QgarMMrUNJKv93plSOivs+nIELF3x9AggtaZ3lXwINWcf/B+VsyJr8h3MDCTDy+TjW
 BXynQuuie2iRRmlovhf9V+VYijmRG68gLFaD5V37zG8hFp/fMnWvSK2LhOG6n/4js8kJ
 kbC+SyzqAiYUSv23iUqTwXoo4vxuIgrhQWnGBzPcNXhiYqrhP25vIklTcWyVmD4+xp4T
 Y/TzSux5HNxGTd23kuDHJ0qQICx0+eACiWq1PYQQLlzStiX4n9LqGSCbKNrgeZTFHJWs
 T24EkpKshCszb8Fed7KnR8CwDDSWtVzh+E3+KgRAGZFxAvQUOtZ/QX7cl3lNmfpARi0k
 MTWA==
X-Gm-Message-State: AOAM530jDbHf654esdF0duQgEXr2Ve46TUJDGGRF+0Pf8Ejn8UZpNQ0k
 4C1XMKzDRkC5ANwUC+6DRRw=
X-Google-Smtp-Source: ABdhPJya6lHf7igGAb2eIfhtj49OpcX70BuRC8nDoJHvWavZcEixqKxkVIAJZ6KPK65JpqjcGV6fqQ==
X-Received: by 2002:aa7:cc02:0:b0:411:487e:36fe with SMTP id
 q2-20020aa7cc02000000b00411487e36femr22183786edt.338.1651657674535; 
 Wed, 04 May 2022 02:47:54 -0700 (PDT)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 r23-20020a056402019700b0042617ba637bsm8951540edv.5.2022.05.04.02.47.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 02:47:54 -0700 (PDT)
Message-ID: <24c9a856-be10-e9b3-b26d-e6ced9e13c63@gmail.com>
Date: Wed, 4 May 2022 11:47:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Andy Shevchenko <andriy.shevchenko@intel.com>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec>
 <alpine.LRH.2.02.2205040453050.22937@file01.intranet.prod.int.rdu2.redhat.com>
 <YnJFViBFIgYOl7/2@smile.fi.intel.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <YnJFViBFIgYOl7/2@smile.fi.intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2] hex2bin: make the function hex_to_bin
 constant-time
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
Cc: Andy Shevchenko <andy@kernel.org>, Mike Snitzer <msnitzer@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
 device-mapper development <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Jason@zx2c4.com,
 Stafford Horne <shorne@gmail.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 04/05/2022 11:20, Andy Shevchenko wrote:
> On Wed, May 04, 2022 at 04:57:35AM -0400, Mikulas Patocka wrote:
>> On Wed, 4 May 2022, Stafford Horne wrote:
>>> On Mon, Apr 25, 2022 at 08:07:48AM -0400, Mikulas Patocka wrote:
> 
> ...
> 
>>> Just a heads up it seems this patch is causing some instability with crypto self
>>> tests on OpenRISC when using a PREEMPT kernel (no SMP).
>>>
>>> This was reported by Jason A. Donenfeld as it came up in wireguard testing.
>>>
>>> I am trying to figure out if this is an OpenRISC PREEMPT issue or something
>>> else.
> 
>> That patch is so simple that I can't imagine how could it break the
>> curve25519 test. Are you sure that you bisected it correctly?
> 
> Can you provide a test cases for hex_to_bin()?

BTW we use exactly the same code from Mikulas in cryptsetup now (actually the report
was initiated from here :) and I added some tests for this code,
you can probably adapt it (we just use generic wrapper around it):

https://gitlab.com/cryptsetup/cryptsetup/-/commit/2d8cdb2e356d187658efa6efc7bfa146be5d3f60#d9c94cde02e4509f6d12c3edd40f8a9138696807_0_176

(it calls this: https://gitlab.com/cryptsetup/cryptsetup/-/commit/ff14c17de794fe85299d90e34e12a677e6148b71 )

I do not have OpenRISC available, but it would be interesting to run cryptsetup/tests/vectors-test there...

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8BBC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Jun 2022 06:09:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-xf61cWj0MRCMfD-HVy3dFQ-1; Wed, 01 Jun 2022 02:09:07 -0400
X-MC-Unique: xf61cWj0MRCMfD-HVy3dFQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 418748027EE;
	Wed,  1 Jun 2022 06:09:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 61DC12166B2B;
	Wed,  1 Jun 2022 06:09:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 286A81947070;
	Wed,  1 Jun 2022 06:09:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2D39D1947079
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Jun 2022 06:09:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 122DF40CFD0B; Wed,  1 Jun 2022 06:09:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DDD640CFD0A
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 06:09:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB632101AA46
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 06:09:01 +0000 (UTC)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-b6mTZ0eZMyOhwi_sQ9mwTA-1; Wed, 01 Jun 2022 02:09:00 -0400
X-MC-Unique: b6mTZ0eZMyOhwi_sQ9mwTA-1
Received: by mail-wr1-f44.google.com with SMTP id p10so805183wrg.12
 for <dm-devel@redhat.com>; Tue, 31 May 2022 23:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=UfmsxzQ5cyXaYfffY/KNNowgw/oLxrr30Q8aXfBM24o=;
 b=o2BvD7pC6LWLWrIISkz6udbW47RW+akNa6p7RBdpn/zqpLY+9WATABRcooKWReiyp1
 iADjyz9xHheuHqUnnvRYdJwyezFfSGN46c0AF8+1bRDYMn9827UiLfHDAwB0rpAKfTCp
 X22grknCnFTuQBZWL6fdvc+vvOA6jdNrsAXdfT++kh6qIRSf56raRGy4RctFDaJhvyo7
 XZo88itCfG9jDLwrIFfCsNBTD6D5S15pO1YqO7PYN/SaimKYK6Z1st7ouSAZhfEaHQ6R
 Hto4dhyIb+wdfDBYX2LgzJZdo+ITRtHKd6JqYPA7yFQNgxwJl9bRo1bI1MM0xnbv2fW4
 ozRQ==
X-Gm-Message-State: AOAM532IfXqJ8BQmlW7tWM92oGPhJ2IVRaetL0LoGDVk6oZcBqPBxpjV
 d2BCQgrEeb9K5txwVSDTx+tZ7jXmrO936hET
X-Google-Smtp-Source: ABdhPJz8fxd4n51jtphXpda+Rpfo2uctjwLEcLzjniBxLo41YM+g4w8Q1MBi9Nt9VXMKx2hwkOekJQ==
X-Received: by 2002:a5d:6e85:0:b0:210:3ded:60ac with SMTP id
 k5-20020a5d6e85000000b002103ded60acmr1544487wrz.143.1654063738961; 
 Tue, 31 May 2022 23:08:58 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net.
 [46.193.73.98]) by smtp.gmail.com with ESMTPSA id
 h24-20020adfa4d8000000b0020d0a57af5esm590754wrb.79.2022.05.31.23.08.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 31 May 2022 23:08:58 -0700 (PDT)
Message-ID: <08625f5f-4781-52c5-46fc-d1250f70626c@kernel.dk>
Date: Wed, 1 Jun 2022 00:08:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
References: <YpK7m+14A+pZKs5k@casper.infradead.org>
 <2523e5b0-d89c-552e-40a6-6d414418749d@kernel.dk>
 <YpZlOCMept7wFjOw@redhat.com> <YpcBgY9MMgumEjTL@infradead.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YpcBgY9MMgumEjTL@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] bioset_exit poison from dm_destroy
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, david@fromorbit.com,
 Matthew Wilcox <willy@infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/1/22 12:04 AM, Christoph Hellwig wrote:
> On Tue, May 31, 2022 at 02:58:00PM -0400, Mike Snitzer wrote:
>> Yes, we need the above to fix the crash.  Does it also make sense to
>> add this?
> 
> Can we just stop treating bio_sets so sloppily and make the callers
> handle their lifetime properly?  No one should have to use
> bioset_initialized (or double free bio_sets).

Yes, that was my point in the previous email - get rid of
bioset_initialized() and just fixup dm, which is the only user of it.
There really should be no need to have this kind of conditional checking
and initialization.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


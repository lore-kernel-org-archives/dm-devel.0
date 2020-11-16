Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2A2C388F9
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 23:22:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3FBB320729
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 23:21:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FBB320729
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-rcAmiV0ANfeWYGkOPvn6XQ-1; Mon, 16 Nov 2020 18:21:56 -0500
X-MC-Unique: rcAmiV0ANfeWYGkOPvn6XQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B1638030B4;
	Mon, 16 Nov 2020 23:21:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C4AC5B4A9;
	Mon, 16 Nov 2020 23:21:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86082183D021;
	Mon, 16 Nov 2020 23:21:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGNLkab008557 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 18:21:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 93E962086F67; Mon, 16 Nov 2020 23:21:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D7492086F65
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 23:21:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15E2590E429
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 23:21:42 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-48-H2u9LkzBPeSnv-vf-nIZTQ-1; Mon, 16 Nov 2020 18:21:39 -0500
X-MC-Unique: H2u9LkzBPeSnv-vf-nIZTQ-1
Received: from [2601:1c0:6280:3f0::f32]
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kenTh-0004T5-H3; Mon, 16 Nov 2020 23:00:05 +0000
To: Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20201113225228.20563-1-rdunlap@infradead.org>
	<344abf76-9405-58ba-2dc4-27cab88c974d@de.ibm.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c29eeb5d-0683-49eb-f729-38b14fac7745@infradead.org>
Date: Mon, 16 Nov 2020 15:00:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <344abf76-9405-58ba-2dc4-27cab88c974d@de.ibm.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] md: dm-writeback: add __noreturn to BUG-ging
	function
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/15/20 11:30 PM, Christian Borntraeger wrote:
> 
> 
> On 13.11.20 23:52, Randy Dunlap wrote:
>> Building on arch/s390/ flags this as an error, so add the
>> __noreturn attribute modifier to prevent the build error.
>>
>> cc1: some warnings being treated as errors
>> ../drivers/md/dm-writecache.c: In function 'persistent_memory_claim':
>> ../drivers/md/dm-writecache.c:323:1: error: no return statement in function returning non-void [-Werror=return-type]
> 
> ok with me, but I am asking why
> 
> the unreachable macro is not good enough. For x86 it obviously is.
> 
> form arch/s390/include/asm/bug.h
> #define BUG() do {                                      \
>         __EMIT_BUG(0);                                  \
>         unreachable();                                  \
> } while (0)
> 

Hi Christian,

Good question.
I don't see any guidance about when to use one or the other etc.

I see __noreturn being used 109 times and unreachable();
being used 33 times, but only now that I look at them.
That had nothing to do with why I used __noreturn in the patch.

> 
>>
>> Fixes: 48debafe4f2f ("dm: add writecache target")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Mikulas Patocka <mpatocka@redhat.com>
>> Cc: Alasdair Kergon <agk@redhat.com>
>> Cc: Mike Snitzer <snitzer@redhat.com>
>> Cc: dm-devel@redhat.com
>> Cc: Heiko Carstens <hca@linux.ibm.com>
>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Cc: linux-s390@vger.kernel.org
>> ---
>>  drivers/md/dm-writecache.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-next-20201113.orig/drivers/md/dm-writecache.c
>> +++ linux-next-20201113/drivers/md/dm-writecache.c
>> @@ -317,7 +317,7 @@ err1:
>>  	return r;
>>  }
>>  #else
>> -static int persistent_memory_claim(struct dm_writecache *wc)
>> +static int __noreturn persistent_memory_claim(struct dm_writecache *wc)
>>  {
>>  	BUG();
>>  }
>>

thanks.
-- 
~Randy

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


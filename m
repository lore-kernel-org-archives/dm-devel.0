Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9116BEB64DD
	for <dm-devel@archiver.kernel.org>; Mon,  7 Aug 2023 06:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691389775;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HtiKN2ER6/pIYdagLyEkmNyuDj1YamEGRo28Tf67WkA=;
	b=QPgOGZk+MANX2MM1X/smS/GuUzU5ibDhfYBbQdzIq8LDC/I59AnVuhN/d09+Cdk6jZZD4B
	3CPTtQNxgP3U7zrfhB7P+5MI7+ngVKUn35K+LxuQKbF9aDY3++LBxxlOYcIfTy8+VlVRBT
	cjitV2c4ZXI80I/Pg0pGSwzFRDrENKA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-e147EiH2PBO6GCcEty9FMA-1; Mon, 07 Aug 2023 02:29:32 -0400
X-MC-Unique: e147EiH2PBO6GCcEty9FMA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99630283476D;
	Mon,  7 Aug 2023 06:29:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46206403168;
	Mon,  7 Aug 2023 06:29:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 01CD21946587;
	Mon,  7 Aug 2023 06:29:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 525C41946586
 for <dm-devel@listman.corp.redhat.com>; Sat,  5 Aug 2023 13:47:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 072F54094DC2; Sat,  5 Aug 2023 13:47:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F35F94094DC0
 for <dm-devel@redhat.com>; Sat,  5 Aug 2023 13:47:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D884580027F
 for <dm-devel@redhat.com>; Sat,  5 Aug 2023 13:47:07 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de
 [80.237.130.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-KS_wEzzTOxq1UNtGc9lHpg-1; Sat, 05 Aug 2023 09:47:06 -0400
X-MC-Unique: KS_wEzzTOxq1UNtGc9lHpg-1
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
 by wp530.webpack.hosteurope.de running ExIM with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
 id 1qSH03-0006q9-To; Sat, 05 Aug 2023 15:07:19 +0200
Message-ID: <84f6ea98-0d72-e17a-4b7c-d025f2d34e95@leemhuis.info>
Date: Sat, 5 Aug 2023 15:07:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Vlastimil Babka <vbabka@suse.cz>, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>
References: <20230531125535.676098-1-hch@lst.de>
 <20230531125535.676098-5-hch@lst.de>
 <2cfa5f55-1d68-8a4f-d049-13f42e0d1484@suse.cz>
From: "Linux regression tracking #adding (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
In-Reply-To: <2cfa5f55-1d68-8a4f-d049-13f42e0d1484@suse.cz>
X-bounce-key: webpack.hosteurope.de; regressions@leemhuis.info; 1691243226;
 20394dce
X-HE-SMSGID: 1qSH03-0006q9-To
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 07 Aug 2023 06:29:27 +0000
Subject: Re: [dm-devel] [PATCH 04/24] PM: hibernate: move finding the resume
 device out of software_resume
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
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc: Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org,
 Linux regressions mailing list <regressions@lists.linux.dev>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: leemhuis.info
Content-Language: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 03.08.23 10:27, Vlastimil Babka wrote:
> On 5/31/23 14:55, Christoph Hellwig wrote:
>> software_resume can be called either from an init call in the boot code,
>> or from sysfs once the system has finished booting, and the two
>> invocation methods this can't race with each other.
>>
>> For the latter case we did just parse the suspend device manually, while
>> the former might not have one.  Split software_resume so that the search
>> only happens for the boot case, which also means the special lockdep
>> nesting annotation can go away as the system transition mutex can be
>> taken a little later and doesn't have the sysfs locking nest inside it.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Acked-by: Rafael J. Wysocki <rafael@kernel.org>
> 
> This caused a regression for me in 6.5-rc1+, fix below.
> 
> ----8<----
>>From 95a310ae6cfae9b3cab61e54a1bce488c3ab93a1 Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Wed, 2 Aug 2023 15:46:18 +0200
> Subject: [PATCH] PM: hibernate: fix resume_store() return value when
>  hibernation not available
> 
> On a laptop with hibernation set up but not actively used, and with
> secure boot and lockdown enabled kernel, 6.5-rc1 gets stuck on boot with
> the following repeated messages:
> 
>   A start job is running for Resume from hibernation using device /dev/system/swap (24s / no limit)
>   lockdown_is_locked_down: 25311154 callbacks suppressed
>   Lockdown: systemd-hiberna: hibernation is restricted; see man kernel_lockdown.7
>   ...
> 
> Checking the resume code leads to commit cc89c63e2fe3 ("PM: hibernate:
> move finding the resume device out of software_resume") which
> inadvertently changed the return value from resume_store() to 0 when
> !hibernation_available(). This apparently translates to userspace
> write() returning 0 as in number of bytes written, and userspace looping
> indefinitely in the attempt to write the intended value.
> 
> Fix this by returning the full number of bytes that were to be written,
> as that's what was done before the commit.
> 
> Fixes: cc89c63e2fe3 ("PM: hibernate: move finding the resume device out of software_resume")
> [...]

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced cc89c63e2fe3
#regzbot title pm: boot problems when hibernate is configured and kernel
locked down
#regzbot fix: PM: hibernate: fix resume_store() return value when
hibernation not available
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


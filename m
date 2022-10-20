Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098D5C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 11:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666266271;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6MhiJ3/9KipMBCitmGdtT0hJZaJS/3ClsNM8Qnoo9oI=;
	b=XN/71XHrdsiE0o2yEm62drX0814Qn9F9XEZY2+zEj0gLArNpxGEhAmyou7QbeI+KUufgEi
	vYCWdjWwANXAekNHJuz6m0pC/Ay+IY9wSI76B/hyIiAznsxNWHc44Q3gpSiPUsPujuWusx
	pVGhssNyoX1OJrHNERoeUCpGyWfaU3o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-jRWEpTHFMsarWRmYUKB_jw-1; Thu, 20 Oct 2022 07:44:28 -0400
X-MC-Unique: jRWEpTHFMsarWRmYUKB_jw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 420D53C0ED40;
	Thu, 20 Oct 2022 11:44:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1261B1121315;
	Thu, 20 Oct 2022 11:44:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0E15D1946595;
	Thu, 20 Oct 2022 11:44:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8473F1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 11:44:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5852840C6EC3; Thu, 20 Oct 2022 11:44:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 24FDC40C6EC2;
 Thu, 20 Oct 2022 11:44:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 29KBiFRG025651; Thu, 20 Oct 2022 07:44:15 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 29KBiEdA025647; Thu, 20 Oct 2022 07:44:14 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 20 Oct 2022 07:44:14 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <Y1EDxZvjEi47iWUN@infradead.org>
Message-ID: <alpine.LRH.2.21.2210200731150.25125@file01.intranet.prod.int.rdu2.redhat.com>
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
 <Y0704chr07nUgx3X@redhat.com> <Y1EDxZvjEi47iWUN@infradead.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.1
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
Cc: Shaomin Deng <dengshaomin@cdjrlc.com>,
 Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <snitzer@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Genjian Zhang <zhanggenjian@kylinos.cn>, Jilin Yuan <yuanjilin@cdjrlc.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
 Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 20 Oct 2022, Christoph Hellwig wrote:

> On Tue, Oct 18, 2022 at 02:48:01PM -0400, Mike Snitzer wrote:
> > > That really does not sound like a good idea at all.  And it does not
> > > seem to have any MM or core maintainer signoffs.
> > 
> > Sorry, I should've solicited proper review more loudly.
> > 
> > But if you have a specific concern with how DM is looking to use
> > is_vmalloc_or_module_addr() please say what that is.
> 
> If I understand the patch correct it tries to use it to detect if
> a string is a string global.  Besides being nasty API abuse I can't
> see how this would even work if DM is built in.

It works for built-in DM.

You have "kfree_const" that detects if the string points to to .rodata 
with "is_kernel_rodata". Unfortunatelly, is_kernel_rodata doesn't detect 
if the string points to some modules's rodata, so we need an extra check 
for that.

So, the logic is:
if (!is_vmalloc_or_module_addr(ptr) && !is_kernel_rodata(ptr)) kfree(ptr);

I thought about modifying is_kernel_rodata to detect module's rodata as 
well, but it wouldn't work because kstrdup_const uses it and there would 
be crash possibility:
ptr = kstrdup_const(modules_rodata); unload_module(); use "ptr";

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


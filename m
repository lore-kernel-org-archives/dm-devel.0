Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05ED3C7EE2E
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 20:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686344253;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dI/RZKum6EtiAamnBpGdJQjbr6+jIsMbk6PW3tv6d9Y=;
	b=YsZZaMjSp7DWmAuSXwBj2qTcka3d3SE7/jgsVWcBSqK9SK6BpgxVnCtAdjDQwmr6HUR66l
	EJrXaMr2M0Kn24SuPrAzJM69xCoo4DEcopuOjWDexz56iuqi6Dj8FIu5TG4ooKjtoeVpny
	NtJh+7pOHsKMgbg2hTTsFZPjQBdtfN0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-z3mXs70TNvqb5sGcdgpYlA-1; Fri, 09 Jun 2023 16:57:30 -0400
X-MC-Unique: z3mXs70TNvqb5sGcdgpYlA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D07C33804530;
	Fri,  9 Jun 2023 20:57:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77C02492B00;
	Fri,  9 Jun 2023 20:57:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3F23419451C1;
	Fri,  9 Jun 2023 20:57:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 08E90194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 20:57:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DAEE2492B0C; Fri,  9 Jun 2023 20:57:27 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C1AF7492B0B;
 Fri,  9 Jun 2023 20:57:27 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id ACFC030C0502; Fri,  9 Jun 2023 20:57:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 A9E133F7CF; Fri,  9 Jun 2023 22:57:27 +0200 (CEST)
Date: Fri, 9 Jun 2023 22:57:27 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
In-Reply-To: <ZHaGvAvFB3wWPY17@moria.home.lan>
Message-ID: <e0ad5e2c-48d0-0fe-a2d3-afcfa5f51d1e@redhat.com>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
 <ZHUcmeYrUmtytdDU@moria.home.lan>
 <alpine.LRH.2.21.2305300809350.13307@file01.intranet.prod.int.rdu2.redhat.com>
 <ZHaGvAvFB3wWPY17@moria.home.lan>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] fuzzing bcachefs with dm-flakey
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
Cc: linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 30 May 2023, Kent Overstreet wrote:

> On Tue, May 30, 2023 at 05:00:39PM -0400, Mikulas Patocka wrote:
> > I'd like to know how do you want to do coverage analysis? By instrumenting 
> > each branch and creating a test case that tests that the branch goes both 
> > ways?
> 
> Documentation/dev-tools/gcov.rst. The compiler instruments each branch
> and then the results are available in debugfs, then the lcov tool
> produces annotated source code as html output.
> 
> > I know that people who write spacecraft-grade software do such tests, but 
> > I can't quite imagine how would that work in a filesystem.
> > 
> > "grep -w if fs/bcachefs/*.[ch] | wc -l" shows that there are 5828 
> > conditions. That's one condition for every 15.5 lines.
> 
> Most of which are covered by existing tests - but by running the
> existing tests with code coverage analylis we can see which branches the
> tests aren't hitting, and then we add fault injection points for those.
> 
> With fault injection we can improve test coverage a lot without needing
> to write any new tests (or simple ones, for e.g. init/mount errors) 

I compiled the kernel with gcov, I ran "xfstests-dev" on bcachefs and gcov 
shows that there is 56% coverage on "fs/bcachefs/*.o".

So, we have 2564 "if" branches (of total 5828) that were not tested. What 
are you going to do about them? Will you create a filesystem image for 
each branch that triggers it? Or, will you add 2564 fault-injection points 
to the source code?

It seems like extreme amount of work.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


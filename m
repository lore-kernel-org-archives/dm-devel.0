Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96083C7EE29
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 22:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686349039;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FaP7Vyf/WXcAzww3+MUYU6ygzy5SMQK4edReTg52YMk=;
	b=Il3vtUbh9tBv1UaBjbDBgVlVGuvWxhNowfYxBe866WQtX2DllVL/g3ggoQc1117/NTyUM5
	cVWmzxcurxg6bEQedp34I0u+/rnI+gO2ZKOTo7KARt0PImXZ/R5NS31FAv39j1O4pyL3LI
	XiUD6hizUNgzVyDhw4V7kmWJWOH+104=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-PLpKe0H0PK2aIeCUFWtfjg-1; Fri, 09 Jun 2023 18:17:16 -0400
X-MC-Unique: PLpKe0H0PK2aIeCUFWtfjg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EE1C29AB3F2;
	Fri,  9 Jun 2023 22:17:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D75EC2166B25;
	Fri,  9 Jun 2023 22:17:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8060319451C1;
	Fri,  9 Jun 2023 22:17:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 232F4194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 22:17:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE8A410724; Fri,  9 Jun 2023 22:17:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7B2B10BDF
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 22:17:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8E7B3804064
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 22:17:12 +0000 (UTC)
Received: from out-17.mta0.migadu.com (out-17.mta0.migadu.com
 [91.218.175.17]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-bzLy-b43NOKwHmLNgVAeJg-1; Fri, 09 Jun 2023 18:17:05 -0400
X-MC-Unique: bzLy-b43NOKwHmLNgVAeJg-1
Date: Fri, 9 Jun 2023 18:17:00 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <ZIOk3ANoGxkcl+u7@moria.home.lan>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
 <ZHUcmeYrUmtytdDU@moria.home.lan>
 <alpine.LRH.2.21.2305300809350.13307@file01.intranet.prod.int.rdu2.redhat.com>
 <ZHaGvAvFB3wWPY17@moria.home.lan>
 <e0ad5e2c-48d0-0fe-a2d3-afcfa5f51d1e@redhat.com>
MIME-Version: 1.0
In-Reply-To: <e0ad5e2c-48d0-0fe-a2d3-afcfa5f51d1e@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.dev
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 09, 2023 at 10:57:27PM +0200, Mikulas Patocka wrote:
> 
> 
> On Tue, 30 May 2023, Kent Overstreet wrote:
> 
> > On Tue, May 30, 2023 at 05:00:39PM -0400, Mikulas Patocka wrote:
> > > I'd like to know how do you want to do coverage analysis? By instrumenting 
> > > each branch and creating a test case that tests that the branch goes both 
> > > ways?
> > 
> > Documentation/dev-tools/gcov.rst. The compiler instruments each branch
> > and then the results are available in debugfs, then the lcov tool
> > produces annotated source code as html output.
> > 
> > > I know that people who write spacecraft-grade software do such tests, but 
> > > I can't quite imagine how would that work in a filesystem.
> > > 
> > > "grep -w if fs/bcachefs/*.[ch] | wc -l" shows that there are 5828 
> > > conditions. That's one condition for every 15.5 lines.
> > 
> > Most of which are covered by existing tests - but by running the
> > existing tests with code coverage analylis we can see which branches the
> > tests aren't hitting, and then we add fault injection points for those.
> > 
> > With fault injection we can improve test coverage a lot without needing
> > to write any new tests (or simple ones, for e.g. init/mount errors) 
> 
> I compiled the kernel with gcov, I ran "xfstests-dev" on bcachefs and gcov 
> shows that there is 56% coverage on "fs/bcachefs/*.o".

Nice :) I haven't personally looked at the gcov output in ages, you
might motivate me to see if I can get the kbuild issue for ktest
integration sorted out.

Just running xfstests won't exercise a lot of the code though - our own
tests are written as ktest tests, and those exercise e.g. multiple
devices (regular raid mode, tiering, erasure coding),
subvolumes/snapshots, all the compression/checksumming/encryption modes,
etc.

No doubt our test coverage will still need improving :)

> So, we have 2564 "if" branches (of total 5828) that were not tested. What 
> are you going to do about them? Will you create a filesystem image for 
> each branch that triggers it? Or, will you add 2564 fault-injection points 
> to the source code?

Fault injection points will be the first thing to look at, as well as
any chunks of code that just have missing tests.

We won't have to manually add individual fault injection points in every
case: once code tagging and dynamic fault injection go in, that will
give us distinct fault injection points for every memory allocation, and
then it's a simple matter to enable a 1% failure rate for all memory
allocations in the bcachefs module - we'll do this in
bcachefs_antagonist in ktest/tests/bcachefs/bcachefs-test-libs, which
runs after mounting.

Similarly, we'll also want to add fault injection for transaction
restart points.

Fault injection is just the first, easiest thing I want people looking
at, it won't be the best tool for the job in all situations. Darrick's
also done cool stuff with injecting filesystem errors into the on disk
image - he's got a tool that can select which individual field to
corrupt - and I want to copy that idea. Our kill_btree_node test (in
single_device.ktest) is some very initial work along those lines, we'll
want to extend that.

And we will definitely want to still be testing with dm-flakey because
no doubt those techniques won't catch everything :)

> It seems like extreme amount of work.

It is a fair amount of work - but it's a more focused kind of work, with
a benchmark to look at to know when we're done. In practice, nobody but
perhaps automotive & aerospace attains full 100% branch coverage. People
generally aim for 80%, and with good, easy to use fault injection I'm
hoping we'll be able to hit 90%.

IIRC when we were working on the predecessor to bcachefs and had fault
injection available, we were hitting 85-88% code coverage. Granted the
codebase was _much_ smaller back then, but it's still not a crazy
unattainable goal.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


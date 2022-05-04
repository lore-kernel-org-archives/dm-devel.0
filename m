Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48526C4321E
	for <dm-devel@archiver.kernel.org>; Thu,  5 May 2022 07:13:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-uBkMOqB3NpiQv4OXJEABaA-1; Thu, 05 May 2022 03:13:16 -0400
X-MC-Unique: uBkMOqB3NpiQv4OXJEABaA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97E03833977;
	Thu,  5 May 2022 07:13:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDA3440D2971;
	Thu,  5 May 2022 07:13:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 68BDD1947B81;
	Thu,  5 May 2022 07:13:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BE4821947040
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 10:15:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 76EE540CFD32; Wed,  4 May 2022 10:15:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72AA240CF8F8
 for <dm-devel@redhat.com>; Wed,  4 May 2022 10:15:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 594C4801210
 for <dm-devel@redhat.com>; Wed,  4 May 2022 10:15:42 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-jNhIWEjqPm63Pmdb_TraUw-1; Wed, 04 May 2022 06:15:38 -0400
X-MC-Unique: jNhIWEjqPm63Pmdb_TraUw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 886FD61ACA;
 Wed,  4 May 2022 10:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97614C385A4;
 Wed,  4 May 2022 10:15:35 +0000 (UTC)
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5c3caf4c
 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO); 
 Wed, 4 May 2022 10:15:33 +0000 (UTC)
Date: Wed, 4 May 2022 12:15:31 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Message-ID: <YnJSQ3jJyvhmIstD@zx2c4.com>
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com> <YnJQXr3igEMTqY3+@smile.fi.intel.com>
MIME-Version: 1.0
In-Reply-To: <YnJQXr3igEMTqY3+@smile.fi.intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Thu, 05 May 2022 07:13:10 +0000
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
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Stafford Horne <shorne@gmail.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 04, 2022 at 01:07:26PM +0300, Andy Shevchenko wrote:
> On Wed, May 04, 2022 at 11:57:29AM +0200, Jason A. Donenfeld wrote:
> > On Wed, May 04, 2022 at 11:42:27AM +0200, Jason A. Donenfeld wrote:
> > > So more likely is that this patch just helps unmask a real issue
> > > elsewhere -- linker, compiler, or register restoration after preemption.
> > > I don't think there's anything to do with regards to the patch of this
> > > thread, as it's clearly fine. 
> > 
> > The problem even goes away if I just add a nop...
> 
> Alignment? Compiler bug? HW issue?

Probably one of those, yea. Removing the instruction addresses, the only
difference between the two compiles is: https://xn--4db.cc/Rrn8usaX/diff#line-440

So either there's some alignment going on here, a compiler thing I
haven't spotted yet, or some very fragile interrupt/preemption behavior
that's interacting with this, either on the kernel side or the QEMU
side.

(I've never touched real HW for this; I just got nerd sniped when
wondering why my wireguard CI was failing...)
 
Jason

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


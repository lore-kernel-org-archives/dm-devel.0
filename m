Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A402C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 25 Apr 2022 13:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1650893629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3Swr/FrQ4bJv6cQbHCSqm6ifZgXG2MD1XY+AIm+2upk=;
	b=hchzojmeppsDgVTaqyYW2mLB2GjoQWUsphFztX3lFMR42VjmpSMCmOvaA94jxM7zIzpVPR
	EiHBJZ4V8taZIAsdidLamc1w2z9pNfQ6LVYaZmrlXDpHEod0yn2LNfZN8uqulFw8uujQBa
	M1cvifeqJsFQsw10lan3B1kQhrldst0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-Ax1fgyMFO2uyzDSgOs5pbQ-1; Mon, 25 Apr 2022 09:33:46 -0400
X-MC-Unique: Ax1fgyMFO2uyzDSgOs5pbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B3FA803CB8;
	Mon, 25 Apr 2022 13:33:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0F1E61468F22;
	Mon, 25 Apr 2022 13:33:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 568451947BBF;
	Mon, 25 Apr 2022 13:33:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7FCF41947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Apr 2022 13:33:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4F36854C75F; Mon, 25 Apr 2022 13:33:38 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07E0654C75A;
 Mon, 25 Apr 2022 13:33:38 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 23PDXbKt006460; Mon, 25 Apr 2022 09:33:37 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 23PDXaJZ006456; Mon, 25 Apr 2022 09:33:37 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 25 Apr 2022 09:33:36 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: David Laight <David.Laight@ACULAB.COM>
In-Reply-To: <e8de034196df450cb352fa60a570acca@AcuMS.aculab.com>
Message-ID: <alpine.LRH.2.02.2204250912350.5163@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <CAHk-=wibmkFz6dybsdpW_3kUnV20FhJazerWDcbm7yCp_Xv+CA@mail.gmail.com>
 <789f0463ce974e90a93f4dbf8c471156@AcuMS.aculab.com>
 <alpine.LRH.2.02.2204250701410.10912@file01.intranet.prod.int.rdu2.redhat.com>
 <e8de034196df450cb352fa60a570acca@AcuMS.aculab.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] hex2bin: make the function hex_to_bin
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
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 'Linus Torvalds' <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 25 Apr 2022, David Laight wrote:

> From: Mikulas Patocka
> > Sent: 25 April 2022 12:04
> > 
> > On Mon, 25 Apr 2022, David Laight wrote:
> > 
> > > From: Linus Torvalds
> > > > Sent: 24 April 2022 22:42
> > > >
> > > > On Sun, Apr 24, 2022 at 2:37 PM Linus Torvalds
> > > > <torvalds@linux-foundation.org> wrote:
> > > > >
> > > > > Finally, for the same reason - please don't use ">> 8".  Because I do
> > > > > not believe that bit 8 is well-defined in your arithmetic. The *sign*
> > > > > bit will be, but I'm not convinced bit 8 is.
> > > >
> > > > Hmm.. I think it's ok. It can indeed overflow in 'char' and change the
> > > > sign in bit #7, but I suspect bit #8 is always fine.
> > > >
> > > > Still, If you want to just extend the sign bit, ">> 31" _is_ the
> > > > obvious thing to use (yeah, yeah, properly "sizeof(int)*8-1" or
> > > > whatever, you get my drift).
> > >
> > > Except that right shifts of signed values are UB.
> > > In particular it has always been valid to do an unsigned
> > > shift right on a 2's compliment negative number.
> > >
> > > 	David
> > 
> > Yes. All the standard versions (C89, C99, C11, C2X) say that right shift
> > of a negative value is implementation-defined.
> > 
> > So, we should cast it to "unsigned" before shifting it.
> 
> Except that the intent appears to be to replicate the sign bit.
> 
> If it is 'implementation defined' (rather than suddenly being UB)

The standard says "If E1 has a signed type and a negative value, the 
resulting value is implementation-defined."

So, it's not undefined behavior.

> it might be that the linux kernel requires sign propagating
> right shifts of negative values.

It may be that some code in the Linux kernel already assumes that right 
shifts keep the sign. It's hard to say if such code exists.

BTW. ubsan warns about left shift of negative values, but it doesn't warn 
about right shift of negative values.

> This is typically what happens on 2's compliment systems.
> But not all small cpu have the required shift instruction.
> OTOH all the ones bit enough to run Linux probably do.
> (And gcc doesn't support '1's compliment' or 'sign overpunch' cpus.)
> 
> The problem is that the compiler writers seem to be entering
> a mindset where they are optimising code based on UB behaviour.
> So given:
> void foo(int x)
> {
> 	if (x >> 1 < 0)
> 		return;
> 	do_something();
> }
> they decide the test is UB, so can always be assumed to be true
> and thus do_something() is compiled away.
> 
> 	David

If it's implementation-defined (rather than undefined), the compiler 
shouldn't do such optimization.

The linux kernel uses "-fno-strict-overflow" which disables some of these 
UB optimizations.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


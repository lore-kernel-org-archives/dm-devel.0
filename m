Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBAFCC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 12:15:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-q8ZL61i8Ojup3z1mApQu5A-1; Wed, 27 Apr 2022 08:15:19 -0400
X-MC-Unique: q8ZL61i8Ojup3z1mApQu5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AFE486B8C2;
	Wed, 27 Apr 2022 12:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 180F12024CB6;
	Wed, 27 Apr 2022 12:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B59DB1947042;
	Wed, 27 Apr 2022 12:15:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A5061947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Apr 2022 12:59:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 788BF4C4782; Mon, 25 Apr 2022 12:59:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 74C804C36D5
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 12:59:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DFFA1014A6E
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 12:59:30 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com
 (eu-smtp-delivery-151.mimecast.com [185.58.85.151]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-dmF-iqpZOrmY7a5ZJrsgfg-1; Mon, 25 Apr 2022 08:59:26 -0400
X-MC-Unique: dmF-iqpZOrmY7a5ZJrsgfg-1
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-246-RsRt4rMLMJSg1HNL0-UwSg-1; Mon, 25 Apr 2022 13:59:24 +0100
X-MC-Unique: RsRt4rMLMJSg1HNL0-UwSg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Mon, 25 Apr 2022 13:59:23 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Mon, 25 Apr 2022 13:59:23 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Mikulas Patocka' <mpatocka@redhat.com>
Thread-Topic: [PATCH] hex2bin: make the function hex_to_bin constant-time
Thread-Index: AQHYWCRFXKVloRHnAkSgNzNf81l36q0AX1CggAAH/4CAAC5kEA==
Date: Mon, 25 Apr 2022 12:59:23 +0000
Message-ID: <e8de034196df450cb352fa60a570acca@AcuMS.aculab.com>
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <CAHk-=wibmkFz6dybsdpW_3kUnV20FhJazerWDcbm7yCp_Xv+CA@mail.gmail.com>
 <789f0463ce974e90a93f4dbf8c471156@AcuMS.aculab.com>
 <alpine.LRH.2.02.2204250701410.10912@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2204250701410.10912@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 27 Apr 2022 12:14:17 +0000
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
 Herbert Xu <herbert@gondor.apana.org.au>, Linux
 Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 'Linus Torvalds' <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Mikulas Patocka
> Sent: 25 April 2022 12:04
> 
> On Mon, 25 Apr 2022, David Laight wrote:
> 
> > From: Linus Torvalds
> > > Sent: 24 April 2022 22:42
> > >
> > > On Sun, Apr 24, 2022 at 2:37 PM Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > Finally, for the same reason - please don't use ">> 8".  Because I do
> > > > not believe that bit 8 is well-defined in your arithmetic. The *sign*
> > > > bit will be, but I'm not convinced bit 8 is.
> > >
> > > Hmm.. I think it's ok. It can indeed overflow in 'char' and change the
> > > sign in bit #7, but I suspect bit #8 is always fine.
> > >
> > > Still, If you want to just extend the sign bit, ">> 31" _is_ the
> > > obvious thing to use (yeah, yeah, properly "sizeof(int)*8-1" or
> > > whatever, you get my drift).
> >
> > Except that right shifts of signed values are UB.
> > In particular it has always been valid to do an unsigned
> > shift right on a 2's compliment negative number.
> >
> > 	David
> 
> Yes. All the standard versions (C89, C99, C11, C2X) say that right shift
> of a negative value is implementation-defined.
> 
> So, we should cast it to "unsigned" before shifting it.

Except that the intent appears to be to replicate the sign bit.

If it is 'implementation defined' (rather than suddenly being UB)
it might be that the linux kernel requires sign propagating
right shifts of negative values.
This is typically what happens on 2's compliment systems.
But not all small cpu have the required shift instruction.
OTOH all the ones bit enough to run Linux probably do.
(And gcc doesn't support '1's compliment' or 'sign overpunch' cpus.)

The problem is that the compiler writers seem to be entering
a mindset where they are optimising code based on UB behaviour.
So given:
void foo(int x)
{
	if (x >> 1 < 0)
		return;
	do_something();
}
they decide the test is UB, so can always be assumed to be true
and thus do_something() is compiled away.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


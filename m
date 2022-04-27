Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC522C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 14:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1651068624;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K7p1Ykh5fiYgfRhlvo9i48TgwiZ3wPw0b9Y6cKsXF0s=;
	b=ewBbk1VjXZ7Kzcc0yAp9vJmyRhrWRWNUDaBcjl0ZRrKKtjUuSe0VEHrYF0YT9ajsZunZht
	0vQPhWffiOSHbe6dORsun02mLi3EfV3X+7R1VBzC7ma+RCdJuH2xySJcXds4mfCHhLP9Tu
	fPTXI5RGXXH5F2ORDeDNZr4cJ735jsY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-kWg_bxLqO22aQ24UbL_svg-1; Wed, 27 Apr 2022 10:10:23 -0400
X-MC-Unique: kWg_bxLqO22aQ24UbL_svg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C575F2999B5B;
	Wed, 27 Apr 2022 14:10:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 50C41404D2EE;
	Wed, 27 Apr 2022 14:10:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 039241947043;
	Wed, 27 Apr 2022 14:10:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A3BA21947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 14:10:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6747F9E6E; Wed, 27 Apr 2022 14:10:17 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 679119D7F;
 Wed, 27 Apr 2022 14:10:06 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 23REA6cT001893; Wed, 27 Apr 2022 10:10:06 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 23REA6Vc001889; Wed, 27 Apr 2022 10:10:06 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 27 Apr 2022 10:10:06 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Andy Shevchenko <andy.shevchenko@gmail.com>
In-Reply-To: <CAHp75Vc8kb+dpT_i93No+0_==tLuYKxu9t1Nnv1KRomRc+Ke1w@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2204271000020.1114@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2204241643030.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHp75VdHnvv6FH1BKcs8WgGF3nJpj77TsrmsQGBSpsAQU_S-bw@mail.gmail.com>
 <alpine.LRH.2.02.2204260759540.2737@file01.intranet.prod.int.rdu2.redhat.com>
 <YmfxaB1j65p8dOyj@smile.fi.intel.com>
 <alpine.LRH.2.02.2204261128220.5129@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHp75Vc8kb+dpT_i93No+0_==tLuYKxu9t1Nnv1KRomRc+Ke1w@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2] hex2bin: fix access beyond string end
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
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
 device-mapper development <dm-devel@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 27 Apr 2022, Andy Shevchenko wrote:

> On Tue, Apr 26, 2022 at 5:29 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > On Tue, 26 Apr 2022, Andy Shevchenko wrote:
> > > On Tue, Apr 26, 2022 at 08:07:44AM -0400, Mikulas Patocka wrote:
> > > > On Tue, 26 Apr 2022, Andy Shevchenko wrote:
> > > > > On Sun, Apr 24, 2022 at 10:48 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> ...
> 
> > > Still shadows error codes.
> > >
> > > > +                   return -EINVAL;
> > >
> > > >                     return -EINVAL;
> >
> > What do you mean? What's wrong with "return -EINVAL"?
> 
> The actual error code is returned by hex_to_bin(). What is the point
> of shadowing it with the explicit value?

hex_to_bin returns -1 on error, hex2bin returns -EINVAL on error.

This is inconsistent and it may be fixed (after verifying all the 
hex_to_bin callers - a quick grep over the source shows that there is "if 
((k = hex_to_bin(in_str[j--])) != -1)").

But for the purpose of fixing this bug, we should preserve the behavior 
and return -1 and -EINVAL just like it was before.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


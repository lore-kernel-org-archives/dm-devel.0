Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C39E92FD6
	for <dm-devel@archiver.kernel.org>; Fri,  6 Oct 2023 02:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696559607;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EBe14rjRQG7bOfqttMznQQ7u1XQ8soWvYE1OQqoNeEU=;
	b=RCsdtTbCiL2BYp1X95h8MZ9edqyPxUfOn5gfOyXg0CmqBgoYiQ+ybzSKvHZPQ59P7GyHcG
	FVqwhmND7XItcfSxL4zUspPvZWFkM+Q/t75PPaie+9TSer0cC01qS6u2/lLDI+6mB8KITJ
	w7CPPqAH8eBI3RPQeqAk7s0r3wnYTfo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-sxQG7I8BMO-4mpk6IT31cA-1; Thu, 05 Oct 2023 22:33:24 -0400
X-MC-Unique: sxQG7I8BMO-4mpk6IT31cA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF112811E86;
	Fri,  6 Oct 2023 02:33:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C99963F45;
	Fri,  6 Oct 2023 02:33:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D345B19465A2;
	Fri,  6 Oct 2023 02:33:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 51E6F194658F
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Oct 2023 02:33:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2AD66140E953; Fri,  6 Oct 2023 02:33:21 +0000 (UTC)
Received: from abb.hmeau.com (unknown [10.67.24.162])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D61F4140E962;
 Fri,  6 Oct 2023 02:33:20 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1qoaeL-0044GQ-OJ; Fri, 06 Oct 2023 10:33:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Fri, 06 Oct 2023 10:33:14 +0800
Date: Fri, 6 Oct 2023 10:33:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <ZR9x6ifhd6axh5Ki@gondor.apana.org.au>
References: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
 <ZR9dEiXhQv-wBVA2@debian.me> <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
 <ZR9wRq7Rkz+LocDX@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZR9wRq7Rkz+LocDX@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] dm crypt: Fix reqsize in crypt_iv_eboiv_gen
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
Cc: Linux Regressions <regressions@lists.linux.dev>,
 Tatu =?iso-8859-1?Q?Heikkil=E4?= <tatu.heikkila@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Device Mapper <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gondor.apana.org.au
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Oct 05, 2023 at 10:26:14PM -0400, Mike Snitzer wrote:
>
> Sure, please do.  Shouldn't your header Cc: stable given that the
> Fixes commit implies v6.5 needs this fix?

Sure I'll add it although it will be picked up automatically due
to the Fixes header.  I'll also fix the reporter's name.

> Reviewed-by: Mike Mike Snitzer <snitzer@kernel.org>

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


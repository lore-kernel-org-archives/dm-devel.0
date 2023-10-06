Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B4FE94134
	for <dm-devel@archiver.kernel.org>; Fri,  6 Oct 2023 21:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696629437;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pU7ihj/4uI+129a53I8uavXWX6ApTdLx2599tDD0BcI=;
	b=QyPh89UV8u+IqtuJ1aQZ1Hf6fxs2F3OInDC8vl94xjWjSEi604IbZ29PPb3sq/ONLFjT6k
	TCWMGVIwdU2RRCrsgUxSPR/MNOf4FP9zoUETojoW76RlajIzvmjIwoCwe6xrvPsEJL1GhJ
	KxNrt+mWo/ryO/AeXnT4IqMKROlCUrU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-BKBszUIBMLmYBJgtm2XTgw-1; Fri, 06 Oct 2023 17:57:14 -0400
X-MC-Unique: BKBszUIBMLmYBJgtm2XTgw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77D173C0F23D;
	Fri,  6 Oct 2023 21:57:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12CEF492C37;
	Fri,  6 Oct 2023 21:57:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AFE001946589;
	Fri,  6 Oct 2023 21:57:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFF191946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Oct 2023 08:39:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C1A5E492B05; Fri,  6 Oct 2023 08:39:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9B4B492C37
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 08:39:31 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DCA93821360
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 08:39:31 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de
 [80.237.130.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-h7gbq-nYOKugrDxEUq4Pag-1; Fri, 06 Oct 2023 04:39:29 -0400
X-MC-Unique: h7gbq-nYOKugrDxEUq4Pag-1
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
 by wp530.webpack.hosteurope.de running ExIM with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
 id 1qog4t-0006XM-43; Fri, 06 Oct 2023 10:20:55 +0200
Message-ID: <9ffdce44-c1ca-4587-bcae-4bd1ebb52f61@leemhuis.info>
Date: Fri, 6 Oct 2023 10:20:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@kernel.org>
References: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
 <ZR9dEiXhQv-wBVA2@debian.me> <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
 <ZR9wRq7Rkz+LocDX@redhat.com> <ZR9x6ifhd6axh5Ki@gondor.apana.org.au>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
In-Reply-To: <ZR9x6ifhd6axh5Ki@gondor.apana.org.au>
X-bounce-key: webpack.hosteurope.de; regressions@leemhuis.info; 1696581569;
 3d56b62a
X-HE-SMSGID: 1qog4t-0006XM-43
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 06 Oct 2023 21:57:07 +0000
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
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc: Linux Regressions <regressions@lists.linux.dev>,
 =?UTF-8?Q?Tatu_Heikkil=C3=A4?= <tatu.heikkila@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Device Mapper <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: leemhuis.info
Content-Language: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 06.10.23 04:33, Herbert Xu wrote:
> On Thu, Oct 05, 2023 at 10:26:14PM -0400, Mike Snitzer wrote:

BTW, Herbert, thx for taking care of this quickly!

>> Sure, please do.  Shouldn't your header Cc: stable given that the
>> Fixes commit implies v6.5 needs this fix?
> 
> Sure I'll add it although it will be picked up automatically due
> to the Fixes header.

FWIW, as some people don't know this: that might be the case, but there
is no guarantee, hence it's better to add it:

https://lore.kernel.org/all/2023060703-colony-shakily-3514@gregkh/

>  I'll also fix the reporter's name.

Side note: a Link: or Closes: tag to the report
(https://lore.kernel.org/all/f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com/
) would be nice as well.

Thx again. Ciao, Thorsten

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


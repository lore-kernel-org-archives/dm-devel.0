Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C41B0E94131
	for <dm-devel@archiver.kernel.org>; Fri,  6 Oct 2023 21:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696629437;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HImu1XBtnHbsaUn4I8oq7Q5JEgX+b/QN0mGeBjNrNoY=;
	b=Cb4lW0DGIh06VIEjdonMVseHVEvhSuSZNmMYIdo1JRoEz09nC04d9N8mywnSAR+C2RSor5
	OzDCFw1ATxL5sLQRJar8IXZTGr3Q8hRZzZ+2fKJcXaJr1WyUXdBfOF6jLDN9okGjiToZx1
	yCeo91f0r3DpgnJoNQvN694FpKE1xLE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-0TkOLs-rO7i5JNmItgfxkw-1; Fri, 06 Oct 2023 17:57:14 -0400
X-MC-Unique: 0TkOLs-rO7i5JNmItgfxkw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77CC33C0F238;
	Fri,  6 Oct 2023 21:57:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 33085400F36;
	Fri,  6 Oct 2023 21:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D9E5A19465BD;
	Fri,  6 Oct 2023 21:57:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0BDBF1946588
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Oct 2023 11:03:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ECF7047AD4A; Fri,  6 Oct 2023 11:03:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4EE940D1EA
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 11:03:40 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7E23101A53B
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 11:03:40 +0000 (UTC)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com
 [209.85.208.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-DP3cb4j7P4uX6-2pcZQRJA-1; Fri, 06 Oct 2023 07:03:38 -0400
X-MC-Unique: DP3cb4j7P4uX6-2pcZQRJA-1
Received: by mail-lj1-f173.google.com with SMTP id
 38308e7fff4ca-2b9338e4695so25140701fa.2; 
 Fri, 06 Oct 2023 04:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696590217; x=1697195017;
 h=content-transfer-encoding:in-reply-to:from:content-language:subject
 :references:cc:to:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=z+TRwFSu5xqtCS4GBmrR7m1FXCNdXTVhpoe8UmPcZTw=;
 b=QpHbszfNz3DbrTrahbhV/K3OEo+TPKUnIU4LvCOUBWoMKGPRmwJ9+1o3D2vHlL3zD3
 /VVaJHluh8Z9T4vk3c6qpTyhoApUQmJX7nTu91M7Ffkn/Hg3VAHELrWZjuaycs80p12R
 X87N8YIkP7IygdGNxRm1JpoYE8A7VOFpzOoqX/r62m7lFzhavyLJzWpv1xTDZnV5k/By
 TC0hxrdL5O0LnUpqQ15d0DN1Th0nognY/pCAVV6gF+DT/rvHVf7nsuI3ULaA6/k1s5XL
 SMTZCfJWBHydP6TheqN3NJG3Dxwh31OFYCzKWVFH+d7LNQeJsNDSjzBZk6EkvzZGsi48
 lJPg==
X-Gm-Message-State: AOJu0Yz7MLHU/cgbs9OSyy1AgqiAcUvULaXW+An09gewX6TP+UslwUiz
 yB0tRSO31L9cKVxZKvFsyco=
X-Google-Smtp-Source: AGHT+IHbJIkrY2O3p6RlIgFAJE8d2tiwnAaepkLjqi+oST9E8RjdFvBeCrjedWjwJRAvUsWAv5tVTQ==
X-Received: by 2002:ac2:5de2:0:b0:4f8:ff52:93b7 with SMTP id
 z2-20020ac25de2000000b004f8ff5293b7mr6840655lfq.30.1696590216741; 
 Fri, 06 Oct 2023 04:03:36 -0700 (PDT)
Received: from [192.168.0.9] (88-114-1-11.elisa-laajakaista.fi. [88.114.1.11])
 by smtp.gmail.com with ESMTPSA id
 u7-20020a056512040700b00501ce0cacb6sm259934lfk.188.2023.10.06.04.03.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Oct 2023 04:03:36 -0700 (PDT)
Message-ID: <48b3624d-ef0c-96e7-ff3d-9f34eb1caad8@gmail.com>
Date: Fri, 6 Oct 2023 14:03:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: herbert@gondor.apana.org.au
References: <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
From: =?UTF-8?Q?Tatu_Heikkil=c3=a4?= <tatu.heikkila@gmail.com>
In-Reply-To: <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 06 Oct 2023 21:57:07 +0000
Subject: Re: [dm-devel] [PATCH] dm crypt: Fix reqsize in crypt_iv_eboiv_gen
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
Cc: regressions@lists.linux.dev, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 linux-crypto@vger.kernel.org, bagasdotme@gmail.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Fri, Oct 06, 2023 at 09:41:55 +0800, Herbert Xu wrote:
>
> On Fri, Oct 06, 2023 at 08:04:18AM +0700, Bagas Sanjaya wrote:
> >
> > > Git bisect lead me to:
> > > # first bad commit: [e3023094dffb41540330fb0c74cd3a019cd525c2] dm crypt:
> > > Avoid using MAX_CIPHER_BLOCKSIZE
> > > 
> > > If I git revert e3023094dffb41540330fb0c74cd3a019cd525c2 on current Linus'
> > > git master, the issue goes away. So I'm personally not all that affected
> > > anymore (if I'm ready to compile my kernels from now on), and I understand
> > > that you have no clear way to reproduce this as it seems strongly bound to
> > > hardware, but seems like this could point to a potentially serious security
> > > issue since it involves both crypto and undefined behaviour.
> 
> Thanks for the report.  Sorry this is indeed my fault.  The allocated
> buffer is too small as it's missing the size for the request object
> itself.

Thank you for your prompt fix, I can access the volume without issue now. :-)
-Tatu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


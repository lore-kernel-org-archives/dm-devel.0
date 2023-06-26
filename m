Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8DAC00528
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971632;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Nbq9Xh14Q0owFEi1g+FUgFLi0Ne/Ud1xwthEPEVJIHk=;
	b=Lfo2hW3iuvkTM2NgRCuzpLyC3IXuI4lfCMwKA/BiYfsT+kzNBSiV2/SaIG1UhVZGNin+N0
	LK3gJCDrjxHbcUzhDKv6rkpFCpB67pHWv9eh69FmH9NLnI/+OeRKhHMr75QdBjpGLkfsx9
	yIiEUuiwaCKjFQv7Te9nJvLVJynFsh0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-oJ3qLrWIO4qe-6-aHN90qA-1; Mon, 10 Jul 2023 02:47:08 -0400
X-MC-Unique: oJ3qLrWIO4qe-6-aHN90qA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDED089E74E;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D9BFA492C13;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 97DE11949757;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 784071946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 16:20:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8B0D92166B26; Mon, 26 Jun 2023 16:20:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 832472166B27
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 16:20:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AEC8185A7A8
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 16:20:31 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.15.14]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-BZTy-1jRMYevktGoysRM6g-1; Mon,
 26 Jun 2023 12:20:25 -0400
X-MC-Unique: BZTy-1jRMYevktGoysRM6g-1
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.83]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N2BMA-1q4MSn2Hug-013X0X; Mon, 26
 Jun 2023 18:20:15 +0200
Message-ID: <1c1cd489-6d59-00ed-a1f5-497ca532c08d@web.de>
Date: Mon, 26 Jun 2023 18:20:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Demi Marie Obenour <demi@invisiblethingslab.com>
References: <20230624230950.2272-3-demi@invisiblethingslab.com>
 <3241078c-2318-fe1b-33cc-7c33db71b1a6@web.de> <ZJh73z2CsgHEJ4iv@itl-email>
 <e42e8115-6f75-447e-9955-ca4ad43ed406@kadam.mountain>
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <e42e8115-6f75-447e-9955-ca4ad43ed406@kadam.mountain>
X-Provags-ID: V03:K1:7kb9UXr+SWFMPITRu36W/qBQb60QuzsKT10LUpMlxNEmJrZD1li
 9OLemY/qY/17OehY6EF/pfgFBBLcLgBKVAcEzuN+Qiy1E7WYuHAf2Bawi2IIJfDPa1UYO1l
 l0nHb+AE12M1mcl/s5jutfMm4BsRu5NN5yvBhFNfPVHY1SMYrm+i09vDZuIc9mHLH0yfbtz
 r76DSeJ3riB+jTENObhOg==
UI-OutboundReport: notjunk:1;M01:P0:nSDa1yPxkD8=;4jzlYJUjpT+S6BpOWOBHQHk4MVZ
 AnWjMzbtYp8N9EJkwsjIRwvIlEI859mydN2XX4xj/l1fnARib1eDEFQON1D2h5IHqMLBC5hzK
 ZJMkC5SRyMdlRwgS1aswnhBGNr8dOuZ/rnyLcg5aI9OMgFnbl6BcpTzlyPO/zeqtiYeg54uZq
 uewHxCbevITk1v0zxOZbNDxROQvc6NRJDcJuSOkm181dgVSboH23F8zGILT/EyUUjwd94vR3s
 3bsy/1mP9uQbzzFtv1v0roMApTN+KD4KxpVLvHAITkTeSaduyh4eYpKpef7QNAsLxQpA28kAT
 IUr+ZbpY7nxLwsvII1TtPXqWzXzgVZUq8GOEute49uJ8eZUEQsxtrhJWCp3VCt2XlwvTdp777
 I1dH394HguG3hv2nHC/aBOZFFPxHMlbuBbLYKdjf+OOM08eEvhKzWsWC4ZU0WyTQ7s4pgFXYQ
 hRyGZOWDxQd0f/fawIkO8uB/SLwMpJuWdF4d9LHGmchyetDE3BaLR0Ao/aKS9FxOFgikoimx9
 E5WfEDF43zVmfbdLujOg1lVhVKTLj72nqz21v25xMGUF64EUxB9MPP9i8Ot1WJ35DzKN8xnpe
 naOSSrlOGCSffyn7Q/D6Dr7a+BGtnnOEBHHLR3x4RUEnPphtPG2LRpwucav6FNjbdsi4OASEd
 ROT5eK3sWlqOPoenaZ0NdSbOrCveaKV9Gt94wwtIkhh02uadBkq+VfIbAVQZfoyZbvDH0XPoi
 Iy+6EAeAG56U1LuA8aVs8BLALL+NVYDAmSETnrH6vi98KVxJMxNGd/YdIwX8t3BgTMjYURxa9
 sDPeZQ5Q/YzXymZ+rMh9grA+VDB9wiZnoh1Hww994BYuRq26Ljj4XITREWhbsWxrrm/MoVmdS
 m56theq36JXkOwVCERz4bbQOZ/M7G3xW16KMksxN1uab8TaMq6hIDo214sAPqAbrzQ9KFjaQB
 8VRDbQhgAny8jQdaR1oW5vLiNyM=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH v2 2/4] dm ioctl: Allow userspace to provide
 expected diskseq
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
Cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: web.de
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiDigKYsIHN0b3AgYm90aGVyaW5nIHBlb3BsZSBhYm91dCB0cml2aWFsIG5vbnNlbnNlLiDigKYK
ClNlZSBhbHNvIGFub3RoZXIgYml0IG9mIGJhY2tncm91bmQgaW5mb3JtYXRpb24gb25jZSBtb3Jl
OgpbUEFUQ0ggdjJdIGNlcnRzL2V4dHJhY3QtY2VydDogRml4IGNoZWNrcGF0Y2ggaXNzdWVzCjIw
MjMtMDYtMDkKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva2VybmVsLWphbml0b3JzL2M0NjRjNGVl
LTAzOGMtNDdiZi04NTdhLWIxMWE4OTY4MGU4MkBrYWRhbS5tb3VudGFpbi8KaHR0cHM6Ly9sa21s
Lm9yZy9sa21sLzIwMjMvNi85Lzg3OQoKUmVnYXJkcywKTWFya3VzCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==


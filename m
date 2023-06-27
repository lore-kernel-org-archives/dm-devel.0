Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A69F1C04A94
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971638;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3L9inMLymPP22pQP2ZeSYZUits8EiteAllwWMu941hA=;
	b=IYqqESSbEghFmioXq1ETkZ51PdlKMNvEoTt3g1oetEcWPR7J8L7Sh1/75Vj4T1sv8fLJXu
	i7Ai9IpRIb2vBKrpdCtxZisYP+a21nXwKq2jVg5dl7Lde4gyl3E6xIf40atRdSJJKXvabF
	SbY5tsTFDltRm9GRjFjOBhnfOyAyl6g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-UrrS8aFdO_u0BvzhKOSS6w-1; Mon, 10 Jul 2023 02:47:17 -0400
X-MC-Unique: UrrS8aFdO_u0BvzhKOSS6w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A94B388D2B1;
	Mon, 10 Jul 2023 06:47:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 947A7492CAF;
	Mon, 10 Jul 2023 06:47:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB5E319451D9;
	Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFB321946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Jun 2023 07:25:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BB7ED14682FC; Tue, 27 Jun 2023 07:25:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B41A814682FA
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 07:25:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B74D38009F3
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 07:25:06 +0000 (UTC)
Received: from mout.web.de (mout.web.de [217.72.192.78]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-52x862CnPoSMeqEHcuEQcw-1; Tue,
 27 Jun 2023 03:25:04 -0400
X-MC-Unique: 52x862CnPoSMeqEHcuEQcw-1
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.83]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MLzit-1qVzKo3ADB-00HkFh; Tue, 27
 Jun 2023 09:19:03 +0200
Message-ID: <3f9370ff-074a-1a14-fae7-e081d47e628c@web.de>
Date: Tue, 27 Jun 2023 09:19:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Dan Carpenter <dan.carpenter@linaro.org>,
 kernel-janitors@vger.kernel.org, dm-devel@redhat.com
References: <20230624230950.2272-3-demi@invisiblethingslab.com>
 <3241078c-2318-fe1b-33cc-7c33db71b1a6@web.de> <ZJh73z2CsgHEJ4iv@itl-email>
 <e42e8115-6f75-447e-9955-ca4ad43ed406@kadam.mountain>
 <1c1cd489-6d59-00ed-a1f5-497ca532c08d@web.de>
 <ab9f1618-5dde-4c70-a88e-c65f33abdb73@kadam.mountain>
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ab9f1618-5dde-4c70-a88e-c65f33abdb73@kadam.mountain>
X-Provags-ID: V03:K1:cGruVG7ep7IrLvpnRKs0j84eH+60d6S/ln4HvvF2jBAArldbTy6
 b3zoX5TrDp1G7/7Kg+e7DGYhMVXwoI6TAehdqEXeQ45eW3hPqAtQCHX0pVwXaHUQm/LiNSL
 N5rqJzlr5jXpe63qOJorUXN2qF7eqfmj63s4FMPBJok/JFYfhQO5Kl2DNiUPPiemPgHI6jW
 Lhqjq/5zfkfpWSJGvo/1A==
UI-OutboundReport: notjunk:1;M01:P0:4/vx+D5cBQw=;u0l/bVXOFITfEWayPU/bYe+k8zp
 tJDSPLdJZzKkFkv6MozIsqJWwoEmOfq25e5jbxlBPrqsShnL0oCOv9QAqeybKFa8VmiS6qG3I
 ETN33StrYZ9kaAg6nsIfk1lXT/zp6DB7u8Zaf6JJyPDukxTiioYRT1RMtngRDHtk6fJ0UtrG2
 +fo+Bm4vvEJbNXadDhGD0MqFCf6pbRb1xDsYQ34Du8jTZC9Fh64uUfHwQMpKJc0wzb73y04VD
 C66b7owefDHQLtjDRWcKIV07FXIZVmm2oZTW+AF2DX9OBgC5di2AV9byOWyy+PEr2ZyQnKhR7
 RpBG9QvPxYkH7MZLNtU8BukhcsqwHOuO8GCZs7LOh4pRH6EBWHq2olVapwZ4VlSvas4XL65i7
 F78uAugVSdlt7UbVwCjrIGYrXiQe1Yb9kOYzmvJtk2ByFJ7LHNiBkzlOXkfFOcYjDm7CwWONi
 d9Eq0n8dqASIHieEyHTqqT1UXSt/5qJVKVEt6D80mZxfg5ZNjsw4iRs69ynSIi77lvPqJ2XqV
 LfQ+zpJ8Vme1fsqpQCx6oP3RJurGqVw9SJwPd8v2Qo57JcW3KG8i3Iu9eSKSKfeE+KrYxpiu1
 H8xZtpjOXmJWYWRHyBicsADPpmEH9F8Mg7bMKm6Ska8D9CovdF4OYEt5jITNzcMDra+hkBhpj
 oGcVERgvZ0aCVcB/AXyQunMSLL+kUgAb2etoJb/rTvbmz+/+Nsp8WHyTnWQQW22OPvpBfUlXG
 Bu3syDTn+4E8k4SOPGznNuZWTjzwIs6H1oMaS2c7WBYqjEZMkPt0hkuFd6C07LtSD0Ds65R1Y
 BdhjCI/nHeAuqa2gD0x2cN55Bbvd5mq1fn/44tV5ThusmJPCJGdqk6tgTL3OofoQlp7Rg5cGw
 13Uk/AoVCYjw1FEYHme1iy2uB1O6fGh14IHoiU3UqPDAVjBgRVQgtnRvfGAdnww0+Tv8thslZ
 onPqpQ==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [v2 2/4] dm ioctl: Allow userspace to provide
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Mike Snitzer <snitzer@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: web.de
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>> See also another bit of background information once more:
>> [PATCH v2] certs/extract-cert: Fix checkpatch issues
>> 2023-06-09
>> https://lore.kernel.org/kernel-janitors/c464c4ee-038c-47bf-857a-b11a89680e82@kadam.mountain/
>> https://lkml.org/lkml/2023/6/9/879
>
> Markus, it's not about imperative tense.  It's about you wasting
> people's time.
>
> Read the subject again.  "Allow userspace to provide expected diskseq".
> That is imperative tense.

Yes for the patch subject.
(Patch/commit descriptions can be adjusted accordingly.)


>                            I have not pointed it out to you because it
> just doesn't matter at all.  If it's in imperative tense or if it's not
> in imperative tense, it doesn't matter.

It seems that known development documentation expresses opposite requirements.


> You're sending out a lot of messages and quite a few times it looks like
> your targeting newbies.

I dare to send some change suggestions (or reminders) to various contributors.


>                          One new developer sent me an email privately
> who was over the top grateful when I told him he could ignore you.
> The guy was like, "I was so puzzled, because it's my first patch
> and I didn't know how to respond."

Thanks for such information.


>                                     This was an experienced programmer
> who we want, but he was new to the kernel community so he didn't know
> if we had bizarre rules or whatever.

There is some guidance available already.
Development experiences can and will grow further.


> I've looked through your patches that have recently been merged.

Thanks for another look.


> Some of those maintainers know that you are banned

Yes, of course.


> and that your patches are not getting any review from the mailing list.

Review approaches are generally improvable.


> We are really trying to be nice and to work around your situation.

Can remaining communication difficulties be resolved better anyhow?


> But don't start bothering newbies who don't know what the situation is.

I do not distinguish some of my patch feedback on the contributor category.

Regards,
Markus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


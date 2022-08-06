Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B2EC19F2D
	for <dm-devel@archiver.kernel.org>; Sat,  6 Aug 2022 18:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659809421;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WvDhfBhMZFyABjYosa7kEUw1qesTFYv8kM1mHy4r4jY=;
	b=e/+Ba0AirsIoYvkoT5EQXuyLRBDkNjk3947Xjh+quLkRPmhsXPD36OKxHO1XJXVfQkWlPW
	SjH39DphZ67jNQhQL+gkRdzoMAc+ymgSWFOJeHcogHdq7J1vmwivyCXbd0vphuNB+fByCn
	KIrQMHmFXZSYOoXc/6Q8e3sCkOKHSOI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-bx5_Wmb_PiqCistdpywvOw-1; Sat, 06 Aug 2022 14:10:17 -0400
X-MC-Unique: bx5_Wmb_PiqCistdpywvOw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90EAF8037AA;
	Sat,  6 Aug 2022 18:10:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE35D400E88D;
	Sat,  6 Aug 2022 18:10:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 79E161946A49;
	Sat,  6 Aug 2022 18:10:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C4C871946A48
 for <dm-devel@listman.corp.redhat.com>; Sat,  6 Aug 2022 18:10:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5AF1403166; Sat,  6 Aug 2022 18:10:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1D3D401E5C
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:10:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B0B2801755
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:10:06 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
 [209.85.218.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-8gee-43UP7yLYHN7C8z-8w-1; Sat, 06 Aug 2022 14:10:01 -0400
X-MC-Unique: 8gee-43UP7yLYHN7C8z-8w-1
Received: by mail-ej1-f52.google.com with SMTP id gb36so9986958ejc.10
 for <dm-devel@redhat.com>; Sat, 06 Aug 2022 11:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=kjtebnWpuVmRvt/UMpUPrQsoSPrunFHPAFg6ElFU0RU=;
 b=rrgURfiJK9POYqdbA2jsgzqdZUzFZToa7w7rxrdFTOLt4gczn9hxlhFX+9LLKJpUBP
 EXK1wO5z0HMJ6J8f81v1ku6RO/yhL7A2dNq6jUHCJtXYn6HoxKgeOPB5gKd1Nyfx979+
 m4fhXpz23vm82D64iRu2Rb0ujAapiSAiNQT+4JzStjmuhB5WFku//NEXGqTAzCbV4Psu
 bF8UqfNmnNxK69pQS4aPua76nhfwfJLl/cFK3K3pRJGBQKtHYYCW+yPuwzhvwTrrfNYK
 uxMkNJV/jk4FkpIhE4mi6OJZo4VrGtFj0RKIKDdxO4Zmc92+8EMNdrki+nBvMjq4iOVI
 Nbxg==
X-Gm-Message-State: ACgBeo3wAoiJRj2PpA4l07znDhhD+oytWQxdREOROWPZqGM8pdT4UW2S
 wDeqgNP87MsBbDJpmBg3HoYFsQj5bObkarnc
X-Google-Smtp-Source: AA6agR6rLw23Oi2MZNJOoffZhUYkkk7fpMQXgH8cbOva4ufPQIiIvdJcasrFVfJNJ6NumdktCQF78A==
X-Received: by 2002:a17:907:72c6:b0:72f:b01:2723 with SMTP id
 du6-20020a17090772c600b0072f0b012723mr8968955ejc.439.1659809399817; 
 Sat, 06 Aug 2022 11:09:59 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com.
 [209.85.221.44]) by smtp.gmail.com with ESMTPSA id
 d16-20020a50fe90000000b0043b986751a7sm1802976edt.41.2022.08.06.11.09.59
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 06 Aug 2022 11:09:59 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id h13so6508627wrf.6
 for <dm-devel@redhat.com>; Sat, 06 Aug 2022 11:09:59 -0700 (PDT)
X-Received: by 2002:a05:6000:178d:b0:222:c7ad:2d9a with SMTP id
 e13-20020a056000178d00b00222c7ad2d9amr112963wrg.274.1659809398767; Sat, 06
 Aug 2022 11:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <YugiaQ1TO+vT1FQ5@redhat.com> <Yu1rOopN++GWylUi@redhat.com>
In-Reply-To: <Yu1rOopN++GWylUi@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 6 Aug 2022 11:09:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj5w+Nga81wGmO6aYtcLrn6c_R_-gQrtnKwjzOZczko=A@mail.gmail.com>
Message-ID: <CAHk-=wj5w+Nga81wGmO6aYtcLrn6c_R_-gQrtnKwjzOZczko=A@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [git pull] Additional device mapper changes for 6.0
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
Cc: Eric Biggers <ebiggers@kernel.org>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Milan Broz <gmazyland@gmail.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Aug 5, 2022 at 12:10 PM Mike Snitzer <snitzer@kernel.org> wrote:
>
> All said: I think it worthwhile to merge these changes for 6.0, rather
> than hold until 6.1, now that we have confidence this _optional_ DM
> verity feature is working as expected. Please be aware there was a
> small linux-next merge fixup needed:
> https://lore.kernel.org/all/20220805125744.475531-1-broonie@kernel.org/T/

Well, more importantly, the verity_target version numbers clash.

I used the newer "{1, 9, 0}" version number, but if you want it to be
"{1, 9, 1}" to show that it's a superset of the previous one, you
should do that yourself.

That said, the best option would be to remove version numbers
entirely. They are a completely broken concept as an ABI, and *never*
work.

Feature bitmasks work. Version numbers don't. Version numbers
fundamentally break when something is backported or any other
non-linearity happens.

Please don't use version numbers for ABI issues. Version numbers are
for human consumption, nothing more, and shouldn't be used for
anything that has semantics.

               Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


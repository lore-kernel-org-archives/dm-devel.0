Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7276BC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 19:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666120809;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xTWNhOgciR96BeuYarWGtcsgPIfbzYdhTRF5a10vU9k=;
	b=emit8dOAZtCCTNOPtcTNOwp3pH+KiKrDsUwFa+MzC9qQsSjWasf1RE0PjBgIQ2cHUTb2L9
	jd1wFHNKGS2zrp7qo3Iip83ZMuAGrCyoNiz+TA1lyn1sP+jI2a4A2DNdSspqaLxFsYeFhk
	CgT70TXtX6jFh3D5hmkLzlHq0UXnBFM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-kRC6XE7HO3a9Zh9fcqfPbg-1; Tue, 18 Oct 2022 15:20:06 -0400
X-MC-Unique: kRC6XE7HO3a9Zh9fcqfPbg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AD57833A09;
	Tue, 18 Oct 2022 19:20:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21E3949BB63;
	Tue, 18 Oct 2022 19:20:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB6E41946594;
	Tue, 18 Oct 2022 19:20:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AB18B194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 19:20:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8688314657C1; Tue, 18 Oct 2022 19:20:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F7A314657C0
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 19:20:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6382B833A0D
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 19:20:01 +0000 (UTC)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com
 [209.85.160.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-539-k96Nyz4HNSay7w4QQyBnyg-1; Tue, 18 Oct 2022 15:19:59 -0400
X-MC-Unique: k96Nyz4HNSay7w4QQyBnyg-1
Received: by mail-qt1-f170.google.com with SMTP id l28so10327978qtv.4
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 12:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=mFa9H1YcgEQ0QJQ6P/vrEWGWEagwD/S4HsG+zs6wkwI=;
 b=nTFsrDzbOWXwlcBaimDxb4mK6fna9a8pHQWVcEzcVtl/+bPBGyK7EsAboVtvgTAL1B
 UaFfBH4iXHIe8n3jQgZcccu+ryaVry3KD/10TYUsgYSD6fRgoBnMYdV4iE9oaJlW9mp1
 Uj5tpIrCn/ULEniC+SbtqXk1oMLoiFSE6Oe1reDQRrXd57UJavqwPoZlH6yt/OakauDy
 IcYdpOeNtCGrHGKG0AhSuIYi7vVmBpj+cYjHH5qQzLvDhSo1nNjcIg9M9W/UaL9mIpGE
 GywjFxRD1NuPjpkZW8KQFdQlbl1EAkQ5tVZiRwetLY9QDOlr642UGYGWzsf8LPv6DHra
 KHFw==
X-Gm-Message-State: ACrzQf2YXSq91IZLYS4M3ye9W8dQyK4zUU5ZM+GC7rsFRBAJdaWBiBSd
 24nXbxszjoWNn2epiy3ZNWOIwRW7MokHZA==
X-Google-Smtp-Source: AMsMyM65WQ4lYUPa+uJQyEwHXV1f/xd7Hvu5dTBBV8NAWsJzT4iOMFa25xb1KMEF1hoGDW7vfnAjtg==
X-Received: by 2002:ac8:5a0c:0:b0:391:7be4:1c4f with SMTP id
 n12-20020ac85a0c000000b003917be41c4fmr3469815qta.472.1666120798072; 
 Tue, 18 Oct 2022 12:19:58 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com.
 [209.85.128.179]) by smtp.gmail.com with ESMTPSA id
 l12-20020a37f90c000000b006cbc6e1478csm2989430qkj.57.2022.10.18.12.19.56
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Oct 2022 12:19:56 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id
 00721157ae682-358bf076f1fso146740687b3.9
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 12:19:56 -0700 (PDT)
X-Received: by 2002:a0d:fe07:0:b0:360:c3e9:fc8a with SMTP id
 o7-20020a0dfe07000000b00360c3e9fc8amr3888903ywf.441.1666120796403; Tue, 18
 Oct 2022 12:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
 <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
In-Reply-To: <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Oct 2022 12:19:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiE_p66JtpfsM2GMk0ctuLcP+HBuNOEnpZRY0Ees8oFXw@mail.gmail.com>
Message-ID: <CAHk-=wiE_p66JtpfsM2GMk0ctuLcP+HBuNOEnpZRY0Ees8oFXw@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.1
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
Cc: Jilin Yuan <yuanjilin@cdjrlc.com>, Nikos Tsironis <ntsironis@arrikto.com>,
 Shaomin Deng <dengshaomin@cdjrlc.com>, Mike Snitzer <snitzer@kernel.org>,
 Nathan Huckleberry <nhuck@google.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Genjian Zhang <zhanggenjian@kylinos.cn>, Milan Broz <gmazyland@gmail.com>,
 Alasdair G Kergon <agk@redhat.com>, Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 18, 2022 at 11:54 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But no, we absolutely do *not* want to emulate that particular horror
> anywhere else.

Side note: if DM people go "Hmm, a lot of our management really does
have the exact same issues as 'mount()' and friends, and doing the
same things as mount does with the whole string interface and logging
sounds like a good idea", I want to nip that in the bud.

It's most definitely *not* a good idea. The mount thing is nasty, it's
just that we've always had the odd string interface, and it's just
grown from "const void *data" to be a whole complicated set of context
handling.

So don't even think about duplicating that thing.

Now, if some "inspired" person then thinks that instead of duplicating
it, you really would want to do device mapper *as* a filesystem and
actually using the fsconfig() model directly and natively, that is at
least conceptually not necessarily wrong. At what point does a
"translate disk blocks and munge contents" turn from "map devices into
other devices" to a "map devices into a filesystem"? We've had loop
devices forever, and they already show how filesystems and block
devices can be a mixed concept.

And no, I'm not seriously suggesting that as a "do this instead".

I'm just saying that from an interface standpoint, we _do_ have an
interface that is kind of doing this, and that is already an area
where a lot of people think there is a lot of commonalities (ie a
number of filesystems end up doing their own device mapping
internally, and people used to say "layering violation - please use dm
for that" before they got used/resigned to it because the filesystem
people really wanted to control the mapping).

In the absence of that kind of unification, just use 'errno'.

               Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


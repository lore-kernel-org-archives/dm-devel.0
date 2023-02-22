Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057E9C636D6
	for <dm-devel@archiver.kernel.org>; Wed, 22 Feb 2023 21:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677101728;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qV7dk47WBMoKKX/CTn5suwtHP8i6ORitq1UmgU63L40=;
	b=E5Zi4XjkDvJ+UPhpSDZP0HW7QWRdX2lh61PhzyYJa9QnU8K+I1ObB6p6Xv3Wy6cdLmE9Jk
	JKhQ1kFmimif2T9fPl34qRrf3MKRhWu5Upr8kwULaN8w5oqeH0iTotjgVvBsuYmnUP8NiF
	q39bEw1CaXPGco7daOYfPd3oMw3vIhY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-KemP2PxqNoSHLEmVaMYz0g-1; Wed, 22 Feb 2023 16:35:27 -0500
X-MC-Unique: KemP2PxqNoSHLEmVaMYz0g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B951F3C10C65;
	Wed, 22 Feb 2023 21:35:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D6E840B4138;
	Wed, 22 Feb 2023 21:35:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 21A9319465A0;
	Wed, 22 Feb 2023 21:35:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6FAB2194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Feb 2023 21:35:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 404232166B2A; Wed, 22 Feb 2023 21:35:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 38C342166B29
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 21:35:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19FD53823A02
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 21:35:21 +0000 (UTC)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com
 [209.85.208.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-531-ly9Vn7lpOGOumYrlCymwVQ-1; Wed, 22 Feb 2023 16:35:19 -0500
X-MC-Unique: ly9Vn7lpOGOumYrlCymwVQ-1
Received: by mail-ed1-f42.google.com with SMTP id cq23so35769894edb.1
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 13:35:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=5qgfR8l8zHD6J2nRh6VzEgVP678bdHEIYPro2wGNo60=;
 b=i0ULXaaakGP2vOLFjNEs6CiFd1N37p3rNF2DwanVpFmTA3g4fpDIfFEaBv/5OfqZGf
 j9tf6CmhHER3T2ZAEVNI1VEjSv58iwAoZCk4mM6t6Lq7uK+vzMPh0t+ctot2AcuWqJoB
 q8reIULRh1pxGgfKMnu5NhXYU7/o8B7+639mnZll/uV8anMuSYVTQ4wzKl55ogter80U
 XEROU4FA3VAWboaNn2UVQ/P7z3oVjTWqH8lq+IIAaax/t7y09jcsfbZQSIVvQELrWY8C
 zwA0J39oPXzIt25YNZoSaO3Xq9IS4rZf4tbf+EG0Trjfqi39xHXJ/+Wkw+JEr4LHG/2S
 p/NQ==
X-Gm-Message-State: AO0yUKXeQkK9V828xU8Lz01FCBBOTcKWUwzIkPQWwVMRqNYliHupJHwU
 zvGG4mKOtdRnT85X4IlKeYKnjIIQ3zyH3lcxC0k=
X-Google-Smtp-Source: AK7set87b6TD6oW2fEyZT34kJvVoQNp6ax/H4gdLMsW6DZgKLUAW3X/kWHO37YT1ijfBt4/P4ZICqw==
X-Received: by 2002:a17:906:3683:b0:7c0:e30a:d3e5 with SMTP id
 a3-20020a170906368300b007c0e30ad3e5mr16740850ejc.18.1677101717529; 
 Wed, 22 Feb 2023 13:35:17 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com.
 [209.85.208.48]) by smtp.gmail.com with ESMTPSA id
 y11-20020a170906914b00b008d427df3245sm4231489ejw.58.2023.02.22.13.35.16
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Feb 2023 13:35:16 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id ck15so37297175edb.0
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 13:35:16 -0800 (PST)
X-Received: by 2002:a17:906:4f0a:b0:878:561c:6665 with SMTP id
 t10-20020a1709064f0a00b00878561c6665mr8126704eju.0.1677101715678; Wed, 22 Feb
 2023 13:35:15 -0800 (PST)
MIME-Version: 1.0
References: <Y/OueIbrfUBZRw5J@redhat.com>
In-Reply-To: <Y/OueIbrfUBZRw5J@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2023 13:34:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgfzPOao+Rbq4aSitQ2gPaZ9PPGbR290X4BikD_W8ZcUg@mail.gmail.com>
Message-ID: <CAHk-=wgfzPOao+Rbq4aSitQ2gPaZ9PPGbR290X4BikD_W8ZcUg@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>, Andy Whitcroft <apw@canonical.com>,
 Joe Perches <joe@perches.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.3
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
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
 Sergey Shtylyov <s.shtylyov@omp.ru>, Pingfan Liu <piliu@redhat.com>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Heinz Mauelshagen <heinzm@redhat.com>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
 Joe Thornber <ejt@redhat.com>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>, dm-devel@redhat.com,
 XU pengfei <xupengfei@nfschina.com>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Hou Tao <houtao1@huawei.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 20, 2023 at 9:31 AM Mike Snitzer <snitzer@kernel.org> wrote:
>
> - Fix all of DM's checkpatch errors and warnings (famous last words).

Actually, I think some of these are potentially actively detrimental.

I do *not* believe that we should run checkpatch on existing code,
since many of those things are heuristics.

For example, the

   Single statement macros should not use a do {} while (0) loop

check is dubious at best, and actively wrong at worst.

It's probably fine for new patches, but to use for existing code? Very
very questionable.

There are very real reason to use "do { xyz } while (0)" even for
single statements. In particular, it changes an expression statement
into a non-expression one, which means that you cannot mis-use it with
comma-expressions and some other situations.

Does that usually matter? No. But I *can* matter, and may well be done
intentionally.

Similarly, when you have multiple macros next to each other, it may
well make sense to just have them all have a common pattern, even if a
couple of them are just single statements.

Now, maybe all of this is ok for the dm code, but I really want to
emphasize that running checkpatch on pre-existing code and making
"trivial changes" based on it, and trying to get the warnings down to
zero is THE WRONG THING TO DO.

Checkpatch should not be seen as a "the warnings should not exist". It
should be seen as at most a _guide_. So never a "remove all warnings"
thing, but a "hey, new patch gets this note, think about it".

Some checkpatch warnings are also more black-and-white than others.
And that "don't use do { } while (0)" is definitely *NOT* some kind of
absolute dictum.

         Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


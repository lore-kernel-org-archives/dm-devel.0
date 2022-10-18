Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434F1C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 21:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666127599;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GH61S8RTG5iqbaP2O/azHFizszy6ursEp+Yz38riyBI=;
	b=ZnNjjzagbna022D6jjCBirzHJhVIvjwWNEJtIUA+pgH2YVdnIKBe9swfvKVLkdGGNzJW1Z
	o/eTed2/R8MsG3Gq+pvQc7pUmg4tLzZwHwlHEH2e/6hFzfpWYNaIAFHxAx/eEOhWd9RRQj
	mffHdTUTfsPwBmKnJL1gAlBmcl0wjT0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-XdxzwYzyNlmDvs-G7cK3qQ-1; Tue, 18 Oct 2022 17:13:17 -0400
X-MC-Unique: XdxzwYzyNlmDvs-G7cK3qQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 296E285A583;
	Tue, 18 Oct 2022 21:13:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 15EA440C2064;
	Tue, 18 Oct 2022 21:13:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C487E1946594;
	Tue, 18 Oct 2022 21:13:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5EAEA194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 21:13:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E84A4081B61; Tue, 18 Oct 2022 21:13:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36EE44081B60
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 21:13:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C08B185A79C
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 21:13:13 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-636-xXVCqVKZOxK8uhntRJ1S6w-1; Tue, 18 Oct 2022 17:13:11 -0400
X-MC-Unique: xXVCqVKZOxK8uhntRJ1S6w-1
Received: by mail-qk1-f199.google.com with SMTP id
 de21-20020a05620a371500b006eed31abb72so1283573qkb.6
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 14:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=i/gc72XiUFWICKTdAlvnq76Fw5Q77LW9+ndBebJynHs=;
 b=sV7X8sjt63+i1hYpWOiq2rrf7ydRHxbEKhb32sIf+2Vpi+8lv7Fe95XJ/WQOQg+3wX
 HdLiANx7Bzf6MSOO/fWU8wMsNewhQSQk4XGwtuh9/8MHF0aznVi20vnP/ku5bnXaevj4
 /7TYnNxUbbY8SkyZYClhMDH+TCnqnMhwZMu4rX7m7cNwiz9apgCi15nSVsyoi/FNrsMr
 pv7MuR5jFS3c6Pi+t/EcGO4wMeEpD3fdqo3sU+BKBdJgU4lJRh4Ju0kKeg8Pxi/JusZO
 yOidA5MnsBWf+b0iHcXEn8ZoEruC+liK0VZ2USoZwYJydFiFfS0whyxUbSZpW5meTwQC
 2lFg==
X-Gm-Message-State: ACrzQf2CcxOBsRlV/JkLrU73AnUFnMM2/G9Mz9E2T/9WoaOueUWNPr92
 VtXEpd2I07gAHwf6cNqT2be3iPJflt2IWH+09CuNmGotyJsDl3NHzUBmu5lh5kgoxCMM+0+m2ZP
 wmeyOaVdHB1FUqg==
X-Received: by 2002:a05:620a:14a3:b0:6ee:c7a4:b4b with SMTP id
 x3-20020a05620a14a300b006eec7a40b4bmr3389196qkj.659.1666127591439; 
 Tue, 18 Oct 2022 14:13:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4tprRqPkzOHwP2yvNh0ctg1/eFfU8Q5Y12c9iV6fTHVoljBTgNHbU/J+eSkAsn2Djn7+d+dA==
X-Received: by 2002:a05:620a:14a3:b0:6ee:c7a4:b4b with SMTP id
 x3-20020a05620a14a300b006eec7a40b4bmr3389177qkj.659.1666127591182; 
 Tue, 18 Oct 2022 14:13:11 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 x5-20020a05620a258500b006bb366779a4sm3085799qko.6.2022.10.18.14.13.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Oct 2022 14:13:10 -0700 (PDT)
Date: Tue, 18 Oct 2022 17:13:09 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y08W5Tj1YC8/BZDM@redhat.com>
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
 <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
 <CAHk-=wiE_p66JtpfsM2GMk0ctuLcP+HBuNOEnpZRY0Ees8oFXw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiE_p66JtpfsM2GMk0ctuLcP+HBuNOEnpZRY0Ees8oFXw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
Cc: linux-block@vger.kernel.org, Shaomin Deng <dengshaomin@cdjrlc.com>,
 Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <snitzer@kernel.org>,
 Nathan Huckleberry <nhuck@google.com>, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Genjian Zhang <zhanggenjian@kylinos.cn>, Jilin Yuan <yuanjilin@cdjrlc.com>,
 Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
 Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 18 2022 at  3:19P -0400,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Oct 18, 2022 at 11:54 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But no, we absolutely do *not* want to emulate that particular horror
> > anywhere else.
> 
> Side note: if DM people go "Hmm, a lot of our management really does
> have the exact same issues as 'mount()' and friends, and doing the
> same things as mount does with the whole string interface and logging
> sounds like a good idea", I want to nip that in the bud.
> 
> It's most definitely *not* a good idea. The mount thing is nasty, it's
> just that we've always had the odd string interface, and it's just
> grown from "const void *data" to be a whole complicated set of context
> handling.
> 
> So don't even think about duplicating that thing.
> 
> Now, if some "inspired" person then thinks that instead of duplicating
> it, you really would want to do device mapper *as* a filesystem and
> actually using the fsconfig() model directly and natively, that is at
> least conceptually not necessarily wrong. At what point does a
> "translate disk blocks and munge contents" turn from "map devices into
> other devices" to a "map devices into a filesystem"? We've had loop
> devices forever, and they already show how filesystems and block
> devices can be a mixed concept.
> 
> And no, I'm not seriously suggesting that as a "do this instead".
> 
> I'm just saying that from an interface standpoint, we _do_ have an
> interface that is kind of doing this, and that is already an area
> where a lot of people think there is a lot of commonalities (ie a
> number of filesystems end up doing their own device mapping
> internally, and people used to say "layering violation - please use dm
> for that" before they got used/resigned to it because the filesystem
> people really wanted to control the mapping).
> 
> In the absence of that kind of unification, just use 'errno'.

Mikulas touches on why why using errno isn't useful for DM. And for
DM's device stacking it is hard to know which error spewed to dmesg
(via DMERR, DMCRIT, DMINFO, etc) is relevant to a particular admin
interface issuing the DM ioctl.

So the idea to send the (hopefully useful) error string back up to the
relevant userspace consumer was one task that seemed needed (based on
Milan Broz's various complaints against DM.. which sprang from your
regular remainder that DM's version numbers are broken and need to be
removed/replaced).

Making DM errors more useful to the endpoints causing them was dealt
with head-on with a couple small changes in this pull request. I
didn't think sending useful error strings to userspace was such a
contested design point.

All said, we'll have a look at dealing with your suggested fsconfig
unification (but it seems really awkward on the surface, maybe we can
at least distill out some subset that is common).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


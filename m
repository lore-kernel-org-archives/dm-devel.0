Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F82FC19F2D
	for <dm-devel@archiver.kernel.org>; Sat,  6 Aug 2022 18:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659810664;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zI1UfdRBhaFDDO1SmNkKQ2rrwjLV6FpXQXbZyOt7TWA=;
	b=ajMtnBhaYPfnXBiarVeS8xXCHxMiYOL591fHcR+u43kBALs3FJvjhlgbfZ9kqrv8Ye07uX
	SwWV5HdTvTK+XZkfYOEDKq0snjRAKJ386soB8mJgkRQuuRO5vIaf78nQSaom3nwSYfmvrt
	RtMMcgwIkuDAVLBnHfCerZEe4sfYA2U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-_rPoTG8hOE-MkD-HGfzzeg-1; Sat, 06 Aug 2022 14:31:00 -0400
X-MC-Unique: _rPoTG8hOE-MkD-HGfzzeg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C20BE2813D24;
	Sat,  6 Aug 2022 18:30:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1119400E88D;
	Sat,  6 Aug 2022 18:30:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 60A4B1946A54;
	Sat,  6 Aug 2022 18:30:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 679251946A4F
 for <dm-devel@listman.corp.redhat.com>; Sat,  6 Aug 2022 18:30:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48B9D2166B2A; Sat,  6 Aug 2022 18:30:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44CC82166B26
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:30:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29BB7811E75
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:30:57 +0000 (UTC)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com
 [209.85.160.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-4ZOiAYenMcyCrAvRG2pqpA-1; Sat, 06 Aug 2022 14:30:55 -0400
X-MC-Unique: 4ZOiAYenMcyCrAvRG2pqpA-1
Received: by mail-qt1-f170.google.com with SMTP id l5so4098614qtv.4
 for <dm-devel@redhat.com>; Sat, 06 Aug 2022 11:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=pxCEjkAH/HtacRN5ao0Jtr5KjS1Q4esBp2dJmtS6eP8=;
 b=wWooaC5ZEDfdD99UcR3cDn1KhzllAaqBLlDgLtRo4HZvm7tRSsCBOrDNlVeVUp48WR
 WTLD4UtStQ9/Q6U/IzMQY+wkgi0+6r31zDm0dWzx2mb7USlVWRR4pNx8VC7NSa0UghaN
 E/uvFElNIJCTvfbVAVr7MS9GK2vjZ1A7XWAHkcEgAjgWZ8sYYJiGCeZIXqCG/HcEUBLE
 5sEbxthuVt06PMIjYw+QdFdVLzqyFBSSFu5ZPRHMUlAgUHSkacZJwceZdXbutNCr2yr0
 IQ+yTb7M2FNfMvYQNkPZx1ddztcggb0rlT0Tm7LW4zHaOQbn3Y3AdV4Sz85UKficAYoh
 8soQ==
X-Gm-Message-State: ACgBeo3ZXKtnwaeKGGF4FhCWIDQ9fLobFLM/wVFA/S7kquHSDv+3JJk1
 PbQeVXSpd6hm5tEUPUUNe2iTtPc=
X-Google-Smtp-Source: AA6agR66ihkCqXOqjW9lbXOY78rAT6SFbRYf/9ykxcxvIFPf9ZA8xJwQD2o96NeUzK/ApPFqy2zDuw==
X-Received: by 2002:a05:622a:81:b0:33f:f102:2845 with SMTP id
 o1-20020a05622a008100b0033ff1022845mr10327415qtw.30.1659810655165; 
 Sat, 06 Aug 2022 11:30:55 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 dm16-20020a05620a1d5000b006b8cb64110bsm6053398qkb.45.2022.08.06.11.30.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 06 Aug 2022 11:30:54 -0700 (PDT)
Date: Sat, 6 Aug 2022 14:30:53 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Yu6zXVPLmwjqGg4V@redhat.com>
References: <YugiaQ1TO+vT1FQ5@redhat.com> <Yu1rOopN++GWylUi@redhat.com>
 <CAHk-=wj5w+Nga81wGmO6aYtcLrn6c_R_-gQrtnKwjzOZczko=A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj5w+Nga81wGmO6aYtcLrn6c_R_-gQrtnKwjzOZczko=A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Aug 06 2022 at  2:09P -0400,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Aug 5, 2022 at 12:10 PM Mike Snitzer <snitzer@kernel.org> wrote:
> >
> > All said: I think it worthwhile to merge these changes for 6.0, rather
> > than hold until 6.1, now that we have confidence this _optional_ DM
> > verity feature is working as expected. Please be aware there was a
> > small linux-next merge fixup needed:
> > https://lore.kernel.org/all/20220805125744.475531-1-broonie@kernel.org/T/
> 
> Well, more importantly, the verity_target version numbers clash.
> 
> I used the newer "{1, 9, 0}" version number, but if you want it to be
> "{1, 9, 1}" to show that it's a superset of the previous one, you
> should do that yourself.

You did the right thing.
 
> That said, the best option would be to remove version numbers
> entirely. They are a completely broken concept as an ABI, and *never*
> work.
> 
> Feature bitmasks work. Version numbers don't. Version numbers
> fundamentally break when something is backported or any other
> non-linearity happens.
> 
> Please don't use version numbers for ABI issues. Version numbers are
> for human consumption, nothing more, and shouldn't be used for
> anything that has semantics.

Yes, I know you mentioned this before and I said I'd look to switch to
feature bitmasks. Yet here we are. Sorry about that, but I will take
a serious look at fixing this over the next development cycle(s).

There is just quite a bit of innertia in these version numbers across
all the disparate userspace tools that use DM. So the transition needs
some design, planning and coordination but I'll get it done. Really ;)

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


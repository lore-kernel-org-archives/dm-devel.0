Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AF3C19F2D
	for <dm-devel@archiver.kernel.org>; Sat,  6 Aug 2022 18:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659811037;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eqVFRG5s3l+Y0YWq/jeCyhhm5SViDPylCEj21ZkIbcI=;
	b=I6L6+EzSCVnpxZzXqh/wblECM6/Wd1i0y+cFugvfgs+3vr/rAa7GIRKCfnvzNGb/C/j32i
	0YavGoDju+0MbhdPBuN3Crs2tt9zR2S6ef8ORC9jMvkZP/3dQ0AxuUS7g7xP1XSUW7YNAu
	G2L/SvJz+fscTLsjvC2o/AyFhoH0Nhk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-65PU_DdqMhCLqT0iGqPeFw-1; Sat, 06 Aug 2022 14:37:14 -0400
X-MC-Unique: 65PU_DdqMhCLqT0iGqPeFw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DB0D101A58D;
	Sat,  6 Aug 2022 18:37:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3780492C3B;
	Sat,  6 Aug 2022 18:37:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E7C51946A58;
	Sat,  6 Aug 2022 18:37:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7A7401946A48
 for <dm-devel@listman.corp.redhat.com>; Sat,  6 Aug 2022 18:37:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C56C400E88D; Sat,  6 Aug 2022 18:37:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 58A2640466A7
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:37:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F1F985A581
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:37:10 +0000 (UTC)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com
 [209.85.208.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-vwrvu59EOS-qMSNJvJBd7A-1; Sat, 06 Aug 2022 14:37:06 -0400
X-MC-Unique: vwrvu59EOS-qMSNJvJBd7A-1
Received: by mail-ed1-f44.google.com with SMTP id b16so6963934edd.4
 for <dm-devel@redhat.com>; Sat, 06 Aug 2022 11:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=YOuCAuJv9B33lhDQ/WIlTMu/AvAFlKqYIlDyi4jBEH0=;
 b=4mitOWLJ1x0xjuDkcp5eRP1bfueOYCn5c6jBmJL6YM8kiB0hUSAugy8CfPKmylgZoh
 7VbaZXIAQItlrrNKaZW4nlA0e5tU9brfOMMrSMysAmol5P/Sy2t93TlnDx5PLZ7rjjdw
 7gOziWo4z6o67Ro0Ij7Hvgdc5i/1/MVnZh0pOWL8m5pFgLWWNlLpXyTbYiiNt/QuQO+7
 54ThAC+NZAuDFgYS5PA7pMQmG4mSivAF7OokIf70+cSxP5maJOQOcwaBSwOxS0FTP7Gz
 HJkTPZVp8yq9KQBVdGvvskrZii2kVA+78cHm7hMO/1XvfOWHVVoCWibruZVzq+X8Qf3C
 jMqQ==
X-Gm-Message-State: ACgBeo0+AYpJPKLEs6oNIzOTAMwjPPEOFbKESTVKlfYl+DJCJb+uqT6y
 7Ap0H251DA5WOl4TKHI3k189uf+neQ5V5lVJ
X-Google-Smtp-Source: AA6agR5DT9zPulutDKsoDrBAczNyjOpYqn+DTwNtLlgID/KslpHs3fufFJXH0pQ6dQvpBO5wc2VYNA==
X-Received: by 2002:a05:6402:5110:b0:440:4cb1:c137 with SMTP id
 m16-20020a056402511000b004404cb1c137mr4906956edd.262.1659811024473; 
 Sat, 06 Aug 2022 11:37:04 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com.
 [209.85.221.52]) by smtp.gmail.com with ESMTPSA id
 u1-20020a1709061da100b0072f5fa11d19sm2861359ejh.202.2022.08.06.11.37.03
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 06 Aug 2022 11:37:04 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id l4so6506793wrm.13
 for <dm-devel@redhat.com>; Sat, 06 Aug 2022 11:37:03 -0700 (PDT)
X-Received: by 2002:a05:6000:178d:b0:222:c7ad:2d9a with SMTP id
 e13-20020a056000178d00b00222c7ad2d9amr146107wrg.274.1659811023524; Sat, 06
 Aug 2022 11:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <YugiaQ1TO+vT1FQ5@redhat.com> <Yu1rOopN++GWylUi@redhat.com>
 <CAHk-=wj5w+Nga81wGmO6aYtcLrn6c_R_-gQrtnKwjzOZczko=A@mail.gmail.com>
 <Yu6zXVPLmwjqGg4V@redhat.com>
In-Reply-To: <Yu6zXVPLmwjqGg4V@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 6 Aug 2022 11:36:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj+ywtyBEp7pmEKxgwRE+iJBct6iih=ssGk2EWqaYL_yg@mail.gmail.com>
Message-ID: <CAHk-=wj+ywtyBEp7pmEKxgwRE+iJBct6iih=ssGk2EWqaYL_yg@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Aug 6, 2022 at 11:30 AM Mike Snitzer <snitzer@kernel.org> wrote:
>
> >
> > Please don't use version numbers for ABI issues. Version numbers are
> > for human consumption, nothing more, and shouldn't be used for
> > anything that has semantics.
>
> Yes, I know you mentioned this before and I said I'd look to switch to
> feature bitmasks. Yet here we are. Sorry about that, but I will take
> a serious look at fixing this over the next development cycle(s).

Well, right now we're in the situation where there are certain kernels
that say that they implement "version 1.9" of the thing, but they
don't actually implement the "version 1.8.1" extensions.

So anybody who asks for "v1.8.1 or newer" will literally get random behavior.

And yes, that random behavior hopefully then doesn't happen with any
*tagged* kernel version, but it's an example of how broken version
numbers are as an ABI. Imagine you are bisecting something entirely
unrelated, and then end up testing one of those "this says it does
1.9, but doesn't do 1.8.1" kernels..

Presumably (and hopefully) these features are all so esoteric that
absolutely nobody cares.

IOW, I sincerely _hope_ the solution to the version number mess is
"nobody actually uses that field anyway".

Because if it matters, it's broken. It's broken by design, but we
literally seem to have one example of active breakage in the tree
right now.

               Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


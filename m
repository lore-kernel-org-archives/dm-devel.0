Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 876FBC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 07:12:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-VtGR1IEHPm28qAmjyGWn2A-1; Tue, 03 May 2022 03:12:02 -0400
X-MC-Unique: VtGR1IEHPm28qAmjyGWn2A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEE0F86B8AB;
	Tue,  3 May 2022 07:11:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 01FB4416385;
	Tue,  3 May 2022 07:11:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AE19F1947042;
	Tue,  3 May 2022 07:11:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1DF3A1947042
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 May 2022 22:45:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0884E40D282C; Mon,  2 May 2022 22:45:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 03BF340D2820
 for <dm-devel@redhat.com>; Mon,  2 May 2022 22:45:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54E05800186
 for <dm-devel@redhat.com>; Mon,  2 May 2022 22:45:03 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-npJgTVM7NUWy36xcDyEggQ-1; Mon, 02 May 2022 18:44:59 -0400
X-MC-Unique: npJgTVM7NUWy36xcDyEggQ-1
Received: by mail-pj1-f54.google.com with SMTP id
 cq17-20020a17090af99100b001dc0386cd8fso571885pjb.5
 for <dm-devel@redhat.com>; Mon, 02 May 2022 15:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9Pev6TadqoPCvCslhpANrkqa0tRzANTdzEtaxAf0Hbw=;
 b=pAvz8bfFfFVdHeduvrtOCAU/RIsHcRorfpAQLlvqINOoJ1bQiR5MbaICQMU3XUpH8d
 ZLlADs5BeRtH/grPsNi8GnuKGdEyI+WH6ZStGGYxlfkAKHm++rRPUrW4WAH+gll+kJjR
 TepC39SEIdexrEXZN1IgDbycZS1YhB3MyIMozrNuzrt3KK/Y/IgtSRzrO33DNr0OBVZs
 5PSNfa9Yu2UrakofPYYauoGSog+XUA9ZFyXn3ZLQXm7+Eux7SctheIbFsGuYcNUsmyIy
 gg24tVxr+t4eDss6hWBibJj9JkH+apr/LX75dBI3VxD/IDOP8OSPCdylA2MnG82fORoc
 6ZZQ==
X-Gm-Message-State: AOAM531p1bBID+ZLxgGJiPvkkywwAOjK9yXz7s2lf7nGbqGTTAHiviCz
 9b2cAysaT6AvyJ8dEN8ZbUEjhg==
X-Google-Smtp-Source: ABdhPJxhVHtiibpNcHj8mIUaI5q3jvfhB3UxBy63zLm72g4zQPjmd26WW0fmoc9EkpEka6ka3qUucw==
X-Received: by 2002:a17:902:d4c2:b0:15e:abd0:926f with SMTP id
 o2-20020a170902d4c200b0015eabd0926fmr4925055plg.129.1651531497972; 
 Mon, 02 May 2022 15:44:57 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:1e1a:955c:a9ca:e550])
 by smtp.gmail.com with UTF8SMTPSA id
 f3-20020a17090a654300b001d26c7d5aacsm218470pjs.13.2022.05.02.15.44.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 02 May 2022 15:44:57 -0700 (PDT)
Date: Mon, 2 May 2022 15:44:56 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <YnBe6K72iKSDSqk9@google.com>
References: <20220426213110.3572568-1-mka@chromium.org>
 <20220426143059.v2.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
 <202204302316.AF04961@keescook>
MIME-Version: 1.0
In-Reply-To: <202204302316.AF04961@keescook>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Tue, 03 May 2022 07:11:56 +0000
Subject: Re: [dm-devel] [PATCH v2 2/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: Douglas Anderson <dianders@chromium.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 James Morris <jmorris@namei.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Apr 30, 2022 at 11:21:54PM -0700, Kees Cook wrote:
> On Tue, Apr 26, 2022 at 02:31:09PM -0700, Matthias Kaehlcke wrote:
> > I'm still doubting what would be the best way to configure
> > the list of trusted digests. The approach in v2 of writing
> > a path through sysctl is flexible, but it also feels a bit
> > odd. I did some experiments with passing a file descriptor
> > through sysctl, but it's also odd and has its own issues.
> > Passing the list through a kernel parameter seems hacky.
> > A Kconfig string would work, but can be have issues when
> > the same config is used for different platforms, where
> > some may have trusted digests and others not.
> 
> I prefer the idea of passing an fd, since that can just use LoadPin
> itself to verify the origin of the fd.
> 
> I also agree, though, that it's weird as a sysctl. Possible thoughts:
> 
> - make it a new ioctl on /dev/mapper/control (seems reasonable given
>   that it's specifically about dm devices).
> - have LoadPin grow a securityfs node, maybe something like
>   /sys/kernel/security/loadpin/dm-verify and do the ioctl there (seems
>   reasonable given that it's specifically about LoadPin, but is perhaps
>   more overhead to built the securityfs).

Thanks for your feedback!

Agreed that an ioctl is preferable over a sysctl interface. I wasn't aware
of securityfs and prefer it over a /dev/mapper/control ioctl. Ultimately
the list of digests is meaningful to LoadPin, not (directly) to the device
mapper / verity. I'm not sure how well this feature of integrating LoadPin
with verity will be by the verity maintainers in the first place, it's
probably best to limit the LoadPin specific stuff in verity to a minimum.
I experimented a bit with the securityfs option, building it doesn't seem
too much of an overhead. If loadpin.c ends up too cluttered with the
verity and securityfs stuff I could try to outsource some of it to (a)
dedicated file(s).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


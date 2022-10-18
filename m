Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FA2C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 22:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666131451;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6rWMNkuFzWu70lrYV0YbkX77+5XORgzx+zVLLCRxi34=;
	b=LF289FvAu6T5zkBrLzPFNoKdxG6loT6NUkAsnJDLHkXva0HgxdqtakhQJjvY8oEcT+b1B9
	3jgMBcroW19F1XqUlBbmyEuaqT6CjqYu44aijyPsZAoSvIiUVKsTeGNkuAlizeayT1H5ox
	dn10X16OnlewuG7NhrRJSJcDFJOdY7E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-s1llpGgqO6GdUfocgYFNgA-1; Tue, 18 Oct 2022 18:17:29 -0400
X-MC-Unique: s1llpGgqO6GdUfocgYFNgA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 711EE800186;
	Tue, 18 Oct 2022 22:17:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 18E3E9D48D;
	Tue, 18 Oct 2022 22:17:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E358F1946594;
	Tue, 18 Oct 2022 22:17:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4770B194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 22:17:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 35640200A7DC; Tue, 18 Oct 2022 22:17:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D39D2027064
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 22:17:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E729811E67
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 22:17:25 +0000 (UTC)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-282-_3vvMd6pPNWk0zEEdsD_SQ-1; Tue, 18 Oct 2022 18:17:23 -0400
X-MC-Unique: _3vvMd6pPNWk0zEEdsD_SQ-1
Received: by mail-qv1-f46.google.com with SMTP id y10so10229138qvo.11
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 15:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=0OiL3fDoOAQJeFptIwHV4F791d26lnzffLbOKVpkXRA=;
 b=uTon5ONwUuJDp7cKi3UDT0tU91Y84lMT29QHvDyglP/1vYVA1LGwvTqbBD+nTw1H5y
 bkvBpUnuNfFaJ2h0tWDu3px73akEd9BseeiWmxQWvKzVGMzLw+5Ul+Ni+tv8heD/jLYe
 gFAumEp838aCfQuBicjkYM0/gQszc158cBo4SLN64xSQsH3aWagwb3GQ2HR66eax5+dZ
 GOzAAQtE9JrVY8aa2x+VR5pAxWjpBJkX+iBZl1lrMgb7bNM0b5Z7PJidzcvBOMRNZwV7
 ROO2y4G7kQMwZ1NYV1R4m+x4lOdUhY4efnHS7V1n2EVPpUNfn+SSaWUXDX8/UgVqVz15
 sNBg==
X-Gm-Message-State: ACrzQf0l1E1Jxx5S6r820xnCtbfB6jbtzgzEnBSSjjI4JBXoqzfVpz1u
 v+exHRRcWNQnZSC5xXWQfV3vAAa0LrROxg==
X-Google-Smtp-Source: AMsMyM5ortQqP42a95n4eB3EtuDkcHUjInmjb3HSH14A47eagbplb4fQS2s5cNtAS510npkAO8KjRw==
X-Received: by 2002:a0c:ac02:0:b0:4af:a3b1:3167 with SMTP id
 l2-20020a0cac02000000b004afa3b13167mr4199235qvb.66.1666131442733; 
 Tue, 18 Oct 2022 15:17:22 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com.
 [209.85.128.169]) by smtp.gmail.com with ESMTPSA id
 bm34-20020a05620a19a200b006ce1bfbd603sm3180409qkb.124.2022.10.18.15.17.18
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Oct 2022 15:17:19 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id
 00721157ae682-354c7abf786so151365497b3.0
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 15:17:18 -0700 (PDT)
X-Received: by 2002:a81:5843:0:b0:361:2d0:7d9 with SMTP id
 m64-20020a815843000000b0036102d007d9mr4529569ywb.58.1666131438524; 
 Tue, 18 Oct 2022 15:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
 <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
 <alpine.LRH.2.02.2210181515170.23349@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2210181515170.23349@file01.intranet.prod.int.rdu2.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Oct 2022 15:17:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjTgPg3H=2BPtTdHdM5=4wvEA3YCaDEm4P6TQnjvw-CEA@mail.gmail.com>
Message-ID: <CAHk-=wjTgPg3H=2BPtTdHdM5=4wvEA3YCaDEm4P6TQnjvw-CEA@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
Cc: linux-block@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>,
 Nikos Tsironis <ntsironis@arrikto.com>, Shaomin Deng <dengshaomin@cdjrlc.com>,
 Mike Snitzer <snitzer@kernel.org>, Nathan Huckleberry <nhuck@google.com>,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Genjian Zhang <zhanggenjian@kylinos.cn>, Milan Broz <gmazyland@gmail.com>,
 Alasdair G Kergon <agk@redhat.com>, Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 18, 2022 at 1:29 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> The error string is not intended to be parsed by userspace (I agree that
> parsing the error string is a horrible idea, but this is not going to
> happen).

I am happy we agree on that fundamental issue.

But it's also why error strings are a HORRIBLE HORRIBLE idea.

They are literally worse than just plain 'errno', exactly because user
space MUST NOT parse them.

They are worse because:

 - user space will parse them anyway, for localization reasons, so the
whole design is garbage

 - user space that correctly doesn't parse them cannot use them for
any helpful thing apart from just displaying them, which makes them
actively worse than having a number that you *can* make actual
decision on.

In other words, user space either can violate the fundamental rule of
"don't parse it", or they are actively weaker than then errno numbers
we already have.

Either way, they are worse. See?

>  It is intended to be displayed to the user by tools such as
> cryptsetup or integritysetup. The tool can't read the log, extract
> messages from it and display them.

Bullshit.

The tools could just use the error number and together with the
operation that failed, make a very good assumption on what went wrong.

And even when that assumption isn't some 100% "this is the reason",
the tool can easily print out helpful hints, like "This is often
because of Xyz".

And guess what? With an errno, the tool can do this MUCH BETTER.

It can localize the error messages.

It can do different things for different error messages.

And it will work with old kernels too.

> With "just use errno", the user sees messages like "device-mapper: reload
> ioctl on test (254:0) failed: No such file or directory" and it's not much
> useful because it doesn't tell what went wrong.

Again, I call bullshit.

You are saying "the tools isn't helpful, so let's change the kernel interface".

And that's just plain stupid.

if the tool isn't helpful, then FIX THE TOOL.

It's that simple.

The fact is, dm isn't special. We use 'errno' absolutely everywhere
else. What makes dm so special that the dm tools can't deal well with
them?

Look at the profile tools (just to give an example of a tool that is
in the kernel tree, so i can grep for it). Sometimes it does just

                if (aio_errno != EINTR)
                        pr_err("failed to write perf data, error: %m\n");

and prints that error string. But sometimes it does things like

                if (errno == EPERM) {
                        pr_err("Permission error mapping pages.\n"
                               "Consider increasing "
                               "/proc/sys/kernel/perf_event_mlock_kb,\n"
                               "or try again with a smaller value of
-m/--mmap_pages.\n"
                               "(current value: %u,%u)\n",
                               opts->mmap_pages, opts->auxtrace_mmap_pages);

because the tool isn't garbage.

You are basically saying that the kernel should generate those strings.

And I'm saying you are completely wrong, and that no, I will not pull
this kind of silly interface, because it's an actively horribly broken
garbage interface.

Furthermore, I'm telling you that you need to really *understand* that
no, device-mapper isn't some super-special thing that magically should
do string errors.

This is not something worth discussing. This is something where you
need to just realize that you are wrong.

End of story.

                  Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


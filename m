Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B476C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666124948;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bAWwbMoA1Qh4X+QmOyprjGMx3AbjNUdBG1cJ0PGjdiw=;
	b=KIRrW8HLAwOIwXb3GO76rPc4WzK/N53+Ic/SYT6MYPaJhthzO4oF/oUQ/ULKVG2IXl2mYT
	wlNtTJTihMsfesRG4zwWyvvru5Jc+6OoC1sZdamYlphjAOZPmsf6Oc+aS63UIFttPXCmXw
	8N0gJJpA0lzs6ESWkL/jzkFFIZWTg1I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-6o_d9twTPdazfS6GlpOaig-1; Tue, 18 Oct 2022 16:29:04 -0400
X-MC-Unique: 6o_d9twTPdazfS6GlpOaig-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF1393815D29;
	Tue, 18 Oct 2022 20:29:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 409FD492B05;
	Tue, 18 Oct 2022 20:29:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F0C9D1946594;
	Tue, 18 Oct 2022 20:29:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 667AC194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 20:28:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21A1BC15BB9; Tue, 18 Oct 2022 20:28:59 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B5DFC15BAB;
 Tue, 18 Oct 2022 20:28:57 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 29IKSvAi010168; Tue, 18 Oct 2022 16:28:57 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 29IKSjqV010163; Tue, 18 Oct 2022 16:28:49 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 18 Oct 2022 16:28:43 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2210181515170.23349@file01.intranet.prod.int.rdu2.redhat.com>
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
 <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 18 Oct 2022, Linus Torvalds wrote:

> On Tue, Oct 18, 2022 at 11:17 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Tue, Oct 18, 2022 at 12:20:50PM -0400, Mike Snitzer wrote:
> > >
> > > - Enhance DM ioctl interface to allow returning an error string to
> > >   userspace. Depends on exporting is_vmalloc_or_module_addr() to allow
> > >   DM core to conditionally free memory allocated with kasprintf().
> >
> > That really does not sound like a good idea at all.  And it does not
> > seem to have any MM or core maintainer signoffs.
> 
> I wouldn't worry about maintainer sign-offs just for exporting a
> helper function, but I agree with the whole concept being a complete
> disaster and not a good idea at all.
> 
> Use errno.
> 
> It really is that simple. Strings have been discussed before, and they
> are simply not a good idea. If your interface is so complicated that
> you think errors need some textual explanation, your interface is
> probably garbage.
> 
> Strings also have allocation issues (as you found out), and have
> serious localization issues.
> 
> Yes, we do a lot of strings in the kernel in the form of dmesg, and we
> have the rule that we simply don't localize. But that's dmesg. It's
> for special stuff, not some interface.
> 
> And equally importantly, some really small detail in the kernel really
> has *NO* business making up new error models of its own. You may think
> that the DM ioctl's are a big and important deal, but realistically,
> it's just an odd corner of the world that very very few people care
> about, and they can use the same error numbers that EVERYBODY ELSE HAS
> BEEN USING FOR SIX DECADES!
> 
> Don't reinvent something that works - badly.
> 
> I think we have one major interface that is string-based (apart from
> the obvious pathname ones and the strings passed to 'execve()').
> 
> It's 'mount()' (and now fsconfig() etc), and it's string-based mainly
> because it has that nasty "arbitrary things that different filesystem
> may need for configuration"). And it has some nasty logging model
> associated with it too for output.
> 
> But no, we absolutely do *not* want to emulate that particular horror
> anywhere else.
> 
> If you think some errors are really important and hard to understand,
> maybe you can just log them with a ratelimited pr_info() or something.

This is what we currently do.

>            Linus

The error string is not intended to be parsed by userspace (I agree that 
parsing the error string is a horrible idea, but this is not going to 
happen). It is intended to be displayed to the user by tools such as 
cryptsetup or integritysetup. The tool can't read the log, extract 
messages from it and display them.

With "just use errno", the user sees messages like "device-mapper: reload 
ioctl on test (254:0) failed: No such file or directory" and it's not much 
useful because it doesn't tell what went wrong.

Try to type "grep -r 'ti->error = ' drivers/md/|wc -l". There are 480 
distinct error messages generated by device mapper. You can't map each of 
them to a unique errno number.


BTW. we were talking about replacing device mapper version numbers with 
feature bitmaps and people preferred textual lists of features instead of 
bitmaps (because the bitmap will overflow when you have more than 64 
features). Do you oppose to this too? Do you prefer a 64-bit feature 
bitmap or a string with comma-separated list of features?

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


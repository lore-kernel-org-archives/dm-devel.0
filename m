Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EED1C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666119318;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=45crTseKDWzeRZGCYsLzZYeY0hk6jceMpnEKE6tsK2Q=;
	b=M4c/m6/YQUMP3UNzSKNz36s1M9KomEDnhpv/ehcAyTA/QkqDJrytZjFkG9VDs6DQcZacMU
	/rgrbPkuIRdUzauxpjAOZciIU5m96J0J1HyOSGK/J4smUkyBVdjf3RJgpCYhmM2YuSY8VM
	4Aitc8/JRmYY0N9oW4RLfQM3bgYCKuw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-7MHKYYL5MQC5jaws-YA0Eg-1; Tue, 18 Oct 2022 14:55:15 -0400
X-MC-Unique: 7MHKYYL5MQC5jaws-YA0Eg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 410E385A5A6;
	Tue, 18 Oct 2022 18:55:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF32A492B05;
	Tue, 18 Oct 2022 18:55:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AFFBC1946594;
	Tue, 18 Oct 2022 18:55:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1024194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 18:55:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C606C1121320; Tue, 18 Oct 2022 18:55:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF78C1121315
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 18:55:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A25F885A5B6
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 18:55:11 +0000 (UTC)
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com
 [209.85.219.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-577-dFpxIkyvOi-bP0pWkLuOYQ-2; Tue, 18 Oct 2022 14:55:10 -0400
X-MC-Unique: dFpxIkyvOi-bP0pWkLuOYQ-2
Received: by mail-qv1-f43.google.com with SMTP id i12so9925568qvs.2
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 11:55:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=SJv2e3NDb4hb7fpvgryRdyTK/aBL4JeyRFOO7JpAa3g=;
 b=6PuOrXQdFDUUAyvyQubJXloG/tkJAUyJqumba6ql0a/hdYoPoiNr8pwsNuJ1jp95Ng
 AJqdXvg/hOcbuSgriXkUsSJrebSedEJNrUjAb6xhKcYbP78sY0XAJ8D08SNgiTDWVLGx
 yN5DCLWwnW7Xsam8imfvioAgMtvlljgwODszQu9f70c6AzmQGtbaU5GYtSORI6InwlKc
 9nvpQBey+ElMIJ61kKAUJ6teUf7j2TYtKUA8onHg5tyqaVXZZv2QUK6I/7ahmJntOETu
 j/J2AvFz3NNl5ZaGo2fiHuo6NgxAJxC+zDP0CgUtHOKCZNASXYhDsoelyCAkK8vjb0FG
 rt2A==
X-Gm-Message-State: ACrzQf1qUaVMYVS+U6CNxoToW3GLiK4cRn7S5QagIc46a96YGV2ApChC
 T2COQnNACKPieQp7nBciHux8s1DJL2DkPA==
X-Google-Smtp-Source: AMsMyM5a0n0J6K+2cUn7xWRQcBe1LAsyAgZbe5jnBRlQMLLd9ybjLJrIZ7gdWjhgptPDws/a82ozyg==
X-Received: by 2002:ad4:5be6:0:b0:4b3:ff39:7ad4 with SMTP id
 k6-20020ad45be6000000b004b3ff397ad4mr3372644qvc.126.1666119309390; 
 Tue, 18 Oct 2022 11:55:09 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com.
 [209.85.219.175]) by smtp.gmail.com with ESMTPSA id
 x27-20020a05620a0b5b00b006ecdfcf9d81sm2841030qkg.84.2022.10.18.11.55.06
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Oct 2022 11:55:06 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id r3so18076504yba.5
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 11:55:06 -0700 (PDT)
X-Received: by 2002:a05:6902:124f:b0:66e:e3da:487e with SMTP id
 t15-20020a056902124f00b0066ee3da487emr3964959ybu.310.1666119305668; Tue, 18
 Oct 2022 11:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
In-Reply-To: <Y07twbDIVgEnPsFn@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Oct 2022 11:54:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
Message-ID: <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 18, 2022 at 11:17 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Oct 18, 2022 at 12:20:50PM -0400, Mike Snitzer wrote:
> >
> > - Enhance DM ioctl interface to allow returning an error string to
> >   userspace. Depends on exporting is_vmalloc_or_module_addr() to allow
> >   DM core to conditionally free memory allocated with kasprintf().
>
> That really does not sound like a good idea at all.  And it does not
> seem to have any MM or core maintainer signoffs.

I wouldn't worry about maintainer sign-offs just for exporting a
helper function, but I agree with the whole concept being a complete
disaster and not a good idea at all.

Use errno.

It really is that simple. Strings have been discussed before, and they
are simply not a good idea. If your interface is so complicated that
you think errors need some textual explanation, your interface is
probably garbage.

Strings also have allocation issues (as you found out), and have
serious localization issues.

Yes, we do a lot of strings in the kernel in the form of dmesg, and we
have the rule that we simply don't localize. But that's dmesg. It's
for special stuff, not some interface.

And equally importantly, some really small detail in the kernel really
has *NO* business making up new error models of its own. You may think
that the DM ioctl's are a big and important deal, but realistically,
it's just an odd corner of the world that very very few people care
about, and they can use the same error numbers that EVERYBODY ELSE HAS
BEEN USING FOR SIX DECADES!

Don't reinvent something that works - badly.

I think we have one major interface that is string-based (apart from
the obvious pathname ones and the strings passed to 'execve()').

It's 'mount()' (and now fsconfig() etc), and it's string-based mainly
because it has that nasty "arbitrary things that different filesystem
may need for configuration"). And it has some nasty logging model
associated with it too for output.

But no, we absolutely do *not* want to emulate that particular horror
anywhere else.

If you think some errors are really important and hard to understand,
maybe you can just log them with a ratelimited pr_info() or something.

           Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


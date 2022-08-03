Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BBC2C19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 16:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659543432;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=au4lwD6XVxMqyH6OpGLE0ze/FcBwAdKvvqQfJPxve9s=;
	b=G2fKmF/SH+YLgD2PO9dXXeMN5dxVHGyvsyV+WkS2cH7NLMtUriacaLCnt/txrHxzv9OLg8
	Jn6GX7cTe20MuFrZmbKJkm8iKWCSQxsG2Gx5eOYJj5SmLFunBCZ210NQzIZIWtkKdIiQKo
	pfZKxkNOISEviTHtYU+b2j1ZyIv1+6E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-k7DQDsP2Ojy8IwPXX1TsgA-1; Wed, 03 Aug 2022 12:17:10 -0400
X-MC-Unique: k7DQDsP2Ojy8IwPXX1TsgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A48A785A58B;
	Wed,  3 Aug 2022 16:17:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6C505141510F;
	Wed,  3 Aug 2022 16:17:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 30C311946A5C;
	Wed,  3 Aug 2022 16:17:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A3771946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 16:17:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C4D6C27D95; Wed,  3 Aug 2022 16:17:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 58DA7C1D3AD
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 16:17:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36F283810796
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 16:17:06 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-mPVMnMioOyakYngn-eW2Ig-1; Wed, 03 Aug 2022 12:17:05 -0400
X-MC-Unique: mPVMnMioOyakYngn-eW2Ig-1
Received: by mail-qk1-f199.google.com with SMTP id
 bm34-20020a05620a19a200b006b5f1d95ceeso13747889qkb.5
 for <dm-devel@redhat.com>; Wed, 03 Aug 2022 09:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=KvlEsIXYdL7pYQSca7e8QiPUNObB1JXPZUJDJkqfFfo=;
 b=CIScYjxUR08rlFhiPZyY+8tKLAUgIuiaGmgjPW9+g6z/IN+Joarfz6BWbufSk/wT6N
 1k9INc2aqbUr4HSLOCd9hl25quJjw/8oBDQ475IVtmAQyDP2nKtIFIYojOjMxhsAtiIQ
 Rs/qQhfMeDrnSGUEChdGmkTLNSMpyXE/9DQPwTuGnqh6MrbH4DM+2+0D5tTH+6Mayxpj
 yAvkm/mcW4kbpO9B3LCA3GB1TbDN163QQy+z0KhUbY395k+O7a6qRREXQpjpR6OYk1rY
 cg3ZSZfV6PwZ63YmTgXmIp2Ecu0P6PkfLScCh0yViR41BEmiSRX5+RxvSz74x0JzDKJp
 M8BQ==
X-Gm-Message-State: AJIora9WnqcSkXTuPj5x9ILvIkFggrqzHUmwfS9xC6/v/+toLizP76bP
 WstAiwWM0xfAo8nVXDgRWCLNXyfsMCFtlvJ1UyzkQd3r1kLRieLLpDjikTLR2WXIH7E6T/1NpuK
 KlgcNu0hhieYPRg==
X-Received: by 2002:ae9:e901:0:b0:6b6:ad9:c9c1 with SMTP id
 x1-20020ae9e901000000b006b60ad9c9c1mr18661172qkf.313.1659543424493; 
 Wed, 03 Aug 2022 09:17:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vXVE0dujiASybe9IXw4b0lQ3tiw3YPy3RxvBEkSMmPxkaxPE1QNVrCTaBQYtzd96O84IDQKQ==
X-Received: by 2002:ae9:e901:0:b0:6b6:ad9:c9c1 with SMTP id
 x1-20020ae9e901000000b006b60ad9c9c1mr18661152qkf.313.1659543424208; 
 Wed, 03 Aug 2022 09:17:04 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 r20-20020a05622a035400b0031eeecd21d6sm12062772qtw.69.2022.08.03.09.17.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 03 Aug 2022 09:17:03 -0700 (PDT)
Date: Wed, 3 Aug 2022 12:17:02 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Nathan Huckleberry <nhuck@google.com>
Message-ID: <YuqffhXctdt9vM0i@redhat.com>
References: <20220726160959.89247-1-snitzer@kernel.org>
 <6a158b48-10d3-6427-bc44-e7f78513380b@gmail.com>
 <YuBzAIXQXBRwukR7@redhat.com>
 <28afb65a-f15a-7f75-9a78-acae374f809b@gmail.com>
 <CAJkfWY5wbGB=2CxGKcSKSUCyE18fg4HHH4KuDw+1zRe5jNGmww@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJkfWY5wbGB=2CxGKcSKSUCyE18fg4HHH4KuDw+1zRe5jNGmww@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 0/6] dm verity: optionally use tasklets
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
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>,
 Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 02 2022 at  9:39P -0400,
Nathan Huckleberry <nhuck@google.com> wrote:

> On Wed, Jul 27, 2022 at 1:23 AM Milan Broz <gmazyland@gmail.com> wrote:
> >
> > On 27/07/2022 01:04, Mike Snitzer wrote:
> > > On Tue, Jul 26 2022 at  5:44P -0400,
> > > Milan Broz <gmazyland@gmail.com> wrote:
> > >
> > >> On 26/07/2022 18:09, Mike Snitzer wrote:
> > >>> Hi,
> > >>>
> > >>> Please see this updated patchset that reflects what I've staged for
> > >>> the 5.20 merge window, see:
> > >>> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.20
> > >>>
> > >>> My only outstanding question, from previous v1 patchset, is: should
> > >>> the verify_wq be created using WQ_HIGHPRI instead of WQ_CPU_INTENSIVE?
> > >>> (I doubt it has a significant impact on performance but if you have
> > >>> insight on why you made that change, and if it meaningful, I'd happily
> > >>> apply the change).
> > >>>
> > >>> I've tested using cryptsetup's testsuite (which has dm-verity tests)
> > >>> but I haven't tested the "try_verify_in_tasklet" feature.
> > >
> > > I wasn't lying above: I haven't tested the "try_verify_in_tasklet"
> > > feature.  I just figured I didn't break what Huck posted by cleaning
> > > it up while reviewing closely ;)
> >
> > :) What I am trying to avoid is that these patches reach Linux tree
> > until properly tested even in non-standard configurations (like FEC enabled).
> >
> > Currently we have not even enough HW for GitLab runners for upstream cryptsetup
> > CI testing and regression like these will cause *huge* pain for us later.
> >
> > >> I added new veritysetup option --use-tasklets for testing to a new branch
> > >> https://gitlab.com/cryptsetup/cryptsetup/-/commits/verify-tasklet
> > >>
> > >> I tried to run verity-compat-test (on that branch above), not used the flag yet,
> > >> just in one simple option flag test (see the branch).
> > >
> > > OK, thanks for doing this work, really appreciate it.  How is it I
> > > would initiate this test using your "verify-tasklet" branch?
> >
> > Basically, just checkout that branch, compile it
> > (autogen.sh, configure, make, make check-programs) and then run verity test
> > cd tests; ./verity-compat-test
> >
> > Even without adding the feature, FEC tests are skipped for some reason...
> > (Check for N/A that should not be there.)
> >
> > Then you can easily enable "--use-tasklets" for every open, I would just
> > comment this line:
> >
> > --- a/src/veritysetup.c
> > +++ b/src/veritysetup.c
> > @@ -184,7 +184,7 @@ static int _activate(const char *dm_device,
> >                  activate_flags |= CRYPT_ACTIVATE_IGNORE_ZERO_BLOCKS;
> >          if (ARG_SET(OPT_CHECK_AT_MOST_ONCE_ID))
> >                  activate_flags |= CRYPT_ACTIVATE_CHECK_AT_MOST_ONCE;
> > -       if (ARG_SET(OPT_USE_TASKLETS_ID))
> > +//     if (ARG_SET(OPT_USE_TASKLETS_ID))
> >                  activate_flags |= CRYPT_ACTIVATE_TASKLETS;
> >
> >
> > compile it, and run the verity-compat-test again.
> >
> 
> > For me, it stucks on the first in-kernel verify (non-FEC) line.
> > Some trace below...
> 
> I was able to fix this. There was a problem with falling back to a
> work-queue after FEC fails. This caused an infinite loop. I have
> dm-verity passing verity-compat-test with --use-tasklets; I'll send a
> v3 soon.
> 
> Thanks,
> Huck

Great news. If your fix is confined to a small incremental fix that
needs folding into patch 3 of the v2 patchset: please just send the
incremental patch.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


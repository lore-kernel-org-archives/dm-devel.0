Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F00C1C43334
	for <dm-devel@archiver.kernel.org>; Wed,  1 Jun 2022 23:10:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-T4yemuGCNl2D0tqBOf3Eow-1; Wed, 01 Jun 2022 19:10:43 -0400
X-MC-Unique: T4yemuGCNl2D0tqBOf3Eow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6C1929AB41F;
	Wed,  1 Jun 2022 23:10:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2BCCD2166B26;
	Wed,  1 Jun 2022 23:10:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D70101947B88;
	Wed,  1 Jun 2022 23:10:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3248C194707F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Jun 2022 23:10:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 20D1340EC002; Wed,  1 Jun 2022 23:10:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C5B440EC004
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 23:10:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03B17185A794
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 23:10:40 +0000 (UTC)
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com
 [209.85.160.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-XT6UAQPANWyBTJ8qsFkEJA-1; Wed, 01 Jun 2022 19:10:38 -0400
X-MC-Unique: XT6UAQPANWyBTJ8qsFkEJA-1
Received: by mail-qt1-f179.google.com with SMTP id k12so2296579qtx.13
 for <dm-devel@redhat.com>; Wed, 01 Jun 2022 16:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=3BL2j27uOeKUjZvjS9fDhhPdKAKOn2fyQ3uqHAJSWmw=;
 b=nu0+QFnavkkWQG7XHq/BnavDcK6vOKhmZmgd0moBdNXvaM5Zfl1+GwwQ04ikz2NVPq
 pBNCYalgviSBZuE/xsdXE/DiETEaXO58Gsvd/1ZxPyenEVToqJsSM2cBaN57cZBd83w4
 a9ZxQgsh9spxeym3gRIWgrgBrSM0cN9fz9pVStMA19pjAYRw13XOBz0PISmcfk6B/C2n
 zhEs0pnTZ9hMZjJZ2uU3ZW6X+CeOU8Ij6yhhpfqJr6nIc5g+vGWvLK+idwZyHuAmRCLv
 gq4W+zg7WYdmWngV70YHPIot0uk92nzHsjpPZRLzlbAaSYVR6/4Bel5Hap61zd60CTo7
 aeqg==
X-Gm-Message-State: AOAM532TpMDKl3xsteTM8+W28qRxAyqVcLzqMv3jcXgl7DidYZZPE3eD
 RjqNuezZNvEXdLilUWLqj5AsRf0V5tzSr4s=
X-Google-Smtp-Source: ABdhPJxDP8Use9lg+iACzkQhLsjrYAfgKdP6/Xd1MUjR7GEHLk4x+Yr8dJBFQe84kuV1GR8lB+i1tQ==
X-Received: by 2002:a05:622a:1452:b0:304:5453:fa43 with SMTP id
 v18-20020a05622a145200b003045453fa43mr1722231qtx.297.1654125037749; 
 Wed, 01 Jun 2022 16:10:37 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 fb11-20020a05622a480b00b002fbf0114477sm1949883qtb.3.2022.06.01.16.10.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Jun 2022 16:10:37 -0700 (PDT)
Date: Wed, 1 Jun 2022 19:10:36 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Ypfx7MPYGehYdwCo@redhat.com>
References: <YpfTQgw6RsEYxSFD@redhat.com>
 <CAHk-=wjTOB7yuygFwz64xFHYthwdTOYoC=L2kM4k1GW2a80uNQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjTOB7yuygFwz64xFHYthwdTOYoC=L2kM4k1GW2a80uNQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [git pull] device mapper fixes for 5.19-rc1
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
Cc: linux-block <linux-block@vger.kernel.org>,
 Sarthak Kukreti <sarthakkukreti@google.com>,
 device-mapper development <dm-devel@redhat.com>,
 Kees Cook <keescook@chromium.org>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 01 2022 at  5:43P -0400,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Jun 1, 2022 at 1:59 PM Mike Snitzer <snitzer@kernel.org> wrote:
> >
> > ----------------------------------------------------------------
> > - Fix DM core's dm_table_supports_poll to return false if no data
> >   devices.
> 
> So looking at that one (mainly because of the incomprehensible
> explanation), I do note:
> 
>  (a) the caller does
> 
>         for (i = 0; i < t->num_targets; i++) {
>                 ti = t->targets + i;
> 
>     while the callee does
> 
>         unsigned i = 0;
> 
>         while (i < dm_table_get_num_targets(t)) {
>                 ti = dm_table_get_target(t, i++);
> 
> Now, those things are entirely equivalent, but that latter form is
> likely to generate horribly bad code because those helper functions
> aren't some kind of trivial inline, they are actually normal functions
> that are defined later in that same source file.

Yes, that needs fixing.. but not urgently so.
 
> Maybe a compiler will do optimizations within that source file even
> for functions that haven't been defined yet. Traditionally not.
> 
> Whatever. Probably not a case where anybody cares about performance,
> but it does strike me that the "use abstractions" version probably not
> only generates worse code, it seems less legible too.
> 
> Very odd pattern.

OK, I can just nuke those wrappers.  But yeah, none of this setup code
is fast path.

>  (b) The commit message (which is why I started looking at this) says
> that it used to return true even if there are no data devices.
> 
>      But dm_table_supports_poll() actually _still_ returns true for at
> least one case of no data devices: if the dm_table has no targets at
> all.

Right, I'm aware.. ugly but not a case that really matters (more below).

> So I don't know. Maybe that is a "can't happen". But since I looked at
> this, I thought I'd just point out the two oddities I found while
> doing so.

It can happen that someone loads a table without any targets but it
isn't a case that matters given IO cannot be sent anywhere.  For that
to happen the DM table will have been reloaded to have targets (at
which point all will be setup properly, assuming no bugs like was
fixed here).

I do see you've since pulled the changes.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


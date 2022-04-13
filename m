Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE0FC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Apr 2022 06:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649830381;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wsxGAQjqFKUd0AHao29ekwv7+z2dwFoH0lrxOADO1qk=;
	b=E+8L+kh70I8r7R7bkAfFFnh1W1aP7DgnnBSj5GEMG81tEO2tdnlqhH9ivBux04qFWXrsJ7
	jfi4mCnKb5NpdMrpd/9yJerifeAltFApgAW+11VVgvdnUxjD8OGGiAJRHiCZEcfdy1S8Uu
	kdHBg4qxA1sCRnkqNKHMHT+81JQ/A0A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-YA9i1HqMON6k7FKXTTHy_Q-1; Wed, 13 Apr 2022 02:12:58 -0400
X-MC-Unique: YA9i1HqMON6k7FKXTTHy_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81EF48117B0;
	Wed, 13 Apr 2022 06:12:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E57640E80E0;
	Wed, 13 Apr 2022 06:12:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 183761949761;
	Wed, 13 Apr 2022 06:12:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B87601947BBE
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 06:12:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A2E26C44B1D; Wed, 13 Apr 2022 06:12:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EDE8C27E9B
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 06:12:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8682F3801ECA
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 06:12:52 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-ZwTG8CO9O5qC6jutb_QOpg-1; Wed, 13 Apr 2022 02:12:50 -0400
X-MC-Unique: ZwTG8CO9O5qC6jutb_QOpg-1
Received: by mail-qt1-f197.google.com with SMTP id
 ay36-20020a05622a22a400b002f1d1702432so502597qtb.14
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 23:12:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4Ux7XB9elwVH5NdCYl17IXEufEqJfJJdXr0Uu64WT7w=;
 b=OE+5vwo0CjfRW89dDeJOm8t4SRKtTj05pxXxu88Jp31pqhJwhn+MOtWIhut/5QM/6/
 AkEcaG3OTYqa+IEtIJ8lFT+HaXwE44uWzeuL/csYtX+dK8ocxfmAqaPUCzCg9+pU83zK
 QuXVTQcDpgOTSjtBEY3ltwPM7khX9qRzkaytSpUslWYeM3gV2rnzj5gueHSWnBwD2YRj
 xysslGoA3Ea8Z7/J+Um04YX2X/3WbJUMNytONW92WX9jZsNbjE6mqt4WOJ/HkwjY0Xz4
 h69V4GDBkMUYFamXVEGZX3Hoqgmo6n3Apx4EsfXDb/2+ZyGLtudmTOUy8EEAXJIvTLHa
 QZQA==
X-Gm-Message-State: AOAM533FlXSXhqtVABZI9u3tPj0t3GMEE1t06lDvGp+tppDi4ZhSTCFo
 pxym2WDRfJk6mYKcJ2lqkOjBrO8Lqca60eJ1Rhpb3gSRoOWM+yD5pdwILVz7svwFY5qkFB0Q1a4
 UW8e242RkKGv6Sw==
X-Received: by 2002:ac8:7281:0:b0:2ee:ed60:777a with SMTP id
 v1-20020ac87281000000b002eeed60777amr6076751qto.197.1649830370334; 
 Tue, 12 Apr 2022 23:12:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE3nUhkGCZlB8Nm7wu43fO17nO28Q703b9H7cthQ7uYqf2jU3Gae9pL5zRpbhxMG+0RVfwsg==
X-Received: by 2002:ac8:7281:0:b0:2ee:ed60:777a with SMTP id
 v1-20020ac87281000000b002eeed60777amr6076742qto.197.1649830370053; 
 Tue, 12 Apr 2022 23:12:50 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 s4-20020ae9de04000000b0069c3a577b0asm2648615qkf.51.2022.04.12.23.12.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Apr 2022 23:12:49 -0700 (PDT)
Date: Wed, 13 Apr 2022 02:12:47 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YlZp3+VrP930VjIQ@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com>
 <YlXmmB6IO7usz2c1@redhat.com> <YlYt2rzM0NBPARVp@T590>
MIME-Version: 1.0
In-Reply-To: <YlYt2rzM0NBPARVp@T590>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 5/8] dm: always setup ->orig_bio in alloc_io
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 12 2022 at  9:56P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Tue, Apr 12, 2022 at 04:52:40PM -0400, Mike Snitzer wrote:
> > On Tue, Apr 12 2022 at  4:56P -0400,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > The current DM codes setup ->orig_bio after __map_bio() returns,
> > > and not only cause kernel panic for dm zone, but also a bit ugly
> > > and tricky, especially the waiting until ->orig_bio is set in
> > > dm_submit_bio_remap().
> > > 
> > > The reason is that one new bio is cloned from original FS bio to
> > > represent the mapped part, which just serves io accounting.
> > > 
> > > Now we have switched to bdev based io accounting interface, and we
> > > can retrieve sectors/bio_op from both the real original bio and the
> > > added fields of .sector_offset & .sectors easily, so the new cloned
> > > bio isn't necessary any more.
> > > 
> > > Not only fixes dm-zone's kernel panic, but also cleans up dm io
> > > accounting & split a bit.
> > 
> > You're conflating quite a few things here.  DM zone really has no
> > business accessing io->orig_bio (dm-zone.c can just as easily inspect
> > the tio->clone, because it hasn't been remapped yet it reflects the
> > io->origin_bio, so there is no need to look at io->orig_bio) -- but
> > yes I clearly broke things during the 5.18 merge and it needs fixing
> > ASAP.
> 
> You can just consider the cleanup part of this patches, :-)

I will.  But your following list doesn't reflect any "cleanup" that I
saw in your patchset.  Pretty fundamental changes that are similar,
but different, to the dm-5.19 changes I've staged.

> 1) no late assignment of ->orig_bio, and always set it in alloc_io()
>
> 2) no waiting on on ->origi_bio, especially the waiting is done in
> fast path of dm_submit_bio_remap().

For 5.18 waiting on io->orig_bio just enables a signal that the IO was
split and can be accounted.

For 5.19 I also plan on using late io->orig_bio assignment as an
alternative to the full-blown refcounting currently done with
io->io_count.  I've yet to quantify the gains with focused testing but
in theory this approach should scale better on large systems with many
concurrent IO threads to the same device (RCU is primary constraint
now).

I'll try to write a bpfrace script to measure how frequently "waiting on
io->orig_bio" occurs for dm_submit_bio_remap() heavy usage (like
dm-crypt). But I think we'll find it is very rarely, if ever, waited
on in the fast path.

> 3) no split for io accounting

DM's more recent approach to splitting has never been done for benefit
or use of IO accounting, see this commit for its origin:
18a25da84354c6b ("dm: ensure bio submission follows a depth-first tree walk")

Not sure why you keep poking fun at DM only doing a single split when:
that is the actual design.  DM splits off orig_bio then recurses to
handle the remainder of the bio that wasn't issued.  Storing it in
io->orig_bio (previously io->bio) was always a means of reflecting
things properly. And yes IO accounting is one use, the other is IO
completion. But unfortunately DM's IO accounting has always been a
mess ever since the above commit. Changes in 5.18 fixed that.

But again, DM's splitting has _nothing_ to do with IO accounting.
Splitting only happens when needed for IO submission given constraints
of DM target(s) or underlying layers.

All said, I will look closer at your entire set and see if it better
to go with your approach.  This patch in particular is interesting
(avoids cloning and other complexity of bio_split + bio_chain):
https://patchwork.kernel.org/project/dm-devel/patch/20220412085616.1409626-6-ming.lei@redhat.com/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


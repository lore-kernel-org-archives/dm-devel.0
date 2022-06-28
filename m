Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D0BC43334
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 07:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656487944;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f0UAj96g1URlrCdNLtO535wT0a5Vt1GUTTRkp7XEKEM=;
	b=OYVNakB4MxWf5jXFaH1z7zayWA8Vt5WuL35O9yPyZOScC5dCQWeb+6Qd9yzjBde3ouqWtq
	b4T7SAkbeymYRKGg7U1XXFidS05EKffvUIP80z1Lrm8O+XBlX1pvrZnGKV2wADSbbqy3Qm
	YQyLiFfhq/0v1RXuD1vR759ja9phhKY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-iaFfNbzRMJS50dDGSNo3vQ-1; Wed, 29 Jun 2022 03:31:06 -0400
X-MC-Unique: iaFfNbzRMJS50dDGSNo3vQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A268F294EDF3;
	Wed, 29 Jun 2022 07:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A5682026D64;
	Wed, 29 Jun 2022 07:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA4FC194705E;
	Wed, 29 Jun 2022 07:31:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 92CF519466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 17:53:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7A46A1410F3B; Tue, 28 Jun 2022 17:53:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 751E81410DD8
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 17:53:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CB793C1016A
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 17:53:02 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-a0u5xQb6N9muJwb82rJ6yw-1; Tue, 28 Jun 2022 13:52:56 -0400
X-MC-Unique: a0u5xQb6N9muJwb82rJ6yw-1
Received: by mail-qk1-f175.google.com with SMTP id k20so10327136qkj.1;
 Tue, 28 Jun 2022 10:52:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ewm/D54QJwPydqqMESWdGD9ZAIStLXJg44P7oeFTnc4=;
 b=78St5DIpymYsCtS3p5Agy/aetSC4qbd8/IZ1Gt0hjMvwO7fpPjOdX9HS4naOiNwoRI
 KWxQylKwGK+N0FSl84+suhFxTj3Xa+5+96H5kznqQkZiYMA9veaCUyh9Z98eS42KWK57
 vSDPPfmvBcSg+uAsh1YawMQIdjPFl9dJXgxqBP57LvAYklJDxjfwQ/ouWdX/R6Qh+nyT
 0NzMTeDrY2jOsuGCBLi9veo9MW9yeERf4mMnSROkeECv0vA9smtKDqprux+gCrcWm6tU
 zImxI3XIXoGLCC/IH+3Mj4Q11n5eQtJhipNu5/CT3wdVax+UXFuDcIbko5WAYKraoxTY
 Agog==
X-Gm-Message-State: AJIora/VY79c9F4/uJ1pJel3x5n/wwnjjHo2wYo3g7Z3EBgvweDqOpv7
 3RWD3KOT4EzGN7K3tagepcrO0Gd/iVuhsxAaHA==
X-Google-Smtp-Source: AGRyM1v2jHOLNo75aMnY6qO6lwP4wH61BoDXlZP+NDawv2fIOw5rhViYFT1b6L+U1xEzQTF8j+LSKQ==
X-Received: by 2002:a37:355:0:b0:6ae:e5a7:bb5c with SMTP id
 82-20020a370355000000b006aee5a7bb5cmr12528898qkd.758.1656438774998; 
 Tue, 28 Jun 2022 10:52:54 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 cb24-20020a05622a1f9800b003187c484027sm3631751qtb.73.2022.06.28.10.52.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Jun 2022 10:52:53 -0700 (PDT)
Date: Tue, 28 Jun 2022 13:52:53 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20220628175253.s2ghizfucumpot5l@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
 <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
 <Yrs9OLNZ8xUs98OB@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Yrs9OLNZ8xUs98OB@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 29 Jun 2022 07:31:01 +0000
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Eric Biggers <ebiggers@google.com>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 28, 2022 at 01:41:12PM -0400, Mike Snitzer wrote:
> On Tue, Jun 28 2022 at 12:36P -0400,
> Kent Overstreet <kent.overstreet@gmail.com> wrote:
> 
> > On Tue, Jun 28, 2022 at 03:49:28PM +0800, Ming Lei wrote:
> > > On Tue, Jun 28, 2022 at 12:26:10AM -0400, Kent Overstreet wrote:
> > > > On Mon, Jun 27, 2022 at 03:36:22PM +0800, Ming Lei wrote:
> > > > > Not mention bio_iter, bvec_iter has been 32 bytes, which is too big to
> > > > > hold in per-io data structure. With this patch, 8bytes is enough
> > > > > to rewind one bio if the end sector is fixed.
> > > > 
> > > > And with rewind, you're making an assumption about the state the iterator is
> > > > going to be in when the IO has completed.
> > > > 
> > > > What if the iterator was never advanced?
> > > 
> > > bio_rewind() works as expected if the iterator doesn't advance, since bytes
> > > between the recorded position and the end position isn't changed, same
> > > with the end position.
> > > 
> > > > 
> > > > So say you check for that by saving some other part of the iterator - but that
> > > > may have legitimately changed too, if the bio was redirected (bi_sector changes)
> > > > or trimmed (bi_size changes)
> > > > 
> > > > I still think this is an inherently buggy interface, the way it's being proposed
> > > > to be used.
> > > 
> > > The patch did mention that the interface should be for situation in which end
> > > sector of bio won't change.
> > 
> > But that's an assumption that you simply can't make!
> 
> Why not?  There is clear use-case for this API, as demonstrated in the
> patchset: DM can/will make use of it for the purposes of enhancing its
> more unlikely bio requeuing work (that is needed to make the more
> likely bio splitting scenario more efficient).
> 
> > We allow block device drivers to be stacked in _any_ combination. After a bio is
> > completed it may have been partially advanced, fully advanced, trimmed, not
> > trimmed, anything - and bi_sector and thus also bio_end_sector() may have
> > changed, and will have if there's partition tables involved.
> 
> We don't _need_ this API to cure cancer for all hypothetical block
> drivers.
> 
> If consumers of the API follow the rule that end sector of the
> _original bio_ isn't changed then it is all fine.  It is that simple.
> 
> Stacked drivers will work just fine.  The lower layers will be
> modifying their bios as needed. Because for DM those bios happen to
> be clones, so there is isolation to the broader design flaw you are
> trying to say is a major problem. As this patchset demonstrates.
> 
> I do concede that policing who can use an API is hard.  But if some
> consumer of an API tries something that invalidates rules of the API
> they get to keep the N pieces when it breaks.

Mike, keep in mind that when bio_rewind() was originally introduced, it
immediately grew users that were _inherently buggy_ (of the "users can break
this trivially") variety, and the whole thing had to be reverted, and I was
really annoyed - mostly at myself, because I would have caught it if I'd been
paying attention to the mailing list more.

And I _guarantee_ you that if this makes it in, we'll have the same thing
happening all over again - we have a lot of different block drivers being
written by a lot of different people, and most of them do not understand all the
subtleties of the block layer and the ways different things can interact, and so
the onus is on us to not add tools that they aren't going to immediately turn
around and slice themselves with.

The 32 bytes you're trying to save is meaningless. Think instead about the weeks
of engineer time that get wasted by bugs like this - chasing the bugs,
babysitting the patches in to fix it, then the _endless_ -stable backports.

_Please_ try to think more defensively when you're writing code.

So, and I'm sorry I have to be the killjoy here, but hard NACK on this patchset.
Hard, hard NACK.

I'll be happy to assist in coming up with alternate, less dangerous solutions
though (and I think introducing a real bio_iter is overdue, so that's probably
the first thing we should look at).

Cheers

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


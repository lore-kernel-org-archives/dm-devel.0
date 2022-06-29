Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2888AC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 06:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656482841;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QdAtnpjN4mU4aoLlfoMeAFxRuno5YpgLB5VQ+zqvtPU=;
	b=O9t6BhowdqHg8OaL6wTCt31yc/vKyJEf0VCNF+DiTackBHUhnwkEZoGLTmtbjQz1uaXWOa
	V0pQ8lVEIMeAbuo9KTTqw4WIXPwDTj3byUDNFBH+hoMfGCNcnQbTAt+grXuG40htew05xH
	lPJigS+ssjlFAucPRq28BEmQq1bIZ/k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-hpOVT-66P7y3MZvg4ZW5yA-1; Wed, 29 Jun 2022 02:07:18 -0400
X-MC-Unique: hpOVT-66P7y3MZvg4ZW5yA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A3393806648;
	Wed, 29 Jun 2022 06:07:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A4F02415F5E;
	Wed, 29 Jun 2022 06:07:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A5CA1947056;
	Wed, 29 Jun 2022 06:07:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4A80119466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 06:07:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 26F3C40EC004; Wed, 29 Jun 2022 06:07:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22F0140EC002
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 06:07:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09BD31C01B3C
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 06:07:13 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-bTLWTRzMMK-ib9kOtsjcFw-1; Wed, 29 Jun 2022 02:07:11 -0400
X-MC-Unique: bTLWTRzMMK-ib9kOtsjcFw-1
Received: by mail-qv1-f69.google.com with SMTP id
 m1-20020a0cf181000000b0046e65e564cfso14473969qvl.17
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 23:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5EQ7f/05KqmK9Xa7KeRmbo8x7feZUGGxCGIHn0m0Opw=;
 b=yX57pAoD3U4Imd/eoEs/TbU+RrKKNf9akfw1BtUlzuU3GUSk8adrI+9llDAaQzC7vb
 4e1J5PZ9cv7RTHuevnENjnm7sx/nhuKXufza0G1+4TOftGkT92XCfZ5BQ9gPXNo0Pw1a
 eOxIRzTsmKna9jg3DH9hVv6saCsw7YKWcGbiQRsDyCFO39AE/lhJ33udKy2TxPjmdoG7
 PZHcLkJn66Detx5z3oPRBT2p2jU/snJTANSuNGRON7cZgANg4U1LuErNWeVmgW5AGxgE
 yv2bz6hfxLmqb2vUkz0J3OHyBlcEHewiHfnemmNMQ2E736TT9FEw4S5OjNCtluxTGmNz
 V6lw==
X-Gm-Message-State: AJIora/UEjLtp6827SQKgqpzDkQ+1SHxllKbfHaKByn6bR9OtYLRX+lo
 ymHHEt/2WziM+LFPldWweuFKYSqWNuB2wGvewNhAqr5QdhkA7bKeNfxFlcDBfcCU8OMkaVR+ytH
 WZ3GR37pMLKy7cA==
X-Received: by 2002:ad4:4ee2:0:b0:470:72a4:8685 with SMTP id
 dv2-20020ad44ee2000000b0047072a48685mr5521417qvb.46.1656482831200; 
 Tue, 28 Jun 2022 23:07:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1swAwir+Rz9oJNJPuh2do6GuZ6EW9NU1dJFtYJbUgyoZpMXwS4GACW15qhdgcIc8cEQRP+ETQ==
X-Received: by 2002:ad4:4ee2:0:b0:470:72a4:8685 with SMTP id
 dv2-20020ad44ee2000000b0047072a48685mr5521405qvb.46.1656482830891; 
 Tue, 28 Jun 2022 23:07:10 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 j4-20020a05620a410400b006a6278a2b31sm1256063qko.75.2022.06.28.23.07.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Jun 2022 23:07:10 -0700 (PDT)
Date: Wed, 29 Jun 2022 02:07:08 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Message-ID: <YrvsDNltq+h6mphN@redhat.com>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
 <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
 <Yrs9OLNZ8xUs98OB@redhat.com>
 <20220628175253.s2ghizfucumpot5l@moria.home.lan>
MIME-Version: 1.0
In-Reply-To: <20220628175253.s2ghizfucumpot5l@moria.home.lan>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 28 2022 at  1:52P -0400,
Kent Overstreet <kent.overstreet@gmail.com> wrote:

> On Tue, Jun 28, 2022 at 01:41:12PM -0400, Mike Snitzer wrote:
> > On Tue, Jun 28 2022 at 12:36P -0400,
> > Kent Overstreet <kent.overstreet@gmail.com> wrote:
> > 
> > > On Tue, Jun 28, 2022 at 03:49:28PM +0800, Ming Lei wrote:
> > > > On Tue, Jun 28, 2022 at 12:26:10AM -0400, Kent Overstreet wrote:
> > > > > On Mon, Jun 27, 2022 at 03:36:22PM +0800, Ming Lei wrote:
> > > > > > Not mention bio_iter, bvec_iter has been 32 bytes, which is too big to
> > > > > > hold in per-io data structure. With this patch, 8bytes is enough
> > > > > > to rewind one bio if the end sector is fixed.
> > > > > 
> > > > > And with rewind, you're making an assumption about the state the iterator is
> > > > > going to be in when the IO has completed.
> > > > > 
> > > > > What if the iterator was never advanced?
> > > > 
> > > > bio_rewind() works as expected if the iterator doesn't advance, since bytes
> > > > between the recorded position and the end position isn't changed, same
> > > > with the end position.
> > > > 
> > > > > 
> > > > > So say you check for that by saving some other part of the iterator - but that
> > > > > may have legitimately changed too, if the bio was redirected (bi_sector changes)
> > > > > or trimmed (bi_size changes)
> > > > > 
> > > > > I still think this is an inherently buggy interface, the way it's being proposed
> > > > > to be used.
> > > > 
> > > > The patch did mention that the interface should be for situation in which end
> > > > sector of bio won't change.
> > > 
> > > But that's an assumption that you simply can't make!
> > 
> > Why not?  There is clear use-case for this API, as demonstrated in the
> > patchset: DM can/will make use of it for the purposes of enhancing its
> > more unlikely bio requeuing work (that is needed to make the more
> > likely bio splitting scenario more efficient).
> > 
> > > We allow block device drivers to be stacked in _any_ combination. After a bio is
> > > completed it may have been partially advanced, fully advanced, trimmed, not
> > > trimmed, anything - and bi_sector and thus also bio_end_sector() may have
> > > changed, and will have if there's partition tables involved.
> > 
> > We don't _need_ this API to cure cancer for all hypothetical block
> > drivers.
> > 
> > If consumers of the API follow the rule that end sector of the
> > _original bio_ isn't changed then it is all fine.  It is that simple.
> > 
> > Stacked drivers will work just fine.  The lower layers will be
> > modifying their bios as needed. Because for DM those bios happen to
> > be clones, so there is isolation to the broader design flaw you are
> > trying to say is a major problem. As this patchset demonstrates.
> > 
> > I do concede that policing who can use an API is hard.  But if some
> > consumer of an API tries something that invalidates rules of the API
> > they get to keep the N pieces when it breaks.
> 
> Mike, keep in mind that when bio_rewind() was originally introduced, it
> immediately grew users that were _inherently buggy_ (of the "users can break
> this trivially") variety, and the whole thing had to be reverted, and I was
> really annoyed - mostly at myself, because I would have caught it if I'd been
> paying attention to the mailing list more.
> 
> And I _guarantee_ you that if this makes it in, we'll have the same thing
> happening all over again - we have a lot of different block drivers being
> written by a lot of different people, and most of them do not understand all the
> subtleties of the block layer and the ways different things can interact, and so
> the onus is on us to not add tools that they aren't going to immediately turn
> around and slice themselves with.
> 
> The 32 bytes you're trying to save is meaningless. Think instead about the weeks
> of engineer time that get wasted by bugs like this - chasing the bugs,
> babysitting the patches in to fix it, then the _endless_ -stable backports.

While you or others did something approximating all that, really
doesn't mean it applicable here.

> _Please_ try to think more defensively when you're writing code.

Please try to dial down the hyperbole and judgment. Ming wrote this
code. And you haven't been able to point out anything _actually_ wrong
with it (yet).

This patch's header does need editing for clarity, but we can help
improve it and the documentation above bio_rewind() in the code.

> So, and I'm sorry I have to be the killjoy here, but hard NACK on this patchset.
> Hard, hard NACK.

<insert tom-delonge-wtf.gif>

You see this bio_rewind() as history repeating itself, but it isn't
like what you ranted about in the past:
https://marc.info/?l=linux-block&m=153549921116441&w=2

I can certainly see why you think it similar at first glance. But this
patchset shows how bio_rewind() must be used, and how DM benefits from
using it safely (with no impact to struct bio or DM's per-bio-data).

bio_rewind() usage will be as niche as DM's use-case for it. If other
code respects the documented constraint, that the original bio's end
sector be preserved, then they can use it too.

The key is for a driver to maintain enough state to allow this fixed
end be effectively immutable. (DM happens to get this state "for free"
simply because it was already established for its IO accounting of
split bios).

The Linux codebase requires precision. This isn't new.

> I'll be happy to assist in coming up with alternate, less dangerous solutions
> though (and I think introducing a real bio_iter is overdue, so that's probably
> the first thing we should look at).

It isn't dangerous. It is an interface whose constraint needs to be
respected. Just like is documented for a myriad other kernel
interfaces.

Factoring out a bio_iter will bloat struct bio for functionality most
consumers don't need. And gating DM's ability to achieve this
patchset's functionality with some overdue refactoring is really _not_
acceptable.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871C1C43334
	for <dm-devel@archiver.kernel.org>; Thu, 30 Jun 2022 00:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656550341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JP+lk7IQFNLsN7+PqsPsMcDMiD28KZr26efQgYLYZoc=;
	b=bL0cwjePINlt5YKzJXj/iwCkUskLr+b+gp2msf+Iu8Vgn/gRzz2+2pYSnPxH0AhEn8xT4d
	FSN/z8WDZ+B+TgQOZVrFkHS8jujB2n+oBAXf0IEqyGN/R46SaI+E5oS8Qi4sU6/KKYL5LC
	BhCzLV+YsUzjPvZ3wtoDrugqwOifktc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-H4EC5xN3N9O3FkSpR7OPog-1; Wed, 29 Jun 2022 20:52:18 -0400
X-MC-Unique: H4EC5xN3N9O3FkSpR7OPog-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A50A801231;
	Thu, 30 Jun 2022 00:52:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71D3140336E;
	Thu, 30 Jun 2022 00:52:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EE9A194705F;
	Thu, 30 Jun 2022 00:52:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C317E1947058
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Jun 2022 00:47:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 89BC8C28115; Thu, 30 Jun 2022 00:47:23 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A0BEC2810D;
 Thu, 30 Jun 2022 00:47:17 +0000 (UTC)
Date: Thu, 30 Jun 2022 08:47:13 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Message-ID: <YrzykX0jTWpq5DYQ@T590>
References: <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
 <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
 <Yrs9OLNZ8xUs98OB@redhat.com>
 <20220628175253.s2ghizfucumpot5l@moria.home.lan>
 <YrvsDNltq+h6mphN@redhat.com>
 <20220629181154.eejrlfhj5n4la446@moria.home.lan>
MIME-Version: 1.0
In-Reply-To: <20220629181154.eejrlfhj5n4la446@moria.home.lan>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
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

On Wed, Jun 29, 2022 at 02:11:54PM -0400, Kent Overstreet wrote:
> On Wed, Jun 29, 2022 at 02:07:08AM -0400, Mike Snitzer wrote:
> > Please try to dial down the hyperbole and judgment. Ming wrote this
> > code. And you haven't been able to point out anything _actually_ wrong
> > with it (yet).
> > 
> > This patch's header does need editing for clarity, but we can help
> > improve it and the documentation above bio_rewind() in the code.
> > 
> > > So, and I'm sorry I have to be the killjoy here, but hard NACK on this patchset.
> > > Hard, hard NACK.
> > 
> > <insert tom-delonge-wtf.gif>
> > 
> > You see this bio_rewind() as history repeating itself, but it isn't
> > like what you ranted about in the past:
> > https://marc.info/?l=linux-block&m=153549921116441&w=2
> > 
> > I can certainly see why you think it similar at first glance. But this
> > patchset shows how bio_rewind() must be used, and how DM benefits from
> > using it safely (with no impact to struct bio or DM's per-bio-data).
> > 
> > bio_rewind() usage will be as niche as DM's use-case for it. If other
> > code respects the documented constraint, that the original bio's end
> > sector be preserved, then they can use it too.
> > 
> > The key is for a driver to maintain enough state to allow this fixed
> > end be effectively immutable. (DM happens to get this state "for free"
> > simply because it was already established for its IO accounting of
> > split bios).
> > 
> > The Linux codebase requires precision. This isn't new.
> 
> Mike, that's not justification for making things _more_ dangerous.
> 
> > 
> > > I'll be happy to assist in coming up with alternate, less dangerous solutions
> > > though (and I think introducing a real bio_iter is overdue, so that's probably
> > > the first thing we should look at).
> > 
> > It isn't dangerous. It is an interface whose constraint needs to be
> > respected. Just like is documented for a myriad other kernel
> > interfaces.
> > 
> > Factoring out a bio_iter will bloat struct bio for functionality most
> > consumers don't need. And gating DM's ability to achieve this
> > patchset's functionality with some overdue refactoring is really _not_
> > acceptable.
> 
> Mike, you're the one who's getting seriously hyperbolic here. You're getting
> frustrated because you've got this one thing you really want to get done, and
> you feel like you're running into a brick wall when I tell you "no".
> 
> And yes, coding in the kernel is a complicated, dangerous environment with many
> rules that need to be respected.
> 
> That does not mean it's ok to be adding to that complexity, and making it even
> more dangerous, without a _really fucking good reason_. This doesn't fly. Maybe
> it would if it was some device mapper private thing, but you're acting like it's
> only going to be used by device mapper when you're trying to add it to the
> public interface for core block layer bio code. _That_ needs real justification.
> 
> Also, bio_iter is something we should definitely be considering because of the
> way integrity and now crypt has been tacked on to struct bio.
> 
> When I originally wrote the modern bvec_iter code, the ability to use an
> iterator besides the one in struct bio was an important piece of functionality,
> one that's still in use (including in device mapper; see
> __bio_for_each_segment()). The fact that we're growing additional data
> structures that in theory want to be iterated in lockstep with the main bio
> payload but _aren't_ iterated over with bi_iter is, at best, a code smell and a
> lurking footgun.
> 
> However, I can see that the two of you are not likely take on figuring out how
> to clean that up, and truthfully I don't have the time right now either, much as
> it pains me.
> 
> Here's an alternative approach:
> 
> The fundamental problem with bio_rewind() (and I know that you two are super
> serious that this is completely safe for your use case and no one else is going
> to use it for anything else) is that we're using it to get back to some initial
> state, but it's not invariant w.r.t. what's been done to the bio since then, and
> the nature of the block layer is that that's a problem.
> 
> So here's what you do:
> 
> You bring back bi_done: bi_done counts bytes advanced, total, since the start
> of the bio. Then we introduce a type:
> 
> struct bio_pos {
> 	unsigned	bi_done;
> 	unsigned	bi_size;
> };
> 
> And two new functions:
> 
> struct bio_pos bio_get_pos(struct bio *)
> {
> 	...
> }
> 
> void bio_set_pos(struct bio *, struct bio_pos)
> {
> 	...
> }
> 
> That gets you the same functionality as bio_rewind(), but it'll be much more
> broadly useful.

What is the difference between bio_set_pos and bio_rewind()? Both have
to restore bio->bi_iter(the sector part and the bvec part).

Also how to update ->bi_done which 'counts bytes advanced'? You meant doing it in
very bio_advance()? then no, why do we have to pay the cost for very unusual
bio_rewind()?

Or if I misunderstood your point, please cook a patch and I am happy to
take a close look, and posting one very raw idea with random data
structure looks not helpful much for this discussion technically.


Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


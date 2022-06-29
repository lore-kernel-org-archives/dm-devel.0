Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F54CCA481
	for <dm-devel@archiver.kernel.org>; Thu, 30 Jun 2022 07:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656574291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SlmyCqL0ZjZm5kvqq4AQ/xyOvXZK7CbQgiQxNFEoFnM=;
	b=BvhS/+FfwrdZG6Q5b89Nx/24ex3Qu9+FHAr+6AXEeBz1K8EuMkWM9ZaeS9iP9y673K9YTg
	lFUwdNTrkKT/e7oAxAFJMVM6KPaERlIFg+w6r6bkcQKco3+lq4gRQga7htbZ4kLBCsiwFa
	mLhzKC/V4UndsYYuG5boRZZHdUDFucQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-ugqzC3ZQMg2JcgkwzdAZEQ-1; Thu, 30 Jun 2022 03:31:28 -0400
X-MC-Unique: ugqzC3ZQMg2JcgkwzdAZEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E0F41C0CE70;
	Thu, 30 Jun 2022 07:31:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EDCF040EC003;
	Thu, 30 Jun 2022 07:31:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 10F081947B8F;
	Thu, 30 Jun 2022 07:31:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0FC191947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 18:12:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C84E6C2811A; Wed, 29 Jun 2022 18:12:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4614C28118
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 18:12:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC1702932497
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 18:12:02 +0000 (UTC)
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com
 [209.85.219.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-vzdqUNVBNfCWhK_BJjUZvg-1; Wed, 29 Jun 2022 14:11:58 -0400
X-MC-Unique: vzdqUNVBNfCWhK_BJjUZvg-1
Received: by mail-qv1-f45.google.com with SMTP id u14so23384878qvv.2;
 Wed, 29 Jun 2022 11:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Gijk56NMdB/sja9dAmbjVTkCB9EEiLswQtfTGFbcORI=;
 b=b9NBFVv4BoRCwhAScA4R5Z+5ALlb3w2eaOBETqF6KYhsStm/PXR/6NNF28KJmlmDez
 GE08GthGEaxp4jMcgmtTvOYIzv8E5SXnUmpN88ZtbmiPX3egXLZMzoUjrLPQ6g/FCKf2
 juxaZX1OuLrngwdfR7150kVbYGSjzrsJqt9v7vri6vgjkzfaSZVUNKkoQvv9hUjGR9yI
 p6xSjfkL9ZbGbWr76AMU56AHE6ndimEJ5p+xjoRDtZKr/k/H9xWfRa3g3DhJwr2TD29S
 HF4T/nC4kKfOR4s7wLNEJZXIP9CqIcjEQuEDO12yMJ1xyZBlfP3qgTnIudxVnNault9g
 z+ig==
X-Gm-Message-State: AJIora8xM3+GPfkWxL4t8NMUoIf2owzFqFA2cf1Uww8SaXsP4mQQU9kv
 QC2Bp6ncd0cw9Sc8Cpu002ZFOoNjBCF3H6Xu6g==
X-Google-Smtp-Source: AGRyM1sPrUbtuaytU8RpCVUWuNrZiasGP0JPuy3ZOunsnIkksLe8Hvawxu7sMDiOu7MTU+ctUVOggA==
X-Received: by 2002:ac8:5fc3:0:b0:31d:2637:7ed6 with SMTP id
 k3-20020ac85fc3000000b0031d26377ed6mr2811002qta.282.1656526316309; 
 Wed, 29 Jun 2022 11:11:56 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 g6-20020ac842c6000000b00317ccc66971sm10357618qtm.52.2022.06.29.11.11.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 11:11:55 -0700 (PDT)
Date: Wed, 29 Jun 2022 14:11:54 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20220629181154.eejrlfhj5n4la446@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
 <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
 <Yrs9OLNZ8xUs98OB@redhat.com>
 <20220628175253.s2ghizfucumpot5l@moria.home.lan>
 <YrvsDNltq+h6mphN@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YrvsDNltq+h6mphN@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Thu, 30 Jun 2022 07:31:23 +0000
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 29, 2022 at 02:07:08AM -0400, Mike Snitzer wrote:
> Please try to dial down the hyperbole and judgment. Ming wrote this
> code. And you haven't been able to point out anything _actually_ wrong
> with it (yet).
> 
> This patch's header does need editing for clarity, but we can help
> improve it and the documentation above bio_rewind() in the code.
> 
> > So, and I'm sorry I have to be the killjoy here, but hard NACK on this patchset.
> > Hard, hard NACK.
> 
> <insert tom-delonge-wtf.gif>
> 
> You see this bio_rewind() as history repeating itself, but it isn't
> like what you ranted about in the past:
> https://marc.info/?l=linux-block&m=153549921116441&w=2
> 
> I can certainly see why you think it similar at first glance. But this
> patchset shows how bio_rewind() must be used, and how DM benefits from
> using it safely (with no impact to struct bio or DM's per-bio-data).
> 
> bio_rewind() usage will be as niche as DM's use-case for it. If other
> code respects the documented constraint, that the original bio's end
> sector be preserved, then they can use it too.
> 
> The key is for a driver to maintain enough state to allow this fixed
> end be effectively immutable. (DM happens to get this state "for free"
> simply because it was already established for its IO accounting of
> split bios).
> 
> The Linux codebase requires precision. This isn't new.

Mike, that's not justification for making things _more_ dangerous.

> 
> > I'll be happy to assist in coming up with alternate, less dangerous solutions
> > though (and I think introducing a real bio_iter is overdue, so that's probably
> > the first thing we should look at).
> 
> It isn't dangerous. It is an interface whose constraint needs to be
> respected. Just like is documented for a myriad other kernel
> interfaces.
> 
> Factoring out a bio_iter will bloat struct bio for functionality most
> consumers don't need. And gating DM's ability to achieve this
> patchset's functionality with some overdue refactoring is really _not_
> acceptable.

Mike, you're the one who's getting seriously hyperbolic here. You're getting
frustrated because you've got this one thing you really want to get done, and
you feel like you're running into a brick wall when I tell you "no".

And yes, coding in the kernel is a complicated, dangerous environment with many
rules that need to be respected.

That does not mean it's ok to be adding to that complexity, and making it even
more dangerous, without a _really fucking good reason_. This doesn't fly. Maybe
it would if it was some device mapper private thing, but you're acting like it's
only going to be used by device mapper when you're trying to add it to the
public interface for core block layer bio code. _That_ needs real justification.

Also, bio_iter is something we should definitely be considering because of the
way integrity and now crypt has been tacked on to struct bio.

When I originally wrote the modern bvec_iter code, the ability to use an
iterator besides the one in struct bio was an important piece of functionality,
one that's still in use (including in device mapper; see
__bio_for_each_segment()). The fact that we're growing additional data
structures that in theory want to be iterated in lockstep with the main bio
payload but _aren't_ iterated over with bi_iter is, at best, a code smell and a
lurking footgun.

However, I can see that the two of you are not likely take on figuring out how
to clean that up, and truthfully I don't have the time right now either, much as
it pains me.

Here's an alternative approach:

The fundamental problem with bio_rewind() (and I know that you two are super
serious that this is completely safe for your use case and no one else is going
to use it for anything else) is that we're using it to get back to some initial
state, but it's not invariant w.r.t. what's been done to the bio since then, and
the nature of the block layer is that that's a problem.

So here's what you do:

You bring back bi_done: bi_done counts bytes advanced, total, since the start
of the bio. Then we introduce a type:

struct bio_pos {
	unsigned	bi_done;
	unsigned	bi_size;
};

And two new functions:

struct bio_pos bio_get_pos(struct bio *)
{
	...
}

void bio_set_pos(struct bio *, struct bio_pos)
{
	...
}

That gets you the same functionality as bio_rewind(), but it'll be much more
broadly useful.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


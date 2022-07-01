Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30B57C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119810;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KJKsK5GJP+op35tUZsJuzplVxoFnayR3gL08tUry1sM=;
	b=K1SB3WW6X6mbRVwVFmfecqG6wohYDyPTnF5VsZgcFORAE2Jev6cbBZ5uXBVyp5EFOWQiM2
	8OKGRJC0LftgQMA4ZUgtaUbaBdsDPRSnG69gIEfGVKQPZFx2qPjcZCojuXOPHo8Ty6EcOh
	qsBBkY6qCBtXmK00r0YA9ubgNPeAfrk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-M2uDY8QcO4awKlLSxkKh9g-1; Wed, 06 Jul 2022 11:03:27 -0400
X-MC-Unique: M2uDY8QcO4awKlLSxkKh9g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8927F80D3FE;
	Wed,  6 Jul 2022 15:03:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 395CCC23DBF;
	Wed,  6 Jul 2022 15:03:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F039F1947063;
	Wed,  6 Jul 2022 15:03:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E8C1F1947058
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Jul 2022 21:09:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D951341616B; Fri,  1 Jul 2022 21:09:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D526C40336E
 for <dm-devel@redhat.com>; Fri,  1 Jul 2022 21:09:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C78D101A588
 for <dm-devel@redhat.com>; Fri,  1 Jul 2022 21:09:21 +0000 (UTC)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com
 [209.85.222.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-CYW-S9D0Ms6PIJbgZYeJ5Q-1; Fri, 01 Jul 2022 17:09:13 -0400
X-MC-Unique: CYW-S9D0Ms6PIJbgZYeJ5Q-1
Received: by mail-qk1-f177.google.com with SMTP id n10so2694524qkn.10;
 Fri, 01 Jul 2022 14:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Lmh2DXHdd9zUpt+ZM652uY0erz/sbuLnVvhvieIFyDc=;
 b=bTfIf2RuVvFX7bborlf6VBhpx3mVrv0en4mRXeIUKcK8YYlSjPmMExgY0sAo8W/f6l
 7AFHYyfN1ATPEk2w+33ML9xKkAJo3GkYWU5AEeq4L84oKhd+jzBXluu9vih0E846B7Vv
 744Aj9BI6Af1Ptr/kXj13ATpVR0Wdp6qkjfLjV4ONCt0noSWbG16CyBNhTVQo8skdIG+
 RWug7AStuxdDle/ATfqWtk6JGwVQnbbRgq9mocggq97I8lHg6eh/nYI2UYse08yz8CMU
 BGuMrnp5PUfwB117JYabQ3QTOvi6U9PCssm9WThgWr8c9XB63XCuvAyYqr0OgtnBERjs
 JQYw==
X-Gm-Message-State: AJIora9FUa/q0/7CjGkQSq9f2yS7AjIRnx3rf9U1PyPdZTaaGdZyWhab
 Ukgts9htv7vZ1iatvWeIEhgsaKu7qIvfTEc=
X-Google-Smtp-Source: AGRyM1s4APE6/bCx07qx5C96Q5YLy1DDaOjPMssv3bm12xPXOIlOiSyxNSOEQbXpq/LKeOEvrqL63Q==
X-Received: by 2002:a05:620a:44c6:b0:6b0:3757:4521 with SMTP id
 y6-20020a05620a44c600b006b037574521mr12349439qkp.655.1656709751384; 
 Fri, 01 Jul 2022 14:09:11 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 x9-20020a05620a448900b006a708baa069sm12724705qkp.101.2022.07.01.14.09.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Jul 2022 14:09:10 -0700 (PDT)
Date: Fri, 1 Jul 2022 17:09:09 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20220701210909.vgyb5ls644pldr2g@moria.home.lan>
References: <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
 <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
 <Yrs9OLNZ8xUs98OB@redhat.com>
 <20220628175253.s2ghizfucumpot5l@moria.home.lan>
 <YrvsDNltq+h6mphN@redhat.com>
 <20220629181154.eejrlfhj5n4la446@moria.home.lan>
 <YrzykX0jTWpq5DYQ@T590>
 <20220630011454.c6djuzkwsn33x7y6@moria.home.lan>
 <Yr5w6+/AAYSxcHaf@T590>
MIME-Version: 1.0
In-Reply-To: <Yr5w6+/AAYSxcHaf@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 01, 2022 at 11:58:35AM +0800, Ming Lei wrote:
> Why do we need to pay the cost(4 bytes added to bio and the updating
> in absolutely fast path) if rewind isn't used? So far, only dm requeue
> needs it, and it is one very unusual event.
> 
> Assuming fixed bio end sector should cover most of cases, especially
> if bio_rewind is only for dm or driver.
> 
> I'd suggest to not take this way until turning out bio_rewind() is not
> enough for new requirement or usages.

Well, you're proposing add this to the block layer, not just dm, so we should be
looking at potential users and not just this one use case.

Check out block/blk-crypto-fallback.c -> blk_crypto_fallback_decrypt_bio: it's
using __bio_for_each_segment, which is how I found it. It's also using a
bio_crypt_ctx they've stashed in their per-bio bio_fallback_crypt_ctx, in
blk_crypto_fallback_bio_prep, in addition to saving a copy of bio->bi_iter.

bio_crypt_ctx is 40 bytes, struct bvec_iter is currently 20 bytes, so we'd be
replacing 60 bytes of per-bio state with 8 bytes, if we went with bio_pos. And
this code path is used by block/blk-crypto.c as well, not just
blk-crypto-fallback.c.

drivers/md/dm-integrity.c: Again, we're saving a bvec_iter (using
dm_bio_record()) so that after the bio completes we can walk through the bio as
it was when we submitted it. Here, we're also interested in bi_integrity, but
what dm_bio_record() is doing looks highly suspect - we're only saving a copy of
the bio->bi_integrity pointer, but bio_integrity_payload contains another
bvec_iter and that's probably what should be getting saved.

So for this code, switching bio_(get|set)_pos would likely either be eliminating
the need for a tricky workaround I haven't spotted yet, or perhaps fixing an
actual bug - and it'd be saving 20 bytes of state in dm_bio_details.

Side note: according to the comment in dm_bio_details, what that code is trying
to do is actually something rather interesting - fully restore the state of a
bio so it can be resubmitted to another device after an error. This is probably
something that's worth promoting to block/bio.c, so it can be kept in sync with
e.g. bio_init() and bio_reset, and because we have other code in the kernel
that's doing similar stuff and might want to make use of it if it was standard
(btrfs, bcachefs, md-multipath, perhaps aoe).

drivers/block/aoe/aoecmd.c: here we're also saving bvec_iter, but this code is
doing a different trick that it's able to do because it's not submitting the bio
to other block drivers, the terminal handling is in its own code. It's not
modifying bio->bi_iter at all, which is neat because it makes resubmitting after
an error trivial.

This code is smart, and I would consider it a vote in favor of the bio_iter
approach (but see below, I'm not actually advocating we do that). I do something
similar in bcachefs, my read retry path: the original bio may have been
fragmented, and a retry may be for only a fragment of an original bio. Having a
separate bvec_iter means that the retry path can submit a retry for only a
fragment of the original bio, without having to mutate it or race with other
threads that are doing things with other parts of the original bio. It's not
strictly necessary functionality - I could've also solved this by not freeing
the fragment and retrying that - but it kept things simpler in other ways (the
retry may itself end up being fragmented if the extents we're reading from
changed, which means in the normal read path fragment bch_read_bios only ever
point to toplevel bch_read_bios, but retrying fragment bch_read_bios would mean
when doing retries we'd have fragments pointing to fragments pointing to
fragments, and memory allocations bounded only by the maximum number of retries
we could do).

So the struct bio_iter approach - segregating all the things we mutate when
iterating over a bio into a sub-type, i.e. what I was originally doing with
bvec_iter - has some nice and useful properties, but OTOH with integrity and now
bio_crypt_ctx it doesn't look super practical anymore - bio_iter would always
have to contain whatever it is we need for iterating over crypt and integrity if
those features are #ifdef'd in, whereas now an individual bio only pays the
memory overhead for those features if they're in use.

OTOH, looking at actual code, bio_(get|set)_pos gets us 90% of the elegance of a
separate iterator type, and it works for what all the code I've looked at is
trying to do (except for bcachefs, but I have no interest in blk crypt or
integrity so I'm fine with the current situation).

That's just what I found with a bit of perusing - there's other things I'd want
to look at if I wanted to be thorough (anything with multipath in the name for
sure, I haven't looked at all at the nvme multipath code yet).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


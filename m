Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C4CC43334
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 04:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658808838;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PZWs3W676YfjNNxUoeO4QjXHDPeyUqjJ9f0El2iZoKU=;
	b=X7aB3ccbeIyfz2XtbfyOSgTALRE9zi2YU28cWEq68IM0mXiF9/KBo9SehYdIaYNpZfHMTA
	UKeipgNeuGbC6cVX2skhgKt5R6c7nni973xHXfposd0J2IvpW5Uyz1NQa9wGGpxfZ6gx6z
	N3nvEiCfLHRsGCZ///MllmXaY6zowmo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-yc7jcC8LMb-D5BKS8geVYg-1; Tue, 26 Jul 2022 00:13:54 -0400
X-MC-Unique: yc7jcC8LMb-D5BKS8geVYg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FE0F101A588;
	Tue, 26 Jul 2022 04:13:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D3D5B2026D64;
	Tue, 26 Jul 2022 04:13:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 504491945D88;
	Tue, 26 Jul 2022 04:13:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C43CB1945D86
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 04:13:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A80E22026D07; Tue, 26 Jul 2022 04:13:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A44AE2026D64
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 04:13:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86C663C0ED48
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 04:13:49 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-d-6Crq65PkiSPnHzy6TLgg-1; Tue, 26 Jul 2022 00:13:39 -0400
X-MC-Unique: d-6Crq65PkiSPnHzy6TLgg-1
Received: by mail-qk1-f200.google.com with SMTP id
 bl27-20020a05620a1a9b00b0069994eeb30cso11223809qkb.11
 for <dm-devel@redhat.com>; Mon, 25 Jul 2022 21:13:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5lntECexEyNpXWdt23OJngoZd0SrPa0OPt4d0XLP3io=;
 b=rZBSRRmWfgOzp3Or2UBdrsJGrATPLa7aWuFWGatYKz7N0L/aK0v0CdQNSr3hjSm2Ur
 nAJRyojotgM/YWipOqj80vfhBNuIyP10d6z+xUlDIDtpvT32gJs/FLtSDud42t6PGU0R
 3suzjoSmjabpS9nG/ggh2rgrnQFeIeFVQ+LONGSMce6C2oL4IDOzBn0mJjeT0MMtUiO1
 mLjUWyDVf8BnASs5BAxn8xcpep/gKsUGnNBb6Hb08oWGQ3/dEno+yp47J9+J8WKmgmAf
 W4p0ZbijUN/tGMzY+3cp4bNN9W4omh1FSy8LyXj60qMSsZob2la6izbnMXEmEPsO1l17
 goTA==
X-Gm-Message-State: AJIora+BwSVMoBPqRX3+iAM8p4A4ARTNv77OYhUDRWpLXYUKXmnsxzMR
 uBVBUKls/9nZO1ajcAx5IpaX11nCLyaRg6E6cXqcsEmPU8FOljWlUTR22T863E7AorZX2Vp6eWr
 xHbO+arqtcONFEA==
X-Received: by 2002:a05:620a:2405:b0:6b6:1706:3bcc with SMTP id
 d5-20020a05620a240500b006b617063bccmr11435718qkn.92.1658808818852; 
 Mon, 25 Jul 2022 21:13:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vt1Wg+374rShiULPVsZdaORIIEaTUiexr2fiXazKlx6twVcTzPKaaHpero0NwP8BXrP+CeSg==
X-Received: by 2002:a05:620a:2405:b0:6b6:1706:3bcc with SMTP id
 d5-20020a05620a240500b006b617063bccmr11435711qkn.92.1658808818639; 
 Mon, 25 Jul 2022 21:13:38 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 i4-20020a05620a248400b006b59ddb4bc5sm10344597qkn.84.2022.07.25.21.13.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Jul 2022 21:13:38 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:13:37 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <Yt9p8VupWC0ZlFv4@redhat.com>
References: <20220722093823.4158756-1-nhuck@google.com>
 <20220722093823.4158756-4-nhuck@google.com>
 <Yt9KTzXUeA8xAiGv@redhat.com> <Yt9aGRXNNPGZFvld@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <Yt9aGRXNNPGZFvld@sol.localdomain>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 3/3] dm-verity: Add try_verify_in_tasklet
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
Cc: Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Nathan Huckleberry <nhuck@google.com>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Alasdair Kergon <agk@redhat.com>
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

On Mon, Jul 25 2022 at 11:06P -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

> On Mon, Jul 25, 2022 at 09:58:39PM -0400, Mike Snitzer wrote:
> > 
> > > @@ -1156,7 +1217,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
> > >  		goto bad;
> > >  	}
> > >  
> > > -	v->tfm = crypto_alloc_ahash(v->alg_name, 0, 0);
> > > +	v->tfm = crypto_alloc_ahash(v->alg_name, 0, CRYPTO_ALG_ASYNC);
> > >  	if (IS_ERR(v->tfm)) {
> > >  		ti->error = "Cannot initialize hash function";
> > >  		r = PTR_ERR(v->tfm);
> > 
> > This hunk that adds the CRYPTO_ALG_ASYNC flag _seems_ unrelated.
> 
> I believe it's needed to ensure that only a synchronous algorithm is allocated,
> so that verity_hash_update() doesn't have to sleep during the tasklet.  It
> should be conditional on v->use_tasklet, though.

Ah yes, it is a mask, that makes sense.

I can now see why it was being set unconditionally given dm-verity's
optional ctr args aren't processed until after the crypto_alloc_ahash() call. 
And of course verity_parse_opt_args() depends on non-optional args
related to the tfm.... gah!

Do you have a sense for what the implications are for always setting
CRYPTO_ALG_ASYNC like Nathan had? Will it disallow certain tfm that
may already be in use by some users?

> > @@ -321,14 +320,12 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
> >  		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
> >  				  v->digest_size) == 0))
> >  			aux->hash_verified = 1;
> > -		else if (io->in_tasklet) {
> > +		else if (io->in_tasklet)
> >  			/*
> >  			 * FEC code cannot be run in a tasklet since it may
> > -			 * sleep.  We need to resume execution in a work-queue
> > -			 * to handle FEC.
> > +			 * sleep, so fallback to using a work-queue.
> >  			 */
> >  			return -EAGAIN;
> > -		}
> 
> 
> Doesn't this need to be:
> 
> 			r = -EAGAIN;
> 			goto release_ret_r;

Yes, good catch.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


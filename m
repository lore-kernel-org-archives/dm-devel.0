Return-Path: <SRS0=mcEr=MU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3655C432BE
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 16:19:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4146960F93
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 16:19:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4146960F93
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627489190;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LxTjbqeK5PQK4EnsX6Glj6OeiSBxpN5A7duSaLLKKso=;
	b=Fy0FrRxiTfeXRj9ySsWtkE+r1pS0sPBRgYuFcY/2nb1OmQuKojb9ckn4KaXbeR843ZeiTd
	TaPTvbisOaKCrY/Hxv5MzHuTWl+TSpPODMrr7pehIaoAeREOw7/MAnCOqAn+tN9zuATSQx
	FoO4jhYKvh1pUFyc6tSvZFEverhs0rg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-4j_8_t0oNAK5kLuyn4rltg-1; Wed, 28 Jul 2021 12:19:48 -0400
X-MC-Unique: 4j_8_t0oNAK5kLuyn4rltg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07038760C4;
	Wed, 28 Jul 2021 16:19:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BB5D5D9FC;
	Wed, 28 Jul 2021 16:19:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EAC354BB7C;
	Wed, 28 Jul 2021 16:19:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16SGHsOU020169 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Jul 2021 12:17:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B1CC920285DE; Wed, 28 Jul 2021 16:17:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ACD80202863A
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 16:17:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5CAC18812CC
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 16:17:51 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
	[209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-427-16tQL8FXNSe0RFjiWG8j5g-1; Wed, 28 Jul 2021 12:17:50 -0400
X-MC-Unique: 16tQL8FXNSe0RFjiWG8j5g-1
Received: by mail-qk1-f198.google.com with SMTP id
	13-20020a370e0d0000b02903a5eee61155so1928125qko.9
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 09:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Zr6iO5EfhirdLS6EThCnFQV2o1b+d2YY8eAPyEtxmt4=;
	b=mxnVxJvsoo0szRY12J8sTzjIY70JjMPzNWdV21aAc6C+EUlTufIb6bAJP9Jr4rrUnN
	JmErvSFhQYW62yEA5rCul8+0LIzZAgBLveBzw3RStkBIUAow2zHYsru/6nkGkto1vzyf
	oA6j0r6JK7Bnle+XrOd+gKndZhfjPC81uwnUFRYe2sc2m7I1ZeK12FLyIX+0aZk758Fn
	45IkqWZ3SvIFAXV9Q87WxaRzaE208iUU9TQL/2VcxMKJOSTgn2Xlk8MkH2wJ1/BjyWMQ
	BcrbTQZnisr/M4ru4zh63GekJBwI+eozYkQg7bbAorqRO1tzQJGFMbiFLguEaLHWHqVq
	jySQ==
X-Gm-Message-State: AOAM530gmlaOon5k0uu99aCn2ePVIvpWT24SiVsnJ0MScz2Y5cMN4klR
	nwgXqf8xX0hCoSBNxWfoqFfL3t+EHERB4f/k4GyAXTXU/hSFYJ9mUi3oqBKUDtwusFCtKP+g1vg
	UZc5Hr/bWJVTn8g==
X-Received: by 2002:ac8:4f14:: with SMTP id b20mr316077qte.236.1627489069715; 
	Wed, 28 Jul 2021 09:17:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq/FUgQMZBFspmTaanQXJhzUXM+wyidC3InkD7kOm5mOKJeD1mRH+Pq0A4ZiaR+yacRvY5Xg==
X-Received: by 2002:ac8:4f14:: with SMTP id b20mr316061qte.236.1627489069494; 
	Wed, 28 Jul 2021 09:17:49 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id d4sm141513qty.15.2021.07.28.09.17.48
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 28 Jul 2021 09:17:49 -0700 (PDT)
Date: Wed, 28 Jul 2021 12:17:48 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <YQGDLIbefYvSHJqi@redhat.com>
References: <20210725055458.29008-1-hch@lst.de> <YQAtNkd8T1w/cSLc@redhat.com>
	<20210727160226.GA17989@lst.de> <YQAxyjrGJpl7UkNG@redhat.com>
	<9c719e1d-f8da-f1f3-57a9-3802aa1312d4@gmail.com>
MIME-Version: 1.0
In-Reply-To: <9c719e1d-f8da-f1f3-57a9-3802aa1312d4@gmail.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] use regular gendisk registration in device mapper
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 27 2021 at  4:38P -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 27/07/2021 18:18, Mike Snitzer wrote:
> > On Tue, Jul 27 2021 at 12:02P -0400,
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> >> On Tue, Jul 27, 2021 at 11:58:46AM -0400, Mike Snitzer wrote:
> >>>> This did not make a different to my testing
> >>>> using dmsetup and the lvm2 tools.
> >>>
> >>> I'll try these changes running through the lvm2 testsuite.
> >>
> >> Btw, is ther documentation on how to run it somewhere?  I noticed
> >> tests, old-tests and unit-tests directories, but no obvious way
> >> to run them.
> > 
> > I haven't tracked how it has changed in a while, but I always run:
> > make check_local
> > 
> > (but to do that you first need to ./configure how your distro does
> > it... so that all targets are enabled, etc. Then: make).
> > 
> > Will revisit this shortly and let you know if my process needed to
> > change at all due to lvm2 changes.
> 
> BTW it would be also nice to run cryptsetup testsuite as root - we do a lot
> of DM operations there (and we depend on sysfs on some places).
> 
> You can just run configure, make and then make check.

Once I installed all deps, I got all but one passing with Christoph's changes:

Block_size: 512, Data_size: 256000B, FEC_roots: 9, Corrupted_bytes: 4 [no-superblock][one_device_test]Usage: lt-veritysetup [-?Vv] [-?|--help] [--usage] [-V|--version]
        [--cancel-deferred] [--check-at-most-once] [--data-block-size=bytes]
        [--data-blocks=blocks] [--debug] [--deferred] [--fec-device=path]
        [--fec-offset=bytes] [--fec-roots=bytes] [--format=number]
        [-h|--hash string] [--hash-block-size=bytes] [--hash-offset=bytes]
        [--ignore-corruption] [--ignore-zero-blocks] [--no-superblock]
        [--panic-on-corruption] [--restart-on-corruption]
        [--root-hash-file=STRING] [--root-hash-signature=STRING]
        [-s|--salt hex string] [--uuid=STRING] [-v|--verbose]
        [OPTION...] <action> <action-specific>
-s=e48da609055204e89ae53b655ca2216dd983cf3cb829f34f63a297d106d53e2d: unknown option
[N/A, test skipped]
FEC repair failed
FAILED backtrace:
500 ./verity-compat-test
FAIL: verity-compat-test

Seems like a test bug.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


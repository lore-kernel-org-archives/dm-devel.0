Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16618C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:01:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6243D64E42
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:01:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6243D64E42
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-mGO6ErS5O7GW2pvCbOIeDw-1; Thu, 11 Feb 2021 18:01:01 -0500
X-MC-Unique: mGO6ErS5O7GW2pvCbOIeDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B50F1005501;
	Thu, 11 Feb 2021 23:00:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA3845C260;
	Thu, 11 Feb 2021 23:00:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A81A958074;
	Thu, 11 Feb 2021 23:00:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BMwq79005016 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 17:58:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5C2B12166B34; Thu, 11 Feb 2021 22:58:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56A1B2166B31
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 22:58:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C008E185A79B
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 22:58:44 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
	[209.85.215.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-575-O4ADoKZuOlKyeYGJu4e0sg-1; Thu, 11 Feb 2021 17:58:42 -0500
X-MC-Unique: O4ADoKZuOlKyeYGJu4e0sg-1
Received: by mail-pg1-f169.google.com with SMTP id n10so4984842pgl.10
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 14:58:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=amreorW5Wp+rgEfeKxxFdgVmmwkgOKq0HeoNDJfuGV4=;
	b=ASE6gDARilTnV+JWNFTfoAoroGMrc+VrVWIJ1M0Erk2XsMaaDDYI+lNlp3JpDLrG7P
	9x6tW1c9OKw/X7gHFLPcALpQD076qYMLKTEQDc7aHP2722unbdebUe/+79/N4EhoY0S4
	zuL3ghSdWtfvzKEZE+Uth/4Lusf/DNv3wwPVLvVaEebWUgTvjbS3XS7GvFwfVGTga7AD
	Iu5Tz09bD3uL46NMamkBjFcj/wcs+cfZXrdAzx8bmAurK/x3+ThWLk1//2c0IETK3DFC
	BKg90Hds/Gihf9rn6tMVbbfTQ9p5CieIfzLB7WjJivZnNVOFRoRlAXx4zb/CRzxuIgun
	cN6g==
X-Gm-Message-State: AOAM530Kqg1+rYFXyyFRbouUVA+5Hihpity5ve9jwqTaQh1EPBK/mb3M
	wVUqpoKqfRpoJu8hRDS84UZVig==
X-Google-Smtp-Source: ABdhPJyoyyDeZHN2igF/Aa4CBWlQghor7IDCot2l7wTM7pQVHEvTAoANtTfktIz6cSZNPRruC+6nHQ==
X-Received: by 2002:a63:fe13:: with SMTP id p19mr370840pgh.119.1613084321254; 
	Thu, 11 Feb 2021 14:58:41 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com.
	[34.82.60.139]) by smtp.gmail.com with ESMTPSA id
	o14sm7499206pgr.44.2021.02.11.14.58.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 11 Feb 2021 14:58:40 -0800 (PST)
Date: Thu, 11 Feb 2021 22:58:37 +0000
From: Satya Tangirala <satyat@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <YCW2nWmHCunU1DwV@google.com>
References: <20210201051019.1174983-1-satyat@google.com>
	<20210201051019.1174983-4-satyat@google.com>
	<YCQ/WjAsVA2gdb7d@gmail.com>
MIME-Version: 1.0
In-Reply-To: <YCQ/WjAsVA2gdb7d@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 3/5] dm: add support for passing through
 inline crypto support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 10, 2021 at 12:17:30PM -0800, Eric Biggers wrote:
> On Mon, Feb 01, 2021 at 05:10:17AM +0000, Satya Tangirala wrote:
> > Update the device-mapper core to support exposing the inline crypto
> > support of the underlying device(s) through the device-mapper device.
> > 
> > This works by creating a "passthrough keyslot manager" for the dm
> > device, which declares support for encryption settings which all
> > underlying devices support.  When a supported setting is used, the bio
> > cloning code handles cloning the crypto context to the bios for all the
> > underlying devices.  When an unsupported setting is used, the blk-crypto
> > fallback is used as usual.
> > 
> > Crypto support on each underlying device is ignored unless the
> > corresponding dm target opts into exposing it.  This is needed because
> > for inline crypto to semantically operate on the original bio, the data
> > must not be transformed by the dm target.  Thus, targets like dm-linear
> > can expose crypto support of the underlying device, but targets like
> > dm-crypt can't.  (dm-crypt could use inline crypto itself, though.)
> > 
> > A DM device's table can only be changed if the "new" inline encryption
> > capabilities are a (*not* necessarily strict) superset of the "old" inline
> > encryption capabilities.  Attempts to make changes to the table that result
> > in some inline encryption capability becoming no longer supported will be
> > rejected.
> > 
> > For the sake of clarity, key eviction from underlying devices will be
> > handled in a future patch.
> > 
> > Co-developed-by: Eric Biggers <ebiggers@google.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Signed-off-by: Satya Tangirala <satyat@google.com>
> 
> I don't see any obvious issues with this latest version.  I assume you've tested
> it on real hardware?
> 
> If it's needed despite my Co-developed-by, feel free to add:
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> 
> A few nits about comments, in case you resend:
> 
Thanks! I addressed the nits, added acked/reviewed-bys and resent v5.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


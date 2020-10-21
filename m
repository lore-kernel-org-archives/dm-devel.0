Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D4CC2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:21:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E8016222EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:21:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8016222EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-NESMkeRbNG2NmC9vQdX2oQ-1; Mon, 26 Oct 2020 03:21:30 -0400
X-MC-Unique: NESMkeRbNG2NmC9vQdX2oQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89FA08049D0;
	Mon, 26 Oct 2020 07:21:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A5085C1A3;
	Mon, 26 Oct 2020 07:21:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3FFAB92F27;
	Mon, 26 Oct 2020 07:21:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09L5S8sM021787 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Oct 2020 01:28:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B41DA2018034; Wed, 21 Oct 2020 05:28:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC5E0203B866
	for <dm-devel@redhat.com>; Wed, 21 Oct 2020 05:28:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D47C858294
	for <dm-devel@redhat.com>; Wed, 21 Oct 2020 05:28:05 +0000 (UTC)
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com
	[209.85.214.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-434-t-blV2NeMLWkvli2sMqlPg-1; Wed, 21 Oct 2020 01:28:01 -0400
X-MC-Unique: t-blV2NeMLWkvli2sMqlPg-1
Received: by mail-pl1-f193.google.com with SMTP id bf6so626095plb.4
	for <dm-devel@redhat.com>; Tue, 20 Oct 2020 22:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=7GB5y84r6xMSGeFUmcejHOzMFE3WByKQWJdu7wCKtTc=;
	b=R0X3RIws8ru/wvwDO4KGIXcKFRyihbF81iMnB8s92e3F093X/agDsnG4pbsdnQ9Qa/
	PCRr71Qt5TmuGCeyfljYiHsIHIz003sGKcodpZumRm3lQyT9nfbcOLeiCacOV0q5hl+0
	uRPpgIapJGSZ7S4x0azkVH7ntcI4TVRtsUd30SupXB2IGGgb/XBpjae0T9zbdM4FfifB
	PMJ7jhYArWIMWXQG2TlgD+hhrlLE8TTAXwpw+VFyTlvgmh84VSOvbzFWmUIaDnlSjobc
	DZbYsinAz4GeasdYA1mDRPhjJcE2yC1mEavxLMERz5UWy6jPICfizq1waSX2kb6DbYyS
	JDJw==
X-Gm-Message-State: AOAM532AkJq/bmUO3e9QcBnAo+WO86/9zp41h8W88UOpl9KWfRkanj2e
	2wDwHLW+aSb0fBHQDIl9ik2T3g==
X-Google-Smtp-Source: ABdhPJz/C1gaOL5hjy8zFTXccY3UyWJy8F9I2GVGOtdTnA9WyL1I4Sz6zoWRWPflnNBRW2alRjjx8A==
X-Received: by 2002:a17:902:c697:b029:d3:df24:163e with SMTP id
	r23-20020a170902c697b02900d3df24163emr1837466plx.18.1603258080533;
	Tue, 20 Oct 2020 22:28:00 -0700 (PDT)
Received: from google.com (154.137.233.35.bc.googleusercontent.com.
	[35.233.137.154]) by smtp.gmail.com with ESMTPSA id
	194sm713228pfz.182.2020.10.20.22.27.58
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 20 Oct 2020 22:27:59 -0700 (PDT)
Date: Wed, 21 Oct 2020 05:27:55 +0000
From: Satya Tangirala <satyat@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <20201021052755.GA1165871@google.com>
References: <20201015214632.41951-1-satyat@google.com>
	<20201015214632.41951-2-satyat@google.com>
	<20201016072044.GB14885@infradead.org>
	<20201021044423.GB3939@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <20201021044423.GB3939@sol.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:18 -0400
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/4] block: keyslot-manager: Introduce
 passthrough keyslot manager
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

On Tue, Oct 20, 2020 at 09:44:23PM -0700, Eric Biggers wrote:
> On Fri, Oct 16, 2020 at 08:20:44AM +0100, Christoph Hellwig wrote:
> > And this just validates my argument that calling the inline crypto work
> > directly from the block layer instead of just down below in blk-mq was
> > wrong.  We should not require any support from stacking drivers at the
> > keyslot manager level.
> 
> I'm not sure what you're referring to here; could you clarify?
> 
> It's true that device-mapper devices don't need the actual keyslot management.
> But they do need the ability to expose crypto capabilities as well as a key
> eviction function.  And those are currently handled by
> "struct blk_keyslot_manager".  Hence the need for a "passthrough keyslot
> manager" that does those other things but not the actual keyslot management.
> 
> FWIW, I suggested splitting these up, but you disagreed and said you wanted the
> crypto capabilities to remain part of the blk_keyslot_manager
> (https://lkml.kernel.org/linux-block/20200327170047.GA24682@infradead.org/).
> If you've now changed your mind, please be clear about it.
> 
I thought what Christoph meant (and of course, please let us know
if I'm misunderstanding you, Christoph) was that if blk-mq
handled all the blk-crypto stuff including deciding whether to
use the blk-crypto-fallback, and blk-mq was responsible for
calling out to blk-crypto-fallback if required, then the device
mapper wouldn't need to expose any capabilities at all... or at
least not for bio-based device mapper devices, since bios would
go through the device mapper and eventually hit blk-mq which
would then handle crypto appropriately.

We couldn't do that because the crypto ciphers for the
blk-crypto-fallback couldn't be allocated on the data path (so we
needed fscrypt to ask blk-crypto to check whether the underlying
device supported the crypto capabilities it required, and
allocate ciphers appropriately, before the data path required the
ciphers). I'm checking to see if anything has changed w.r.t
allocating crypto ciphers on the data path (and checking if
memalloc_noio_save/restore() helps with that).
> - Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


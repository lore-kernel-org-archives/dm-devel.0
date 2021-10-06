Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12B1C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 19:33:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 508A161184
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 19:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 508A161184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-2wf0G4rZMiGH6lTYNI-0cQ-1; Wed, 06 Oct 2021 15:33:07 -0400
X-MC-Unique: 2wf0G4rZMiGH6lTYNI-0cQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB8F1835DE1;
	Wed,  6 Oct 2021 19:33:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5353A5D9C6;
	Wed,  6 Oct 2021 19:33:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 328194EA2A;
	Wed,  6 Oct 2021 19:33:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196JJrkI016353 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 15:19:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3CEEE2166B46; Wed,  6 Oct 2021 19:19:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 379682166B40
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 19:19:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CF68811E76
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 19:19:53 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-277-D3QMgBv5O_eNikwXnBtkuQ-1;
	Wed, 06 Oct 2021 15:19:51 -0400
X-MC-Unique: D3QMgBv5O_eNikwXnBtkuQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB8EF60E08;
	Wed,  6 Oct 2021 19:19:49 +0000 (UTC)
Date: Wed, 6 Oct 2021 12:19:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Message-ID: <YV321JFYV/u7pbsO@gmail.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
	<20210929163600.52141-4-ebiggers@kernel.org>
	<YV2kdHeS4GTXUdpi@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YV2kdHeS4GTXUdpi@redhat.com>
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
Cc: Satya Tangirala <satyaprateek2357@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v4 3/4] blk-crypto: rename
 blk_keyslot_manager to blk_crypto_profile
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

On Wed, Oct 06, 2021 at 09:28:20AM -0400, Mike Snitzer wrote:
> On Wed, Sep 29 2021 at 12:35P -0400,
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > blk_keyslot_manager is misnamed because it doesn't necessarily manage
> > keyslots.  It actually does several different things:
> > 
> >   - Contains the crypto capabilities of the device.
> > 
> >   - Provides functions to control the inline encryption hardware.
> >     Originally these were just for programming/evicting keyslots;
> >     however, new functionality (hardware-wrapped keys) will require new
> >     functions here which are unrelated to keyslots.  Moreover,
> >     device-mapper devices already (ab)use "keyslot_evict" to pass key
> >     eviction requests to their underlying devices even though
> >     device-mapper devices don't have any keyslots themselves (so it
> >     really should be "evict_key", not "keyslot_evict").
> > 
> >   - Sometimes (but not always!) it manages keyslots.  Originally it
> >     always did, but device-mapper devices don't have keyslots
> >     themselves, so they use a "passthrough keyslot manager" which
> >     doesn't actually manage keyslots.  This hack works, but the
> >     terminology is unnatural.  Also, some hardware doesn't have keyslots
> >     and thus also uses a "passthrough keyslot manager" (support for such
> >     hardware is yet to be upstreamed, but it will happen eventually).
> > 
> > Let's stop having keyslot managers which don't actually manage keyslots.
> > Instead, rename blk_keyslot_manager to blk_crypto_profile.
> > 
> > This is a fairly big change, since for consistency it also has to update
> > keyslot manager-related function names, variable names, and comments --
> > not just the actual struct name.  However it's still a fairly
> > straightforward change, as it doesn't change any actual functionality.
> > 
> > Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Unfortunate how fiddley this change forced you to get but it looks
> like you've done a very solid job of cleaning it all up to be
> consistent.
> 
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>
> 

Thanks for the reviews!  Yes, we should have done it this way originally which
would have saved some pain, but better late than never.

Jens, anything else you're waiting for before applying this series?  Note that
I'm not sure that Satya will leave any feedback, given that he's no longer
working for Google, so any kernel work he does is in his free time.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


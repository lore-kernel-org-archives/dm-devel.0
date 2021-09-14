Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8617C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 06:50:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 43B986120D
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 06:50:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 43B986120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-FnGUDI1eO_2DO_Hj4Eawcw-1; Thu, 16 Sep 2021 02:50:15 -0400
X-MC-Unique: FnGUDI1eO_2DO_Hj4Eawcw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D7431800D41;
	Thu, 16 Sep 2021 06:50:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC51010023B0;
	Thu, 16 Sep 2021 06:50:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A707D4EA2F;
	Thu, 16 Sep 2021 06:50:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18E959Uo018097 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 14 Sep 2021 05:05:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C9231201B075; Tue, 14 Sep 2021 09:05:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0581203394F
	for <dm-devel@redhat.com>; Tue, 14 Sep 2021 09:05:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9702291C7C8
	for <dm-devel@redhat.com>; Tue, 14 Sep 2021 09:05:01 +0000 (UTC)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com
	[209.85.208.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-368-TliK8iz0Mlu_u6JBBsOCeg-1; Tue, 14 Sep 2021 05:04:58 -0400
X-MC-Unique: TliK8iz0Mlu_u6JBBsOCeg-1
Received: by mail-lj1-f182.google.com with SMTP id w4so22424145ljh.13
	for <dm-devel@redhat.com>; Tue, 14 Sep 2021 02:04:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=hJGnWAchz/HDqF7HydjX2fUZvRJTYMKYHvyvKYF6LTA=;
	b=NwToJBRhdJ6cnmUauE+XYKQIhbFdfMao6u1Ebgz+u2o25FosTdTa9giuU/qmBTRtjO
	1a0iqKKYaj93n63Jt0N6O8xuLJc0Oiw/7VDfkwyY/bXBFoff8Bdwb/8WjUqeOYtHM4fE
	c1l94tTlaZtvsImPcufBIoWZ5emxPLQwFizJp9q5Eoc9+FONSfs4UTwQ38MAzqHzKg5b
	RzBMMsYwaElNfD998aXJMyWv3X1J4ORFREP3VP+JLol9JgymoG1aEN9v1Lxe2NMnxGpt
	zf1tvUs4IvnpScJBhiUGknYi0IHlutDqCVGAfvM9eDUfWs6g6InNB53gBMxzJ5ySF/F/
	HR7g==
X-Gm-Message-State: AOAM532cJeHN23MoZvp4ZxSD4/VM1rMRvny8iMdFQpqIeQeTEaQUoP7D
	9+/GPpDWRHak30H50x0WhpEjSmECgalItMPdl3M2Yg==
X-Google-Smtp-Source: ABdhPJxZC/j49j+CcIzIqzNYUN//TpHs73k6VRwmbWS0R4xoDibBWk/HYQNi25ajG7KIqw46sDy4K+S8GNnu6KTzYqE=
X-Received: by 2002:a2e:960c:: with SMTP id v12mr14672590ljh.300.1631610296769;
	Tue, 14 Sep 2021 02:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210913013135.102404-1-ebiggers@kernel.org>
	<20210913013135.102404-5-ebiggers@kernel.org>
In-Reply-To: <20210913013135.102404-5-ebiggers@kernel.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 14 Sep 2021 11:04:20 +0200
Message-ID: <CAPDyKFpvZAQ+5niZkw2tk-q_6w=VAuK=P-OVGjQA7QbJW7OvgQ@mail.gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
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
X-Mailman-Approved-At: Thu, 16 Sep 2021 02:50:07 -0400
Cc: linux-block <linux-block@vger.kernel.org>,
	Satya Tangirala <satyaprateek2357@gmail.com>,
	dm-devel@redhat.com, linux-mmc <linux-mmc@vger.kernel.org>,
	linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 4/5] blk-crypto: rename blk_keyslot_manager
	to blk_crypto_profile
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 13 Sept 2021 at 03:35, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> blk_keyslot_manager is misnamed because it doesn't necessarily manage
> keyslots.  It actually does several different things:
>
>   - Contains the crypto capabilities of the device.
>
>   - Provides functions to control the inline encryption hardware.
>     Originally these were just for programming/evicting keyslots;
>     however, new functionality (hardware-wrapped keys) will require new
>     functions here which are unrelated to keyslots.  Moreover,
>     device-mapper devices already (ab)use "keyslot_evict" to pass key
>     eviction requests to their underlying devices even though
>     device-mapper devices don't have any keyslots themselves (so it
>     really should be "evict_key", not "keyslot_evict").
>
>   - Sometimes (but not always!) it manages keyslots.  Originally it
>     always did, but device-mapper devices don't have keyslots
>     themselves, so they use a "passthrough keyslot manager" which
>     doesn't actually manage keyslots.  This hack works, but the
>     terminology is unnatural.  Also, some hardware doesn't have keyslots
>     and thus also uses a "passthrough keyslot manager" (support for such
>     hardware is yet to be upstreamed, but it will happen eventually).
>
> Let's stop having keyslot managers which don't actually manage keyslots.
> Instead, rename blk_keyslot_manager to blk_crypto_profile.
>
> This is a fairly big change, since for consistency it also has to update
> keyslot manager-related function names, variable names, and comments --
> not just the actual struct name.  However it's still a fairly
> straightforward change, as it doesn't change any actual functionality.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/blk-crypto-fallback.c        |  60 ++--
>  block/blk-crypto-profile.c         | 518 ++++++++++++++---------------
>  block/blk-crypto.c                 |  25 +-
>  block/blk-integrity.c              |   2 +-
>  drivers/md/dm-core.h               |   2 +-
>  drivers/md/dm-table.c              | 168 +++++-----
>  drivers/md/dm.c                    |   8 +-
>  drivers/mmc/core/crypto.c          |  11 +-
>  drivers/mmc/host/cqhci-crypto.c    |  31 +-
>  drivers/scsi/ufs/ufshcd-crypto.c   |  32 +-
>  drivers/scsi/ufs/ufshcd-crypto.h   |   9 +-
>  drivers/scsi/ufs/ufshcd.c          |   2 +-
>  drivers/scsi/ufs/ufshcd.h          |   4 +-
>  include/linux/blk-crypto-profile.h | 164 +++++----
>  include/linux/blkdev.h             |  18 +-
>  include/linux/device-mapper.h      |   4 +-
>  include/linux/mmc/host.h           |   2 +-
>  17 files changed, 548 insertions(+), 512 deletions(-)
>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC

[...]

Kind regards
Uffe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


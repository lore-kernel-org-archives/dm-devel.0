Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7FDC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:32:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D8B2961075
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:32:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D8B2961075
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633527126;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UWh6xMgedLncpsMJQyY8BfhX3KZAmQVOWcXXRqPZpaA=;
	b=U1YbO++UrmRQcMphi4OHFX2zjsINFHfNfRwNBiSnelbsUtVvhxHwL0unMv1qBUceRjb/0g
	NzVxe56K01KNaeogfhKNS0G9UbLOzk5Rj6UN7gwZpRJa6tvaiyx4eEVtGYVKJFRRRSmd/f
	mITFweafsm0OFFx5fFrSVFakSnhzzms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-eLdBzYq4Mue67EKvcAZV2Q-1; Wed, 06 Oct 2021 09:32:03 -0400
X-MC-Unique: eLdBzYq4Mue67EKvcAZV2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9AE810168CE;
	Wed,  6 Oct 2021 13:31:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C01B45F4EE;
	Wed,  6 Oct 2021 13:31:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97A594E9F4;
	Wed,  6 Oct 2021 13:31:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196DSViS014912 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 09:28:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2CFB52026D64; Wed,  6 Oct 2021 13:28:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28FB22026D48
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:28:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0644805C1D
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:28:22 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-58-LAq0YU5dMOCtYQZ0KI-F_A-1; Wed, 06 Oct 2021 09:28:21 -0400
X-MC-Unique: LAq0YU5dMOCtYQZ0KI-F_A-1
Received: by mail-qt1-f197.google.com with SMTP id
	r13-20020ac86d2d000000b002a755d36425so2261660qtu.14
	for <dm-devel@redhat.com>; Wed, 06 Oct 2021 06:28:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=1tJD1MyAZSMlO+w5dHejgDl1BZyQkw7PrMG9J/BwPx4=;
	b=wRqjdlw9tjOdL7/xO3R5DRC5u1YANzRqtpTK6TJo23Aj9QL3I0ofb+BGrm1nSDtinQ
	LovrzhMnIbXLr6e9TwRc8jrjpQhZ2uUOdT+wV1dw5L8OydFtFstmJHCp6MBPle3QDwwv
	krS53rVkzI+Txh6OU6fidA0JpuNzaaEvw7pTm56at1oHSkT68b9sJORjznBynIenYdLF
	qaNBh0MbF9t38zPMdrqIp5htpk5+l3/6KMQxKiTeCV9uBxVGglSWSUeL8puiX9ZEPYvb
	vEGVeFOAFj04ycudUxMHCdQx0ES1d/3Rq1BGCWuQ5+jG7vPBnpnvPsuLEfMZCkcKXZ26
	ezsg==
X-Gm-Message-State: AOAM531tDgje0uzM4lwhUouB0GPHJcZCb6S2aplbHCDinm5wQbEDCEyL
	8rKiBeouHUNVpeoV1WFq9ExJODGmbwvImGJIW44cHqPzuZlyQ5d8qmlBb1j1QhhIODhdP9ku9xf
	7LRegv9h04mWEmQ==
X-Received: by 2002:a05:622a:614:: with SMTP id
	z20mr26023526qta.232.1633526901338; 
	Wed, 06 Oct 2021 06:28:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQYqJgkQDoER0wVjEnhGOvfMferVnYWL3MCFbh+T5SgAmvWHhmeJb7yIfGG5UVXT07/2sCPA==
X-Received: by 2002:a05:622a:614:: with SMTP id
	z20mr26023510qta.232.1633526901173; 
	Wed, 06 Oct 2021 06:28:21 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id m1sm1131877qtu.59.2021.10.06.06.28.20
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 06 Oct 2021 06:28:20 -0700 (PDT)
Date: Wed, 6 Oct 2021 09:28:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-ID: <YV2kdHeS4GTXUdpi@redhat.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
	<20210929163600.52141-4-ebiggers@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210929163600.52141-4-ebiggers@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
	linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
	linux-scsi@vger.kernel.org
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 29 2021 at 12:35P -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

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
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Unfortunate how fiddley this change forced you to get but it looks
like you've done a very solid job of cleaning it all up to be
consistent.

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


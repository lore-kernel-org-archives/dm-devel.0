Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C3C481AB5
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 10:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789987597; cv=none; b=VuCoh0dSye+hln8dSQzkQd+BMeXii5n3+ti1p/DV/bW1zxWoR4eOsdohRONWkZRiQGrGQ68NZ0oBqPezruLARy+6W1m0E/QuRZeG2U9u6V5ToUqCnnSdqYoSnLzBK0qSvqlBfQHVBZEXxB3T48csvckMwcUWRRn8jhA6HuAOvoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789987597; c=relaxed/simple;
	bh=4ExNL/dyZRTZ8of8W7TIP229I6QEOWpteKGWbxZ72kY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=JKFJ9oOBI2YEfJoA17Pmp8MkJW5G3cFQndgzDfet2HAHAmRqjSWXfONfb3e7zS+QRX3AAKoKfJxUek2HXIN0sPzpmcPmwaFw1+hapboww6CYLxA6Ktmh6WKyyuRGYkBlIqfL2qFHMdbvlMe8w1aLvat5ffWmWTR5NB8iNcSVQ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ruk4pJNS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ruk4pJNS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789987594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xOxCxi0et4Im0QZpiAibCfANf5oH7SZI/BNFkKL+4DA=;
	b=Ruk4pJNS2sjSXUbYD6FYzvma9e93q5lnSC7OpzdQTJlv7byQJlXp/jsSg0INrJEZtDQNIB
	/sLEt+yxPVX6YUyynAbjjYeJ0K2nBSbAc81pdHmHPIhyLuuXqSsQztgheoZvT00+QoNpFW
	Cx55z98+NXFHwXsTd2aCGwYwt402yxM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-q8y1uSteN0-oJqoYVBNtGA-1; Mon,
 21 Sep 2026 06:46:31 -0400
X-MC-Unique: q8y1uSteN0-oJqoYVBNtGA-1
X-Mimecast-MFC-AGG-ID: q8y1uSteN0-oJqoYVBNtGA_1789987590
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 723F518011E3;
	Mon, 21 Sep 2026 10:46:29 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD3BA180056E;
	Mon, 21 Sep 2026 10:46:26 +0000 (UTC)
Date: Mon, 21 Sep 2026 12:46:24 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ayoub Zaki <ayoub.zaki@embetrix.com>
cc: snitzer@kernel.org, agk@redhat.com, bmarzins@redhat.com, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, corbet@lwn.net, 
    linux-doc@vger.kernel.org
Subject: Re: [PATCH] dm-verity: add DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE
In-Reply-To: <20260907171939.355472-1-ayoub.zaki@embetrix.com>
Message-ID: <a37a63f2-e45d-4e51-0c2d-bd19cca5fe88@redhat.com>
References: <20260907171939.355472-1-ayoub.zaki@embetrix.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: m-hLmkLK4uu2jOapFW1sbaiforYvhUrNiYLhkNGfO1c_1789987590
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

The argument can be turned off even with your patch - by specifying 
dm_verity.require_signatures=0 on the kernel command line (read-only 
module parameters can be modified on the command line during boot).

I'd like to know what kind of security problem does this patch try to 
solve. If the attacker can tamper with the kernel command line, he can 
already gain root (i.e. by using init=/bin/bash).

Mikulas


On Mon, 7 Sep 2026, Ayoub Zaki wrote:

> Add DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE Kconfig option.  When enabled,
> dm-verity always requires a valid root hash signature: require_signatures
> defaults to true and can no longer be cleared on the command line.  When
> disabled, the existing require_signatures module parameter controls
> enforcement.
> 
> Signed-off-by: Ayoub Zaki <ayoub.zaki@embetrix.com>
> ---
>  Documentation/admin-guide/device-mapper/verity.rst |  5 +++++
>  drivers/md/Kconfig                                 | 14 ++++++++++++++
>  drivers/md/dm-verity-verify-sig.c                  |  4 ++--
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
> index eb9475d7e196..bb48c001aeac 100644
> --- a/Documentation/admin-guide/device-mapper/verity.rst
> +++ b/Documentation/admin-guide/device-mapper/verity.rst
> @@ -163,6 +163,11 @@ root_hash_sig_key_desc <key_description>
>      also gain new certificates at run time if they are signed by a certificate
>      already in the secondary trusted keyring.
>  
> +    Whether a signature is required for every dm-verity device is controlled by
> +    the dm_verity.require_signatures parameter which defaults to off. Setting
> +    DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE makes it default to on in which case it
> +    can no longer be turned off.
> +
>  try_verify_in_tasklet
>      If verity hashes are in cache and the IO size does not exceed the limit,
>      verify data blocks in bottom half instead of workqueue. This option can
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index df27c7d066d2..59098d1f4534 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -610,6 +610,20 @@ config DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
>  
>  	  If unsure, say N.
>  
> +config DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE
> +	bool "Require dm-verity root hash signature verification"
> +	depends on DM_VERITY_VERIFY_ROOTHASH_SIG
> +	help
> +	  Reject dm-verity devices that are created without a valid root hash
> +	  signature.  Without this, whether a signature is required is decided
> +	  at boot time by the dm_verity.require_signatures parameter which
> +	  defaults to off.
> +
> +	  Enabling this makes that parameter default to on and it can then no
> +	  longer be turned off.
> +
> +	  If unsure, say N.
> +
>  config DM_VERITY_FEC
>  	bool "Verity forward error correction support"
>  	depends on DM_VERITY
> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> index b2b55c41e2cb..aadcf5e4a47c 100644
> --- a/drivers/md/dm-verity-verify-sig.c
> +++ b/drivers/md/dm-verity-verify-sig.c
> @@ -21,8 +21,8 @@ static bool dm_verity_keyring_unsealed __ro_after_init;
>  module_param_named(keyring_unsealed, dm_verity_keyring_unsealed, bool, 0444);
>  MODULE_PARM_DESC(keyring_unsealed, "Leave the dm-verity keyring unsealed");
>  
> -static bool require_signatures;
> -module_param(require_signatures, bool, 0444);
> +static bool require_signatures = IS_ENABLED(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE);
> +module_param(require_signatures, bool_enable_only, 0444);
>  MODULE_PARM_DESC(require_signatures,
>  		"Verify the roothash of dm-verity hash tree");
>  
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157
> -- 
> 2.43.0
> 


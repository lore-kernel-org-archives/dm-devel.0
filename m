Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B74A1B011C
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720106465; cv=none; b=dQXnQ5XU499Gg8aRZi+XzbImtiw02xy6ZEOSVHOAlEfJH3rWqo7krA61DezU6waysCNiQ2pvES4iGsLzvsvWMEeTfmPmLr5SWUAoTqEGgTmUDrXwbifvfvDFUVGNzDiFwO5/E+/AyX5Z3JijLa2JrIyDTWslxsFJ7qlSmeKVaUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720106465; c=relaxed/simple;
	bh=1QkPAeQbzWNjKsSzX9mh3yrjLAOEOzgoCw8OXSzrSXc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d/UxyVYLgKTGsY7WY8+0rJKnVZeDB9pIDpKZuM63xuTyOI5/Nqu3gFmn7EOA9GdeRr30q5GWC5no7fqHWyB2jVT7tKnIgG/llURO9zLt/MuygLifSgiqulR0rognWyQFi1EZ1Gd2HUc4QFwVBLlBn1p3rh4iNojxFd9YJf3G/NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=TcxRQACj; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=TcxRQACj; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="TcxRQACj";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="TcxRQACj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1720106462;
	bh=1QkPAeQbzWNjKsSzX9mh3yrjLAOEOzgoCw8OXSzrSXc=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=TcxRQACjjco0bN5UZGUcX4GFe5NtAKfoB8d3l0UtWCA63UfKgVbE5shDLG1oixcrP
	 qxPiJLMGdRXvCjv/2wZehjHhJalHLdSKJb0t/MNEGxFbhqjbaml93Fj/Mfu2wj8bkG
	 VTls4vZH70ETmg610xJWwYBODPsUAPi+DEUm9jFI=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 54AFF1286085;
	Thu, 04 Jul 2024 11:21:02 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id TAFvsKsO3u7p; Thu,  4 Jul 2024 11:21:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1720106462;
	bh=1QkPAeQbzWNjKsSzX9mh3yrjLAOEOzgoCw8OXSzrSXc=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=TcxRQACjjco0bN5UZGUcX4GFe5NtAKfoB8d3l0UtWCA63UfKgVbE5shDLG1oixcrP
	 qxPiJLMGdRXvCjv/2wZehjHhJalHLdSKJb0t/MNEGxFbhqjbaml93Fj/Mfu2wj8bkG
	 VTls4vZH70ETmg610xJWwYBODPsUAPi+DEUm9jFI=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 9BF2F1285E26;
	Thu, 04 Jul 2024 11:21:01 -0400 (EDT)
Message-ID: <544c16649bafe77d5ff4f6cecb09f3de3b97d9a6.camel@HansenPartnership.com>
Subject: Re: [PATCH] dm verity: add support for signature verification with
 platform keyring
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: luca.boccassi@gmail.com, dm-devel@lists.linux.dev
Cc: snitzer@kernel.org, jmorris@namei.org, paul@paul-moore.com
Date: Thu, 04 Jul 2024 11:21:00 -0400
In-Reply-To: <20240617220037.594792-1-luca.boccassi@gmail.com>
References: <20240617220037.594792-1-luca.boccassi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-06-17 at 23:00 +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <bluca@debian.org>
> 
> Add a new configuration
> CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> that enables verifying dm-verity signatures using the platform
> keyring, which is populated using the UEFI DB certificates. This is
> useful for self-enrolled systems that do not use MOK, as the
> secondary keyring which is already used for verification, if the
> relevant kconfig is enabled, is linked to the machine keyring, which
> gets its certificates loaded from MOK. On datacenter/virtual/cloud
> deployments it is more common to deploy one's own certificate chain
> directly in DB on first boot in unattended mode, rather than relying
> on MOK, as the latter typically requires interactive authentication
> to enroll, and is more suited for personal machines.

I think that's true if you roll your own cloud OS.  If you rely on a
distro OS (as, say, IBM Cloud does) you do use shim/mok and actually
you als have to enroll all the driver module keys in MoK.

> Default to the same value as
> DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
> if not otherwise specified, as it is likely that if one wants to use
> MOK certificates to verify dm-verity volumes, DB certificates are
> going to be used too. Keys in DB are allowed to load a full kernel
> already anyway, so they are already highly privileged.

But there's a reason we allow mok users to distrust DB through mokutil.
It's because although you might be OK with these keys guarding the pre-
boot environment (because if they don't do that Microsoft will be
unhappy) and transferring control to SHIM via these keys, you wouldn't
necessarily trust the owner of these keys to tamper with your kernel or
install modules.  Doesn't a similar reasoning apply to dm-verity root
hash signing?

By the way, if I look at how the machine keyring is handled, db certs
won't get added if MokIgnoreDB is set by shim, so I think the behaviour
of this patch is correct, and it's just the wording above that may be
misleading.

James


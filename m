Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4757E36D
	for <dm-devel@lists.linux.dev>; Sat, 16 Nov 2024 00:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731715530; cv=none; b=RwNPNCmU4GFWsCY5a4ivexJy/pCHb6UicZ7H9b4BTEw0WPVmL9CUedPQWLW8J8qfCKo1utqFXzX22MawbUE6L3LjyElEChr8WQkCgdCv5pAIV8BYDm9OUlcTBA9TDNl2Q1Uq8MKJKtDfyLFciE3Mr7F2EO4Z01VeIUwUOVlMFW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731715530; c=relaxed/simple;
	bh=MhgliO5Axbzu8FQ+nsPPVK7zgTSXRrKQCPsPRZPQfTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=qjRqK98R0P4XrJJfphxRcoYdxVhI/9ZzO3vSOntokhzB0pWq4h79WkWdkdkjiKseefBLQ5EBp/YT7G1E95dNnuPrxRohqFEiLDddjqqX5O5HVfTVJLL60Roi2Soa5KihCCDSnEb4VpMWBuTmNX1pGAXQABIE0R7wkUYIctn5i78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DkSUZcvF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DkSUZcvF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731715525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uhsrAm/8i4vr0ow++oWBhR3aTvLqoRDuv6By7PKrhFs=;
	b=DkSUZcvFaknu2i3P2yc+/fOBxI/f1Efe8u3Ar/SqiJaXtAQbxjnxhm3Qgt6ZrQdiWnefXg
	W1epJ9GEgi3OY0KYH36NCsKCXoTRv6Khdsyb4okMpqRwnN18A4tCsBsO1xijrAT/aa1qfg
	mmPC6OyeStYfvHSc6KWUytRNYTFBwD8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-jfyJ-xiJOJ2SoUZjagyCxg-1; Fri,
 15 Nov 2024 19:05:21 -0500
X-MC-Unique: jfyJ-xiJOJ2SoUZjagyCxg-1
X-Mimecast-MFC-AGG-ID: jfyJ-xiJOJ2SoUZjagyCxg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A57C21955F57;
	Sat, 16 Nov 2024 00:05:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 303493003B76;
	Sat, 16 Nov 2024 00:05:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AG05IrW628384
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 19:05:18 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AG05IHO628383;
	Fri, 15 Nov 2024 19:05:18 -0500
Date: Fri, 15 Nov 2024 19:05:18 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/3] multipath-tools: fixes for systemd watchdog
Message-ID: <Zzfhvmj-gFrRVH3G@redhat.com>
References: <20241114144224.248606-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241114144224.248606-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TcEdLOvksRL_ifzGBPktOvep5z7JHu4A8gmJe-7BjsM_1731715520
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 14, 2024 at 03:42:21PM +0100, Martin Wilck wrote:
> A set of small fixes to make multipathd better adhere to the conventions

I'm a little confused by this. Your patches make sense, but why do we
bother limiting max_checkint to the Watchdog timer? We send a notify
every loop in checkerloop() regardless. Changing max_checkint won't make
us any less likely to hang for too long if we're using a synchronous
chacker, and I can't figure out why the Watchdog time should have
anything to do with how frequently we check working paths.

Your code changes looks fine, so assuming there's a use for this code:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

But possibly we should be removing set_max_checkint_from_watchdog(), or
replacing max_checkint with something like checker_timeout, but only for
synchronous checkers. Or possibly I'm just missing something here.

-Ben

> for systemd's WatchdogSec= setting.
> 
> Martin Wilck (3):
>   libmultipath: don't print error message if WATCHDOG_USEC is 0
>   libmultipath: honor WATCHDOG_PID setting
>   libmultipath: cut watchdog interval in half
> 
>  libmultipath/config.c             | 21 ++++++++++++++++++---
>  libmultipath/config.h             |  2 ++
>  libmultipath/libmultipath.version |  1 +
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> -- 
> 2.47.0


Received: from mail.thinkmo.de (s3.thinkmo.de [162.55.237.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A1A33F378
	for <dm-devel@lists.linux.dev>; Mon, 26 Jan 2026 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.55.237.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769443036; cv=none; b=E5Iqr04uPuWRFkyWeBmkOYf+18lcIvwFe/SKyc9ITDzPKzaTxVf7EcL/n+ACJshcBlSwej2VnFpBZvU20J2XVYi5EYGXt3rbL+Thr1hOKtsjypBEjcacydcdRHsSlU28XciHjObh4coog9ARo/WdYsb6QXWymv5ctWI3Gvv8vEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769443036; c=relaxed/simple;
	bh=tazU74C6nO+k9GA3PDs6VuBvtAeEpEDzPfGiG7vHTTA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRiwzE0NV3pqg3S3r0WYB1CsoGnCRvxtIkYQB+gnKthwbdgCm2S3yNUce8IAv395lL7nALiyRgiZRspuJ/tyGeUfFNB19O8ChBL/BzMzFyBUDfJAfXQII2hJMXsaSrMWWJWxf4QI2jspWISFmEHhcfv44uZvPhmMt7tsXT3xRYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thinkmo.de; spf=pass smtp.mailfrom=thinkmo.de; dkim=pass (2048-bit key) header.d=thinkmo.de header.i=@thinkmo.de header.b=sghVx64Z; arc=none smtp.client-ip=162.55.237.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thinkmo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thinkmo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thinkmo.de header.i=@thinkmo.de header.b="sghVx64Z"
Received: from localhost (localhost [127.0.0.1])
	by mail.thinkmo.de (Postfix) with ESMTP id 4f0CcP641fzyVc
	for <dm-devel@lists.linux.dev>; Mon, 26 Jan 2026 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thinkmo.de; h=
	in-reply-to:content-disposition:content-type:content-type
	:mime-version:references:message-id:subject:subject:from:from
	:date:date:received:received; s=mail202312; t=1769442501; bh=p3G
	mj06rIL7+KpPmGE2bCSzQWEeodXu7vM5kYLgJKcM=; b=sghVx64Z37demS82jNQ
	ALvKfkTSI82izhBKuw9zwtalS1F+7UeIuHfqQ5RJ4E2mGUK9WFSPKhhvcYSDiSXl
	OMmh0m1ASM5sgMO3rg8OqJ7Tab7YN3lDtPlSKWdYPK08O5h3sSsxDKpQ3myUsdEQ
	xhycLdNXZ3yuzcSqmwaPRk1Iu1rq12ZYWdfksmSSj99voN5gQeLm4rbfcYHMAmis
	XSr77AnFGknIebN6NfquH7jypLcj0+lzxdWwSJLTUQdI/ue7FVcHIu4RvvZ2hIzt
	HkjSQ1MhjVm7Bo01yvuYA2hPmGlZl+ofuxsaqdYqBPpjkRoJZHLy+43yCOZ64gWw
	SYg==
X-Virus-Scanned: Debian amavis at 
Received: from mail.thinkmo.de ([127.0.0.1])
 by localhost (mail.thinkmo.de [127.0.0.1]) (amavis, port 10024) with ESMTP
 id laafJ7EUKP74 for <dm-devel@lists.linux.dev>;
 Mon, 26 Jan 2026 15:48:21 +0000 (UTC)
Received: from shell.thinkmo.de (shell.thinkmo.de [IPv6:2a01:4f8:271:3f5c:0:22:0:1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.thinkmo.de (Postfix) with ESMTPS id 4f0CcP53yMzyRd
	for <dm-devel@lists.linux.dev>; Mon, 26 Jan 2026 15:48:21 +0000 (UTC)
Date: Mon, 26 Jan 2026 16:48:19 +0100
From: Bastian Blank <bblank@thinkmo.de>
To: dm-devel@lists.linux.dev
Subject: Re: [PATCH] kpartx: fix segfault when operating on regular files
Message-ID: <20260126154819.pdah2ptiq6stwtmy@shell.thinkmo.de>
Mail-Followup-To: Bastian Blank <bblank@thinkmo.de>,
	dm-devel@lists.linux.dev
References: <20260126121325.208908-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260126121325.208908-1-mwilck@suse.com>

On Mon, Jan 26, 2026 at 01:13:25PM +0100, Martin Wilck wrote:
>  		uuid = nondm_create_uuid(buf.st_rdev);
> +		if (!uuid)
> +			exit(1);

This sounds like it should be "abort()".

Bastian

-- 
It is undignified for a woman to play servant to a man who is not hers.
		-- Spock, "Amok Time", stardate 3372.7

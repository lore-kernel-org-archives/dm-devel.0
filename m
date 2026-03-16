Received: from mail.thinkmo.de (s3.thinkmo.de [162.55.237.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A9F34CFBE
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 19:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.55.237.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773687621; cv=none; b=glcgyinb50Ol8vCzgwmEUB0bHiApe9ST5H3PokbsjAE4UVbiNkfXXO75my2DKS1491aEEpG4waffOMFsDh9gYv2LH4zXDaotfFmpqXbGiMn8npa4vipV1nUWMmLlh+MxdIO3BL/N+AcIA1oYZbsczeGrjfEALVRoc8PIvG9Ww0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773687621; c=relaxed/simple;
	bh=K8NpBFsH5VMSGbpr79MI4TOuiQQQqMd/cErQKqOfEU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBarQLk+dOUaR1QDRdWVTFK0IdbD1V/CtwsJZzHTBQT+GbcSvFGMAeSBNEb2zRZ14/URZHg+qL2ZxhznsxtGWj+Y/SNYGy5jiYlq+bfLcC5bBvpVN/o972jgFfDsIb8p4cafTZU3OrAnP7lwfmR53UtIRZHN5EoeI77fV9k96XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thinkmo.de; spf=pass smtp.mailfrom=thinkmo.de; dkim=pass (2048-bit key) header.d=thinkmo.de header.i=@thinkmo.de header.b=PDJYi+qb; arc=none smtp.client-ip=162.55.237.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thinkmo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thinkmo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thinkmo.de header.i=@thinkmo.de header.b="PDJYi+qb"
Received: from localhost (localhost [127.0.0.1])
	by mail.thinkmo.de (Postfix) with ESMTP id 4fZPKw3mhnzyY2;
	Mon, 16 Mar 2026 18:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thinkmo.de; h=
	in-reply-to:content-disposition:content-type:content-type
	:mime-version:references:message-id:subject:subject:from:from
	:date:date:received:received; s=mail202312; t=1773687028; bh=/8l
	Ev91r5d5xju7ki3pR3KlyTJ14j8DUsjzMPu+/STo=; b=PDJYi+qbmuXTpc3Jm2Z
	WgcsB65oEn13neRPErVkVnBRVvGrt4sys/t5U/5kRObm0Apyux79rXTv48zYPEie
	1Sy6MxfUSMt+bL4y60FlISulArATRa6RiLdpF0S3BAf3AbzEbqMZ++aAPJBl7mCx
	qi03jDEK2NJnAXf/7lo7M8HqBX8o1A8VxLg2RyzpCZlaTC3bqeYESCGcJoAuHqTC
	Yb8N7wyXXe4HDxODfBFXum5hK5uBNCvlJiykXazjXHUy1F1AXdXn5qlnScgKqVeU
	cR2YxBjmyqfH5VaPEA2xPonYaoefwq3C8uvw6k8UwPTIt+28EOufAltMBY9hAT82
	QQQ==
X-Virus-Scanned: Debian amavis at 
Received: from mail.thinkmo.de ([127.0.0.1])
 by localhost (mail.thinkmo.de [127.0.0.1]) (amavis, port 10024) with ESMTP
 id pKtFh56zawNE; Mon, 16 Mar 2026 18:50:28 +0000 (UTC)
Received: from shell.thinkmo.de (shell.thinkmo.de [IPv6:2a01:4f8:271:3f5c:0:22:0:1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.thinkmo.de (Postfix) with ESMTPS id 4fZPKw2ZLxzyVT;
	Mon, 16 Mar 2026 18:50:28 +0000 (UTC)
Date: Mon, 16 Mar 2026 19:50:24 +0100
From: Bastian Blank <bblank@thinkmo.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v2] dm: make "dmsetup remove_all" interruptible
Message-ID: <20260316185024.awx5ljaozloojtxx@shell.thinkmo.de>
Mail-Followup-To: Bastian Blank <bblank@thinkmo.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@lists.linux.dev
References: <4a39a67d-37e6-bb5c-d08f-0fd4b75e5181@redhat.com>
 <79941ba6-cac8-4283-82b6-807c20729e76@acm.org>
 <bec39289-bf7a-2ba7-70c0-ec227c30d078@redhat.com>
 <8c60292b-bab9-4a7e-8014-8fa2dda3965c@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c60292b-bab9-4a7e-8014-8fa2dda3965c@acm.org>

On Mon, Mar 16, 2026 at 10:58:39AM -0700, Bart Van Assche wrote:
> On 3/16/26 9:37 AM, Mikulas Patocka wrote:
> > +#define KEEP_OPEN_DEVICES	1
> > +#define MARK_DEFERRED		2
> > +#define ONLY_DEFERRED		4
> > +#define INTERRUPTIBLE		8
> Has it been considered to add a (short) prefix to these flag names?

And shouldn't this be an enum?  Yes, the dm code currently flaps between
both styles.

| Enums are preferred when defining several related constants.
https://www.kernel.org/doc/html/v6.19/process/coding-style.html#macros-enums-and-rtl

And maybe even "(1 << 0)" to make them easier visible as flags.

Bastian

-- 
I'm a soldier, not a diplomat.  I can only tell the truth.
		-- Kirk, "Errand of Mercy", stardate 3198.9

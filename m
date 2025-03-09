Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A5B184F
	for <dm-devel@lists.linux.dev>; Sun,  9 Mar 2025 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741536064; cv=none; b=HHC90Z1mwe3AKqK83xJIR3owXmeZwbLMBrbavBw9bvyOSp1bRkP+2DOfNNiDMKLD7LMjmPE5bBWNq7HypptSZi88mJ2sTrXaQwocz9SMA09OJm7T7a55R/JpWxhboHh78YNJb2C41RtqSicoDwIxJJ2ZoqRgr1wdho2f4LYBHRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741536064; c=relaxed/simple;
	bh=nDwYZupDUsmNtD5KXjLHq3sA78rZCKq+IGssDT9/7g0=;
	h=MIME-Version:Date:From:To:Message-Id:Subject:Content-Type; b=HlEMGvXzErciR17+Mn9RxUeZk00EVne8Wy5ZHnx8FXhDE9G2UWnWqK50FqJsukmdI84VpyCiEJfCBAjeYVW3gE6fMDGOHqrQbA8a8XtHKFZ9PUsy8rOKwC+AxDvSQOp6Xw1jxJkEtEQFSahZp/d+V67Z+ffBe7SFhuSywNx+zqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=owlfolio.org; spf=pass smtp.mailfrom=owlfolio.org; dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b=YuvfBRbw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fOb73p2I; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b="YuvfBRbw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fOb73p2I"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 0D0EA1382CA1
	for <dm-devel@lists.linux.dev>; Sun,  9 Mar 2025 12:01:00 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Sun, 09 Mar 2025 12:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=owlfolio.org; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1741536060; x=1741622460; bh=CrmWmoWLpE
	+wutjIMyvMdmK3+FA/NWun1FpooZDTG60=; b=YuvfBRbw/Lwpc7Dq7oCbBFY8GO
	argvryfnB9D7LznUvBpflgp0/TQ4Lh4IimgJxkccJXqpKoNssJxu1dtiTJE04U0+
	TZFImfzfl2SVYxqZlHZ0Rv7zWq8RJcUmggvWVIeYwdIFMK2O6GX5MH9mdJDyl0fA
	hRqLU/cg9PQ852zJKcn4L2pvGiiizIvXQrcHK6cd8kh9HiInffgm1WEQUKRofCs4
	kZX2GX/Xx0EOyheJ87ZkdJ4XopPPxlNadb6bbJ1P6v1m3IFXL0JS3sYxFmMMt3bF
	z5ZRnXZuVILZBcgFr0i2PbRIbtLPQs2VlKwVpKuHHMo+0CDK/mwmuE1CgrZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1741536060; x=1741622460; bh=CrmWmoWLpE+wutjIMyvMdmK3+FA/NWun1Fp
	ooZDTG60=; b=fOb73p2IefH1WAIhDjJf7lG/UPq4o8jOagZxz1MFvUdu+C+dnms
	sAYB1g+QhKWU/6/VzntebWIzS5dof99Sz+PK4fUo26fX+EA447WKwn05UYKDB/eU
	oHiAWTBbMvCM72zWVuDDUswSoSrUMJu+LoqyUAykQ3q3eiYeVG5PXIvy1HDoSr8l
	t5H07y9PXlUoxxzW7iYxsjZZsfKmfNpn37VJXFM06TMzXSx9uCd8vlXaCRGddqcj
	I9TRD1SQYI9/V+M7NRKmG/rxHzs7TOwE1kVDMzCxC8BSeLyHU9idKyawPpyLfjt2
	Ni0t26cYKCKBoAw13ITtiAaDseBsXYMwqYA==
X-ME-Sender: <xms:O7vNZ7RNVBNrsCaUDp079fWTKdKNaJN2TBwOKtu2OY6tkctUKHA0oQ>
    <xme:O7vNZ8zpmvr3CyFvUPynTN5n74o8HSo6iCAej16wO0OI3S7NgrjuNmZResZX2g_TP
    ZHD_igBlAiIeuCZ5I4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduudeikeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefogg
    ffhffvkffutgfgsehtjeertdertddtnecuhfhrohhmpedfkggrtghkucghvghinhgsvghr
    ghdfuceoiigrtghksehofihlfhholhhiohdrohhrgheqnecuggftrfgrthhtvghrnhepfe
    duteeifeevuedtgeehvefgtedvjefhleejteduvddtvddvhedvgeekhfejffdtnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepiigrtghksehofi
    hlfhholhhiohdrohhrghdpnhgspghrtghpthhtohepuddpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepughmqdguvghvvghlsehlihhsthhsrdhlihhnuhigrdguvghv
X-ME-Proxy: <xmx:O7vNZw0sc0kFB7Usv6-ooTSN_M58ufb0fFir1R-LlDVSs05oEAR4AA>
    <xmx:O7vNZ7DbfOb2igLJSyUfhQL9tByFe0VT_MXUMM9NWvzm1OcIkpBNdw>
    <xmx:O7vNZ0huDbOwEhI5pnwYJTyVRkcT-sANTud-zZ3ACkHy8QEMpOf_0g>
    <xmx:O7vNZ_pAE-k-Rk0ho5eHPhmp689BluDu0_OL4yI35tAr2yZmLvxSZA>
    <xmx:PLvNZ8LdYplA3CTS3h0drSHBwtcxqfoPExr7VhqUhQdwAqNHVVytj45d>
Feedback-ID: i876146a2:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C2B783020080; Sun,  9 Mar 2025 12:00:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sun, 09 Mar 2025 12:00:39 -0400
From: "Zack Weinberg" <zack@owlfolio.org>
To: dm-devel@lists.linux.dev
Message-Id: <0211b995-d844-4a0d-a02f-2f9bd2a4215e@app.fastmail.com>
Subject: Allowed characters in strings passed to/from device-mapper APIs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I am developing a device-mapper client library in Rust.  The language is
relevant here because Rust's standard library makes a strong distinction
between strings that are known to be encoded in UTF-8 and strings whose
encoding is not known (`str` vs `OsStr`), with the latter being awkward
to use compared to the former.

The device-mapper ioctls use a lot of strings, and it's not clear
to me from either the documentation or the kernel's source code
what expectations the *kernel* has of the character encoding of these
strings.  I don't expect the kernel to care about UTF-8 versus
ISO-8859-n or whatever, but it is plausible to me that at least some
of the strings used in device-mapper ioctls can be expected always to
be ASCII, in which case I can safely use `str` for them on the library
side and it'll be more ergonomic for end users.

There are, I think, four different kinds of strings used in device-
mapper ioctls: target names, device names and UUIDs, table parameters,
and target messages.  For each of these, I would like to ask:

* Are there any circumstances where non-ASCII bytes *should* be
used in this type of string *when supplied to the kernel*?

* Are there any circumstances where a client library should expect
non-ASCII bytes to *appear* in this type of string *when reported
back to the client by the kernel*?

* If there are any such circumstances (either way), does the kernel
try to interpret non-ASCII bytes in this type of string as characters
in a specific encoding, or does it just treat them as an opaque
token (as is typical e.g. for pathname components)?

Thanks,
zw

please cc: me directly on all responses, I'm not subscribed to the list

Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1093231A2D
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 17:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626344; cv=none; b=gLy7G6Yk4lMChZRBAF93dolKMlBSfXfjxljoauVWDxSNfs5QiDYFcgzN8Ped2UqHp3NzPdWrWAy4vmtH4sAo3V04j0J4Jm0EZYpBLjZ7PzsQe8geGjK1O7d7xsIcb1A3VXIrGuJ8oZMVTNep2zSsuMpN2unlefffmawmLU5x7HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626344; c=relaxed/simple;
	bh=RZqjh0F1hffEJl1SKeFYRUXx9828kAhYY9hPbcP559Y=;
	h=MIME-Version:Date:From:To:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=E99hhgy5mmNXKPixgbk/5pnx1o+dne0/dCYn9CYfSmhopa9JSZt3w9nbKX2Q9haTkTQtjmTpSv7IJyQJkQ40sBX9S6ZWIvaDdV5Ac4Cjdm5QpknoJWTZUPtut9s0tn8uk3U0E/z9rqQbp+7zJsKbXnoYzYx43nOj+iwqSp1HpOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=owlfolio.org; spf=pass smtp.mailfrom=owlfolio.org; dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b=kVcPrWZF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ufPafcE8; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b="kVcPrWZF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ufPafcE8"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id A42B81382D56;
	Mon, 10 Mar 2025 13:05:40 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Mon, 10 Mar 2025 13:05:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=owlfolio.org; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1741626340;
	 x=1741712740; bh=HrksSGldFsMzQXPwBqslCsmt15iHqOW6RMDTJ2HqZwE=; b=
	kVcPrWZF54miOH/6bE+3AVt7YWlhLcFL8EBBhGexOmuXPrwnuQp6y3jW4GMM20K0
	82FiBXyQUv6bFUSEqqV9vimnETmVYBrd5wgtXSerZi1S7tRIOtzruDTwGYBbcLLD
	FQi0OizvaIxuFL4ged2Dhi6Fj/2suyz4pN5ZD++B/aaFygpFJ671+eYPYd0ucFRh
	mil/idlOm0uEo/CjJgHwRLSS4vxdtpuI75/KLGlQOOAoyiINjzOMjHfXmXZTW1Wz
	jTaW+BCyg4r55b8sfJ43pArUqtKfBJmR1u5WLAaJlkwQ1bM/i1fZcd9T7GsXeILv
	hCbdKh6jogsX9UyPVy/oIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1741626340; x=1741712740; bh=H
	rksSGldFsMzQXPwBqslCsmt15iHqOW6RMDTJ2HqZwE=; b=ufPafcE8Xa9azw/HK
	Gas/h5pDHyFX9aTHms62zOeb+zOkvp1cxQY6KRrwZml9tIbwCxfgObNsDt3DBr9G
	+DJtauzyYjACnMMLmzhcOmYgzfzKgm0LcXEsNPI695e1tK1071t40JPzgQ/9sHxE
	Bu/cFuRLmU8Ymm9FnYvPlDSJ4h++xQ4AJmgfi8zUj+Lyldh/4VEk3I2/76cwJQ7h
	qomfmABwvthXopFR21ixVlojmcM08ux8JGvuK/otbPh2qA1GH9RoPY60RQrnv9EK
	g1su2rMQb8NYkFxhuuv977AZCkENCUWYWrHcC0sNY+2+LP5GS6NaTHNg/Gd/4Xv7
	S3ZSA==
X-ME-Sender: <xms:5BvPZy2JqqsuXiey8sONdUn07f6xyixaDAAzP7MEhAPK_6U6V27uPw>
    <xme:5BvPZ1HyTBJ-5HzNX1_X65LIOYm4zEoKfcKyk_3tHBZzDaXOq43KRJ_VO8Qg8wk1f
    td6EL6QZSl0L6XIQ6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduudelledtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvffkjghfufgtgfesthejredtredt
    tdenucfhrhhomhepfdgkrggtkhcuhggvihhnsggvrhhgfdcuoeiirggtkhesohiflhhfoh
    hlihhordhorhhgqeenucggtffrrghtthgvrhhnpefgveelheeliedvfeejteffheeuleev
    geduffeludehiedufeevjeejvdevudelteenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpeiirggtkhesohiflhhfohhlihhordhorhhgpdhnsggp
    rhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeiiuggvnhgvkh
    drkhgrsggvlhgrtgesghhmrghilhdrtghomhdprhgtphhtthhopegumhdquggvvhgvlhes
    lhhishhtshdrlhhinhhugidruggvvh
X-ME-Proxy: <xmx:5BvPZ65KhIQVagrmQybrqUtzFnbM97I8jtCYvzSOLFaLOs1Qm3md5w>
    <xmx:5BvPZz2Mt0jk3GaRuYfutIDjvvbkruYGxyQ_Pu2OF0BQ8PB4qjpuBQ>
    <xmx:5BvPZ1FIpUjB-rsnh_yR1VaOv_i-V8XRnlZbWSX5bcdrNd01D8d1mg>
    <xmx:5BvPZ88s69a1PKhufNFRsVP9VWCfHaQm8LBHBH26D4EI04wY2wntJw>
    <xmx:5BvPZzMC66L3VZoNUiePHeY9XgOpTfdpPZ6mjstgXn0ltvXwR0NqTX2x>
Feedback-ID: i876146a2:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 626AB3020083; Mon, 10 Mar 2025 13:05:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 10 Mar 2025 13:05:20 -0400
From: "Zack Weinberg" <zack@owlfolio.org>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>, dm-devel@lists.linux.dev
Message-Id: <25a38d69-4128-4c51-bf28-95f2f76b78a9@app.fastmail.com>
In-Reply-To: <4dd35799-f43b-461a-a3c4-5cec8ff22006@redhat.com>
References: <0211b995-d844-4a0d-a02f-2f9bd2a4215e@app.fastmail.com>
 <4dd35799-f43b-461a-a3c4-5cec8ff22006@redhat.com>
Subject: Re: Allowed characters in strings passed to/from device-mapper APIs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Mar 10, 2025, at 10:35 AM, Zdenek Kabelac wrote:
> Dne 09. 03. 25 v 17:00 Zack Weinberg napsal(a):
>> I am developing a device-mapper client library in Rust. 
[...]
> While you could surely interface kernel directly through ioctl(),
> you should probably base your tool around libdevmapper as this library
> is there to solve version differences or possible kernel or udev
> issue that pops up here and there -  if you will go your own path,
> you will need to reimplement these things within Rust - which
> might potentially be problematic - as we are solving i.e. udev trouble
> to be working only within our 'small world' across different version of kernel 
> and udev version installed on the system.

Unfortunately this is not an option for me, as my library needs to be usable
in a context where neither the base C library nor udev is available.

> Again - you are free to reimplement your Rust version - but eventually this 
> may lead to a completely different set of udev rules needed for management of 
> Rust devices -  as libdevmapper is free to 'change' DM udev rules as long as 
> we are 'internally' consistent - as these rules are seen as 'internal' 
> property for DM world.

I don't immediately see how that could happen, can you be more specific about the
potential problems you have in mind?

> Device name and UUID are always plain 7bit ASCII.

Is that enforced by the kernel, and if so, where?  I was not able to find any
code in the kernel that does that, but I could easily have missed it.

> But there is a catch in udev process - as udev has even further limited char 
> subset usable for device names - libdevmapper uses name mangling for those.

Thanks, this is helpful.  Do you happen to know offhand where udev documents
its character restrictions?

How about target names, table parameters, and target message strings?  What are
the restrictions on those?

zw 

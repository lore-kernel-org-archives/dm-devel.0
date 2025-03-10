Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C7622D4D0
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 17:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626433; cv=none; b=l7zbUPjnweVHjUH84O9SBMG5Pd3UnQhwOwXrCVV9Gmt0kfCkY6tuafKTCJcK6XQNZNpqqCQyXiHGUSc7UhYiUxhT7KW9y/q+ZrtFdZH1l57mQQ7GhvnemlCl+Q/jUyXyoBQ91lOtoBn4H2WZF50Wp2zqCCkTc2o1cVMLG1i0xV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626433; c=relaxed/simple;
	bh=Oeuh2tyma287v2NketftJF3ycXumV597hCjLWybZHbs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=gWuxymB3iqEi94QFRuppp7+bMEzxdogBBWKK0ihZqJwqtEL5shdgQvUdvXngkMyczU3p3dMNV0aUW2lyD0Ig72lkEvo54F3k8P98+xzJbIhApsh+vSMQBYw1B9KX5xHoDxOjQnPtgoVPsX+dNhTWH6TWE3njNTHg/CPxMhVwvnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=owlfolio.org; spf=pass smtp.mailfrom=owlfolio.org; dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b=BPtg0GaX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=O5dFvxNJ; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b="BPtg0GaX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="O5dFvxNJ"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B7FC7114010D;
	Mon, 10 Mar 2025 13:07:09 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Mon, 10 Mar 2025 13:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=owlfolio.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1741626429;
	 x=1741712829; bh=Oeuh2tyma287v2NketftJF3ycXumV597hCjLWybZHbs=; b=
	BPtg0GaXEXV3G6dRtwPiCUrl/yWBNy1cG/R8NQLaX0bE9SlJQXRB8HkX3LtJX+1C
	kTntXwTl6V8/uUrqOHTRM1DWEyeT9nxVTnljExF9emByp/N69ge4Oknb6C4FayTu
	r7orzQY9wA4W/hvo3yo2ug1cUz/LeAGRcdVepzY0vwI9d1X6TJmKabIyDQ7p35XS
	JYPkr9piADMvobfAQt0dmN25dsCwAdJ9L8BGfTDI83rxc+WOBtTGWCzquoRvI45G
	2W9VE2w2CTmgK9Le1i7YBLTAPovYrwCylBjVh56CHGJPtisKlaUB/9Bnjs/tDQe3
	DNkL83TlwYUyAy//oZ+BXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1741626429; x=
	1741712829; bh=Oeuh2tyma287v2NketftJF3ycXumV597hCjLWybZHbs=; b=O
	5dFvxNJZsyYKlTrLTudXw4JQcSnZLtEOy8tneGTKjQ6rDJOiZgSy3krnLewj63up
	SM1XQRk/SbGCZDLwj94tBes2HC8mJAvbzu/eO3khVawSjHQs96GtvDfmKe9LqC9J
	nvhwkJ7qlSJ94gizsyaQadue4PUjuEsVPxnSxZgSRtgHBFWx10AEoKkXuOZXduXg
	FZVkMQiKds0dtufdnjSfKEJrIglfadED5pXOe4hyDvkXEQCKPmAEw9LjXZ5K+/jP
	tH0wM/wrz2n0+rscvPktGBg2p0WkKS8Tz6ZMXIR5YFPRvOBu0Ca22tbCX1vZjupO
	eTNg2uqwmAC400GQVmrpg==
X-ME-Sender: <xms:PRzPZyVDbzRuigGsAVm-_KNHmUowRhNtrAai1SktLmTTrcc6hP55tg>
    <xme:PRzPZ-nwxI0nRhC8B5mK-kXTnSqfKegp4Dc7mNX0y2MTsGSIBtjom9SirlH8QCR3l
    JOFjRb_s4ZS1sIu09Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduudelleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertder
    tddtnecuhfhrohhmpedfkggrtghkucghvghinhgsvghrghdfuceoiigrtghksehofihlfh
    holhhiohdrohhrgheqnecuggftrfgrthhtvghrnhepgfejtdefleehtddvteeitdeigffg
    fedvheelieevkeetgfdtkeehhfegfffffedvnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepiigrtghksehofihlfhholhhiohdrohhrghdpnhgs
    pghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepiiguvghnvg
    hkrdhkrggsvghlrggtsehgmhgrihhlrdgtohhmpdhrtghpthhtohepughmqdguvghvvghl
    sehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepthhhohhrnhgsvghrsehrvg
    guhhgrthdrtghomh
X-ME-Proxy: <xmx:PRzPZ2ZBeGlWeiK6HDuOfI5jb3-WyQwA1KJWw1z_tTO9N-dZ50iB1A>
    <xmx:PRzPZ5Xo4PXWcO19QqmSDthYC7V3cQkXIhxXS-bfT_JMyMkpmAoVLg>
    <xmx:PRzPZ8mpWJ0YzF-8UU25EQvoNeOSi5atLFzXaD5sL6R_9Ova2_LcKA>
    <xmx:PRzPZ-d8ffskK8VCKT4yNI2AD8glueHgEreWXT-H4LCPHBsagpOQBQ>
    <xmx:PRzPZxzHuXfcZAlooFO--rCUTimG6Q1bubXHPozfMefZhwysbuRdzQO5>
Feedback-ID: i876146a2:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 756D23020080; Mon, 10 Mar 2025 13:07:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 10 Mar 2025 13:06:49 -0400
From: "Zack Weinberg" <zack@owlfolio.org>
To: "Joe Thornber" <thornber@redhat.com>,
 "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: dm-devel@lists.linux.dev
Message-Id: <93f44259-31b1-4157-9db0-a3add582acde@app.fastmail.com>
In-Reply-To: 
 <CAJ0trDZRg=DPPDa0LMiFw0T9uT+B_53K4=aXc=njr=j_VYOarw@mail.gmail.com>
References: <0211b995-d844-4a0d-a02f-2f9bd2a4215e@app.fastmail.com>
 <4dd35799-f43b-461a-a3c4-5cec8ff22006@redhat.com>
 <CAJ0trDZRg=DPPDa0LMiFw0T9uT+B_53K4=aXc=njr=j_VYOarw@mail.gmail.com>
Subject: Re: Allowed characters in strings passed to/from device-mapper APIs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Mar 10, 2025, at 11:09 AM, Joe Thornber wrote:
> This is the Rust library developed by the Stratis project, and I use
> it in a couple of my projects (blk-archive and
> thin-provisioning-tools).

I am aware of this library and in fact have stolen a bunch of code
from it, but I can't use it directly for the same reason I can't
use libdevmapper: my library needs to work in a context where the
base C library is not available and neither is udev.

zw

Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE80230988
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626607; cv=none; b=WaemP+Ru62I2HLGkdassqEfcpajteUC/pCZKA1O0vRgc216B49XworC+P7+LX+HPsIG73NoCZC+vj9ZVEd8UyvCO694lEdXzq/lf8RAFgJkEcU5TGEjXSBFz672vtKPIfPTo/D5OwqTkWYS1M+DjJJM3ae2Nqv9yPUG3BoSqIF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626607; c=relaxed/simple;
	bh=CAPE3ZyiYPNGAarIQWi2Jc17auT3Ib9qYVQBiKMs3QE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DjOFUxEf7tDvncwMY24H1MhJsl4EyRAx6VTzAucX227G3C77p8ORpIskgitVUV7LMTp++jiFc2CyXdSe/2ntYdnTFwulPD5vWXfbRAdbbOZC1QLhhoa/ZfxuzSHC7xQNt1YSeYz+xukpOGfMZpFDvLKQ6zV17KQM4kZYcQ1mnHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=owlfolio.org; spf=pass smtp.mailfrom=owlfolio.org; dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b=SGnHvL0p; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=g/PhUcNR; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b="SGnHvL0p";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="g/PhUcNR"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8F0581140190;
	Mon, 10 Mar 2025 13:10:04 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Mon, 10 Mar 2025 13:10:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=owlfolio.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1741626604;
	 x=1741713004; bh=PvvnBsU62G2LSBC89yZxnZ+qQLecggqiGK+GeQd3Arw=; b=
	SGnHvL0pG1jwib3RgvB6G8d3Kv0wVn0KbHjwimKnweYBUXVJaSeo0ZrzRrCUl1Ks
	3DBqYlXzsYrA0YvDlvvvVWmZeal6L9V4mjQa8ov+qjoNgKfW1BeSuYhgeUYKrpEw
	I9T82/h5KJ2uRydG8GVmJUeZqz/tlkkE0u//sf/N2rVd6E5hDSTaJrZWDRAIRQVm
	sNen9rNthMPmm75bKleuUcUZICf/PnnrXTKo6Yg7bDUbFsBeDPn98p8x7rn9wN+E
	+9XNNXirTUppP3M4Knj+5S56VqiJDC08CwH1YGpgmSWRajS1KocmpGR/dQX+t7sZ
	9+Y110T5uB6fer6f3m8Jmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1741626604; x=
	1741713004; bh=PvvnBsU62G2LSBC89yZxnZ+qQLecggqiGK+GeQd3Arw=; b=g
	/PhUcNRO5IejiS6ohkHZjUr/MGpGIw/o3d/s2w2Fes85QMhMmzS9iP0lE/Twko0g
	LS2FtR06yaqFhEybbNSsNSgR+wB/rYZ45Y0G6Bn3F3e/BKMCx/HRBtZE9Wuj+Lc9
	LKP5ICKG0XDCae1PnXKm5dLkTctKAlRO3/LDQpro/t9pUvJ4aissnmJiQD0LQZ9D
	MCqi2nax/Kg8sqEka0Fwg73dhY0fVvBRVTw8Mj7XovdRZuHiqI7LgR3jdqeyTtTD
	HIdnuqvlvf3RSGhpH7IAQBcAjcc4RietoZ5l5IPDrJlzUP1BgRpCyHjSxcjh8f8E
	pjsrZwucYfbVmnTkeLpkQ==
X-ME-Sender: <xms:7BzPZz7yLikgyeScwjd-SOwCGwXBDO_CMqysvR751VOyhcQBMcC8Qg>
    <xme:7BzPZ470vhOiz_TDChIXLJjvGT36uDHVu4F1kaXQPLZPapV4V0YeEjIDqICPkLCGK
    TaOUt3Lt-DsFEHr9as>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduudelleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertder
    tddtnecuhfhrohhmpedfkggrtghkucghvghinhgsvghrghdfuceoiigrtghksehofihlfh
    holhhiohdrohhrgheqnecuggftrfgrthhtvghrnhepgfejtdefleehtddvteeitdeigffg
    fedvheelieevkeetgfdtkeehhfegfffffedvnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepiigrtghksehofihlfhholhhiohdrohhrghdpnhgs
    pghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepiiguvghnvg
    hkrdhkrggsvghlrggtsehgmhgrihhlrdgtohhmpdhrtghpthhtohepughmqdguvghvvghl
    sehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepthhhohhrnhgsvghrsehrvg
    guhhgrthdrtghomh
X-ME-Proxy: <xmx:7BzPZ6cMTobgxoAR0atSAJfBQmaAlsEJhB_-bzyE4N0bUbbaAE4sAg>
    <xmx:7BzPZ0LZcA9e2XEhj-l2OjFTqEm0-e3N9KQiaRmUhUmtQAksdnULPA>
    <xmx:7BzPZ3KRWbcn7kUvVA08HXR6q_Bmr0q_Z_w-W_71E3IDPPQmTMckpw>
    <xmx:7BzPZ9z1zftsDFCyoN6_1njHOLprphCVES-bvMke1-ooTg6MEdZdSA>
    <xmx:7BzPZ-WaJtRvreU85ezmvp2J05f-TMHhiX9FDTRmbvPl1a2nmpmf5gzy>
Feedback-ID: i876146a2:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 103723020080; Mon, 10 Mar 2025 13:10:04 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 10 Mar 2025 13:09:41 -0400
From: "Zack Weinberg" <zack@owlfolio.org>
To: "Joe Thornber" <thornber@redhat.com>,
 "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: dm-devel@lists.linux.dev
Message-Id: <d0324e59-ce5d-40ff-9b4f-28a2785fd1a3@app.fastmail.com>
In-Reply-To: <93f44259-31b1-4157-9db0-a3add582acde@app.fastmail.com>
References: <0211b995-d844-4a0d-a02f-2f9bd2a4215e@app.fastmail.com>
 <4dd35799-f43b-461a-a3c4-5cec8ff22006@redhat.com>
 <CAJ0trDZRg=DPPDa0LMiFw0T9uT+B_53K4=aXc=njr=j_VYOarw@mail.gmail.com>
 <93f44259-31b1-4157-9db0-a3add582acde@app.fastmail.com>
Subject: Re: Allowed characters in strings passed to/from device-mapper APIs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Mar 10, 2025, at 1:06 PM, Zack Weinberg wrote:
> On Mon, Mar 10, 2025, at 11:09 AM, Joe Thornber wrote:
>> This is the Rust library developed by the Stratis project, and I use
>> it in a couple of my projects (blk-archive and
>> thin-provisioning-tools).
>
> I am aware of this library and in fact have stolen a bunch of code
> from it, but I can't use it directly for the same reason I can't
> use libdevmapper: my library needs to work in a context where the
> base C library is not available and neither is udev.

Oh, also, stealing code from that library doesn't resolve the questions
I came here to ask; in fact it's what brought the issue to my attention
in the first place.  The Stratis people seem to have *blindly assumed*
that *all* C-strings passed to or from the device-mapper ioctls would always
be printable ASCII, and I do not trust that assumption, particularly for
table parameters and target messages.

zw

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642417;
	b=16uYLCZmbYWn2NJae9RMb5X/153bOsAFMpTocfp/cCc3WgblmcpRbKgc1Ymb5T//TAxZ
	 mlkwehtQRBwGPYekqcx79hfk1+qMdDBnvEKZshf3D9yUT6TIPSdhXbFowLMd51w4I5oPD
	 bQTmt1f6BpuNktc5l2+P942rTb5xuXYl+kyXsifahOzKbghdbtRajx4S+/5cQaUAnbMvf
	 eWGV4XPIE8yCXT5fm3eg4+5wlb1NSZ4EkscKXZnBzfMFeWt38Gn+/Ky9/w/KkPPMl4Cdg
	 Lw/5PO48L2v4+1Ln5L2DM9tnqOJbMPM+MsDH6HwS/eNbLCcl+ySCtG0OT0dqElD3iug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642417;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FGNJ1d/2nF+bRZrybTD7E/noHwTUs34iqH0nvE138sc=;
	b=mQVh1D4d9nJ05N9LBW/9dM4SZuq7qFpmUz5UoLRBrb83oLuSPWphSzuZFWFVveJ6aYyE
	 mlkWjgBjXyJtn5ItiHwz94mCKfyziQDn8ed/qlxJIcj9QqFz1enFzRixOYZAXkyuDEyvT
	 XG3HXv09Gf8MNI8rXQF5xKX3Do8mhLMgzXmVj2ygaGbxbNDjM8mfhMTddZ8muqfnv43oy
	 HrLJzEfObPGMaoLvgiAmDnFLVBS5l+Xl5TovQjXyORFORVaeHCZKoEnCUweN7vuftUP0P
	 s2jcOsYW78NMjkA2UxWSmhhWinJefUlYOSWr5j6wHWiyeVwX6FuioDZ3p8vVaHSC2Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JZ0ITf5u;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD70606A321
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 21:33:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DD70606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JZ0ITf5u
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-49412eb1474so4084831f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 13:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795642416; x=1796247216; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FGNJ1d/2nF+bRZrybTD7E/noHwTUs34iqH0nvE138sc=;
        b=JZ0ITf5ul0FVKMiQmw+/0vZkQVdOA4kHJXGvjbrZXu+DJKWUpMY+plm+vKQ72VzM6K
         zoGl6Xynsi3Or2SVTiPtC8wIl/pEo2UNARSL/uH/etKqbEHBbXEBoRwIIuenQfWnPrAE
         Bd5869mIX9cio5I5ww6wnGsLf5DBJqKWN1TYT9FjbizCdCH5dMTqTIGLEz3dcN59VXfN
         swJsPMqhhFnC8bCC83CshgcgU2DrEfy0T56VzhWeOhgmmCoDAVHKmUfg1GrF+2DUgIl+
         xmiTII95zAWVBC7jJiHJ5fePDWY3NXZYHmeW3efrTMGcBDGvNyBQ4jy1+bfJJIF+W07c
         vPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795642416; x=1796247216;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FGNJ1d/2nF+bRZrybTD7E/noHwTUs34iqH0nvE138sc=;
        b=vXJ1TXgxm6Zff+Pe0x6DZR8rHG0TxUSQMym5vUUxP821n0+MrYynl8rfi76zOZ0TqO
         b6ptQXr72+jvWxT0pwawwDsiobGYhjPjaAZlazYmE2THjW2FfjxDLNQziU1fJS6DI24S
         grQEy7emWsDTd502ThwfMcyQRZM73YdgMGoTtNKLanzZccXTlB4k+hFBZ/PmGe/t1GUb
         gOcgcat+i/uiyF/SjLP3aSdqzqb7+oxVKQLOMWSHmev03YQkIcCdc4RiPMoF7fkoYwTE
         e0BsVQ450rtSb/Hmk/4TzUBrpLBmN21QTUOfCbJrTBXCCro7VlXZDn/ruc+b2wMbAEX7
         a5pQ==
X-Forwarded-Encrypted: i=1; AL+hErH7SPDM52yRzl5iIYjODpsUVpgXFK9kksV6y8Ir8fdBDw2iWkalMj8DyzbFvrVX1gKBpATZ5+6hJQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z/aY2ROh42EJqJheX6vaYD2kJZJ/Z0noCnHyYycVW3wDbGRnBHJ
	hpYvMrsisdheKMY8sbE/9Cb5MOOiZuaM3rZJcxmdevG69a8vuKCUN+ey
X-Gm-Gg: AZFdTZeqZ9O8Jiu9jsF4qY636YuhrPtSloVMPtY05ZZiTHygImapBDttG5FTP5U/3ev
	qyRAmmzz9uT8jTTOU4IQGa+y20o9uNaywhD9DBVHISbP7eSqYZQxMO5dKOwkgHpV2iO1hjJHfuI
	wHcaK/BcVCIcpBEZfzShufqkuH33Gsbz1lw9hgyqkGQ76cLgL/8fjXMVDSVnmOltgMg6CBtoLlJ
	6yUD5pp4DgH6prVn3rYmqY30etuXEk+52FOrBT7ZVCsrTgrYIBfdRzkn6iHs+GYFbBtcSYygJMH
	YUPvDlON6D7TamBtub00AjnrmWRnSZc/LT1gMHmUPoG1L8RjayAflXGM7YNXSL3C9x1YWEt8BjD
	xGigKwsk8eO6JbtFFl7ESfeQGP14TaF9iolk3eWyLrwk6QWTNUlGeQLpWHMSd+dtlODACsTZ3cF
	WZlkkbInZ5f4jcSmiu/xyrlcOIdjO/OGR2vGot6zl8Ojp+mvM1gkfwbWR/+OULdeFmmocza+6xr
	1ZaY24E/je2mcFDiiphevSdIIBNigck3u71QNB3m2xNxrUro/9b3Dex663NazIJtKOP+kFckWVo
	oubWqqKXKvJHa0NVCo0fY51ALE9NA+5NTNGNnlMSc7EFuLb3ZmotDcI0XM806cAkBg==
X-Received: by 2002:a05:6000:4a0e:b0:48b:db7:86a7 with SMTP id ffacd0b85a97d-4abb7787c05mr35815085f8f.50.1795642415460;
        Wed, 25 Nov 2026 13:33:35 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a680355sm30439805f8f.27.2026.11.25.13.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 13:33:35 -0800 (PST)
Date: Wed, 25 Nov 2026 21:33:33 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, Ahmad Fatoum
 <a.fatoum@pengutronix.de>, Alasdair Kergon <agk@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Gstir <david@sigma-star.at>, David Howells <dhowells@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, David Woodhouse
 <dwmw2@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, Ignat
 Korchagin <ignat@linux.win>, James Bottomley
 <James.Bottomley@hansenpartnership.com>, James Morris <jmorris@namei.org>,
 James Prestwood <prestwoj@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>, Mike
 Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>, Peter Huewe
 <peterhuewe@gmx.de>, Randy Dunlap <rdunlap@infradead.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, Shuah Khan <skhan@linuxfoundation.org>, Sumit
 Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 2/9] lib/asn1_encoder: Add
 asn1_encode_integer_bytes()
Message-ID: <20261125213333.23eedef1@pumpkin>
In-Reply-To: <awcBD-bp27JCVpc-@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
	<20261124194043.1651679-3-jarkko@kernel.org>
	<20261125091921.4bf40279@pumpkin>
	<awcBD-bp27JCVpc-@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Nov 2026 17:38:55 +0200
Jarkko Sakkinen <jarkko@kernel.org> wrote:

> On Wed, Nov 25, 2026 at 09:19:21AM +0000, David Laight wrote:
> > On Tue, 24 Nov 2026 21:40:36 +0200
> > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >   
> > > Add a helper encoding a positive integer from a byte array in big-endian
> > > format.  
> > 
> > Interesting...
> > You allow for integer values longer than 127 bytes but don't allow for the
> > much more common likelyhood of the encoding being 'implicit'.  
> 
> This is the first thing I wrote in 2024 and have not touched since
> without further feedback :-)

I wrote an ASN.1 encoder/decoder for a tcap library a few years back.
Pretty much everything was implicit and some of the tags exceed 5 bits.
About the only things that needed multi-byte lengths were constructed.
Oh - and you can't fit in a maximal length SMS if you use the indefinite
length for constructed items between 128 and 255 bytes, you have to use
the two-byte encoding.

There were a few functions for 'add item to buffer', but I didn't need
this one.

David

> 
> 
> > 
> > David  
> 
> 
> Br, Jarkko

